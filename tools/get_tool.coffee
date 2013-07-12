fs = require 'fs'

DIR = 'd:/workspace/fontend'

REG_VM = /#set[\s\S]*?#end/g
REG_KEYWORD = /\$tools\.([a-zA-Z]+)\(\)/g

result = {}
travel = (dir)->
  for path in fs.readdirSync dir
    if path.indexOf('.') isnt 0
      path = dir + '/' + path
      if fs.existsSync(path)
        if fs.statSync(path).isFile() and path.indexOf('tml') > 0
          find path
        else if fs.statSync(path).isDirectory()
          travel path

find = (dir) ->
  vmmatch = fs.readFileSync(dir).toString().match REG_VM
  if vmmatch 
    for tag in vmmatch
      kewordmatch = tag.match REG_KEYWORD
      result[keyword] = null for keyword in kewordmatch if kewordmatch
travel DIR

console.log result