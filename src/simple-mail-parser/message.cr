module SimpleMailParser
  class Message
    property headers = {} of String => HeaderTuple
    property parts = [] of Message
    property body = ""

    def subject
      headers["subject"].value
    end

    def from
      get_header_address("from")
    end

    def to
      get_header_address("to")
    end

    def content_type
      headers["content-type"]?.try &.value || "text/plain"
    end


    protected def get_header_address(key)
      addr = headers[key].value
      addr = parse_address_line(addr) if addr && addr =~ />$/
      addr
    end

    protected def parse_address_line(line)
      matches = line.scan(/<([^,\s>]+)>/)
      if matches.size == 1
        matches.first[1]
      else
        line
      end
    end
  end
end
