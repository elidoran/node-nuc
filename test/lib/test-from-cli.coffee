assert = require 'assert'
fromCli = require '../../lib/from-Cli'

describe 'test fromCli', ->

  tests = [
    {desc:'single key', should:'pair them', key:'--ID_KEY', value:'value', answer:{KEY:'value'}}
    {desc:'long single key', should:'pair them', key:'--ID_KEY_KEY', value:'value2', answer:{KEY_KEY:'value2'}}
    {desc:'two nested keys', should:'create two tier hierarchy', key:'--ID_ONE__TWO', value:'value3', answer:{ONE:{TWO:'value3'}}}
    {desc:'long key and nested key', should:'create two tier hierarchy', key:'--ID_ONE_ONE__TWO', value:'value4', answer:{ONE_ONE:{TWO:'value4'}}}
    {desc:'three nested keys', should:'create three tier hierarchy', key:'--ID_ONE__TWO_TWO__THREE', value:'value5', answer:{ONE:{TWO_TWO:{THREE:'value5'}}}}
    {desc:'four nested keys', should:'create four tier hierarch', key:'--ID_ONE__TWO__THREE__FOUR', value:'value6', answer:{ONE:{TWO:{THREE:{FOUR:'value6'}}}}}
  ]
  for test in tests
    do (test) ->
      describe "with #{test.desc}", ->
        it "should #{test.should}", ->
          process.argv.push test.key + '=' + test.value
          result = {}
          fromCli id:'id', values:result
          process.argv.pop()
          assert.deepEqual result, test.answer
