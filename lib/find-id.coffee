
module.exports = (options = {}) ->

  if options.id? then return options.id

  # search for an npm config environment variable
  id = process.env.NUCID ? process.env.npm_package_config_nucid

  # search cli args
  for arg in process.argv
    if arg[...8] is '--nucid='
      id = arg[8..]
      break

  unless id? or options.noFindId is true

    # otherwise, we'd better find a .nuc.name file...
    file = require('path').resolve process.cwd(), '.nuc.name'

    try
      # then read it
      id = require('fs').readFileSync(file, 'utf8').trim()
    catch error
      # uh-oh, we don't have an <id>
      return __error:'`id` required for nuc', reason:error

  # set id into options and return it
  options.id = id
