assert = require 'assert'
findId = require '../../lib/find-id'

describe 'test findId', ->

  describe 'with id', ->

    it 'should return the id', ->

      id = 'test'
      result = findId id:id
      assert.equal result, id

  describe 'without id', ->

    id = 'test'

    describe 'with npm config prop', ->

      before 'add npm config prop', -> process.env.npm_package_config_nucid = 'test'

      after 'remove npm config prop', -> delete process.env.npm_package_config_nucid

      it 'should find it', ->

        options = {}
        result = findId options

        assert.equal result, id
        assert.equal options.id, id


    describe 'with env prop', ->

      before 'add env prop', -> process.env.NUCID = 'test'

      after 'remove env prop', -> delete process.env.NUCID

      it 'should find it', ->

        options = {}
        result = findId options

        assert.equal result, id
        assert.equal options.id, id


    describe 'with cli arg', ->

      before 'add cli arg', -> process.argv.push '--nucid=test'

      after 'remove cli arg', -> process.argv.pop()

      it 'should find it', ->

        options = {}
        result = findId options

        assert.equal result, id
        assert.equal options.id, id


    describe 'with .nuc.name in CWD', ->

      cwd = process.cwd()

      before 'move to test dir with .nuc.name file', ->

        process.chdir require('path').resolve 'test', 'helpers'

      after 'return to original cwd', -> process.chdir cwd

      it 'should find it', ->

        options = {}
        result = findId options

        assert.equal result, id
        assert.equal options.id, id


    describe 'with noFindID', ->

      it 'should return nothing', ->

        options = noFindId:true
        result = findId options

        assert.equal result, undefined


    describe 'without id anywhere', ->

      it 'should return error', ->

        result = findId()

        assert.equal result?.__error, '`id` required for nuc'
