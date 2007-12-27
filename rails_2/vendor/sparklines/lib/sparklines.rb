require 'RMagick'
require 'mathn'

=begin rdoc

A library (in Ruby!) for generating sparklines.

Can be used to write to a file or make a web service with Rails or other Ruby CGI apps.

Idea and much of the outline for the source lifted directly from {Joe Gregorio's Python Sparklines web service script}[http://bitworking.org/projects/sparklines].

Requires the RMagick image library.

==Authors

{Dan Nugent}[mailto:nugend@gmail.com]
Original port from Python Sparklines library.


{Geoffrey Grosenbach}[mailto:boss@topfunky.com] -- http://nubyonrails.topfunky.com 
-- Conversion to module and addition of functions for using with Rails. Also changed functions to use Rails-style option hashes for parameters.

===Tangent regarding RMagick

I had a heck of a time getting RMagick to work on my system so in the interests of saving other people the trouble here's a little set of instructions on how to get RMagick working properly and with the right image formats.

1. Install the zlib[http://www.libpng.org/pub/png/libpng.html] library
2. With zlib in the same directory as the libpng[http://www.libpng.org/pub/png/libpng.html] library, install libpng
3. Option step: Install the {jpeg library}[ftp://ftp.uu.net/graphics/jpeg/jpegsrc.v6b.tar.gz] (You need it to use jpegs and you might want to have it)
4. Install ImageMagick from *source*[http://www.imagemagick.org/script/install-source.php].  RMagick requires the ImageMagick headers, so this is important.
5. Install RMagick from source[http://rubyforge.org/projects/rmagick/].  The gem is not reliable.
6. Edit Magick-conf if necessary. I had to remove -lcms and -ltiff since I didn't want those to be built and the libraries weren't on my system.

Please keep in mind that these were only the steps that made RMagick work on my machine.  This is a tricky library to get working.
Consider using Joe Gregorio's version for Python if the installation proves to be too cumbersome.

==General Usage and Defaults

To use in a script:

	require 'rubygems'
	require 'sparklines'
	Sparklines.plot([1,25,33,46,89,90,85,77,42], :type => 'discrete', :height => 20)

An image blob will be returned which you can print, write to STDOUT, etc.

In Rails, 

* Install the 'sparklines_generator' gem ('gem install sparklines_generator')
* Call 'ruby script/generate sparklines'. This will copy the Sparklines controller and helper to your rails directories
* Add "require 'sparklines'" to the bottom of your config/environment.rb
* Restart your fcgi's or your WEBrick if necessary

And finally, add this to the controller whose view will be using sparklines:

	helper :sparklines

In your view, call it like this:

<%= sparkline_tag [1,2,3,4,5,6] %> <!-- Gives you a smooth graph -->

Or specify details:

<%= sparkline_tag [1,2,3,4,5,6], :type => 'discrete', :height => 10, :upper => 80, :above_color => 'green', :below_color => 'blue' %>


Graph types:

 area
 discrete
 pie
 smooth

General Defaults:

 :type =>  'smooth'
 :height  =>  14px
 :upper  =>  50
 :above_color  =>  'red'
 :below_color  =>  'grey'
 :background_color  =>  'white'
 :line_color => 'lightgrey'

==License

Licensed under the MIT license.

=end

module Sparklines
	$VERSION = '0.2.2'

	# Does the actually plotting of the graph. Calls the appropriate function based on the :type value passed. Defaults to 'smooth.'
	def Sparklines.plot(results=[], options={})
		defaults = {	:type => 'smooth',
				:height => 14,
				:upper => 50,
				:diameter => 20,
				:step => 2,
				:line_color => 'lightgrey',

				:above_color => 'red',
				:below_color => 'grey',
				:background_color => 'white',
				:share_color => 'blue',
				:remain_color => 'lightgrey',
				:min_color => 'blue',
				:max_color => 'green',	
				:last_color => 'red',								

				:has_min => false,
				:has_max => false,
				:has_last => false
							}
			
		# This symbol->string->symbol is kind of awkward. Is there a more elegant way?
			
		# Convert all symbol keys to strings
		defaults.keys.reverse.each do |key|
			defaults[key.to_s] = defaults[key]
		end
		options.keys.reverse.each do |key|
			options[key.to_s] = options[key]
		end

		options  = defaults.merge(options)

		# Convert options string keys back to symbols
		options.keys.reverse.each do |key|
			options[key.to_sym] = options[key]
		end

		
		# Call the appropriate function for actual plotting
		#self.send('smooth', results, options)
		self.send(options[:type], results, options)
	end

	# Writes a graph to disk with the specified filename, or "Sparklines.png"
	def Sparklines.plot_to_file(filename="sparklines.png", results=[], options={})
		File.open( filename, 'wb' ) do |png|
	 		png << self.plot( results, options)
		end
	end

# Creates a pie-chart sparkline
#
# * results - an array of integer values between 0 and 100 inclusive. Only the first integer will be accepted. It will be used to determine the percentage of the pie that is filled by the share_color
#
# * options - a hash that takes parameters:
#
# :diameter - An integer that determines what the size of the sparkline will be.  Defaults to 20
#
# :share_color - A string or color code representing the color to draw the share of the pie represented by percent.  Defaults to blue.
#
# :remain_color - A string or color code representing the color to draw the pie not taken by the share color. Defaults to lightgrey.
	def self.pie(results=[],options={})

		diameter = options[:diameter].to_i
		share_color = options[:share_color]
		remain_color = options[:remain_color]
		percent = results[0]

		img = Magick::Image.new(diameter , diameter) {self.background_color = options[:background_color]}
		img.format = "PNG"
		draw = Magick::Draw.new

		#Adjust the radius so there's some edge left n the pie
		r = diameter/2.0 - 2
		draw.fill(remain_color)
		draw.ellipse(r + 2, r + 2, r , r , 0, 360)
		draw.fill(share_color)

		#Okay, this part is as confusing as hell, so pay attention:
		#This line determines the horizontal portion of the point on the circle where the X-Axis
		#should end.  It's caculated by taking the center of the on-image circle and adding that
		#to the radius multiplied by the formula for determinig the point on a unit circle that a
		#angle corresponds to.  3.6 * percent gives us that angle, but it's in degrees, so we need to
		#convert, hence the muliplication by Pi over 180
		arc_end_x = r + 2 + (r * Math.cos((3.6 * percent)*(Math::PI/180)))

		#The same goes for here, except it's the vertical point instead of the horizontal one
		arc_end_y = r + 2 + (r * Math.sin((3.6 * percent)*(Math::PI/180)))

		#Because the SVG path format is seriously screwy, we need to set the large-arc-flag to 1
		#if the angle of an arc is greater than 180 degrees.  I have no idea why this is, but it is.
		percent > 50? large_arc_flag = 1: large_arc_flag = 0

		#This is also confusing
		#M tells us to move to an absolute point on the image.  We're moving to the center of the pie
		#h tells us to move to a relative point.  We're moving to the right edge of the circle.
		#A tells us to start an absolute elliptical arc.  The first two values are the radii of the ellipse
		#the third value is the x-axis-rotation (how to rotate the ellipse if we wanted to [could have some fun
		#with randomizing that maybe), the fourth value is our large-arc-flag, the fifth is the sweep-flag,
		#(again, confusing), the sixth and seventh values are the end point of the arc which we calculated previously
		#More info on the SVG path string format at: http://www.w3.org/TR/SVG/paths.html
		path = "M#{r + 2},#{r + 2} h#{r} A#{r},#{r} 0 #{large_arc_flag},1 #{arc_end_x},#{arc_end_y} z"
		draw.path(path)

		draw.draw(img)
		img.to_blob
	end

# Creates a discretized sparkline
#
# * results is an array of integer values between 0 and 100 inclusive
#
# * options is a hash that takes 4 parameters:
#
# :height - An integer that determines what the height of the sparkline will be.  Defaults to 14
#
# :upper - An integer that determines the threshold for colorization purposes.  Any value less than upper will be colored using below_color, anything above and equal to upper will use above_color.  Defaults to 50.
#
# :above_color - A string or color code representing the color to draw values above or equal the upper value.  Defaults to red.
#
# :below_color - A string or color code representing the color to draw values below the upper value. Defaults to gray.
	def self.discrete(results=[], options = {})

		height = options[:height].to_i
		upper = options[:upper].to_i
		below_color = options[:below_color]
		above_color = options[:above_color]

		img = Magick::Image.new(results.size * 2 - 1, height) {self.background_color = options[:background_color]}
		img.format = "PNG"
		draw = Magick::Draw.new

		i=0
		results.each do |r|
			color = (r >= upper) && above_color || below_color
			draw.stroke(color)
			draw.line(i, (img.rows - r/(101.0/(height-4))-4).to_i,i,(img.rows - r/(101.0/(height-4))).to_i)
			i+=2
		end

		draw.draw(img)
		img.to_blob
	end

# Creates a continuous area sparkline
#
# * results is an array of integer values between 0 and 100 inclusive
#
# * options is a hash that takes 4 parameters:
#
# :step - An integer that determines the distance between each point on the sparkline.  Defaults to 2.
#
# :height - An integer that determines what the height of the sparkline will be.  Defaults to 14
#
# :upper - An ineger that determines the threshold for colorization purposes.  Any value less than upper will be colored using below_color, anything above and equal to upper will use above_color.  Defaults to 50.
#
# :has_min - Determines whether a dot will be drawn at the lowest value or not.  Defaulst to false.
#
# :has_max - Determines whether a dot will be drawn at the highest value or not.  Defaulst to false.
#
# :has_last - Determines whether a dot will be drawn at the last value or not.  Defaulst to false.
#
# :min_color - A string or color code representing the color that the dot drawn at the smallest value will be displayed as.  Defaults to blue.
#
# :max_color - A string or color code representing the color that the dot drawn at the largest value will be displayed as.  Defaults to green.
#
# :last_color - A string or color code representing the color that the dot drawn at the last value will be displayed as.  Defaults to red.
#
# :above_color - A string or color code representing the color to draw values above or equal the upper value.  Defaults to red.
#
# :below_color - A string or color code representing the color to draw values below the upper value. Defaults to gray.
	def self.area(results=[], options={})
		
		step = options[:step].to_i
		height = options[:height].to_i
		upper = options[:upper].to_i

		has_min = options[:has_min]
		has_max = options[:has_max]
		has_last = options[:has_last]

		min_color = options[:min_color]
		max_color = options[:max_color]
		last_color = options[:last_color]
		below_color = options[:below_color]
		above_color = options[:above_color]

		img = Magick::Image.new((results.size - 1) * step + 4, height) {self.background_color = options[:background_color]}
		img.format = "PNG"
		draw = Magick::Draw.new

		coords = [[0,(height - 3 - upper/(101.0/(height-4)))]]
		i=0
		results.each do |r|
			coords.push [(2 + i), (height - 3 - r/(101.0/(height-4)))]
			i += step
		end
		coords.push [(results.size - 1) * step + 4, (height - 3 - upper/(101.0/(height-4)))]

		#Block off the bottom half of the image and draw the sparkline
		draw.fill(above_color)
		draw.define_clip_path('top') do
			draw.rectangle(0,0,(results.size - 1) * step + 4,(height - 3 - upper/(101.0/(height-4))))
		end
		draw.clip_path('top')
		draw.polygon *coords.flatten

		#Block off the top half of the image and draw the sparkline
		draw.fill(below_color)
		draw.define_clip_path('bottom') do
			draw.rectangle(0,(height - 3 - upper/(101.0/(height-4))),(results.size - 1) * step + 4,height)
		end
		draw.clip_path('bottom')
		draw.polygon *coords.flatten

		#The sparkline looks kinda nasty if either the above_color or below_color gets the center line
		draw.fill('black')
		draw.line(0,(height - 3 - upper/(101.0/(height-4))),(results.size - 1) * step + 4,(height - 3 - upper/(101.0/(height-4))))

		#After the parts have been masked, we need to let the whole canvas be drawable again
		#so a max dot can be displayed
		draw.define_clip_path('all') do
			draw.rectangle(0,0,img.columns,img.rows)
		end
		draw.clip_path('all')
		if has_min == 'true'
			min_pt = coords[results.index(results.min)+1]
			draw.fill(min_color)
			draw.rectangle(min_pt[0]-1, min_pt[1]-1, min_pt[0]+1, min_pt[1]+1)
		end
		if has_max == 'true'
			max_pt = coords[results.index(results.max)+1]
			draw.fill(max_color)
			draw.rectangle(max_pt[0]-1, max_pt[1]-1, max_pt[0]+1, max_pt[1]+1)
		end
		if has_last == 'true'
			last_pt = coords[-2]
			draw.fill(last_color)
			draw.rectangle(last_pt[0]-1, last_pt[1]-1, last_pt[0]+1, last_pt[1]+1)
		end

		draw.draw(img)
		img.to_blob
	end

# Creates a smooth sparkline
#
# * results - an array of integer values between 0 and 100 inclusive
#
# * options - a hash that takes these optional parameters:
#
# :step - An integer that determines the distance between each point on the sparkline.  Defaults to 2.
#
# :height - An integer that determines what the height of the sparkline will be.  Defaults to 14
#
# :has_min - Determines whether a dot will be drawn at the lowest value or not.  Defaulst to false.
#
# :has_max - Determines whether a dot will be drawn at the highest value or not.  Defaulst to false.
#
# :has_last - Determines whether a dot will be drawn at the last value or not.  Defaulst to false.
#
# :min_color - A string or color code representing the color that the dot drawn at the smallest value will be displayed as.  Defaults to blue.
#
# :max_color - A string or color code representing the color that the dot drawn at the largest value will be displayed as.  Defaults to green.
#
# :last_color - A string or color code representing the color that the dot drawn at the last value will be displayed as.  Defaults to red.
	def self.smooth(results, options)
	
		step = options[:step].to_i
		height = options[:height].to_i
		min_color = options[:min_color]
		max_color = options[:max_color]
		last_color = options[:last_color]
		has_min = options[:has_min]
		has_max = options[:has_max]
		has_last = options[:has_last]
		line_color = options[:line_color]

		img = Magick::Image.new((results.size - 1) * step + 4, height.to_i) {self.background_color = options[:background_color]}
		img.format = "PNG"
		draw = Magick::Draw.new
  
		draw.stroke(line_color)
		coords = []
		i=0
		results.each do |r|
			coords.push [ 2 + i, (height - 3 - r/(101.0/(height-4))) ]
			i += step
		end
		
		my_polyline(draw, coords)

		if has_min == true
			min_pt = coords[results.index(results.min)]
			draw.fill(min_color)
			draw.rectangle(min_pt[0]-2, min_pt[1]-2, min_pt[0]+2, min_pt[1]+2)
		end
		if has_max == true
			max_pt = coords[results.index(results.max)]
			draw.fill(max_color)
			draw.rectangle(max_pt[0]-2, max_pt[1]-2, max_pt[0]+2, max_pt[1]+2)
		end
		if has_last == true
			last_pt = coords[-1]
			draw.fill(last_color)
			draw.rectangle(last_pt[0]-2, last_pt[1]-2, last_pt[0]+2, last_pt[1]+2)
		end

		draw.draw(img)
		img.to_blob
	end


	# This is a function to replace the RMagick polyline function because it doesn't seem to work properly.
	#
	# * draw - a RMagick::Draw object. 
	#
	# * arr - an array of points (represented as two element arrays)
	def self.my_polyline (draw, arr)
		i = 0
		while i < arr.size - 1
			draw.line(arr[i][0], arr[i][1], arr[i+1][0], arr[i+1][1])
			i += 1
		end
	end

	# Draw the error Sparkline.  Not implemented yet.
	def self.plot_error(options={})
		img = Magick::Image.new(40,15) {self.background_color = options[:background_color]}
		img.format = "PNG"
		draw = Magick::Draw.new
		draw.fill('red')
		draw.line(0,0,40,15)
		draw.line(0,15,40,0)
		draw.draw(img)

		img.to_blob
	end

end
