# frozen_string_literal: true

require 'etc'
COLUMN_NUMBER = 3
SPACE_NUMBER = 3

PERMISSION_MAP = {
  '7' => 'rwx',
  '6' => 'rw-',
  '5' => 'r-x',
  '4' => 'r--',
  '3' => '-wx',
  '2' => '-w-',
  '1' => '--x',
  '0' => '---'
}.freeze

def files(path)
  Dir.entries(path).sort
end

def transform_by_option(files, option, path)
  # aオプションのみの場合に引数を変更しないで返すためnew_filesに再定義している。
  transformed_files = if option[:a]
                        files
                      else
                        files.reject { |file| file.start_with?('.') }
                      end

  transformed_files = transformed_files.reverse if option[:r]

  if option[:l]
    file_stats(transformed_files, path)
  else
    transformed_files
  end
end

def show_as_grid(files)
  maximum_length = files.max_by(&:length).length + SPACE_NUMBER # 本家lsコマンドに寄せたスペース幅に調整
  height = files.length.ceildiv(COLUMN_NUMBER)

  (0...height).each do |h_num|
    COLUMN_NUMBER.times do |w_num|
      files_index = h_num + (height * w_num)
      print files[files_index].ljust(maximum_length) if !files[files_index].nil?
    end
    puts # ターミナル上で見栄えが悪いので改行。
  end
end

def file_type(file_lstat)
  if file_lstat.file?
    '-'
  elsif file_lstat.symlink?
    'l'
  elsif file_lstat.blockdev?
    'b'
  elsif file_lstat.chardev?
    'c'
  elsif file_lstat.pipe?
    'p'
  elsif file_lstat.directory?
    'd'
  end
end

def file_stats(file_names, path)
  file_stats = []
  max_size_length = 0
  total_file_blocks = 0

  file_names.each do |file_name|
    outfile = File.join(path, file_name)
    fs = File::Stat.new(outfile)
    max_size_length = fs.size.to_s.length if fs.size.to_s.length > max_size_length
    file_type = file_type(File.lstat(outfile)) # File::Statは自動的にシンボリックリンクをたどっていき常にfalseを返すのでlstatを渡す。
    octal_mode = fs.mode.to_s(8).rjust(6, '0')
    mode = "#{PERMISSION_MAP[octal_mode[3]]}#{PERMISSION_MAP[octal_mode[4]]}#{PERMISSION_MAP[octal_mode[5]]}"
    time = fs.mtime.strftime('%m %d %H:%M ')
    file_stats << [file_type + mode, fs.nlink.to_s.rjust(2), Etc.getpwuid(fs.uid).name, Etc.getgrgid(fs.gid).name, fs.size.to_s, time, file_name]
    total_file_blocks += fs.blocks
  end

  # 最大文字列長に合わせて整形
  formatted_file_stats = [total_file_blocks]
  file_stats.each do |s|
    s[4] = s[4].rjust(max_size_length + 1)
    formatted_file_stats << s.join(' ')
  end
  formatted_file_stats
end
