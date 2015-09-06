fs         = require 'fs'
path       = require 'path'
ini        = require 'ini'
deepExtend = require 'deep-extend'

# gets array of files which may be available
getFiles = require './file-list'

# if files exist then load them via JSON or INI
# and override current `the.values`
module.exports = (the) ->
  for file in getFiles the.id
    if fs.existsSync file
      if '.json' is path.extname file
        object = require file
      else
        object = ini.parse fs.readFileSync file, 'utf8'
      the.values = deepExtend object, the.values
  return the
