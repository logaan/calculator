require "calculation"

describe Calculation do
  context "tokenisation" do
    it "tokenizes numbers" do
      calculation = Calculation.new("1")
      calculation.tokens.should == ["1"]
    end

    it "tokenizes sums" do
      calculation = Calculation.new("1 + 1")
      calculation.tokens.should == ["1", "+", "1"]
    end

    it "tokenizes subtraction" do
      calculation = Calculation.new("1 - 1")
      calculation.tokens.should == ["1", "-", "1"]
    end

    it "tokenizes multiplication" do
      calculation = Calculation.new("1 * 1")
      calculation.tokens.should == ["1", "*", "1"]
    end

    it "tokenizes division" do
      calculation = Calculation.new("1 / 1")
      calculation.tokens.should == ["1", "/", "1"]
    end

    it "doesn't tokenize shit" do
      lambda{ Calculation.new("cocks") }.should raise_exception(RuntimeError, "Fucked String")
    end
  end

  context "parsing" do
    it "parses basic operations" do
      calculation = Calculation.new("1 + 1")
      calculation.parse_tree.should == ["+", ["1", "1"]]
    end
  end

  context "adding numbers" do
    it "adds 1 to 1" do
      calculation = Calculation.new("1 + 1")
      calculation.solve.should == 2
    end
  end
end

