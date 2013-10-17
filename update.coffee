cheerio = require 'cheerio'
request = require 'request'
fs = require 'fs'
CONFIG = require './config.json'
BASE_URL = 'http://qa.developer.163.com/component/server/'

file_amount = 0
callback = null
run_server = ->
  server = require('./lib/server.coffee').run ()->
    console.log 'server running on:',CONFIG.port
    callback and callback(server) 
update_file = (url)->
  request "#{BASE_URL}/#{url}", (err, res, html)->
    file_amount--
    if err or res.statusCode != 200 or !html
      console.log 'file no found:', url
      run_server() if file_amount == 0
      return
    console.log 'update file:', url
    #fs.writeFileSync(__dirname + '/' + url, html)
    run_server() if file_amount == 0

check_update = (cb)->
  callback = cb
  request "#{BASE_URL}/update", (err, res, html)->
    if err or !html or res.statusCode != 200
      console.log 'check update fail, start server'
      return run_server()
    file_list = html.split(/\s+/)
    console.log 'update list:'
    console.log file_list
    file_amount = file_list.length
    update_file(url) for url in file_list
console.log 'check update'

module.exports = check_update
