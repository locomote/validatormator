should = require 'should'
helper = require './support/spec_helper'
validators = require '../index'
fixtures   = require './fixtures/patterns'

shouldBehaveLikeAnAsyncValidator = (validatorFn, defaultErrorMessage, fixtures) ->
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


shouldBehaveLikeASyncValidator = (validatorFn, defaultErrorMessage, fixtures) ->
  describe 'valid', ->
    for validCase in fixtures.valid
      do (validCase) ->
        it "should allow #{validCase}", ->
          validatorFn(validCase).should.be.true


  describe 'invalid', ->
    for invalidCase in fixtures.invalid
      do (invalidCase) ->
        it "should not allow #{invalidCase}", ->
          validatorFn(invalidCase).should.be.false

describe '#urls',      -> shouldBehaveLikeAnAsyncValidator(validators.pattern.url,     "Invalid Url specified", fixtures.urls)
describe '#urlSync',   -> shouldBehaveLikeASyncValidator(validators.pattern.urlSync,   "Invalid Url specified", fixtures.urls)
describe '#emails',    -> shouldBehaveLikeAnAsyncValidator(validators.pattern.email,   "Invalid Email specified", fixtures.emails)
describe '#emailSync', -> shouldBehaveLikeASyncValidator(validators.pattern.emailSync, "Invalid Email specified", fixtures.emails)
