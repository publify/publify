class AimpresenceSidebar < Sidebar
  display_name "AIM Presence"

  description <<EOS
Displays the Online presence of an AOL Instant Messenger screen name<br/>
If you don\'t have a key, register <a href="http://www.aim.com/presence">here</a>.
EOS

  setting :sn, '', :label => 'Screen Name'
  setting :devkey, '', :label => 'Key'


  def parse_request(contents, params)
    # contents is a list of the items being rendered on the current page
    # params is the params hash for the current request

    # Take a look at (eg) the amazon sidebar for examples of what gets done here
    # If your sidebar doesn't depend on the request or the contents, you don't
    # need to do anything here.
  end
end
