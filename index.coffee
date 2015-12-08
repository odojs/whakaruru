cluster = require 'cluster'

module.exports = (cb) ->
  return cb() if cluster.isWorker

  toma = {}
  #console.log "#{process.pid} Tētē kura"
  cluster.on 'exit', (worker) ->
    if !toma[worker.id]?
      #console.log "#{worker.process.pid} Whakamātūtū"
      cluster.fork()
    # else
    #   console.log "#{worker.process.pid} Mōnehu"
  # cluster.on 'listening', (worker, address) ->
  #   console.log "#{worker.process.pid} Whakarongo #{address.address ? '0.0.0.0'}:#{address.port}"
  cluster.fork()
  process.on 'SIGHUP', ->
    #console.log "#{process.pid} Pūangiangi"
    worker = cluster.fork()
    worker.once 'listening', (address) ->
      for id, child of cluster.workers
        continue if id == worker.id.toString()
        #console.log "#{child.process.pid} Harapaki"
        toma[id] = yes
        child.process.kill()
  process.on 'SIGTERM', ->
    for id in cluster.workers
      cluster.workers[id].process.kill()
