# handles nested keys and creating object hierarchy
fromKeyValue = require './from-keyvalue'

# filter options based on prefix using app ID:  ID_
# nested keys use '__'
module.exports = (the) ->

  prefix = the.id.toUpperCase() + '_'

  # hold all key/values found in this one object
  result = {}

  # loop over all environment keys to see if they start with prefix
  for key of process.env when key[...prefix.length] is prefix

    # get the part after the prefix
    subKey = key[prefix.length...]

    # if there is something after the prefix
    if subKey.length > 0

      # convert it to an object
      fromKeyValue result, subKey, process.env[key]

  result.__source = 'env'

  # return wrapped in an array so we're always dealing with an array
  return objects: [result]

module.exports.scopes = [ 'env', 'all', 'each' ]
