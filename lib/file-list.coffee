corepath = require 'path'

# gets array of files which may be available with configuration data
module.exports = (options) ->
  id = options?.id
  unless options? then throw new Error 'getFiles requires `options` value'
  unless 'string' is typeof(id) then throw new Error 'getFiles `options.id` must be a string'

  files = []

  # load patterns strings from platform specific file
  switch options.platform ? process.platform
    when 'win32' then patterns = require('./win32-files.coffee') id:id
    else patterns = require('./nix-files.coffee') id:id

  # turn each pattern into a path using `id`
  files.push pattern for pattern in patterns.array

  # check each pwd path searching up the CWD hierarchy until one is found)

  # 0. get cwd, check options first...
  cwd = options.cwd ? process.cwd()

  # 1. split the cwd path into its parts
  dirs = cwd.split corepath.sep

  # 2. combine the parts, accumulating as the array goes to pwd
  if dirs[0] is '' then dirs[0] = corepath.sep
  dirs[i] = corepath.join dirs[i - 1], dirs[i] for i in [1...dirs.length]

  # 3. for each of those dirs, add the file name patterns to files
  for dir in dirs
    files.push corepath.join dir, pattern for pattern in patterns.pwd

  # console.log 'FILES:\n'
  # console.log '  ', file for file in files

  # got'em all...
  return files
