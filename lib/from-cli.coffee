# handles nested keys and creating object hierarchy
fromKeyValue = require './from-keyvalue'

# filter options based on prefix using app ID:  --ID_
# expect format: --key=value
# nested keys use '__'
module.exports = (the) ->

  prefix = "--#{the.id.toUpperCase()}_"

  for opt in process.argv when opt[...prefix.length] is prefix
    opt = opt[prefix.length...]
    if opt.length > 0
      [key, value] = opt.split '='
      fromKeyValue the.values, key, value

  return the
