findId = require './find-id'

module.exports = (options = {}) ->

  # # get what we need (inside function to avoid holding refs in memory)

  # use to collapse a new objects keys into another object, overriding them
  deepExtend = require 'deep-extend'

  # used to create a hierarchy of object "value stores"
  buildValueStore = require 'value-store'

  # the functions which get objects from sources
  gatherers = [
    require './from-files' # from a list of OS specific files using 'id'
    require './from-env'   # from process.env using 'id'
    require './from-cli'   # from process.argv using 'id'
  ]

  result = findId options
  if result?.__error? then return result

  # we don't do this by default, so, only do when explicitly set to true
  #if options.stack is true # options.default may be undefined, that's okay
  # let's use this for file reading, so, always create it.
  # keep deleting what we read in unless options.stack is true
  store = buildValueStore options.default

  # we do this by default, so, only *don't* when explicitly set to false
  unless options.collapse is false
    # use defaults as the base object to collapse into, or, an empty object
    values = options.defaults ? {}

  # what we give to each gatherer function.
  input =
    id: options.id
    scope: options.scope
    values: values
    store: store

    # fromFiles cares about this, the others will ignore it
    # Note: this avoids an array by handling file paths one at a time
    # Note: it also uses the ValueStore to read the files for us
    each: (file, exists) ->

      # if the file exists then we want to read it
      if exists

        # use the value store to read the file, put it in front to override others
        result = store.prepend file

        # if we're collapsing into a single values object, then do that
        if values? then deepExtend values, store.array[0]

        # if we're NOT stacking up the objects then remove the one we just read
        unless options.stack then store.array.shift()

      return

  # call each gatherer in order
  for gather in gatherers

    # only call the gather function if we're doing all scopes, or,
    # if the scope we're looking for is handled by this 'gather' function
    if scope? and not scope in gather.scopes then continue

    # call the gatherer with our inputs
    result = gather input

    # if there was an error, return result now
    if result.error? then return result

    # process objects
    for object in result.objects

      # if collapsing into a single object then collapse into `values`
      if values? then deepExtend values, object

      # if stacking, then, add object to the front of the value store stack
      if options.stack then store.prepend object

  # delete this key cuz it is leftover from using ValueStore to read files
  if values? then delete values.__source

  # if both exist, return both together in a new object
  # otherwise, only one exists, so, return that alone
  return result =
    if values?
      if options.stack? then values:values, store:store
      else values
    else store
