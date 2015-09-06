assert = require 'assert'
getFiles = require '../../lib/file-list'

describe 'test getFiles', ->

  errorMessagePattern = /getFiles requires `id` value/

  it 'should throw error when id is undefined', ->

    assert.throws getFiles, errorMessagePattern

  it 'should throw error when id is null', ->

    assert.throws getFiles.bind null, null, errorMessagePattern

  describe 'with valid id', ->
    # NOTE: I'm running my tests on Mac
    # TODO: add platform specific content
    # TODO: can i alter process.platform to run multiple modes for this test?
    cwd = process.cwd()
    home = process.env.HOME
    expected = [
      '/usr/lib/node_modules/id/id.conf'
      '/usr/lib/node_modules/id/id.json'
      '/usr/lib/node_modules/id/.idrc'
      '/usr/lib/node_modules/id/idrc'

      '/usr/local/lib/node_modules/id/id.conf'
      '/usr/local/lib/node_modules/id/id.json'
      '/usr/local/lib/node_modules/id/.idrc'
      '/usr/local/lib/node_modules/id/idrc'

      '/etc/id.conf'
      '/etc/id.json'
      '/etc/.idrc'
      '/etc/idrc'

      '/etc/id/id.conf'
      '/etc/id/id.json'
      '/etc/id/.idrc'
      '/etc/id/idrc'

      home + '/id.conf'
      home + '/id.json'
      home + '/.idrc'
      home + '/idrc'

      home + '/id/id.conf'
      home + '/id/id.json'
      home + '/id/.idrc'
      home + '/id/idrc'

      cwd + '/id.conf'
      cwd + '/id.json'
      cwd + '/.idrc'
      cwd + '/idrc'

      cwd + '/id/id.conf'
      cwd + '/id/id.json'
      cwd + '/id/.idrc'
      cwd + '/id/idrc'
    ]

    files = getFiles 'id'
    for file,index in files
      do (file, index) ->
        it 'should have: '+expected[index], ->
          assert.equal file, expected[index]
