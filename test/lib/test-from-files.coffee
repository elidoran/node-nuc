fs        = require 'fs'
path      = require 'path'
assert    = require 'assert'
fromFiles = require '../../lib/from-files.coffee'

describe 'test fromFiles', ->

  id = 'testingid'
  tempdir = path.resolve 'test', 'temp'

  describe 'with json file', ->

    it 'should read it as JSON into an object', ->
      cwd = process.cwd()
      process.chdir tempdir

      jsonfile = path.join tempdir, id + '.json'
      json = some:'thing', something:'else', sub:{thing:{stuff:'more'}}
      fs.writeFileSync jsonfile, JSON.stringify json
      {values} = fromFiles id:id, values:{}, platform:'darwin'
      fs.unlinkSync jsonfile
      assert.deepEqual values, json

      process.chdir cwd

  describe 'with ini file', ->

    it 'should read it as ini into an object', ->
      cwd = process.cwd()
      process.chdir tempdir

      inifile = path.join tempdir, id + '.ini'
      iniobject =
        header:
          key1:'value1'
        header2:
          key2:'value2'
          key3:'value3'
        header3:
          key3:true

      ini  = """
             [header]
             key1=value1

             [header2]
             key2=value2
             key3=value3

             [header3]
             key3
             """

      fs.writeFileSync inifile, ini
      {values} = fromFiles id:id, values:{}, platform:'win32'
      fs.unlinkSync inifile
      assert.deepEqual values, iniobject

      process.chdir cwd
