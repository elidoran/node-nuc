assert = require 'assert'
nuc = require '../../lib'

describe 'test nuc', ->

  id = 'testingid'

  describe 'without id', ->

    it 'should return error', ->

      actual   = nuc()
      expected = __error: '`id` required for nuc'
      assert.deepEqual actual, expected

  describe 'without defaults', ->

    it 'should use an empty object', ->

      values = nuc id:id
      assert.equal values?, true
      assert.deepEqual values, {}

  describe 'with defaults', ->

    it 'should be used', ->
      defaults = some:'thing',else:'an',other:'thing'
      result = nuc id:id, defaults:defaults
      assert.deepEqual result, defaults
