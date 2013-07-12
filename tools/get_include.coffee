fs = require 'fs'
request = require 'request'

DIR = 'd:/workspace/fontend'

REG = /<!--#include (\S+)="(\/special\S+)"-->/g

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
  file = fs.readFileSync(dir).toString()
  matchs = file.match REG
  if matchs
    for match in matchs
      cms =  file.match /meta name="cms_id" content="(\d{4})\S+" \/>/
      console.log if cms then cms[1] else null
      match = /"(\/special\S+)"-->/.exec match
      result[match[1]] = dir.match(/d:\/workspace\/fontend\/(\S+?)\//)[1] if match
      if result[match[1]].indexOf('frontend') == 0
        result[match[1]] =  result[match[1]].replace('frontend', 'temp')
travel DIR

errors = []
csv = []
Object.keys(result).forEach (path)->
  url = "http://#{result[path]}.163.com#{path}"
  request.get url, (err, res, html)->
    csv.push "#{path}, #{url}, #{err || res.statusCode}"
    return console.log 'success:', url if !err and res.statusCode == 200
    console.log 'error: ', url
    errors.push url
process.on 'exit', ->
  console.log 'total:', Object.keys(result).length
  console.log 'success:', Object.keys(result).length - errors.length
  console.log errors.reduce (map, error)->
    domain = error[7...error.indexOf('.')]
    if map[domain] then map[domain]++ else map[domain] = 1
    return map
  , {}
  fs.writeFileSync('url.csv', csv.join('\n'))