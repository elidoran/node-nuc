fs         = require 'fs'
ini        = require 'ini'
path       = require 'path'
deepExtend = require 'deep-extend'

fromFiles = require './from-files'
fromEnv = require './from-env'
fromCli = require './from-cli'

module.exports = (options) ->
  # 1. start with options.defaults or an empty object
  # 2. then files: install, system, user, local
  # 3. then environment variables
  # 4. then command line arguments
  unless options?.id? then throw new Error '`id` required for nuc'
  options = id:options.id, values:options.defaults ? {}
  {values} =  fromCli fromEnv fromFiles options
  return values
