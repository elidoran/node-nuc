# handles nested keys and creating object hierarchy
fromKeyValue = require './from-keyvalue'

# filter options based on prefix using app ID:  ID_
# nested keys use '__'
module.exports = (the) ->

  prefix = the.id.toUpperCase() + '_'

  for key of process.env when key[...prefix.length] is prefix
    subKey = key[prefix.length...]
    if subKey.length > 0
      fromKeyValue the.values, subKey, process.env[key]

  return the
