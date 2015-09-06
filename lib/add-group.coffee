path = require 'path'

# adds 5 files based on common info
# adds *nix only files based on tail (could test for process.platform instead...)
module.exports = (files, root, id, tail) ->
  for arg,i in [
    {name:'files',type:'object'}
    {name:'root',type:'string'}
    {name:'id',type:'string'}
    {name:'tail',type:'string'}
  ]
    unless arguments[i]? then throw new Error "addGroup requires a `#{arg.name}` value"
    unless arg.type is typeof arguments[i] then throw new Error "fromKeyValue `#{arg.name}` should have type '#{arg.type}'"

  files.push path.join(root, id + tail)
  files.push path.join(root, id + '.json')
  if '.conf' is tail
    files.push path.join(root, '.' + id + 'rc')
    files.push path.join(root, id + 'rc')
