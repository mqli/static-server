fs = require 'fs'
connect = require 'connect'
http = require 'http'
pathUtil = require 'path'
request = require 'request'
iconv = require 'iconv-lite'
cheerio = require 'cheerio'
proxy = require './proxy'
vmrender = require './vmrender'
CONFIG = require '../config.json'
version = require('../package.json').version
VERSION_URL = 'http://qa.developer.163.com/component/server/server.html'

need_update = false
request VERSION_URL, (err, res, html)->
  console.log err if err
  if html
    $ = cheerio.load html
    need_update = $('#version').text() != version

DOMAINS = fs.readFileSync(__dirname + '/../lib/domain_map')
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
      resolve_include local_html, local_url, (inc)->
        process.nextTick ()->
          html = html.replace match, inc
          len--
          cb(html) if len == 0
    else
      cms_meta = /meta name="cms_id" content="(\d{4})\S+" \/>/.exec html
      cms_id = if cms_meta then cms_meta[1] else null

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
        followRedirect: false
      }, (err, res, remote_html)->
        len--
        console.log url,path, err or res.statusCode
        if err
          cb(html) if len == 0
          return
        resolve_include iconv.decode(new Buffer(remote_html, 'binary'), 'gbk'), path, (inc)->
          process.nextTick ()->
            html = html.replace match, vmrender(inc.toString('utf8'))
            cb(html) if len == 0
    match
  cb(html) if len == 0

app = connect()
  .use(proxy(CONFIG.proxy))
  .use (req, res, next)->
    url = req.url.split('?')[0]
    if url.indexOf('html')  == url.length - 4
      html = render_local url
      return next() if !html
      resolve_include html, url,(html)->
        res.writeHead 200, 
          'Content-Type': 'text/html;charset=utf8'
        if need_update and CONFIG.check_update != false
          html = html.replace '<body>', """
            <body>
            <div style="width:100%;background-color:yellow">
              <a href="http://tools.f2e.netease.com/server.zip">本工具有新版本，请升级</a>
              <a onclick="this.parentNode.parentNode.removeChild(this.parentNode);">x</a>
            </div>
          """
        res.end(html)
    else next()
  .use(connect.static(CONFIG.dir,{
    index: CONFIG.index
  }))
  .use(connect.directory(CONFIG.dir))
server = null;
exports.run = (cb, on_error)->
  server = http.createServer(app)
  server.on 'error', (err)->
    on_error and on_error(err)
  server.listen CONFIG.port, cb
exports.close = (cb)->
  server.close(cb) if server