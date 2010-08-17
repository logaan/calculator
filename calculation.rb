require "ruby-debug"

# Should be able to compose calculations
class Calculation
  attr_reader :tokens, :parse_tree

  @@patterns  = {
    :integer  => /^(\d+)(.*)/,
    :operator => /^([\+\-\*\/])(.*)/
  }

  def initialize(calculation_string)
    @calculation_string = calculation_string
    @tokens             = []
    @parse_tree         = []

    tokenize
    @parse_tree = parse(@tokens)
  end
 
  #   "1+1" = ["1", "+", "1"]
  #   Should perhaps be tagging the tokens with their type
  def tokenize
    remainder = @calculation_string.gsub(/\s/, "")

    until remainder.empty?
      if @@patterns.values.any?{|p| remainder =~ p }
        @tokens << $1
        remainder = $2
      else
        raise RuntimeError, "Fucked String"
      end
    end

    self
  end

  #   ["1", "+", "1"] = ["+", ["1", "1"]]
  def parse(tokens)
    if tokens.length == 1
      tokens[0]
    elsif tokens.length > 2
      [
        tokens[1],
        [ tokens[0], parse(tokens[2..-1]) ]
      ]
    else
      raise RuntimeError, "Fucked Tokens"
    end
  end

  # ["+", ["1", "1"]] = 2
  def solve
    eval(@parse_tree)
  end

  def eval(expression)
    if expression.is_a? Array
      operation = parse_tree[0]
      children  = parse_tree[1]

      case operation
      when "+"
        eval(children[0]) + eval(children[1])
      else
        raise RuntimeError, "Unknown Operation"
      end
    elsif expression =~ /\d+/
      expression.to_i
    else
      raise RuntimeError, "Unknown Expression"
    end
  end
end

