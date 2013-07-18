fs = require 'fs'
request = require 'request'
CONFIG = require '../config.json'
travel = (dir)->
  fs.readdirSync(dir).forEach (path)->
    return if path.indexOf('.') == 0 or path.indexOf('atc1301') != -1
    path = dir + '/' + path
    return if !fs.existsSync(path)
    if fs.statSync(path).isFile() and path.indexOf('tml') > 0
      setTimeout ->
        test path.replace CONFIG.dir, ''
      ,100
    else if fs.statSync(path).isDirectory()
      travel(path)

result  = []

test = (path)->
  request "http://localhost#{path}", (err, res)->
    console.log err or res.statusCode
    if err or res.statusCode != 200
      result.push(path)

travel CONFIG.dir

process.on 'exit', ->
  console.log result