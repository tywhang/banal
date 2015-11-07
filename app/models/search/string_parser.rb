class Search::StringParser
  # first match is the outer quote character, second is the quoted text
  QUOTED_RX = /((?<![\\])['"])((?:.(?!(?<![\\])\1))*.?)\1/

  def initialize(string)
    @string = string
  end

  def to_attrs
    parse_string
  end

  private

  def parse_string
    {name: @string.scan(/name[:=]#{QUOTED_RX}/).flatten.last}
  end
end
