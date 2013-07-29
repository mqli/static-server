request = require 'request'

module.exports = (config = {}) ->
  (req, res, next) ->
    if address = config[req.headers.host]
      console.log 'proxy:', req.headers.host, address
      x = request(address)
      req.pipe(x)
      x.pipe(res)
    else
      next()