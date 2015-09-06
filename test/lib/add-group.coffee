assert = require 'assert'
addGroup = require '../../lib/add-group'

describe 'test addGroup', ->

  describe 'with null/undefined args', ->

    errorMessagePattern = /addGroup requires a `\w+` value/
    files = []
    tests = [
      {prop:'files', args:[]}
      {prop:'root' , args:[files]}
      {prop:'id'   , args:[files, 'Grooooot']}
      {prop:'tail' , args:[files, 'root', 'ID Please']}
    ]

    for test in tests
      do (test) ->
        it "should throw an error for #{test.prop}", ->
          assert.throws addGroup.bind(addGroup, test.args...), errorMessagePattern

  tests = [
    {length: 4, args:[[], 'root', 'id', '.conf']}
    {length: 2, args:[[], 'root', 'id', '.ini']}
  ]

  for test in tests
    do (test) ->
      files = test.args[0]
      tail = test.args[3]
      describe 'with ' + tail, ->

        addGroup.apply null, test.args

        it "should have #{test.length} files", ->
          assert.equal files.length, test.length

        it "should have root/id#{tail}", ->
          assert.equal files[0], 'root/id' + tail

        it "should have root/id.json", ->
          assert.equal files[1], 'root/id.json'

        unless test.length is 2
          it "should have root/.idrc", ->
            assert.equal files[2], 'root/.idrc'

          it "should have root/idrc", ->
            assert.equal files[3], 'root/idrc'
