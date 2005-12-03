# License: see LICENSE.txt
#  Jabber4R - Jabber Instant Messaging Library for Ruby
#  Copyright (C) 2002  Rich Kilmer <rich@infoether.com>
# 

##
# The Jabber module is the main namespace for all Jabber modules
# and classes.
#
module Jabber
  VERSION_MAJOR = 0
  VERSION_MINOR = 6
  RELEASE = 0
  DEBUG = false
end

require "jabber4r/session"
require "jabber4r/protocol"
require "jabber4r/roster"
require "jabber4r/jid"
require "jabber4r/vcard"

