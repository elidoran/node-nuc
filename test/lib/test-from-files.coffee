fs        = require 'fs'
path      = require 'path'
assert    = require 'assert'
fromFiles = require '../../lib/from-files.coffee'

describe 'test fromFiles', ->

  id = 'testingid'

  describe 'with json file', ->

    it 'should read it as JSON into an object', ->

      jsonfile = path.join(process.cwd(), id + '.json')
      json = some:'thing', something:'else', sub:{thing:{stuff:'more'}}
      fs.writeFileSync jsonfile, JSON.stringify json
      {values} = fromFiles id:id, values:{}
      fs.unlinkSync jsonfile
      assert.deepEqual values, json

  describe 'with ini file', ->

    it 'should read it as ini into an object', ->

      inifile = path.join(process.cwd(), id + '.ini')
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
      platform = process.platform
      process.platform = 'win32'
      {values} = fromFiles id:id, values:{}
      fs.unlinkSync inifile
      process.platform = platform
      assert.deepEqual values, iniobject
