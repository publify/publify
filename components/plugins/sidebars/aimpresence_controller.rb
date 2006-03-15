require 'time'

class Plugins::Sidebars::AimpresenceController < Sidebars::Plugin
	def self.display_name
		"AIM Presence"
	end

	def self.description
		'Displays the <a href="http://www.aim.com/presence">online presence</a> of an AOL Instant Messenger screen name'
	end

	def self.default_config
		{'sn' => '', 'devkey' => ''}
	end

	def configure
	end
end
