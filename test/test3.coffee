request = require 'request'

url = 'http://finance.163.com/special/sp/stock13_column5.html'
request url:url,followRedirect:false, (err, res)->
  console.log  res.statusCode