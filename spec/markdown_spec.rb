require 'spec_helper'

describe Markdownizer do
  describe ".markdown(text)" do
    let(:text) { "#My markdown text"}
    context 'when the hierarchy is 0' do
      it 'calls RDiscount to markdownize the text' do
        rdiscount, html_markdown = double(:rdiscount), double(:html_markdown)

        RDiscount.should_receive(:new).with(text).and_return rdiscount
        rdiscount.should_receive(:to_html).and_return html_markdown

        subject.markdown(text).should == html_markdown
      end
    end
    context 'when the hierarchy is 2' do
      it "converts all headers into 2 levels deeper" do
        my_text = """
        #This is an H1
        ##This is an H2
        ###This is an H3
        """
        result = double :result, :to_html => true
        RDiscount.should_receive(:new).with do |t|
          t.should =~ /###This is an H1/
          t.should =~ /####This is an H2/
          t.should =~ /#####This is an H3/
        end.and_return result
        subject.markdown(my_text, 2)
      end
      it 'still does not convert anything that is not a header' do
        my_text = """
        #This is an H1
        I am talking about my #method
        {% code ruby %}
          \\#My comment
        {% endcode %}
        ###This is an H3
        """
        result = double :result, :to_html => true
        RDiscount.should_receive(:new).with do |t|
          t.should =~ /###This is an H1/
          t.should =~ /#method/
          t.should_not =~ /###method/
          t.should =~ /#My comment/
          t.should_not =~ /###My comment/
          t.should_not =~ /\\#My comment/
          t.should =~ /#####This is an H3/
        end.and_return result
        subject.markdown(my_text, 2)
      end
    end
  end
end
