assert = require 'assert'
fromCli = require '../../lib/from-cli'

describe 'test fromCli', ->

  tests = [
    {desc:'single key', should:'pair them', key:'--ID_KEY', value:'value', answer:{KEY:'value'}}
    {desc:'long single key', should:'pair them', key:'--ID_KEY_KEY', value:'value2', answer:{KEY_KEY:'value2'}}
    {desc:'two nested keys', should:'create two tier hierarchy', key:'--ID_ONE__TWO', value:'three', answer:{ONE:{TWO:'three'}}}
    {desc:'long key and nested key', should:'create two tier hierarchy', key:'--ID_ONE_ONE__TWO', value:'three', answer:{ONE_ONE:{TWO:'three'}}}
    {desc:'three nested keys', should:'create three tier hierarchy', key:'--ID_ONE__TWO_TWO__THREE', value:'four', answer:{ONE:{TWO_TWO:{THREE:'four'}}}}
    {desc:'four nested keys', should:'create four tier hierarch', key:'--ID_ONE__TWO__THREE__FOUR', value:'five', answer:{ONE:{TWO:{THREE:{FOUR:'five'}}}}}
  ]
  for test in tests
    do (test) ->
      describe "with #{test.desc}", ->
        it "should #{test.should}", ->
          process.argv.push test.key + '=' + test.value
          result = fromCli id:'id'
          process.argv.pop()
          assert.equal result?.objects?[0]?.__source, 'cli'
          assert.deepEqual result?.objects?[0], test.answer
