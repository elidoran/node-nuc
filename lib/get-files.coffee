
module.exports = (options) ->

  # get the stuff we need (inside function so it isn't held in memory)
  fs = require 'fs'
  buildGenerator = require './path-generator'

  # get the base paths depending on the platform. allow options to override
  bases = switch options.platform ? process.platform
    when 'win32' then require('./windows-bases')()
    # TODO: separate list for mac? (darwin)
    # when 'darwin','mac' then require './mac-bases'
    else require('./nix-bases')()

  # which scopes are we using?
  scopes =
    # if they specify a scope option then us it
    if options.scope?

      # if it's array then use as-is, otherwise, wrap in an array
      if Array.isArray options.scope then options.scope else [ options.scope ]

    # otherwise, use all the file based scopes.
    # Note: reverse order cuz we pop() off the back
    else [ 'local', 'user', 'system', 'global' ]

  # get our path generator
  next = buildGenerator options

  # store the existing file paths
  files = []

  # loop over all scopes
  while scopes.length > 0

    # get the next scope to process
    scope = scopes.pop()

    # configure the generator with bases for the scope
    # Note: it's a function returning an array
    next.reset bases: bases[scope]()

    # until the generator says it's finished providing paths...
    until next.finished

      # get the next path
      file = next()

      # unfortunately the `fs` module's stuff doesn't have a single way to
      # get all the info about a path in a single call..
      # There is:
      #  fs.exists - deprecated, only tells existence.
      #  fs.access - only tells access permissions, not file type
      #  fs.stats  - only gives characteristics, not access permissions
      #              (can get file's perms from `mode`...)
      # the most important thing is whether the path is a File.
      # if user has read access is a secondary concern.
      # i'm not going to call both fs.stats and fs.access.
      # so, that leaves calling fs.stats to do stats.isFile()
      # then, the read access will happen when we try to read the file
      try # check if it is a file...must use stats
        stats = fs.statSync file
        if stats.isFile()
          files.push file
      catch error
        ; # ignore error, it means we can't read it...
          # either it doesn't exist, or, we don't have read permissions

  # all done
  return files:files
