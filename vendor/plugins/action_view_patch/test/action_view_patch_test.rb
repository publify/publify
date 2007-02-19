require 'test/unit'
$:.unshift '../../../rails/actionpack/lib'
begin
  require 'action_controller'
rescue LoadError
  require 'rubygems'
  require 'action_controller'
end
require 'action_controller/assertions'
require '../lib/action_view_patch'

# borrow BaseTest from prototype_helper_test
module BaseTest
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::ScriptaculousHelper
  
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  
  def setup
    @template = nil
    @controller = Class.new do
      def url_for(options, *parameters_for_method_reference)
        if options.is_a?(String)
          options
        else
          url =  "http://www.example.com/"
          url << options[:action].to_s if options and options[:action]
          url << "?a=#{options[:a]}" if options && options[:a]
          url << "&b=#{options[:b]}" if options && options[:a] && options[:b]
          url
        end
      end
    end.new
  end

protected
  def create_generator
    block = Proc.new { |*args| yield *args if block_given? } 
    JavaScriptGenerator.new self, &block
  end
end

class ActionViewPatchTest < Test::Unit::TestCase
  include BaseTest
  
  def test_observe_form
    assert_dom_equal %(<script type=\"text/javascript\">\n//<![CDATA[\nnew Form.Observer('cart', 2, function(element, value) {new Ajax.Request('http://www.example.com/cart_changed', {asynchronous:true, evalScripts:true, parameters:value})})\n//]]>\n</script>),
      observe_form("cart", :frequency => 2, :url => { :action => "cart_changed" })
  end
end
