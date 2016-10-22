
module.exports = (options) ->

  # ensure we have a key
  key = options.args[0]

  unless key?
    return error: 'Must specify <key> for get command'

  {id} = options
  
  # if a specific scope is specified then tell `nuc` so it can limit its work
  scope = options.args[1]

  # now, let's use `nuc` to gather values and 'get' the one we want.
  nuc = require '../lib'

  values = nuc id:id, scope:scope

  # then show the header
  do ->
    header = 'app @' + id
    if scope? then header += ' in scope ' + scope
    console.log header

  # and then show the value
  console.log ' ', key, '=', values[key]
