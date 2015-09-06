# adds 5 files based on common info
addGroup = require './add-group'
path = require 'path'
# gets array of files which may be available with configuration data
module.exports = (id) ->
  unless id? then throw new Error 'getFiles requires `id` value'
  unless 'string' is typeof(id) then throw new Error 'getFiles `id` must be a string'

  env = process.env
  files = []
  tail = if process.platform is 'win32' then '.ini' else '.conf'

  # global *nix location for a module
  addGroup files, '/usr/lib/node_modules/' + id, id, tail

  # another global *nix location for a module
  addGroup files, '/usr/local/lib/node_modules/' + id, id, tail

  # system level location for both nix/win
  root = env.ALLUSERPROFILE ? '/etc'
  addGroup files, root, id, tail
  addGroup files, path.join(root, id), id, tail

  # user level location for windows only
  if env.APPDATA?
    addGroup files, env.APPDATA, id, tail
    addGroup files, path.join(env.APPDATA, id), id, tail

  # user level location for both nix/win
  root = env.HOME ? env.USERPROFILE
  addGroup files, root, id, tail
  addGroup files, path.join(root, id), id, tail

  # current working directory
  root = process.cwd()
  addGroup files, root, id, tail
  addGroup files, path.join(root, id), id, tail

  return files
