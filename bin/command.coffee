###
This is the main file for the `nuc` command line tool.
It's responsible for:
  1. determining which subcommand to call
  2. converting aliases
  3. getting the id from the args or a .nuc.name file
  4. handling errors returned by the subcommands
###
###
i'm going to forgo using an options parser. I'm going to expect the exact
things documented, or, tell them what happened and quit.
i'm going to adapt the version command to not be -v or --version and instead
be the command 'version'. then it fits the same pattern.
i'll also make 'usage' the default command. It can be overriden using `nuc`
configurations because nuc uses itself to read configurations.

Commands which aren't app specific (no id needed):
   ignore  | which | command
0   |  1   |   2   |   3
------------------------------
node nuc.js use
node nuc.js usage
node nuc.js version
node nuc.js help     <command>

App specific commands require an 'id' to function, but, don't require the
'id' be in the actual command, it can be in PWD/.nuc.name.
The command pattern for those are:
   ignore  | ID   | Which  | key     |  value/scope | scope
0   |  1   |  2   |  3     |  4      |    5         |   6
-------------------------------------------------------------------------
node nuc.js [@id]   get      key       <scope|all>
node nuc.js [@id]   set      key       value          <scope>
node nuc.js [@id]   add      key       value          <scope>
node nuc.js [@id]   delete   key       <scope|all>
node nuc.js [@id]   list     <scope>
###

# first thing, let's tell the system who we are
process.title = 'nuc'

# limit to 3 levels in the stack because they're the useful ones.
Error.stackTraceLimit = 3

# use to extract the id from the command
findId = require './find-id'

process.env.TESTID_key2 = 'value2'

# `nuc` uses itself for its own configuration values
values = require('../lib') id:'nuc', defaults:
  # by default, let's tell them how to use the CLI
  which: 'usage'

  # by default, display object inspections in color
  colors: true

  # some defaults for set/add operations
  # create a new one as a json file with these paths
  createFile:
    format : 'json'            # default write format is json...
    scope  : 'user'            # put it in the `user` scope by default
    local  : '{id}.json'      # where to put it in local scope
    user   : '~/{id}.json'    # where to put it in user scope
    system : '/etc/{id}.json' # where to put it in system scope

# which subcommand do we do? (default to what's in `values`)
# skip the executor name and the scripts' file path
which = process.argv[2] ? values.which

# determine the which, the id, and the args as best we can
# if which starts with an at symbol then it's the 'id'
if which[0] is '@'
  id = which[1..]            # the 'which' value is actually the id
  which = process.argv[3]    # so 'which' is the next arg
  args = process.argv[4..]   # and args are after that

else # which stays the same and we may need to try to find the id

  # either way, we know the args are at 3+
  args = process.argv[3..]

  # we only need an id for some commands
  if which in [ 'get', 'set', 'add', 'delete', 'remove', 'list', 'show' ]
    id = findId()

# now that we have the 'which' for sure, let's convert aliases.
# allow some aliases because sometimes we use a similar word for things
# and it's annoying to have to remember which similar word the dev chose. :)
which = switch which
  when 'use'    then 'usage'
  when 'delete' then 'remove'
  when 'show'   then 'list'
  else which

# remember errors encountered
error = null

# now call the subcommand's script, or, say it doesn't exist
# Note:
#   i try to control errors in normal execution flow by returning an
#   object with an `error` property, and, when caused by a caught Error
#   then i include that in a `reason` property.
#   wrap this with try-catch for the require() call, and, in case a thrown error
#   percolates up anyway.
try

  # if there was an error then store that object as `result`
  if id?.error? then result = id

  # else, continue on to run the subcommand for a new result
  else
    # try to get the subcommand
    command = require('./do-' + which)

    result = command id:id, args:args, defaults:values

  # did we encounter a problem?
  if result?.error? then error = result

catch caughtError # caught an error, so, store it and let the final handler get it
  error = caughtError

# handle caught errors as well as my {error:'blah', reason:...} objects
if error?

  # require() uses code 'MODULE_NOT_FOUND' when it can't find the file
  if error.code is 'MODULE_NOT_FOUND'
    console.error 'Unable to find subcommand:',which
    console.error error.message

  # else, output the error message
  # my object has the error in `error`
  else if error.error?
    console.error 'Error:', error.error

    # if there was a thrown Error then it's included as `reason`,
    # so, output its message too
    if error?.reason?.message? then console.error error.reason?.message

  # an Error type ...
  else console.error error


  # use the exit code they specified, or, 1 by default (which isn't proper...)
  exitCode = error.exitCode ? 1 # TODO: lookup proper exit code

  # exit with an error code
  process.exit exitCode

# otherwise, end this script normally
