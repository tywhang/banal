class Search::StringParser
  TERMINALS = /\s+/
  EQUALITY_EXPR = /([^:=\s]+)[:=]([^:=\s]+)/

  def initialize(string)
    @string = string
  end

  def parsed_string
    @parsed_string ||= parse(@string)
  end

  private

  def parse(string)
    tokens = string.split(TERMINALS)
    parsed_result = []

    # Manually iterating so we can group sub-expressions together
    i = 0
    while i < tokens.length
      chunk = tokens[i]

      if chunk =~ /^and$/i
        parsed_result << :and
      elsif chunk =~ /^or$/i
        parsed_result << :or
      elsif chunk[0] == '('
        sub = chunk[1..-1]
        while true
          if sub[-1] == ')'
            parsed_result << [:group, parse(sub[0..-2])]
            break
          elsif tokens[i].nil?
            raise 'Could not finding closing paren'
            break
          else
            i += 1
            sub << ' ' << tokens[i]
          end
        end
      elsif chunk =~ EQUALITY_EXPR
        match = chunk.match(EQUALITY_EXPR)
        value = match[2]
        if value[0] == '"'
          value = value[1..-1]
          while value[-1] != '"'
            i += 1
            value << " #{tokens[i]}"
          end
          value = value[0..-2]
        elsif value[0] == "'"
          value = value[1..-1]
          while value[-1] != "'"
            i += 1
            value << " #{tokens[i]}"
          end
          value = value[0..-2]
        end

        parsed_result << [:equality, match[1], value]
      else
        raise 'Could not parse search expression'
      end

      i += 1
    end

    parsed_result
  end
end
