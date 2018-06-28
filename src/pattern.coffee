match = (regex, val, msg, cb) ->
  if regex.test val
    return cb?() or true
  cb?(msg) or false

module.exports = v =
  emailSync: (email) ->
    regex = /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$/
    match regex, email

  email: (msg = "Invalid Email specified") ->
    (email, cb) ->
      return cb(msg) unless v.emailSync(email)
      cb()

  urlSync: (url, opts = {}) ->
    # based upon https://gist.github.com/dperini/729294

    excludePrivateAndLocalNetworks =
      # IP address exclusion
      # private & local networks
      "10(?:\\.\\d{1,3}){3}" +
      "|127(?:\\.\\d{1,3}){3}" +
      "|169\\.254(?:\\.\\d{1,3}){2}" +
      "|192\\.168(?:\\.\\d{1,3}){2}" +
      "|172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2}"

    pre =
      "^" +
      # protocol identifier
      "(?:(?:https?|ftp)://)" +
      # user:pass authentication
      "(?:\\S+(?::\\S*)?@)?"

    post =
      # port number
      "(?::\\d{2,5})?" +
      # resource path
      "(?:/[^\\s]*)?" +
      "$"

    localStr =
      "^((?:" +
      "(?:\\\\)" +
      # one or more paths
      "(?:\\\\[^\\s\\\\/]+)+" +
      # optional filename extension
      "(?:\\.[^\\s\\\\/]*)?" +
      ")|(?:" +
      "file:////" +
      # one or more paths
      "(?:/[^\\s\\\\/]+)+" +
      # optional filename extension
      "))(?:\\.[^\\s\\\\/]*)?$"

    # noting that a common error is to submit the address without the TLD,
    # this allows us to reject such malformed data that could have us backtracking for hours
    # no, seriously: hours. https://code.google.com/p/v8/issues/detail?id=2254
    hostFirstPass =
        # ignore lower-order domain segments ....
        "(?:.*)\\." +
        # ..... and just try to match the last segment:
        "(?:" +
          # last IP address dotted notation octet, ...
          "(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4])" +
          "|" +
          #  ... or the TLD identifier
          "(?:[a-z\\u00a1-\\uffff]{2,10})" + # are there tlds more than 10 chars long?
        ")"

    hostSecondPass = "(?:" +
        # IP address dotted notation octets
        # excludes loopback network 0.0.0.0
        # excludes reserved space >= 224.0.0.0
        # excludes network & broacast addresses
        # (first & last IP address of each class)
        "(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])" +
        "(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}" +
        "(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))" +
      "|" +
        # host name
        "(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)" +
        # domain name
        "(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*" +
        # TLD identifier
        "(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))" +
      ")"

    if opts.allowLocalFiles
      if match new RegExp(localStr, "i"), url
       return true

    return false unless match new RegExp(pre + hostFirstPass + post, "i"), url
    return false unless match new RegExp(pre + hostSecondPass + post, "i"), url
    return true if opts.allowPrivateNetworks
    not match new RegExp( pre + excludePrivateAndLocalNetworks + post, "i" ), url

  url: (msg = "Invalid Url specified", opts) ->
    (url, cb) ->
      return cb(msg) unless v.urlSync(url, opts)
      cb()
