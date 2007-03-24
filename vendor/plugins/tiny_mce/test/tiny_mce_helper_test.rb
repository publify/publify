require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.expand_path(File.dirname(__FILE__) + '/helper_testcase')

class TinyMceHelperTest < HelperTestCase
  include TinyMCEHelper

  def setup
    @uses_tiny_mce = nil
    super
  end
  
  def test_javascript_include_tiny_mce
    assert_match /\/javascripts\/tiny_mce\/tiny_mce.js/, javascript_include_tiny_mce
    # We don't match the full string because asset timestamping gets in the way...
  end
  
  def test_javascript_include_tiny_mce_if_used
    assert_nil javascript_include_tiny_mce_if_used
    @uses_tiny_mce = true
    assert_match /\/javascripts\/tiny_mce\/tiny_mce.js/, javascript_include_tiny_mce_if_used
  end
  
  def test_tiny_mce_alias_is_available_for_helper
    assert respond_to?(:tiny_mce)
    assert_equal tiny_mce_init, tiny_mce
  end
  
  def test_tiny_mce_with_default_options_produces_tiny_mce_with_simple_theme_in_textareas_mode
    assert_equal "<script type=\"text/javascript\">\n//<![CDATA[\ntinyMCE.init({\nmode : 'textareas',\ntheme : 'simple'\n});\n//]]>\n</script>", tiny_mce
  end
  
  def test_tiny_mce_with_array_of_plugins_produces_comma_separated_values
    assert_equal "<script type=\"text/javascript\">\n//<![CDATA[\ntinyMCE.init({\nmode : 'textareas',\nplugins : \"table,contextmenu,paste,-externalplugin\",\ntheme : 'simple'\n});\n//]]>\n</script>",
                 tiny_mce_init(:plugins => %w{table contextmenu paste -externalplugin})
  end
  
  def test_tiny_mce_with_true_value_for_debug_produces_true_literal
    assert_equal "<script type=\"text/javascript\">\n//<![CDATA[\ntinyMCE.init({\ndebug : true,\nmode : 'textareas',\ntheme : 'simple'\n});\n//]]>\n</script>",
                 tiny_mce_init('debug' => true)
  end
  
  def test_tiny_mce_with_false_value_for_debug_produces_false_literal
    assert_equal "<script type=\"text/javascript\">\n//<![CDATA[\ntinyMCE.init({\ndebug : false,\nmode : 'textareas',\ntheme : 'simple'\n});\n//]]>\n</script>",
                 tiny_mce_init(:debug => false)
  end
  
  def test_tiny_mce_overriding_default_values
    assert_equal "<script type=\"text/javascript\">\n//<![CDATA[\ntinyMCE.init({\nmode : 'specific_textareas',\ntheme : 'advanced'\n});\n//]]>\n</script>",
                 tiny_mce_init(:theme => 'advanced', :mode => 'specific_textareas')
  end
  
  def test_tiny_mce_with_numeric_value_for_width_produces_string
    assert_equal "<script type=\"text/javascript\">\n//<![CDATA[\ntinyMCE.init({\nmode : 'textareas',\ntheme : 'simple',\nwidth : '50'\n});\n//]]>\n</script>",
                 tiny_mce_init(:width => 50)
  end
  
  def test_tiny_mce_raises_exception
    assert_raise(TinyMCEHelper::InvalidOption) {tiny_mce(:invalid_option => true)}
    assert_raise(TinyMCEHelper::InvalidOption) {tiny_mce(:mode => Class)}
  end
  
  def test_using_tiny_mce_eh
    assert !using_tiny_mce?
    @uses_tiny_mce = true
    assert using_tiny_mce?
  end
end
