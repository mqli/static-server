Velocity = require 'velocityjs'
fs = require 'fs'
render = require './vmrender'
template = fs.readFileSync('D:/workspace/fontend/travel/2013_315/2013_315cover.shtml').toString()
marco = template.match /#macro\s*?\(\s*?(\S*?)\s*\)([\s\S]*?)#end/
if marco
  template = template.replace new RegExp("##{marco[1]}\\(\\)",'g'), marco[2]

console.log render template