assert = require 'assert'
fromKeyValue = require '../../lib/from-keyvalue'

describe 'test fromKeyValue', ->

  describe 'with null/undefined args', ->

    it 'should return without doing anything', ->

      target = {}
      fromKeyValue target

      assert.equal Object.keys(target).length, 0

  tests = [
    {desc:'single key', should:'pair them', key:'KEY', value:'value', answer:{KEY:'value'}}
    {desc:'long single key', should:'pair them', key:'KEY_KEY', value:'value2', answer:{KEY_KEY:'value2'}}
    {desc:'two nested keys', should:'create two tier hierarchy', key:'ONE__TWO', value:'three', answer:{ONE:{TWO:'three'}}}
    {desc:'long key and nested key', should:'create two tier hierarchy', key:'ONE_ONE__TWO', value:'three', answer:{ONE_ONE:{TWO:'three'}}}
    {desc:'three nested keys', should:'create three tier hierarchy', key:'ONE__TWO_TWO__THREE', value:'four', answer:{ONE:{TWO_TWO:{THREE:'four'}}}}
    {desc:'four nested keys', should:'create four tier hierarch', key:'ONE__TWO__THREE__FOUR', value:'five', answer:{ONE:{TWO:{THREE:{FOUR:'five'}}}}}
  ]
  for test in tests
    do (test) -> describe "with #{test.desc}", ->
        it "should #{test.should}", ->
          result = {}
          fromKeyValue(result, test.key, test.value)
          assert.deepEqual result, test.answer
