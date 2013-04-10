require 'spec_helper'

describe Markdownizer do
  describe ".coderay(text)" do
    let(:text) { """
      #My markdown text

      {% code ruby %}
        def function(*args)
          puts 'result'
        end
      {% endcode %}

    """
    }
    let(:text_with_caption) { """
      #My markdown text

      {% code ruby %}
      {% caption 'This will become an h5' %}
        def function(*args)
          puts 'result'
        end
      {% endcode %}

    """
    }
    let(:text_with_weird_caption) { """
      #My markdown text

      {% code ruby %}
      {% caption 'This will become an h5, with some/strange.characters\yo' %}
        def function(*args)
          puts 'result'
        end
      {% endcode %}

    """
    }
    let(:text_with_array_highlights) { """
      #My markdown text

      {% code ruby %}
      {% highlight [1,2,3] %}
        def function(*args)
          puts 'result'
        end
      {% endcode %}

    """
    }
    let(:text_with_range_highlights) { """
      #My markdown text

      {% code ruby %}
      {% highlight (1..3) %}
        def function(*args)
          puts 'result'
        end
      {% endcode %}

    """
    }
    let(:text_with_comments) { """
      #My markdown text

      {% code ruby %}
        #My comment
        # My other comment
        def function(*args)
          puts 'result'
        end
      {% endcode %}

    """
    }

    it 'calls CodeRay to parse the code inside {% code ruby %} blocks' do
      scanned_code, html_code = double(:scanned_code), double(:html_code)

      CodeRay.should_receive(:scan).with("""def function(*args)
          puts 'result'
        end""", 'ruby').and_return scanned_code

      scanned_code.should_receive(:div).with(:css => :class, :my => :option).and_return 'parsed code'

      subject.coderay(text, :my => :option).should match('parsed code')
    end
    it 'accepts a caption option inside the code' do
      subject.coderay(text_with_caption).should match('<h5>This will become an h5</h5>')
    end
    it 'accepts a caption with weird chars inside the code' do
      subject.coderay(text_with_weird_caption).should match('<h5>This will become an h5, with some/strange.characters\yo</h5>')
    end
    it 'marks ruby comments to avoid conflicts with Markdown headers' do
      code = ''
      code.stub(:div).and_return ''
      CodeRay.should_receive(:scan).with do |string|
        string.should match(/\\#My comment/)
        string.should match(/\\# My other comment/)
      end.and_return code
      subject.coderay(text_with_comments)
    end
    it 'passes the caption to the div' do
      parsed = double :parsed
      CodeRay.should_receive(:scan).and_return parsed
      parsed.should_receive(:div).with(:css => :class, :caption => 'This will become an h5').and_return 'result'

      subject.coderay(text_with_caption)
    end
    it 'accepts highlighted lines with an array' do
      parsed = double :parsed
      CodeRay.should_receive(:scan).and_return parsed
      parsed.should_receive(:div).with(:css => :class, :highlight_lines => [1,2,3]).and_return 'result'

      subject.coderay(text_with_array_highlights)
    end
    it 'accepts highlighted lines with a range' do
      parsed = double :parsed
      CodeRay.should_receive(:scan).and_return parsed
      parsed.should_receive(:div).with(:css => :class, :highlight_lines => (1..3)).and_return 'result'

      subject.coderay(text_with_range_highlights)
    end
    it 'encloses everything in a nice class' do
      subject.coderay(text_with_caption).should match(/div class=\"markdownizer_code\" caption=\"This will become an h5\"/)
    end
  end

end
