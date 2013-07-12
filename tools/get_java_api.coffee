request = require 'request'
cheerio = require 'cheerio'
    
URL = 'http://f2e/docs/cms_api_3rd/com/netease/news/file/Tools.html'
#https://cms.ws.netease.com/servlet/webservice.do?target=internal&forward=model&method=getModelData&modelid=0080utf8test
mockFunctions=
  returnString: () ->
    return 'mock string'
  returnNumber: () ->
    return 1

result = {}

request.get  URL, (err, res, html)->
  $ = cheerio.load html
  $('A[NAME="method_summary"]+TABLE TR[CLASS="TableRowColor"]').each ()->
    returnType = $(this).find('TD:first-child').text()
    methodName = $(this).find('TD:last-child B A').text()
    if returnType.indexOf('String') > -1
      result[methodName] = 'String'
    else if  returnType.indexOf('int') > -1 or returnType.indexOf('long') > -1
      result[methodName] = 'Number'
    
  console.log result

