class Plugins::Sidebars::<%= class_name %>Controller < Sidebars::ComponentPlugin
  # display_name "<%= class_name.underscore.humanize %>" # Default
  description "Describe your sidebar here"

  # Declare your settings.

  setting :title,     display_name

  # Check the other sidebars for the sort of thing you can do with
  # setting declarations. Expect more documentation when it's
  # written.

  # setting :key,       'some text'
  # setting :selection, 'foo', :choices => %{foo bar baz}
  # setting :flag,       true, :input_type => :checkbox

  def content

  end
end
