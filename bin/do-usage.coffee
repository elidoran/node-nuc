
module.exports = ->
  require('./do-version')()
  console.log """
  Usage:

    nuc version
    nuc usage
    nuc help <command>
    nuc @<id> get <key> [<scope|all>]
    nuc @<id> set <key> <value> [<scope>]
    nuc @<id> add <key> <value> [<scope>]
    nuc @<id> remove <key> [<scope|all>]
    nuc @<id> list [<scope>]

  @<id>:
    Specify the app ID. It's used to determine the name of the files used to
    store the configuration information. Unlike other "runtime configuration"
    tools which always use the same file name. This allows storing app settings
    separately.

    Prepend the <id> value with an at symbol.

    Name differentiation is helpful for non-local scopes: user, system, global.

    Advanced use:
      Set the name into .nuc.name file where you run your commands.
      Then you may leave out the <id> value from your commands.

  Commands:

    version - prints current version
    usage   - the command which produced this text
    help    - prints help info for a specific <command>
    get     - display the value for the <key> from first scope found, or <scope> or <all> scopes
    set     - replace current <key>'s value with <value> in local scope or <scope>
    add     - like 'set' except it turns value into an array when there's more than one
    remove  - removes value for <key> in first scope found, or in <scope> or <all> scopes
    list    - display all keys and values for all scopes or for <scope>

  """
