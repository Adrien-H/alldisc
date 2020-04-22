module PhpHandler
  DISCLAIMER_PATTERN = /(^<\?php\n+)(?:\/\*\*.+\*\/\n{2,}|.{0})(.*)/m

  def self.format_disclaimer(disclaimer : String) : String
    str = "/**\n"

    disclaimer.each_line.each { |line|
      str = str + "* " + line + "\n"
    }

    str = str + "*/"
  end

  def self.write_or_replace_disclaimer(file_path, disclaimer : String)
    file_content = File.read(file_path)
    new_content = file_content
      .gsub(
        DISCLAIMER_PATTERN,
        "\\1" + self.format_disclaimer(disclaimer) + "\n\n\\2")
    File.write(file_path, new_content)
  end
end