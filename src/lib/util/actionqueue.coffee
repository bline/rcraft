_ = require 'lodash'
queue = require 'queue'
events = require 'events'
assert = require 'assert'

class ActionQueue extends events.EventEmitter
  constructor: (queues) ->
    @_queues = {}
    makeQ = (type) =>
      q = queue()
      q.on 'error', (e) =>
        @emit 'error', e
      q.on 'end', =>
        @emit "queue-end"
        @emit "#{type}-queue-end"
      return q
    _.each queues, (queueName) =>
      @_queues[queueName] = makeQ queueName

  add: (queueName, cb) ->
    @_queues[quueueName].push cb

  run: (queueName, done) ->
    assert _.isString(queueName), 'queueName not supplied'
    @_queues[queueName].start done

module.exports = ActionQueue
