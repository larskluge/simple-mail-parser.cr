require "spec"
require "../src/simple-mail-parser"


def email_fixture(name)
  File.read(File.dirname(__FILE__) + "/fixtures/#{name}.eml")
end
