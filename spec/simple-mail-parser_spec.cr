require "./spec_helper"

module SimpleMailParser
  describe SimpleMailParser do
    it "parses a multipart email" do
      message = Parser.parse(email_fixture("email"))

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
  end
end
