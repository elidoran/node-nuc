
module.exports = (options) ->

  corepath = require 'path'

  return bases =
    global: -> [
      '/usr/lib/node_modules/'
      '/usr/local/lib/node_modules/'
    ]

    system: -> [
      '/etc/'
      '/etc/nuc/'
    ]

    user: -> [
      process.env.HOME + '/.conf/'
      process.env.HOME + '/conf/'
      process.env.HOME + '/'
    ]

    local: ->
      array = []

      # add the CWD path
      path = process.cwd()
      array.push path + '/'

      # strip off one directory at a time and put that onto the front of the array
      # so it ends up being in farthest to closest order.

      until path is corepath.sep
        path = corepath.dirname path
        unless path.length is 1 then path += '/'
        array.unshift path

      return array
