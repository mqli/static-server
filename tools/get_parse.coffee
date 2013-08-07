fs = require 'fs'
request = require 'request'
iconv = require 'iconv-lite'
DIR = 'd:/workspace/fontend'
REG = '#parse\\("(.*?)"\\)'
DOMAINS = fs.readFileSync(__dirname + '/../lib/domain_map')
  .toString()
  .split('\n')
  .reduce (map, str)->
    str = str.trim().split ';'
    map[str[0]] = str[1]
    return map
  , {}
travel = (dir)->
  for path in fs.readdirSync dir when path.indexOf('.') isnt 0
    path = dir + '/' + path
    return if !fs.existsSync(path)
    if fs.statSync(path).isFile() and path.indexOf('tml') > 0
      find path
    else if fs.statSync(path).isDirectory()
      travel path

result = {}
map = 
  '0006/m/0006morelist.vm' : 'http://travel.163.com/special/00063K78/morelist.html'
  '0001/n/0001nav09_end.vm': 'http://news.163.com/special/0001jt/nav09_end.html'
  '0026/l/0026ladynewnav.vm' : 'http://lady.163.com/special/00262GI8/ladynewnav.html '
  '0080/T/0080TransmitToWb.vm': 'http://temp.163.com/special/008049OK/TransmitToWb.html'
  '0080/n/0080nph_2.vm': 'http://temp.163.com/special/008047FL/nph_2.html'


find = (dir) ->
  parse = fs.readFileSync(dir).toString().match REG
  if parse
    return console.log dir
    parse =  parse[1]
    parse = parse.substring(1) if parse.charAt(0) == '/'
    parse = parse.split('/')
    url = "#{DOMAINS[parse[0]]}/special/#{parse[2].replace('.vm', '').substring(4)}"
    url = map[parse.join('/')] if map[parse.join('/')]
    request.get 
      url:url
      encoding: 'binary'
    , (err, res, html)->
      if res.statusCode == 200
        result[parse.join('/')] = iconv.decode(new Buffer(html, 'binary'), 'gbk')
        
travel DIR
#process.on 'exit', ->
  #fs.writeFileSync('parse2.json', JSON.stringify(result))