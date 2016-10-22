# split key on '__' (for nesting)
# value from format: key=value
# build necessary object hierarchy for nested keys
module.exports = (target, key, value) ->

  # unless we have a key we have nothing to do...
  unless key? then return

  # split on the delimiter '__' to get the hierarchy of keys
  keys = key.split '__'

  # if there's only one key, then, we're done
  if keys.length is 1 then target[key] = value

  # otherwise, we need to create the object hierarchy
  else
    # start by adding the first key to the top of the object hierarchy
    current = target

    # then, loop thru all the keys except the last one. we'll set that special.
    for i in [0...keys.length - 1]

      # get the current key
      key = keys[i]

      # create a sub-object with our key
      current[key] = {}

      # then point at that new object to add our next key to it
      current = current[key]

    # we've added all except the last key, so, use that now to set the value in
    key = keys[keys.length - 1]
    current[key] = value

  # we're all done
  return
