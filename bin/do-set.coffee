###
This is the 'set' subcommand file for the `nuc` command line tool.

It's responsible for:
  1. using the `nuc` lib to change the desired configuration
     a. set - will insert or update the key/value
     b. add - do-add calls this with option add:true, values are combined
     c. delete - do-delete call this with option delete:true, key is removed
  2. pretty printing the change results to the console

Format:  nuc [@id] set key value [<scope>]

The '@id' is only required if there isn't a .nuc.name file to get the id from.

Examples:

  These all exclude the ID to make them shorter, but, they could have @id in there.

  nuc set somekey somevalue - create/update key in first writable config file found
                              or, create one in the default scope, 'user'
  nuc set somekey somevalue local  - same as above, but only in the 'local' scope
  nuc set somekey somevalue user   - same as above, but only in the 'local' scope
  nuc set somekey somevalue system - same as above, but only in the 'local' scope

Writable scopes:

1. local - possibly, if the user has the right permissions
2. user - the user has permissions for its own home directory
3. system - depends on the user's permissions
###

module.exports = (options) ->

  # get our key and value from the args array 0 and 1
  key = options.args[0]
  # unless it's a remove op, then there is no `value`
  unless options.remove then value = options.args[1]

  # may be 'add' or 'delete', default to 'set'
  command = options.name ? 'set'

  # we only need `value` if we're doing add or set cuz delete doesn't need it.
  unless options.remove or value?
    unless key? # then we don't have either, so say so
      return error: "Must specify <key> and <value> for #{command} command"
    else # we're only missing value...
      return error: "Must specify <value> for #{command} command"

  # either we don't care about value cuz it's delete, or, we have a value
  unless key? # so complain about key only...
    return error: 'Must specify <key> for set command'

  # is there a scope? it's in 2 cuz 0 = key and 1 = value
  # unless we're doing a delete, then there's no `value`
  scope = if options.remove then options.args[1] else options.args[2]

  # call the nuc library's set() function to do the work
  result = require('../lib').set
    id    : options.id       # which app's configs to affect
    key   : key              # the key to change
    value : value            # the value for the key
    scope : scope            # optionally specify scope to change
    add   : options.add      # tells it do add value instead of replace
    remove: options.remove   # tells it to delete the key instead of change
    defaults: options.defaults # share the defaults :)

  # if there was an error then pass that back instead
  if result?.error? then return result

  console.log "app @#{options.id} #{if scope? then 'in scope '+scope else ''}"

  # tell the current value or that we deleted it
  if options.remove
    if result.replaced? then console.log "  removed \'#{key}\'"
    else console.log "Unable to remove '#{key}' because it didn\'t exist"

  else console.log "  '#{key}'",'=', result.newValue ? value

  # if we replaced a value then say what it was
  if result?.replaced?
    console.log "  '#{key}'",'was',result.replaced

  # all done
  return
