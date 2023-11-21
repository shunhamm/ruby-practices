# frozen_string_literal: true

require 'etc'

require_relative 'ls_option'
require_relative 'file_directory'

class LsCommand
  COLUMN_NUM = 3 # lsの結果表示は最大３列である
  SIZE_PADDING_NUM = 3

  def initialize(argv)
    options, path = parse_argv(argv)
    @option = LsOption.new(options)
    @file_directory = FileDirectory.new(path[0])
  end

  def run_ls
    file_names = @file_directory.files
    prepared_files = prepare_file_list(file_names)
    @option.option_set?('l') ? show_detailed_list(prepared_files) : show_simple_list(prepared_files)
  end

  private

  def show_detailed_list(prepared_files)
    prepared_files.each { |files| puts files }
  end

  def show_simple_list(prepared_files)
    maximum_length = prepared_files.max_by(&:length).length + SIZE_PADDING_NUM # 本家lsコマンドに寄せたスペース幅に調整
    height = prepared_files.length.ceildiv(COLUMN_NUM)

    # 1 5 9
    # 2 6 10
    # 3 7
    # 4 8
    # 上記の様にファイル名を順番に表示する
    (0...height).each do |h_num|
      COLUMN_NUM.times do |w_num|
        files_index = h_num + (height * w_num)
        print prepared_files[files_index].ljust(maximum_length) if !prepared_files[files_index].nil?
      end
      puts
    end
  end

  def prepare_file_list(file_names)
    # オプションを追加したらここに記載する。
    operations = {
      'r' => method(:sort_files),
      'l' => method(:format_file_list)
    }

    # file_namesはhiddenfileをすでに含んでいるので最初にフィルターの処理を行う。
    transformed_files = @option.option_set?('a') ? file_names : filter_files(file_names)

    operations.each do |option, operation|
      transformed_files = operation.call(transformed_files) if @option.option_set?(option)
    end
    transformed_files
  end

  def filter_files(file_names)
    file_names.reject { |file| file.start_with?('.') }
  end

  def sort_files(file_names)
    file_names.reverse
  end

  def format_file_list(file_names)
    max_size_length, total_blocks = calculate_max_size_length_and_total_blocks(file_names)

    file_stats = file_names.map do |file_name|
      format_single_file_stat(file_name, max_size_length)
    end

    formatted_file_stats = ["total #{total_blocks}"]
    file_stats.each { |stat| formatted_file_stats << stat.join(' ') }
    formatted_file_stats
  end

  def calculate_max_size_length_and_total_blocks(file_names)
    max_size_length = 0
    total_blocks = 0

    file_names.each do |file_name|
      stat = File::Stat.new(File.join(@file_directory.path, file_name))
      size_length = stat.size.to_s.length
      max_size_length = size_length if size_length > max_size_length
      total_blocks += stat.blocks
    end

    [max_size_length, total_blocks]
  end

  def format_single_file_stat(file_name, max_size_length)
    file_detail_data = @file_directory.get_file_metadata(file_name)
    [
      file_detail_data.file_type + file_detail_data.permissions,
      file_detail_data.links.to_s.rjust(1),
      file_detail_data.owner,
      file_detail_data.group,
      file_detail_data.size.to_s.rjust(max_size_length + 1), # １を足してテストフォーマットに合う様にする
      file_detail_data.last_modified.strftime('%m %d %H:%M'),
      file_name
    ]
  end

  def parse_argv(argv)
    options = argv.select { |arg| arg.start_with?('-') }
    path = argv.reject { |arg| arg.start_with?('-') }
    [options, path]
  end
end
