# frozen_string_literal: true

require_relative 'file_meta_data'

class FileDirectory
  attr_reader :path

  OWNER_INDEX = 3
  GROUP_INDEX = 4
  OTHERS_INDEX = 5

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

  def initialize(path = nil)
    @path = path || '.'
  end

  def files
    Dir.entries(@path).sort
  rescue Errno::ENOENT => e
    raise e, "#{@path} ディレクトリが存在しません。"
  end

  # lsコマンドのlオプションで使用するファイルの詳細情報を持つFileMetaDataを返す
  def get_file_metadata(file_name)
    file_path = File.join(@path, file_name)
    stat = File.lstat(file_path)

    FileMetaData.new(
      file_type: file_type(stat),
      permissions: format_permissions(stat.mode),
      links: stat.nlink,
      owner: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size,
      last_modified: stat.mtime
    )
  end

  private

  def file_type(lstat)
    if lstat.file?
      '-'
    elsif lstat.symlink?
      'l'
    elsif lstat.blockdev?
      'b'
    elsif lstat.chardev?
      'c'
    elsif lstat.pipe?
      'p'
    elsif lstat.directory?
      'd'
    end
  end

  # ファイル権限を drwxr-xr-x のような記号に変換
  def format_permissions(mode)
    octal_mode = mode.to_s(8).rjust(6, '0')
    "#{PERMISSION_MAP[octal_mode[OWNER_INDEX]]}#{PERMISSION_MAP[octal_mode[GROUP_INDEX]]}#{PERMISSION_MAP[octal_mode[OTHERS_INDEX]]}"
  end
end
