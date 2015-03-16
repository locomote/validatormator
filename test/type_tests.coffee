should = require 'should'
helper = require './support/spec_helper'
AsyncTests = require './support/async_assertion'
SyncTests  = require './support/sync_assertion'
validators = require '../index'
fixtures   = require './fixtures/types'

describe '#JSON',       -> AsyncTests(validators.type.JSON,    "Invalid JSON string specified", fixtures.json)
describe '#JSONSync',   -> SyncTests(validators.type.JSONSync, "Invalid JSON string specified", fixtures.json)
