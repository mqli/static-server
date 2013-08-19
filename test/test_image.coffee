gm = require 'gm'
fs = require 'fs'
gm(200, 400, "#ddff99f3")
.drawText(10, 50, "from scratch")
.stream  (err, stdout, stderr) ->
  stdout.pipe(fs.createWriteStream('a.jpg'))