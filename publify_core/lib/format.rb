module Format
  # Laxly matches an IP Address , would also pass numbers > 255 though
  IP_ADDRESS = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/

  # Laxly matches an HTTP(S) URI
  HTTP_URI = %r{^https?:\/\/\S+$}
end
