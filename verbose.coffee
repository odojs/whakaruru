cluster = require 'cluster'

module.exports = (cb) ->
  return cb() if cluster.isWorker

  toma = {}
  console.log "#{process.pid} Tētē kura"
  cluster.on 'exit', (worker) ->
    if !toma[worker.id.toString()]?
      console.log "#{worker.process.pid}:#{worker.id.toString()} Whakamātūtū"
      cluster.fork()
    else
      console.log "#{worker.process.pid}:#{worker.id.toString()} Mōnehu"
  cluster.on 'listening', (worker, address) ->
    console.log "#{worker.process.pid}:#{worker.id.toString()} Whakarongo #{address.address ? '0.0.0.0'}:#{address.port}"
  cluster.fork()
  process.on 'SIGHUP', ->
    console.log "#{process.pid} Pūangiangi"
    worker = cluster.fork()
    worker.once 'listening', (address) ->
      for id, child of cluster.workers
        continue if id == worker.id.toString()
        console.log "#{child.process.pid}:#{id.toString()} Harapaki"
        toma[id.toString()] = yes
        child.process.kill()
  shutdown = ->
    for id, child of cluster.workers
      toma[id.toString()] = yes
      child.process.kill()
    console.log "#{process.pid} Tētē kura manawa kiore"
  process.on 'SIGINT', shutdown
  process.on 'SIGTERM', shutdown
