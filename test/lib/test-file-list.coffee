assert = require 'assert'
getFiles = require '../../lib/file-list'

describe 'test file-list', ->

  errorMessagePattern = /getFiles requires `options` value/

  it 'should throw error when options is undefined', ->

    assert.throws getFiles, errorMessagePattern

  it 'should throw error when options is null', ->

    assert.throws getFiles.bind null, null, errorMessagePattern

  describe 'for *nix', ->

    describe 'with valid id', ->
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

        '~/.conf/id.conf'
        '~/.conf/id.json'
        '~/.conf/.idrc'
        '~/.conf/idrc'
        '~/.conf/id'

        '~/conf/id.conf'
        '~/conf/id.json'
        '~/conf/.idrc'
        '~/conf/idrc'
        '~/conf/id'

        '~/id.conf'
        '~/id.json'
        '~/.idrc'
        '~/idrc'

        '~/id/id.conf'
        '~/id/id.json'
        '~/id/.idrc'
        '~/id/idrc'
      ]

      # TODO: how do i test the pwd hierarchy ones??
      pwd = [
        '.conf/id.conf'
        '.conf/id.json'
        '.conf/.idrc'
        '.conf/idrc'
        '.conf/id'

        'conf/id.conf'
        'conf/id.json'
        'conf/.idrc'
        'conf/idrc'
        'conf/id'

        'id.conf'
        'id.json'
        '.idrc'
        'idrc'

        'id/id.conf'
        'id/id.json'
        'id/.idrc'
        'id/idrc'
      ]

      files = getFiles id:'id', platform:'darwin'
      for file,index in files
        do (file, index) ->
          if index < expected.length
            it 'should have: ' + expected[index], ->
              assert.equal file, expected[index]

  describe 'for windows', ->

    process.env.ALLUSERSPROFILE ?= '/allusers'
    process.env.APPDATA        ?= '/appdata'
    process.env.USERPROFILE    ?= process.env.HOME

    describe 'with valid id', ->

      alldata = process.env.ALLUSERSPROFILE
      appdata = process.env.APPDATA
      home    = process.env.USERPROFILE

      expected = [
        alldata + '/id.ini'
        alldata + '/id.json'
        alldata + '/idrc'

        alldata + '/id/id.ini'
        alldata + '/id/id.json'
        alldata + '/id/idrc'

        appdata + '/id.ini'
        appdata + '/id.json'
        appdata + '/idrc'

        appdata + '/id/id.ini'
        appdata + '/id/id.json'
        appdata + '/id/idrc'

        home + '/conf/id.ini'
        home + '/conf/id.json'
        home + '/conf/idrc'
        home + '/conf/id'

        home + '/id.ini'
        home + '/id.json'
        home + '/idrc'

        home + '/id/id.ini'
        home + '/id/id.json'
        home + '/id/idrc'
      ]

      # TODO: how do i test the pwd hierarchy ones??
      pwd = [
        'conf/id.ini'
        'conf/id.json'
        'conf/idrc'
        'conf/id'

        'id.ini'
        'id.json'
        'idrc'

        'id/id.ini'
        'id/id.json'
        'id/idrc'
      ]

      files = getFiles id:'id', platform:'win32'
      for file,index in files
        do (file, index) ->
          if index < expected.length
            it 'should have: ' + expected[index], ->
              assert.equal file, expected[index]
