#!/usr/bin/ruby

require 'rubygems'
require 'sparklines'

ary = (1..20).map { rand 100 }

# Run each with defaults
%w{pie area discrete smooth}.each do |type|
	Sparklines.plot_to_file("#{type}.png", ary, :type => type)
end

# Run special tests
tests = {	'smooth-colored' => {	:type => 'smooth',
					:line_color => 'purple'},
		'pie-large'	 => {	:type => 'pie',
					:diameter => 200 },
		'area-high'	 => {	:type => 'area',
					:upper => 80,
					:step => 4,
					:height => 20}
	}

tests.keys.each do |key|
	Sparklines.plot_to_file("#{key}.png", ary, tests[key])
end