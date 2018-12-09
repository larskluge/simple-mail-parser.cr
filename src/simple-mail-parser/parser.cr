require "quoted_printable"

module SimpleMailParser
  class Parser
    def self.parse(content : String)
      parse_part(content)
    end


    protected def self.parse_header_block(content)
      blocks = {} of String => String
      result = {} of String => HeaderTuple

      if !content.blank?
        header_arr = content.split("\r\n")
        current_key = nil

        header_arr.each.with_index do |line, i|
          tuple = line.split(":", 2)
          if line =~ /^\s+/ || tuple.size < 2
            if current_key && line =~ /^\s+/
              blocks[current_key] += " " + line.strip
            else
              raise "Invalid header #{line}"
            end
            next
          end

          key = tuple[0].downcase
          current_key = key
          blocks[key] = tuple[1]
        end

        blocks.each do |k, v|
          result[k] = parse_header(v)
        end
      end

      result
    end

    protected def self.parse_header(header)
      header = header.split(";")
      result = HeaderTuple.new header.shift.strip

      header.each.with_index do |h, i|
        next if h == ""

        tuple = header[i].split("=", 2)
        h_name = tuple[0].strip
        if tuple.size == 2
          result.opts[h_name] = tuple[1].strip.gsub(/^"/, "").gsub(/"$/, "")
        else
          result.opts[h_name] = "" # TODO ?? or nil?
        end
      end
      return result
    end

    protected def self.parse_part(content, *, boundary : String? = nil)
      msg = Message.new
      parts = content.split("\r\n\r\n", 2)
      msg.headers = parse_header_block(parts[0])
      if parts.size == 2
        thing = parse_body_block(parts[1], msg.headers)
        case thing
        when String
          msg.body = thing
        when Array(SimpleMailParser::Message)
          msg.parts = thing
        else
          raise "Unsupported body block '#{parts[1]}'"
        end
      end
      msg
    end

    protected def self.parse_body_block(content, headers)
      type = headers["content-type"]?.try &.value || "text/plain"
      case type
      when /text\//, /application\//
        if headers["content-transfer-encoding"]?.try &.value == "quoted-printable"
          encoding = headers["content-type"].opts["charset"]? || "utf-8"
          QuotedPrintable.decode_string(content, line_break: "\r\n", encoding: encoding)
        else
          content
        end
      when "multipart/mixed", "multipart/alternative"
        parse_multitype(content, headers["content-type"].opts["boundary"])
      when "image/png", "image/jpg"
        content.gsub(/\r\n/m, "")
      else
        raise "Unsupported content type '#{type}'"
      end
    end

    protected def self.parse_multitype(content, boundary)
      if boundary
        split_by = "--#{boundary}\r\n"
        start = content.index(split_by) || 0
        content = content[start..-1]
        content.split(split_by).map(&.strip).map{|c| c unless c.nil? || c.empty? }.compact.map do |part|
          parse_part(part, boundary: boundary)
        end
      else
        content
      end
    end
  end
end
