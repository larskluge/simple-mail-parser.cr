require "./simple-mail-parser/**"

module SimpleMailParser
  VERSION = "0.1.0"

  def self.parse(content)
    Parser.parse content
  end
end
