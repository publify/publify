# jQuery jQuery throttle / debounce: Sometimes, less is more! #
[http://benalman.com/projects/jquery-throttle-debounce-plugin/](http://benalman.com/projects/jquery-throttle-debounce-plugin/)

Version: 1.1, Last updated: 3/7/2010

jQuery throttle / debounce allows you to rate-limit your functions in multiple useful ways. Passing a delay and callback to `$.throttle` returns a new function that will execute no more than once every `delay` milliseconds. Passing a delay and callback to `$.debounce` returns a new function that will execute only once, coalescing multiple sequential calls into a single execution at either the very beginning or end.

Visit the [project page](http://benalman.com/projects/jquery-throttle-debounce-plugin/) for more information and usage examples!


## Documentation ##
[http://benalman.com/code/projects/jquery-throttle-debounce/docs/](http://benalman.com/code/projects/jquery-throttle-debounce/docs/)


## Examples ##
These working examples, complete with fully commented code, illustrate a few
ways in which this plugin can be used.

[http://benalman.com/code/projects/jquery-throttle-debounce/examples/throttle/](http://benalman.com/code/projects/jquery-throttle-debounce/examples/throttle/)  
[http://benalman.com/code/projects/jquery-throttle-debounce/examples/debounce/](http://benalman.com/code/projects/jquery-throttle-debounce/examples/debounce/)  

## Support and Testing ##
Information about what version or versions of jQuery this plugin has been
tested with, what browsers it has been tested in, and where the unit tests
reside (so you can test it yourself).

### jQuery Versions ###
none, 1.3.2, 1.4.2

### Browsers Tested ###
Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome, Opera 9.6-10.1.

### Unit Tests ###
[http://benalman.com/code/projects/jquery-throttle-debounce/unit/](http://benalman.com/code/projects/jquery-throttle-debounce/unit/)


## Release History ##

1.1 - (3/7/2010) Fixed a bug in jQuery.throttle where trailing callbacks executed later than they should. Reworked a fair amount of internal logic as well.  
1.0 - (3/6/2010) Initial release as a stand-alone project. Migrated over from jquery-misc repo v0.4 to jquery-throttle repo v1.0, added the no_trailing throttle parameter and debounce functionality.  


## License ##
Copyright (c) 2010 "Cowboy" Ben Alman  
Dual licensed under the MIT and GPL licenses.  
[http://benalman.com/about/license/](http://benalman.com/about/license/)
