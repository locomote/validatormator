orm   = require "orm"
async = require "async"

global.Models ?= {}

connect = (cb) ->
  return cb(@_db) if @_db?
  orm.connect "sqlite://", (err, db) =>
    throw err if err
    @_db = db
    cb(@_db)

syncSchema = (done) ->
  connect (db) ->
    dropTable = (name, cb) ->
      global.Models[name].drop (err) ->
        # console.log '.' unless err
        cb(err)

    createTable = (name, cb) ->
      model = global.Models[name]
      model.sync (err) ->
        # console.log '.' unless err
        cb(err)

    # console.log "Dropping tables..."
    modelNames = Object.keys global.Models
    async.eachSeries modelNames, dropTable, (err) ->
      throw err if err

      # console.log '-- tables dropped'
      # console.log "Creating tables..."

      async.eachSeries modelNames, createTable, (err) ->
        throw err if err
        # console.log '-- tables created'
        done()

defineModel = (modelName, args...) ->
  connect (db) ->
    name = modelName[0].toUpperCase() + modelName.slice(1)
    global.Models[name] = db.define modelName, args...

module.exports = 
  defineModel:  defineModel
  syncSchema:   syncSchema
