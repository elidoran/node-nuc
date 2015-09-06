# split key on '__' (for nesting)
# value from format: key=value
# build necessary object hierarchy for nested keys
module.exports = (values, key, value) ->

  for arg,i in [{name:'values',type:'object'}, {name:'key',type:'string'}]
    unless arguments[i]? then throw new Error "fromKeyValue requires a `#{arg.name}` value"
    unless arg.type is typeof arguments[i] then throw new Error "fromKeyValue `#{arg.name}` should have type '#{arg.type}'"

  keys = key.split '__'

  if keys.length is 1 then values[key] = value
  else
    current = values
    for i in [0...keys.length - 1]
      key = keys[i]
      current[key] = {} unless typeof current[key] is 'object'
      current = current[key]
    current[keys[-1..]] = value # could clobber object with value...

  return
