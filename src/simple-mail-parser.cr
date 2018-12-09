require "./simple-mail-parser/**"

module SimpleMailParser
  VERSION = "0.1.0"

  def parse(content : String)
    Parser.new
  end
end
