
module.exports = (options) ->

  slash = require('path').sep
  {id} = options

  baseIndex   = 0
  prefixIndex = 0
  suffixIndex = 0

  bases    = options.bases ? ['']
  prefixes = options.prefixes ? [ '', id + slash]
  suffixes = options.suffixes ? [ '.conf', '.json', 'rc', 'rc', '', '.ini' ]

  next = ->

    if baseIndex is -1 then return null

    base   = bases[baseIndex]
    prefix = prefixes[prefixIndex]
    extra  = if suffixIndex is 2 then '.' else ''
    suffix = suffixes[suffixIndex]

    path = base + prefix + extra + id + suffix

    suffixIndex++

    if suffixIndex is suffixes.length
      suffixIndex = 0
      prefixIndex++

    if prefixIndex is prefixes.length
      prefixIndex = 0
      baseIndex++

    if baseIndex is bases.length
      baseIndex = -1
      next.finished = true

    return path

  next.reset = (options) ->
    if options.id? then id = id
    if options.bases? then bases = options.bases
    if options.prefixes? then bases = options.prefixes
    if options.suffixes? then bases = options.suffixes
    baseIndex   = 0
    prefixIndex = 0
    suffixIndex = 0
    next.finished = false

  return next
