# frozen_string_literal: true

require 'flickraw'

# Prepare needed FlickRaw methods
FlickRaw::Flickr.build(['flickr.photos.getInfo', 'flickr.photos.getSizes'])

# Please get your own API key for setting up this.
# You can request it at
# https://www.flickr.com/services/api/misc.api_keys.html
FlickRaw.api_key = ''
FlickRaw.shared_secret = ''
