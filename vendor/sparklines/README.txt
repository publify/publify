**********************************
** Spark Graph Library for Ruby **
**********************************

Geoffrey Grosenbach
boss@topfunky.com
http://nubyonrails.topfunky.com

Daniel Nugent
nugend@gmail.com


*** What is it? ***

A library for generating small sparkline graphs from Ruby. Use it in desktop apps or Rails apps. See the samples in the 'samples' directory.


*** How do I use it? ***

Read the meager documentation in the enclosed 'docs' folder.

In Rails, copy the included files (sparklines_controller.rb, sparklines_helper.rb, sparklines.rb) into your controller, helper, and lib directories, respectively.

In your custom controller, do
	require_dependency 'sparklines'
and 
	helper :sparklines

In your view, call it like this:

<%= sparklines_tag [1,2,3,4,5,6] %> <!-- Gives you a smooth graph -->

Or specify details:

<%= sparklines_tag [1,2,3,4,5,6], :type => 'discrete', :height => 10, :upper => 80, :above_color => 'green', :below_color => 'blue' %>


**********************************
CHANGES
**********************************

0.2.1

* Added line_color option for smooth graphs
* Now available as a gem ('gem install sparklines') and as a rails generator ('gem install sparklines_generator')


