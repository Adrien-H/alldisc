require "option_parser"
require "./src/PhpHandler.cr"

Alldisc.main()

module Alldisc
  def self.main()
    path = "./"

    OptionParser.parse do |parser|
      parser.banner = "Usage: alldisc [arguments]"

      parser.on "-t NAME", "--target=NAME", "Specify the target directory" do |name|
        path = name
      end

      parser.on "-v", "--version", "Show version" do
        puts "Version x.x (todo)"
        exit
      end

      parser.on "-h", "--help", "Show this help display" do
        puts parser
        exit
      end
    end

    content = Alldisc.get_content_from_editor()

    self.recursive_walk(path, content)
  end

  def self.recursive_walk(dir_path : String, content : String)
    begin
      Dir.entries(dir_path).each { |node|
        next if node == "." || node == ".."
        full_node = dir_path.chomp("/") + "/" + node
        if File.directory?(full_node)
          self.recursive_walk(full_node, content)
        else
          case File.extname(full_node)
          when ".php"
            PhpHandler.write_or_replace_disclaimer(full_node, content)
          else
            next
          end
        end
      }

    rescue exception
      puts exception.message
    end
  end

  def self.get_content_from_editor() : String
    editor = Nil
    if ENV.has_key?("EDITOR")
      editor = "$EDITOR"
    else
      editor = "editor"
    end

    tmp = File.tempfile()
    `#{editor} #{tmp.path} < \`tty\` > \`tty\``
    content = File.read(tmp.path)
    tmp.delete()

    content
  end

end
