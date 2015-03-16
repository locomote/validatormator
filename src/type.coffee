module.exports = v =
  JSONSync: (json) ->
    try
      JSON.parse json
      true
    catch e
      false

  JSON: (msg = "Invalid JSON string specified") ->
    (json, cb) ->
      return cb(msg) unless v.JSONSync(json)
      cb()
