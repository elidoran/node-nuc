
module.exports = ->

  # search for an npm config environment variable
  id = process.env.NUCID ? process.env.npm_package_config_nucid

  if id? then return id

  # otherwise, we'd better find a .nuc.name file...
  file = require('path').resolve process.cwd(), '.nuc.name'

  try
    # then read it
    id = require('fs').readFileSync(file, 'utf8').trim()
  catch error
    # uh-oh, we don't have an <id>
    return theError =
      error:'No @id specified and no .nuc.name file found in: '+process.cwd()
      reason:error

  return id
