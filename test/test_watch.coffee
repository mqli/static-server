fs = require 'fs'
watch = require 'watch'
mcss = require 'mcss'
less = require 'less'
CONFIG =
  'dir': 'd:/workspace/fontend'
  'complie': ['less', 'mcss']
compliers =
  mcss: (f)->
    mcss().translate(fs.readFileSync(f).toString()).done (css)->
      fs.writeFileSync f.replace('.mcss', '.css'), css
      console.log 'complie file:', f
    .fail (error)->
      console.log error
  less: (f)->
    less.render fs.readFileSync(f).toString(), (error, css) ->
      return console.log error if error
      fs.writeFileSync f.replace('.less', '.css'), css
      console.log 'complie file:', f
onFileChanged = (f, curr, prev)->
  return if !fs.statSync(f).isFile()
  extension = f[f.lastIndexOf('.') + 1..f.length]
  complier = compliers[extension]
  return if !complier
  complier(f)

filter = (f)->
  extension = f[f.lastIndexOf('.') + 1..f.length]
  !CONFIG.complie.some (complie)-> complie == extension
watch.createMonitor CONFIG.dir ,{
  ignoreDotFiles: true
  filter: filter
}, (monitor)->
  monitor.on "changed", onFileChanged
  monitor.on "created", onFileChanged