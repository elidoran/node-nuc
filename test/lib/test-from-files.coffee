fs        = require 'fs'
corepath  = require 'path'
assert    = require 'assert'
fromFiles = require '../../lib/from-files.coffee'

describe 'test fromFiles', ->

  id = 'testingid'

  describe 'with multiple json files in hierarchy', ->

    it 'should find all the files', ->

      tempdir   = corepath.resolve __dirname, '..', 'temp'
      topdir    = corepath.resolve tempdir, 'top'
      middledir = corepath.resolve topdir, 'middle'
      bottomdir = corepath.resolve middledir, 'bottom'

      # remember where we are so we can return
      cwd = process.cwd()

      # move to the bottom of the temp dir
      process.chdir bottomdir

      # now have fromFiles find it
      options =
        id: id
        platform: 'darwin'
        store:
          append: (file) ->
            # console.log 'append:',file
            options.store.array.push file
          array: []

      {objects} = fromFiles options

      # move back
      process.chdir cwd

      assert.equal objects[0], corepath.join tempdir, 'testingid', 'testingid.json'
      assert.equal objects[1], corepath.join topdir, 'testingid', 'testingid.json'
      assert.equal objects[2], corepath.join middledir, 'testingid.json'
      assert.equal objects[3], corepath.join bottomdir, 'testingid.json'

  describe 'with multiple ini files in hierarchy', ->

    it 'should final all the files', ->

      tempdir   = corepath.resolve __dirname, '..', 'temp2'
      topdir    = corepath.resolve tempdir, 'top'
      middledir = corepath.resolve topdir, 'middle'
      bottomdir = corepath.resolve middledir, 'bottom'

      # remember where we are so we can return
      cwd = process.cwd()

      # move to the bottom of the temp dir
      process.chdir bottomdir

      # now have fromFiles find it
      options =
        id: id
        platform: 'darwin'
        store:
          append: (file) ->
            # console.log 'append:',file
            options.store.array.push file
          array: []

      {objects} = fromFiles options

      # move back
      process.chdir cwd

      assert.equal objects[0], corepath.join tempdir, 'testingid', 'testingid.ini'
      assert.equal objects[1], corepath.join topdir, 'testingid', 'testingid.ini'
      assert.equal objects[2], corepath.join middledir, 'testingid.ini'
      assert.equal objects[3], corepath.join bottomdir, 'testingid.ini'
