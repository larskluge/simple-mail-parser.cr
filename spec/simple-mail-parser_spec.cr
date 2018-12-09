require "./spec_helper"

module SimpleMailParser
  describe SimpleMailParser do
    it "parses a minimal email" do
      eml = "To: foo@bar.com\r\nContent-Type: text/plain\r\n\r\nHello"
      message = SimpleMailParser.parse(eml)
      message.to.should eq "foo@bar.com"
      message.body.should eq "Hello"
    end

    it "parses a multipart email" do
      message = Parser.parse(email_fixture("josh"))

      message.should be_a(Message)
      message.headers.should be_a(Hash(String, HeaderTuple))

      message.to.should eq("testymctestervich@gmail.com")
      message.from.should eq("jparonson@gmail.com")
      message.subject.should eq("Fwd: Test message")
      message.headers["content-type"].value.should eq("multipart/alternative")

      message.parts.should be_a(Array(Message))
      message.parts.size.should eq(2)

      part = message.parts.first
      part.content_type.should eq("text/plain")
      part.body.should contain("test message")

      part = message.parts.last
      part.content_type.should eq("text/html")
      part.body.should contain(%(<a href="mailto:))
    end

    it "parses a mail from Thunderbird" do
      message = Parser.parse(email_fixture("thunderbird"))
      message.to.should eq "foo@bar.com"
      message.from.should eq "l@larskluge.com"
      part = message.parts.first
      part.body.should eq "Hello Body"
    end
  end
end
