should = require 'should'

module.exports = (validatorFn, defaultErrorMessage, fixtures) ->

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

