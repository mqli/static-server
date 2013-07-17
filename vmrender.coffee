Velocity = require 'velocityjs'
fs = require 'fs'
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

#匹配中文占位符
REG = /\[[a-zA-Z0-9\u4e00-\u9fa5_]+\]/g

monkObj = get: (key) ->
  MOCK_VALUS[key] or key

#vm全局对象
context =
  tag:
    getList: (arg) ->
      [monkObj,monkObj,monkObj]
  tools: require './mockTools'
  comment: '<!--#include virtual="/comment/0005/sports_zh_bbs/1P/93VI8G1P00051CDG.html"-->'

module.exports = (template) ->
  template = template.replace REG, (key) ->
    if REPLACE_MAP[key] then "${one.get(\"#{REPLACE_MAP[key]}\")}" else key
  template = template.replace '#parse("/0080/n/0080nph_2.vm")', fs.readFileSync('photo.inc')
  try
    html = Velocity.render(template, context)
  catch e
    return template