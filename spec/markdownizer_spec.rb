require 'spec_helper'

describe Markdownizer do
  describe ".markdown(text)" do
    let(:text) { "#My markdown text"}
    it 'calls RDiscount to markdownize the text' do
      rdiscount, html_markdown = double(:rdiscount), double(:html_markdown)

      RDiscount.should_receive(:new).with(text).and_return rdiscount
      rdiscount.should_receive(:to_html).and_return html_markdown
      
      subject.markdown(text).should == html_markdown
    end
  end
  describe ".coderay(text)" do
    let(:text) { """
      #My markdown text

      {% highlight ruby %}
        def function(*args)
          puts 'result'
        end
      {% endhighlight %}

    """
    }
    it 'calls CodeRay to parse the code inside {% highlight ruby %} blocks' do
      scanned_code, html_code = double(:scanned_code), double(:html_code)

      CodeRay.should_receive(:scan).with("""
        def function(*args)
          puts 'result'
        end
      """, 'ruby').and_return scanned_code

      scanned_code.should_receive(:div).with(:css => :class).and_return 'parsed code'

      subject.coderay(text).should match('parsed code')
    end
  end

  describe Markdownizer::DSL do
    it 'integrates with ActiveRecord::Base' do
      (class << ActiveRecord::Base; self; end).ancestors.should include(Markdownizer::DSL)
    end

    before do
      ActiveRecord::Base.stub(:send)
      @klass = Class.new(ActiveRecord::Base)
      @klass.stub(:column_names) { %{body rendered_body} }
    end

    describe "#markdownize!(attribute)" do
      context "when either of attribute or rendered_attribute does not exist" do
        it 'raises' do
          expect {
            @klass.markdownize! :some_attribute             
          }.to raise_error
        end
      end
      context "otherwise" do
        it 'creates a before_save callback for render_attribute' do
          @klass.should_receive(:before_save).with(:render_body)
          @klass.markdownize! :body
        end
        it 'defines this render_attribute method' do
          klass = Class.new do
            extend Markdownizer::DSL
            def self.column_names
              %{body rendered_body}
            end
          end

          klass.stub(:before_save)
          klass.markdownize! :body

          raw_body, raw_body_with_code, final_code = double(:raw_body),
                                                      double(:raw_body_with_code),
                                                        double(:final_code)

          instance = klass.new
          instance.should_receive(:send).with(:body).and_return raw_body
          Markdownizer.should_receive(:coderay).with(raw_body).and_return raw_body_with_code
          Markdownizer.should_receive(:markdown).with(raw_body_with_code).and_return final_code

          instance.should_receive(:send).with(:rendered_body=, final_code)
          instance.render_body
        end
      end
    end
  end
end