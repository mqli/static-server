module.exports = (html, callback)->
  includes = html.match /<!--#include (\S+)="(\S+)"-->/g
  count = includes.length

  includes.forEach (include)->
    result = include.match /(\S+)="(\S+)"/
    if result[0] != ''