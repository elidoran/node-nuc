###
This is the 'list' subcommand file for the `nuc` command line tool.

It's responsible for:
  1. using the `nuc` lib to get the desired configurations
  2. pretty printing the configurations to the console

Format:  nuc [@id] list [<scope>|each]

Examples:

  nuc @someid list  - include the ID before 'list' unless it's in '.nuc.name'.

  These all exclude the ID to make them shorter, but, they could have @id in there.

  nuc list        - shows the collapsed configurations from all scopes combined
  nuc list all    - same as above, it's the default.
  nuc list each   - shows each scope separately without collapsing
  nuc list cli    - show configuration values from `process.argv`
  nuc list env    - show configuration values from `process.env`
  nuc list local  - show configuration values from files in present working
                    directory up to the root.
  nuc list user   - show configuration values from files in the user's home dir
  nuc list system - show configuration values from files in the system config
  nuc list global - show configuration values from files in installed libraries
###

module.exports = (options) ->

  # use to pretty print objects to the console, with colors
  {inspect} = require 'util'

  # use our library to get the values
  nuc = require '../lib'

  # shorten the usual console.log call
  log = console.log # Note: it's already bound

  {id} = options

  # if a scope is specified then tell `nuc` so it can limit its work.
  # if scope is 'all' then ignore it because that's the default.
  unless options.args?[0] is 'all' then scope = options.args?[0]

  # prepare config options for nuc
  config =
    id   : id     # 'id' is required of course. previous work ensures we have it
    scope: scope  # scope is optional. providing it limits what will be done.

  # if scope is 'each' then we need each scope separately.
  # to get that, pass `stack` as `true` to nuc.
  # also, we don't need the collapsed version, so, tell nuc not to make it
  if scope is 'each'
    # we only need to know 'each' right here, so, remove it from config
    config.scope = undefined
    config.stack = true
    config.collapse = false

  # now, let's use `nuc` to gather what we want
  result = nuc config

  do -> # show the header
    # create it
    header = '#  app @' + id
    # append the scope, if it exists
    if scope? then header += ' in scope ' + scope
    # output it
    log header,'\n#'

  # was there an error?
  # Note: `nuc` puts error in __error to differentiate from a `values` with `error`.
  if result.__error?
    result.error = result.__error
    return result


  # # then show the values

  inspectOptions = colors: options.defaults.colors

  # if it created a ValueStore then show each of its sources
  if config.stack

    # access the array directly, for now, to process each source in order
    for object in result.array
      try
        # remove `__source` while printing ...
        source = object.__source
        delete object.__source

        # print a header for each kind of source
        # TODO: optionally put a 'header' value into the source info?
        # then we could just print that when it exists...
        if source is 'cli'
          log '#   Command Line Options'

        else if source is 'env'
          log '#   Environment Variables'

        else if source?.file?
          log '#   File:', source.file

        else # what other kinds of source are there??
          log '#   Source:', inspect source

        # write a divider under the section's header...
        log '#-------------------------------------------------\n'

        # pretty print the object with 'util' module's inspect() function
        log inspect(object, inspectOptions), '\n'

      finally # restore the source
        object.__source = source

  # otherwise, just show all the values provided
  else
    log '#    Final Configuration\n#-----------------------------------------------------\n'
    log inspect(result, inspectOptions), '\n'
