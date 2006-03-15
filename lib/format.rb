module Format

  EMAIL = /^[_a-z0-9\+\.\-]+\@[_a-z0-9\-]+\.[_a-z0-9\.\-]+$/i
  PASSWORD = /^[\_a-zA-Z0-9\.\-]+$/


  # matches everything to the last \ or / in a string.
  # can chop of path of a filename like this : '/tobi/home/tobi.jpg'.sub(/^.*[\\\/]/,'') => tobi.jpg
  FILENAME = /^.*[\\\/]/

  # good for replacing all special chars with something else, like an underscore
  FILENORMAL = /[^a-zA-Z0-9.]/

  # Laxly matches an IP Address , would also pass numbers > 255 though
  IP_ADDRESS = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/

  # Laxly matches an HTTP(S) URI
  HTTP_URI = /^https?:\/\/\S+$/
end
