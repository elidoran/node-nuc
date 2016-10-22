assert = require 'assert'
fromKeyValue = require '../../lib/from-keyvalue'

describe 'test fromKeyValue', ->

  describe 'with null/undefined args', ->

    errorMessagePattern = /fromKeyValue requires a `\w+` value/
    tests = [
      {prop:'values', args:[]}
      {prop:'key' , args:[{}]}
    ]

    for test in tests
      do (test) ->
        it "should throw an error for #{test.prop}", ->
          assert.throws fromKeyValue.bind(null, test.args...), errorMessagePattern

  tests = [
    {desc:'single key', should:'pair them', key:'KEY', value:'value', answer:{KEY:'value'}}
    {desc:'long single key', should:'pair them', key:'KEY_KEY', value:'value2', answer:{KEY_KEY:'value2'}}
    {desc:'two nested keys', should:'create two tier hierarchy', key:'ONE__TWO', value:'value3', answer:{ONE:{TWO:'value3'}}}
    {desc:'long key and nested key', should:'create two tier hierarchy', key:'ONE_ONE__TWO', value:'value4', answer:{ONE_ONE:{TWO:'value4'}}}
    {desc:'three nested keys', should:'create three tier hierarchy', key:'ONE__TWO_TWO__THREE', value:'value5', answer:{ONE:{TWO_TWO:{THREE:'value5'}}}}
    {desc:'four nested keys', should:'create four tier hierarch', key:'ONE__TWO__THREE__FOUR', value:'value6', answer:{ONE:{TWO:{THREE:{FOUR:'value6'}}}}}
  ]
  for test in tests
    do (test) -> describe "with #{test.desc}", ->
        it "should #{test.should}", ->
          result = {}
          fromKeyValue(result, test.key, test.value)
          assert.deepEqual result, test.answer
