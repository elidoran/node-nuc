assert = require 'assert'
nuc = require '../../lib'

describe 'test nuc', ->

  id = 'testingid'

  describe 'without id', ->

    it 'should throw error', ->

      assert.throws nuc, /`id` required for nuc/

  describe 'without defaults', ->

    it 'should use an empty object', ->
      values = undefined
      values = nuc id:id
      assert.equal values?, true

  describe 'with defaults', ->

    it 'should be used', ->
      defaults = some:'thing',else:'an',other:'thing'
      result = nuc id:id, defaults:defaults
      assert.deepEqual result, defaults

# TODO: make test files in multiple places and test they are found...
