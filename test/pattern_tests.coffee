should = require 'should'
helper = require './support/spec_helper'
AsyncTests = require './support/async_assertion'
SyncTests  = require './support/sync_assertion'
validators = require '../index'
fixtures   = require './fixtures/patterns'

describe '#urls',      -> AsyncTests(validators.pattern.url,     "Invalid Url specified", fixtures.urls)
describe '#urlSync',   -> SyncTests(validators.pattern.urlSync,   "Invalid Url specified", fixtures.urls)
describe '#urlSync opts', ->
  describe 'allowPrivateNetworks is true', ->
    for validCase in fixtures.urls.privateNetworks
      do (validCase) ->
        it "should allow #{validCase}", ->
          validators.pattern.urlSync(validCase, allowPrivateNetworks: true).should.be.true

  describe 'allowPrivateNetworks is false', ->
    for validCase in fixtures.urls.privateNetworks
      do (validCase) ->
        it "should not allow #{validCase}", ->
          validators.pattern.urlSync(validCase).should.be.false

  describe 'allowLocalFiles is true', ->
    for validCase in fixtures.urls.localFiles
      do (validCase) ->
        it "should allow #{validCase}", ->
          validators.pattern.urlSync(validCase, allowLocalFiles: true).should.be.true

    for invalidCase in fixtures.urls.localFilesInvalid
      do (invalidCase) ->
        it "should not allow #{invalidCase}", ->
          validators.pattern.urlSync(invalidCase, allowLocalFiles: true).should.be.false

  describe 'allowLocalFiles is false', ->
    for validCase in fixtures.urls.localFiles
      do (validCase) ->
        it "should not allow #{validCase}", ->
          validators.pattern.urlSync(validCase).should.be.false


describe '#emails',    -> AsyncTests(validators.pattern.email,   "Invalid Email specified", fixtures.emails)
describe '#emailSync', -> SyncTests(validators.pattern.emailSync, "Invalid Email specified", fixtures.emails)
