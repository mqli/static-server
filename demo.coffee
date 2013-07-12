Velocity = require 'velocityjs'
fs = require 'fs'
connect = require 'connect'
http = require 'http'
https = require 'https'
pathUtil = require 'path'
request = require 'request'
#模拟发布器做的一次中文占位符到vm语言的替换
REPLACE_MAP =
  "[链接]": "url"
  "[图片链接]": "imagesrc"
  "[标题]": "title"
  "[3G标题]": "mtitle"
  "[副标题]": "stitle"
  '[摘要]': "digest",
  '[3G标题]': "mtitle",
  '[来源]': "source",
  '[个人履历]': "title",
  '[文章ID]': "docid" 


MOCK_VALUS = 
  'url': 'http://money.163.com/13/0411/08/8S5SOGQN00251LJU.html'
  'title': '标题标题标题'
  'imagesrc': 'http://img4.cache.netease.com/stock/2012/10/30/2012103010122251732.jpg'

#匹配中文占位符
REG =
  charholder: /\[[a-zA-Z0-9\u4e00-\u9fa5_]+\]/g

ROOT_DIR = 'D:\\workspace\\fontend'

monkObj = get: (key) ->
  MOCK_VALUS[key] or key

context =
  tag:
    getList: (arg) ->
      [monkObj,monkObj,monkObj]
  tools: require './mockTools'

render = (path)->
  console.log 'render: ', path
  filePath = pathUtil.join ROOT_DIR, path
  console.log 'read file: ', filePath
  if not fs.existsSync filePath
    return console.log 'not exists:', filePath 
  template = fs.readFileSync(filePath).toString()
  
  template = template.replace REG.charholder, (key) ->
    if REPLACE_MAP[key] then "${one.get(\"#{REPLACE_MAP[key]}\")}" else key

  try
    html = Velocity.render(template, context)
  catch e
    return template

  html.replace /<!--#include (\S+)="(\S+)"-->/g, (match, cmd , url)->
    console.log 'include:', url
    url = if url.indexOf('/') is 0 then url else path[0...path.lastIndexOf('/')] + '/' + url
    render(url) or url

app = connect()
  #如果在本地跑多个站点则根据域名做判断代理到其他端口
  .use (req, res, next)->
    if req.headers.host == 'push.netease.com'
      console.log 'proxy:', req.headers.host
      x = request('http://127.0.0.1:8080')
      req.pipe(x)
      x.pipe(res)
    else
      next()
  .use (req, res, next)->
    if req.url.indexOf('html') > 0 or req.url.indexOf('shtml') > 0
      res.writeHead 200, 
        'Content-Type': 'text/html'
      return res.end(render(req.url))
    next()
  .use(connect.static('d:/workspace/fontend'))
  .use(connect.directory('d:/workspace/fontend'))
http.createServer(app).listen(80)
#https.createServer(app).listen(443)