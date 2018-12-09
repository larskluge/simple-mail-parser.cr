module SimpleMailParser
  class HeaderTuple
    alias Opts = Hash(String, String)

    property value : String
    property opts : Opts

    def initialize(@value, @opts = Opts.new)
    end
  end
end
