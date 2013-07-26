Velocity = require 'velocityjs'
fs = require 'fs'
mocking = require './mocking'
CONFIG = require './config.json'

#模拟发布器做的vm渲染，先进行一次中文占位符到vm语言的替换，然后用mock的对象和数据渲染页面
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
  'digest': '摘要摘要摘要'
  'stitle': '副标题'
#匹配中文占位符
REG = /\[[a-zA-Z0-9\u4e00-\u9fa5_]+\]/g

monkObj = get: (key) ->
  console.log key
  MOCK_VALUS[key] or key

#vm全局对象
context =
  tag:
    getList: (str_args) ->
      console.log str_args
      if str_args
        args = {}
        for arg in str_args.split(';')
          arg = arg.split '='
          args[arg[0]] = arg[1] if arg[0]

        return mocking.array(mocking.object(
          title: mocking.string(mocking.int(3, parseInt(args.titlelength) || 3), "标题"),
          digest: mocking.string(mocking.int(3, parseInt(args.digestlength) || 10), "摘要"),
          get: ()-> return (key)-> this[key] or MOCK_VALUS[key] or key
        ), parseInt(args.listnum) || 2)()

      [monkObj,monkObj,monkObj]
  tools: require './mockTools'
  comment: '<!--#include virtual="/comment/0005/sports_zh_bbs/1P/93VI8G1P00051CDG.html"-->'

module.exports = (template) ->
  template = template.replace REG, (key) ->
    if REPLACE_MAP[key] then "${one.get(\"#{REPLACE_MAP[key]}\")}" else key
  template = template.replace /##.+\r/g ,''
  template = template.replace /<script.*?>([\w\W]*?)<\/script>/g, ()->
    arguments[0].replace(/#/g, '#[[#]]#')
     .replace /\$/g, '#[[$]]#'
  template = template.replace '#parse("/0080/n/0080nph_2.vm")', fs.readFileSync('./photo.inc')
  template = template.replace '#parse("/0080/w/0080wb_public.vm")', """
    <link href="http://img1.cache.netease.com/utf8/microblog/plugin/css/wb2.0.8.css" charset="utf-8" type="text/css" rel="stylesheet">
    <script type="text/javascript" src="http://img1.cache.netease.com/utf8/microblog/plugin/js/wb2.2.7.js " charset="utf-8"></script>
    <script type="text/javascript" src="http://img1.cache.netease.com/utf8/microblog/plugin/js/wbshare1.0.3.js" charset="utf-8"></script>
  """
  marcos = template.match /#macro\s*?\(\s*?(\S*?)\s*\)([\s\S]*?)#end/g

  if marcos then for marco in marcos
    marco = marco.match  /#macro\s*?\(\s*?(\S*?)\s*\)([\s\S]*?)#end/
    template = template.replace marco[0], ''
    template = template.replace new RegExp("##{marco[1]}\\(\\)",'g'), marco[2]
  try
    html = Velocity.render(template, context)
  catch e
    console.log e
    return template