filewalker = require 'filewalker'

filewalker('d:/workspace/fontend/').on 'file', (p, s) ->
  console.log p if p
.walk()