should = require 'should'
helper = require './support/spec_helper'
AsyncTests = require './support/async_assertion'
SyncTests  = require './support/sync_assertion'
validators = require '../index.coffee'
fixtures   = require './fixtures/types'

describe '#JSON',       -> AsyncTests(validators.type.JSON,    "Invalid JSON string specified", fixtures.json)
describe '#JSONSync',   -> SyncTests(validators.type.JSONSync, "Invalid JSON string specified", fixtures.json)
describe '#JSON opts', ->
  describe 'allowNull', ->
    it "should default to true", ->
      validators.type.JSONSync(null).should.be.true

    it "should allow nulls if allowNull is true", ->
      validators.type.JSONSync(null, allowNull: true).should.be.true

    it "should not allow nulls if allowNull is false", ->
      validators.type.JSONSync(null, allowNull: false).should.be.false

  describe 'mustBeObject', ->
    it "should allow objects if mustBeObject is true", ->
      validators.type.JSONSync("{}", mustBeObject: true).should.be.true

    it "should not allow numbers if mustBeObject is true", ->
      validators.type.JSONSync(1, mustBeObject: true).should.be.false

    it "should allow numbers if mustBeObject is false", ->
      validators.type.JSONSync(1, mustBeObject: false).should.be.true

    it "should default to false", ->
      validators.type.JSONSync(1).should.be.true

  describe 'schemas', ->
    schemas = []
    json    = null

    before ->
      schemas.push
        id   : "http://test.com/schemas/something"
        type : "object"
        required: [ "name", "age" ]
        properties:
          name:
            id   : "http://test.com/schemas/something/currency"
            type : "string"
          age:
            id   : "http://test.com/schemas/something/age"
            type : "number"

      json = JSON.stringify(name: 'Ben', age: 37)

    it 'should allow json adhering to a schema', ->
      validators.type.JSONSync(json, schemas: schemas).should.be.true

    it 'should allow schemas as strings', ->
      s = [ JSON.stringify( schemas[0] ) ]
      validators.type.JSONSync(json, schemas: s).should.be.true

    it 'should return false if a dodgy schema is given', ->
      s = [ 'asdasd' ]
      validators.type.JSONSync(json, schemas: s).should.be.false

    it 'should not allow json not adhering to a schema', ->
      validators.type.JSONSync(JSON.stringify(hairColor: 'Blue'), schemas: schemas).should.be.false

    it 'should return false if a dodgy schema is given', ->
      json = JSON.stringify(hairColor: 'Blue')
      validators.type.JSONSync(json, schemas: schemas).should.be.false