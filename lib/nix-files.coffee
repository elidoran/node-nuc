
module.exports = (options) ->
  id = options.id
  unless id? then throw new Error '`id` must be specified'

  # sure, i could shorten up this code by using loops and function calls...
  # but, i think it is ultimately *clearer* written explicitly like this.
  # and, probably faster.
  return paths =
    array: [
      "/usr/lib/node_modules/#{id}/#{id}.conf"
      "/usr/lib/node_modules/#{id}/#{id}.json"
      "/usr/lib/node_modules/#{id}/.#{id}rc"
      "/usr/lib/node_modules/#{id}/#{id}rc"

      "/usr/local/lib/node_modules/#{id}/#{id}.conf"
      "/usr/local/lib/node_modules/#{id}/#{id}.json"
      "/usr/local/lib/node_modules/#{id}/.#{id}rc"
      "/usr/local/lib/node_modules/#{id}/#{id}rc"

      "/etc/#{id}.conf"
      "/etc/#{id}.json"
      "/etc/.#{id}rc"
      "/etc/#{id}rc"

      "/etc/#{id}/#{id}.conf"
      "/etc/#{id}/#{id}.json"
      "/etc/#{id}/.#{id}rc"
      "/etc/#{id}/#{id}rc"

      "~/.conf/#{id}.conf"
      "~/.conf/#{id}.json"
      "~/.conf/.#{id}rc",
      "~/.conf/#{id}rc",
      "~/.conf/#{id}",

      "~/conf/#{id}.conf"
      "~/conf/#{id}.json"
      "~/conf/.#{id}rc",
      "~/conf/#{id}rc",
      "~/conf/#{id}",

      "~/#{id}.conf"
      "~/#{id}.json"
      "~/.#{id}rc"
      "~/#{id}rc"

      "~/#{id}/#{id}.conf"
      "~/#{id}/#{id}.json"
      "~/#{id}/.#{id}rc"
      "~/#{id}/#{id}rc"
    ]

    pwd: [
      ".conf/#{id}.conf"
      ".conf/#{id}.json"
      ".conf/.#{id}rc"
      ".conf/#{id}rc"
      ".conf/#{id}",

      "conf/#{id}.conf"
      "conf/#{id}.json"
      "conf/.#{id}rc"
      "conf/#{id}rc"
      "conf/#{id}",

      "#{id}.conf"
      "#{id}.json"
      ".#{id}rc"
      "#{id}rc"

      "#{id}/#{id}.conf"
      "#{id}/#{id}.json"
      "#{id}/.#{id}rc"
      "#{id}/#{id}rc"
    ]
