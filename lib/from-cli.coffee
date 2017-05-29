# handles nested keys and creating object hierarchy
fromKeyValue = require './from-keyvalue'

# sets the __source hidden property
setSource = require './set-source'

# filter options based on prefix using app ID:  --ID_
# expect format: --key=value
# nested keys use '__'
module.exports = (the) ->

  prefix = "--#{the.id.toUpperCase()}_"

  # hold all key/values found in this one object
  result = {}

  # loop over all cli options to see if they start with prefix
  for opt in process.argv when opt[...prefix.length] is prefix

    # get the part after the prefix
    opt = opt[prefix.length...]

    # if there is something after the prefix
    if opt.length > 0

      # separate the key from the value
      [key, value] = opt.split '='

      # if there wasn't an '=' then value is undefined, so default to true
      value ?= true

      # convert it to an object
      fromKeyValue result, key, value

  # return wrapped in an array so we're always dealing with an array

  if Object.keys(result).length > 0
    setSource result, 'cli'
    return objects: [ result ]

  else
    return objects: []

module.exports.scopes = [ 'cli', 'all', 'each' ]
