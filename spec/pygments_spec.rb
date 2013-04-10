require 'spec_helper'

describe Markdownizer do
  describe ".pygments(text)" do
    Markdownizer.highlight_engine = :pygments

    Markdownizer.highlight_engine = :coderay # turn back
  end

end
