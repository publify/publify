
# Handles requests for sparkline graphs.
#
# You shouldn't need to edit or extend this, but you can read
# the documentation for SparklinesHelper to see how to call it from
# another view.
#
# AUTHOR
# 
# Geoffrey Grosenbach[mailto:boss@topfunky.com]
#
# http://topfunky.com
#
class SparklinesController < ApplicationController
	layout nil

	def index
		# Make array from comma-delimited list of data values
		ary = []
		params['results'].split(',').each do |s|
			ary << s.to_i
		end
		
		send_data( Sparklines.plot( ary, params ), 
					:disposition => 'inline',
					:type => 'image/png',
					:filename => "spark_#{params[:type]}.png" )
	end

end
