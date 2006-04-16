require 'time'

class Plugins::Sidebars::AimpresenceController < Sidebars::ComponentPlugin
  display_name 'AIM Presence'
  description  %{Displays the Online presence of an AOL Instant Messenger screen name<br/>
If you don\'t have a key, register <a href="http://www.aim.com/presence">here</a>.}

  setting :sn, '', :label => 'Screen Name'
  setting :devkey, '', :label => 'Key'
end
