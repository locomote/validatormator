should     = require 'should'
helper     = require './support/spec_helper'
validators = require '../index.coffee'
urls       = require './fixtures/patterns/urls'

describe 'ORM2 Integration', ->
  describe '#urls', ->
    before (done)->
      @errorMsg = "Bad Url"
      helper.defineModel "blog", {name : String, blogUrl: String},
        validations:
          blogUrl: validators.pattern.url(@errorMsg)
      helper.syncSchema done

    describe 'valid urls', ->
      for url in urls.valid
        it "should allow #{url}", (done) ->
          Models.Blog.create {name: 'my blog', blogUrl: url}, (err, blog) ->
            should.not.exist err
            blog.name.should.eql 'my blog'
            blog.blogUrl.should.eql url
            done()

    describe 'invalid urls', ->
      for url in urls.invalid
        it "should not allow #{url}", (done) ->
          Models.Blog.create {name: 'my blog', blogUrl: url}, (err, blog) =>
            should.not.exist blog
            err.msg.should.eql @errorMsg
            done()
