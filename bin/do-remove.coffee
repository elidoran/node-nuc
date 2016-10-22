
module.exports = (options) ->

  # do 'set' with 'delete' override
  options.name = 'remove'
  options.remove = true

  require('./do-set') options
