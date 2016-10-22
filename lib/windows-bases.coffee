
module.exports = (options) ->

  corepath = require 'path'

  bases =
    global: -> [
      # where does windows install global libs?
    ]

    system: -> [
      process.env.ALLUSERSPROFILE
    ]

    user: -> [
      process.env.APPDATA
      process.env.USERPROFILE + '\\.conf\\'
      process.env.USERPROFILE + '\\conf\\'
    ]

    local: ->
      array = []

      # add the CWD path
      path = process.cwd()
      array.push path + corepath.sep

      # strip off one directory at a time and put that onto the front of the array
      # so it ends up being in farthest to closest order.

      until path is corepath.sep
        path = corepath.dirname path
        unless path.length is 1 then path += corepath.sep
        array.unshift path

      return array
