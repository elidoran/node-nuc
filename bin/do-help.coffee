
# TODO: look at which command they want help on ahead of time and
# add that to the name for the file to require.
# then we can separate all these into diff files...

module.exports = (options) ->

  command = options?.args?[0]

  # if they didn't specify then babble about 'help'
  unless command
    console.log """
    Help shows extra information, such as example commands.
    For example, use the help command for a specific subcommand:

      nuc help get

    """
    return

  # otherwise, babble about specific subcommand
  switch command

    when 'version' then console.log 'It shows the version :)'

    when 'usage','use' then console.log 'It shows what you can do with nuc'

    when 'get'
      console.log """
      Example 'get' commands:

      1. search configurations for app 'someid' to get the first value found
         for the specified <key>:

        nuc @someid get somekey

      2. search configurations for app 'someid' to get the value in the
         specific <scope>, or, say there isn't one:

        nuc @someid get somekey local

        Scopes: local, user, system, global

      3. search configurations for app 'someid' to get every value in every scope:

        nuc @someid get somekey all

      Advanced use case:

      Specify the <id> in a file in the present working directory named '.nuc.name'.
      The file should only contain a word which is the <id>.
      Then, the above three example commands become:

        nuc get somekey
        nuc get somekey local
        nuc get somekey all

      """

    when 'set'
      console.log """
      Example 'set' commands:

      1. set the <value> for <key> into the local scope, if one exists, or the
         user scope otherwise, for the app <id> of 'someid'.

        nuc @someid set somekey somevalue

      2. set the <value> for <key> into the specified scope overwriting the
         previous value if one exists, and creating the scope if it doesn't
         exist yet, for app <id> of 'someid'

        nuc @someid set somekey somevalue local

      Advanced use case:

      Specify the <id> in a file in the present working directory named '.nuc.name'.
      The file should only contain a word which is the <id>.
      Then, the above three example commands become:

        nuc set somekey somevalue
        nuc set somekey somevalue local

      """


    when 'add'
      console.log """
      Add command is the same as 'set' except instead of replacing an existing
      value it combines values into an array of values.

      When there is no previous <value> then the new <value> is stored.

      When there is a previous <value> then it becomes the first element of a
      new array value, and, the new <value> is the second element.

      When there is already an array value then the new <value> is appended
      to the end of the array.

      """


    when 'remove'
      console.log """
      Example 'remove' commands:

      1. remove the first value found in any scope for the <key> 'somekey'
         and app <id> 'someid':

        nuc @someid remove somekey

      2. remove value for <key> 'somekey' from <scope> 'local' for app 'someid':

        nuc @someid remove somekey local

      3. remove values for <key> 'somekey' from all scopes for app <id> 'someid':

        nuc @someid remove somekey all

      Advanced use case:

      Specify the <id> in a file in the present working directory named '.nuc.name'.
      The file should only contain a word which is the <id>.
      Then, the above three example commands become:

        nuc remove somekey
        nuc remove somekey local
        nuc remove somekey all

      """


    when 'list'
      console.log """
      Example 'list' commands:

      1. List key/value pairs combined from all scopes for app <id> 'someid':

        nuc @someid list

      2. List all key/value pairs in <scope> 'local' for app <id> 'someid':

        nuc @someid list local

      Advanced use case:

      Specify the <id> in a file in the present working directory named '.nuc.name'.
      The file should only contain a word which is the <id>.
      Then, the above two example commands become:

        nuc list
        nuc list local

      """

    when 'scope'
      console.log """
      There are multiple scopes available:

        1. all    - `get` will provide the <key>'s values for all scopes
                  - `list` does its default behavior, shows combined from all scopes
                  - `remove` will remove the key from all the scopes it's found in
        2. each   - `list` provides each scope's list separately, instead of combined
        2. global - these settings come with installed softare. they're defaults.
        3. system - these are configured on a system, for example, in /etc
        4. user   - the current user's home directory stored settings
        5. local  - a file in PWD, or up the hierarchy towards root
        6. cli    - the command line options
        7. env    - the environment variables

      """


    # unknown command!
    else

      console.error 'Unable to provide \'help\' for unknown command:',command
      require('./do-usage')()
      return exitCode:1 # TODO: lookup proper exit code

  return
