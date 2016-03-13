cluster = require 'cluster'

module.exports = (cb) ->
  return cb() if cluster.isWorker

  toma = {}
  #console.log "#{process.pid} Tētē kura"
  cluster.on 'exit', (worker) ->
    cluster.fork() if !toma[worker.id.toString()]?
    process.exit() if Object.keys(cluster.workers).length is 0
  cluster.fork()
  process.on 'SIGHUP', ->
    worker = cluster.fork()
    worker.once 'listening', (address) ->
      for id, child of cluster.workers
        continue if id == worker.id.toString()
        toma[id.toString()] = yes
        child.process.kill()
  shutdown = ->
    for id, child of cluster.workers
      toma[id.toString()] = yes
      child.process.kill()
  process.on 'SIGINT', shutdown
  process.on 'SIGTERM', shutdown
