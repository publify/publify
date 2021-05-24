# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyApp::Textfilter::Code, type: :model do
  it "is registered in the list of textfilter plugins" do
    expect(TextFilterPlugin.available_filters).to include described_class
  end

  it "is registered in the list of macro filters" do
    expect(TextFilterPlugin.macro_filters).to include described_class
  end

  describe "#filter_text" do
    let(:filter) { TextFilter.none }

    describe "specific publify tags" do
      describe "code" do
        describe "single line" do
          it "mades nothin if no args" do
            result = filter.filter_text("<publify:code>foo-code</publify:code>")
            expect(result).
              to eq '<div class="CodeRay"><pre>foo-code</pre></div>'
          end

          it "parses ruby lang" do
            result = filter.filter_text('<publify:code lang="ruby">foo-code</publify:code>')
            expect(result).
              to eq('<div class="CodeRay"><pre><span class="CodeRay">' \
                    "foo-code</span></pre></div>")
          end

          it "parses ruby and xml in same sentence but not in same place" do
            result = filter.
              filter_text('<publify:code lang="ruby">foo-code</publify:code> ' \
                          'blah blah <publify:code lang="xml">zzz</publify:code>')
            expect(result).
              to eq '<div class="CodeRay"><pre><span class="CodeRay">' \
                    "foo-code</span></pre></div> blah blah" \
                    ' <div class="CodeRay"><pre><span class="CodeRay">' \
                    "zzz</span></pre></div>"
          end
        end

        describe "multiline" do
          it "renders ruby" do
            original = <<~HTML
              <publify:code lang="ruby">
              class Foo
                def bar
                  @a = "zzz"
                end
              end
              </publify:code>
            HTML

            expected_result = <<~HTML
              <div class="CodeRay"><pre><span class="CodeRay"><span class="keyword">class</span> <span class="class">Foo</span>
                <span class="keyword">def</span> <span class="function">bar</span>
                  <span class="instance-variable">@a</span> = <span class="string"><span class="delimiter">&quot;</span><span class="content">zzz</span><span class="delimiter">&quot;</span></span>
                <span class="keyword">end</span>
              <span class="keyword">end</span></span></pre></div>
            HTML
            expect(filter.filter_text(original)).to eq(expected_result)
          end
        end
      end
    end

    it "test_code_plus_markup_chain" do
      text = <<-MARKUP.strip_heredoc
        *header text here*

        <publify:code lang="ruby">
        class test
          def method
            "foo"
          end
        end
        </publify:code>

        _footer text here_

      MARKUP

      expects_markdown = <<-HTML.strip_heredoc.strip
        <p><em>header text here</em></p>
        <div class=\"CodeRay\"><pre><span class=\"CodeRay\"><span class=\"keyword\">class</span> <span class=\"class\">test</span>
          <span class=\"keyword\">def</span> <span class=\"function\">method</span>
            <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">foo</span><span class=\"delimiter\">&quot;</span></span>
          <span class=\"keyword\">end</span>
        <span class=\"keyword\">end</span></span></pre></div>
        <p><em>footer text here</em></p>
      HTML

      filter = TextFilter.markdown

      assert_equal expects_markdown, filter.filter_text(text)
    end
  end
end
