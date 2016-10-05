
# let's tell the system who we are
process.title = 'nuc'

# `nuc` uses itself for its own configuration values
values = require('../lib') id:'nuc', defaults:require './defaults.json'

program = require 'commander'

program
  .version (require '../package.json').version
  # .usage '<command> [options]'
  .command 'set <key> <value> [scope]', 'Set key/value pair into scope'
  # .option '' # option to set it only if it doesn't exist yet

  .command 'get <key> [scope]', 'Get value for key in first scope, or specified scope'

  .command 'delete <key> [all]', 'Delete key/value pair'

  .command 'list [scope]', 'List key/value pairs from all scopes, or specified scope' # scope: local, user, system, global

  .parse process.argv
