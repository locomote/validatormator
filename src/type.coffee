schema = require 'jsonschema'


adheresToSchemas = (obj, theSchemas = []) ->
  return true unless theSchemas.length and theSchemas.forEach?

  validator = new schema.Validator
  for aSchema, idx in theSchemas

    # parse the schema if necessary
    if typeof aSchema is 'string'
      try
        aSchema = JSON.parse aSchema
      catch e
        return false

    validator.addSchema aSchema, "schema-#{idx}"
    res = validator.validate obj, aSchema
    return false unless res.valid

  true

module.exports = v =
  JSONSync: (json, opts = {}) ->
    return false if opts.allowNull is false and not json?

    obj = null
    try
      obj = JSON.parse json

      return ( typeof obj is 'object' )          if opts.mustBeObject
      return adheresToSchemas(obj, opts.schemas) if opts.schemas
      true

    catch e
      false

  JSON: (msg = "Invalid JSON string specified", opts) ->
    (json, cb) ->
      if typeof opts is 'function' and not cb?
        cb   = opts
        opts = {}

      return cb(msg) unless v.JSONSync(json, opts)
      cb()
