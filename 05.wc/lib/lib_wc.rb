# frozen_string_literal: true

SPACE_NUMBER = 8

def run_wc(file_names, option)
  option = { lines: true, words: true, bytes: true } if option.empty? # wcコマンドが何もオプションを持たない場合、全てのオプションを指定したことにしている。
  wc(file_names, option)
end

def wc(file_names, option)
  wc = []
  total_file_data = { lines: 0, words: 0, bytes: 0 }

  file_names.each do |file|
    file_data = build_file_data(File.new(file).read)
    %i[lines words bytes].each { |key| total_file_data[key] += file_data[key] }
    body = render_body(file_data, option)
    wc << [body, file].join(' ')
  end
  if file_names.size > 1
    total = "#{render_body(total_file_data, option)} total"
    wc << total
  end
  wc.join("\n")
end

def build_file_data(file_content)
  {
    lines: file_content.split("\n").size,
    words: file_content.split(/\s+/).size,
    bytes: file_content.bytesize
  }
end

def render_body(file_data, options)
  %i[lines words bytes].map { |key| file_data[key].to_s.rjust(SPACE_NUMBER) if options[key] }.join
end
