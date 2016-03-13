whakaruru = require './verbose'
whakaruru ->
  mutunga = require 'http-mutunga'
  app = (req, res) -> res.end 'Ok.'
  server = mutunga(app).listen 8080, ->
    console.log "#{process.pid} Listening"
    shutdown = ->
      console.log "#{process.pid} Waiting for requests to finish"
      server.close ->
        console.log "#{process.pid} Exiting"
        process.exit 0
    process.on 'SIGTERM', shutdown
    process.on 'SIGINT', shutdown