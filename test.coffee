Velocity = require 'velocityjs'
fs = require 'fs'
render = require './vmrender'
template = fs.readFileSync('D:/workspace/fontend/travel/2013_315/2013_315cover.shtml').toString()
marco = template.match /#macro\s*?\(\s*?(\S*?)\s*\)([\s\S]*?)#end/
if marco
  template = template.replace new RegExp("##{marco[1]}\\(\\)",'g'), marco[2]

#console.log render template
str = 'topicid=00084IMR;liststart=0;listnum=2;titlelength=8;digestlength=38;pointstart=
60;pointend=90;'

result = {}
for arg in str.split(';')
  arg = arg.split '='
  result[arg[0]] = arg[1] if arg[0]

result = mocking.array(mocking.object(
  title: mocking.string(mocking.int(3, parseInt(result.titlelength) || 3), "标题"),
  get: ()-> return (key)-> this[key]
), parseInt(result.listnum) || 2)

console.log  result()[0].get('title')
