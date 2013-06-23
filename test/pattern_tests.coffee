should = require 'should'
helper = require './support/spec_helper'
validators = require '../index'
fixtures   = require './fixtures/patterns'

shouldBehaveLikeAValidator = (validatorFn, defaultErrorMessage, fixtures) ->
  describe 'valid', ->
    for validCase in fixtures.valid
      ((testCase)->
        it "should allow #{testCase}", (done) =>
          validate = validatorFn()
          validate testCase, (err) ->
            should.not.exist err
            done()
      )(validCase)

  describe 'invalid', ->
    it 'should return a custom error message', (done) ->
      validate = validatorFn "My Error Message"
      validate fixtures.invalid[0], (err) ->
        err.should.eql "My Error Message"
        done()

    for invalidCase in fixtures.invalid
      ((testCase) ->
        it "should not allow #{testCase}", (done) =>
          validate = validatorFn()
          validate testCase, (err) ->
            should.exist err
            err.should.eql defaultErrorMessage
            done()
      )(invalidCase)

describe '#urls',   -> shouldBehaveLikeAValidator(validators.pattern.url, "Invalid Url specified", fixtures.urls)
describe '#emails', -> shouldBehaveLikeAValidator(validators.pattern.email, "Invalid Email specified", fixtures.emails)
