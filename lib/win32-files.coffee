
module.exports = (options) ->
  id = options.id
  unless id? then throw new Error '`id` must be specified'

  # sure, i could shorten up this code by using loops and function calls...
  # but, i think it is ultimately *clearer* written explicitly like this.
  # and, probably faster.
  # TODO: what is the var for program files folders??
  alldata = process.env.ALLUSERSPROFILE # c:\ProgramData
  appdata = process.env.APPDATA         # c:\users\name\appdata\[roaming]
  home    = process.env.USERPROFILE     # c:\users\name

  return paths =
    array: [
      "#{alldata}/#{id}.ini"
      "#{alldata}/#{id}.json"
      "#{alldata}/#{id}rc"

      "#{alldata}/#{id}/#{id}.ini"
      "#{alldata}/#{id}/#{id}.json"
      "#{alldata}/#{id}/#{id}rc"

      "#{appdata}/#{id}.ini"
      "#{appdata}/#{id}.json"
      "#{appdata}/#{id}rc"

      "#{appdata}/#{id}/#{id}.ini"
      "#{appdata}/#{id}/#{id}.json"
      "#{appdata}/#{id}/#{id}rc"

      "#{home}/conf/#{id}.ini"
      "#{home}/conf/#{id}.json"
      "#{home}/conf/#{id}rc",
      "#{home}/conf/#{id}",

      "#{home}/#{id}.ini"
      "#{home}/#{id}.json"
      "#{home}/#{id}rc"

      "#{home}/#{id}/#{id}.ini"
      "#{home}/#{id}/#{id}.json"
      "#{home}/#{id}/#{id}rc"
    ]

    pwd: [
      "conf/#{id}.ini"
      "conf/#{id}.json"
      "conf/.#{id}rc"
      "conf/#{id}rc"
      "conf/#{id}",

      "#{id}.ini"
      "#{id}.json"
      "#{id}rc"

      "#{id}/#{id}.ini"
      "#{id}/#{id}.json"
      "#{id}/#{id}rc"
    ]



#
# # system level location for both nix/win
# root = env.ALLUSERPROFILE ? '/etc'
# addGroup files, root, id, tail
# addGroup files, path.join(root, id), id, tail
#
# # user level location for windows only
# if env.APPDATA?
#   addGroup files, env.APPDATA, id, tail
#   addGroup files, path.join(env.APPDATA, id), id, tail
#
# # user level location for both nix/win
# root = env.HOME ? env.USERPROFILE
# addGroup files, root, id, tail
# addGroup files, path.join(root, id), id, tail
#
# # current working directory
# root = process.cwd()
# addGroup files, root, id, tail
# addGroup files, path.join(root, id), id, tail
