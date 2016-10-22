
module.exports = (options) ->

  # do 'set' with 'add' override
  options.name = 'add'
  options.add = true

  require('./do-set') options
