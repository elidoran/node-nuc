
getFiles = require './get-files'

module.exports = (options) ->

  {store} = options

  result = getFiles options

  # store the parsed objects
  objects = []

  # remember which files we've already read in case of overlap
  # Note: when working in your user directory it can find a file in there
  # because of both user scope and local scope.
  set = {}

  for file in result.files

    # let's see if we've already appended this file before...
    found = false       # mark whether we found it
    for each of set     # iterate over keys in `set`, which are files
      if each is file   # if they match then...
        found = true    # we found it
        break           # so we're all done looping

    # only append it if we didn't find it already in there
    if not found

      # remember we already appended this file
      set[file] = true

      # use the value store to read the file
      result = store.append file

      # let's pop it out of there
      object = store.array.pop()

      # add the object to our results
      objects.push object

  return objects:objects

# everything except 'cli' and 'env' are handled by files
module.exports.scopes = [ 'global', 'system', 'user', 'local', 'each', 'all' ]
