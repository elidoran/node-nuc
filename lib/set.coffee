
module.exports = (options) ->

  # if they didn't specify an id, then try to find it, unless they say not to
  unless options.id?
    unless options.noFindId then options.id = require('./find-id')()
    # use __error instead of the usual 'error' in case they use 'error' as
    # a key in the config values we look up.
    unless options.id? then return __error: '`id` required for nuc'

  corepath = require 'path'

  # searches file paths for existing files
  getFiles = require './get-files'

  # if they specify a scope, then, that's where we search and create
  if options.scope?

    # ensure it's a writable scope
    unless options.scope in [ 'local', 'user', 'system' ]
      return error:'May only change configuration in writable scopes local, user, and system. Not in:' + options.scope

    # it's okay, so use it
    searchScope = createScope = options.scope

  # look in all writable scopes for one to read.
  # if none found, create in the specified scope, or, in the default
  # scope with the default path...
  else
    # Note: closest to farthest cuz they're used in reverse (pop()'d)
    searchScope = [ 'local', 'user', 'system' ]
    createScope = options.createScope ? options.defaults.createFile.scope

  # create a ValueStore to do the work for us
  store = require('value-store')()

  # 1. search for files which exist

  result = getFiles id:options.id, scope:searchScope

  # TODO: check result for error

  # keep the closest existing file (last in the array)
  if result?.files?.length > 0
    closestExistingFile = result.files[result.files.length - 1]

  # console.log 'closest file:',closestExistingFile

  # 2. either read the file we found, or, add an empty object
  store.prepend closestExistingFile ? {}

  # 3. change it with operation

  op = # which operation...
    if options.add then 'add'
    else if options.remove then 'remove'
    else 'set'

  # remember the value we're replacing if we're doing a 'set' or 'delete'
  unless op is 'add' then replaced = store.get options.key

  # call the op
  store[op] options.key, options.value

  unless op is 'remove'
    # get new value
    newValue = store.get options.key

  # 4. write it back out

  unless closestExistingFile?

    # create our options to tell it the format and where to write it out
    writeOptions =
      # which format (json or ini) ? either in options or use default
      # file extension could specify which to use...
      format: options.createFormat ? options.defaults.createFile.format
      file  : options.createFile ? options.defaults.createFile[createScope]

    # if file used a shorthand then replace it
    # if the "user home directory" style tilde is there
    if writeOptions.file[0] is '~'
      # prepend the HOME or USERPROFILE environment variables
      # with the part of `file` after the tilde
      home = process.env.HOME ? process.env.USERPROFILE
      writeOptions.file = corepath.join home, writeOptions.file[1..]

    # also, replace {id} with the id
    writeOptions.file = writeOptions.file.replace '{id}', options.id

  # use the ValueStore to do the writing.
  # Either it knows where the file came from, or, the options tells it what to do
  result = store.write 0, writeOptions

  # TODO: check result for error

  # all done
  return replaced:replaced, newValue:newValue
