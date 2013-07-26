fs = require 'fs'
connect = require 'connect'
http = require 'http'
pathUtil = require 'path'
request = require 'request'
iconv = require 'iconv-lite'
proxy = require './proxy'
vmrender = require './vmrender'
CONFIG = require './config.json'

DOMAINS = fs.readFileSync('domain_map')
  .toString()
  .split('\n')
  .reduce (map, str)->
    str = str.trim().split ';'
    map[str[0]] = str[1]
    return map
  , {}

render_local = (path) ->
  console.log 'render local: ', path
  filePath = pathUtil.join CONFIG.dir, path
  console.log 'read file: ', filePath
  if not fs.existsSync filePath
    return console.log 'not exists:', filePath 
  vmrender fs.readFileSync(filePath).toString()

resolve_include = (html, path, cb)->
  len = 0
  html = html.replace /<!--\s*#include (\S+)="(\S+)"\s*-->/g, (match, cmd , url, index)->
    console.log match
    len++
    local_url = if url.indexOf('/') is 0 then url else path[0...path.lastIndexOf('/')] + '/' + url
    local_html = render_local local_url
    if local_html
      resolve_include local_html, path, (inc)->
        process.nextTick ()->
          html = html.replace match, inc
          len--
          cb(html) if len == 0
    else
      cms_meta = /meta name="cms_id" content="(\d{4})\S+" \/>/.exec html
      cms_id = if cms_meta then cms_meta[0] else null
      if cms_id then domain = DOMAINS[cms_id]
      if !domain
        path_cms = /\/(\d{4})\S*\//.exec(url)
        if path_cms then domain = DOMAINS[path_cms[1]]
      if !domain
        _path = path.substring(1)
        domain = "http://#{_path[0..._path.indexOf('/')]}.163.com"

      url = "#{domain}#{url}"
      request.get {
        url: url
        encoding: 'binary'
      }, (err, res, remote_html)->
        len--
        console.log url,path, err or res.statusCode
        if err
          cb(html) if len == 0
          return
        #is_GBK = res.headers['content-type'].indexOf('GBK') >= 0
        console.log  res.headers['content-type']
        remote_html = iconv.decode(new Buffer(remote_html, 'binary'), 'gbk')
        resolve_include remote_html, path, (inc)->
          process.nextTick ()->
            html = html.replace match, vmrender(inc.toString('utf8'))
            cb(html) if len == 0
    match
  cb(html) if len == 0

app = connect()
  .use(proxy(CONFIG.proxy))
  .use (req, res, next)->
    if req.url.indexOf('html') > 0 or req.url.indexOf('shtml') > 0
      html = render_local req.url
      resolve_include html, req.url,(html)->
        res.writeHead 200, 
          'Content-Type': 'text/html;charset=utf8'
        res.end(html)
    else next()
  .use(connect.static(CONFIG.dir,{
    index: CONFIG.index
  }))
  .use(connect.directory(CONFIG.dir))
http.createServer(app).listen CONFIG.port, ()->
  console.log 'listening:', CONFIG.port
  module.exports = app