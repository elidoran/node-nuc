module.exports = (object, value) ->
  Object.defineProperty object, '__source',
    value: value
    writable: false
    enumerable: false
    configurable: false
  return
