var iconv = require('iconv-lite')
var request = require('request')
request({
  url: 'http://lady.163.com/special/0026jt/channel_nav_special.html',
  encoding: 'binary'
},function (err, res, html) {
  console.log(iconv.decode(new Buffer(html, 'binary'), 'gbk'));
});