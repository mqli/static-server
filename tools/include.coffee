fs = require 'fs'
request = require 'request'

DOMAINS = fs.readFileSync('D:\\workspace\\domain_map')
  .toString()
  .split('\n')
  .reduce (map, str)->
    str = str.trim().split ';'
    map[str[0]] = str[1]
    return map
  , {}
#
travel = (dir)->
  fs.readdirSync(dir).forEach (path)->
    return if path.indexOf('.') == 0
    path = dir + '/' + path
    return if !fs.existsSync(path)
    if fs.statSync(path).isFile() and path.indexOf('tml') > 0
      parse fs.readFileSync(path).toString(), path
    else if fs.statSync(path).isDirectory()
      travel path

results = []

REG_INCLUDE = /<!--#include (\S+)="(\/special\S+)"-->/g
REG_META_CMS = /meta name="cms_id" content="(\d{4})\S+" \/>/
REG_PATH = /"\/special(\S+)"/
REG_PATH_CMS = /\/(\d{4})\S*\//
parse = (str,path) ->
  matchs = str.match REG_INCLUDE
  return if !matchs?
  meta_cms =  REG_META_CMS.exec str
  #path_cms = /\/special\/(\d{4})\S*\//.exec path
  if meta_cms? 
    cms_id = meta_cms[1] 
  results.push
    path: path.substring('d:/workspace/fontend/'.length)
    cms_id: cms_id
    includes: (REG_PATH.exec(match)[1] for match in matchs) if matchs

travel 'd:/workspace/fontend'

results_has_cmd_id = results.filter (result) ->
  result.cms_id? or (result.includes.every (path)-> REG_PATH_CMS.exec(path))
results_has_not_cmd_id = results.filter (result) ->
  !result.cms_id? and (!result.includes.every (path)-> REG_PATH_CMS.exec(path))

results_error = {}

results.forEach (result)->
  result.includes.forEach (path)->
    if result.cms_id then domain = DOMAINS[result.cms_id]
    if !domain
      path_cms = REG_PATH_CMS.exec(path)
      if path_cms then domain = DOMAINS[path_cms[1]]
    if !domain
      domain = "http://#{result.path[0...result.path.indexOf('/')]}.163.com"
    url = "#{domain}/special#{path}"
    request.get url, (err, res, html)->
      console.log url, err or res.statusCode
      results_error[url] = result or res.statusCode if err or res.statusCode != 200

process.on 'exit', ->
  console.log 'total main file:', results.length
  console.log 'contain cms_id:', results_has_cmd_id.length
  console.log 'not contain cms_id:', results_has_not_cmd_id.length
  console.log 'fail locate:', Object.keys(results_error).length
  console.log results_error
