###
 rcraft
 https://github.com/bline/rcraft

 Copyright (c) 2014 Scott Beck
 Licensed under the MIT license.
###

events = require 'events'
queue = require 'queue'
ActionQueue = require './actionqueue'
_ = require 'lodash'
{Router, State, Async} = require 'abyssa'

class Environment extends events.EventEmitter
  constructor: (@options = {}) ->
    super
    @queue = new ActionQueue ['enter', 'update', 'exit']
    @queue.on 'error', (err) => @error err
    @_namespaces = {}
    return @

  error: (err) ->
    err = if err instanceof Error then err else new Error(err)
    # throw if no error handler
    unless @emit "error", err
      throw err
    return this

  register: (namespace, Composite) ->
    unless _.isString namespace
      return @error(new Error 'No namespace')
    @_namespaces[namespace] = Composite
    return this

  namespaces: ->
    return _.keys @_namespaces

  get: (namespace) ->
    return unless namespace # stop recursion
    @_namespaces[namespace] || @get namespace.split(':').slice(0, -1).join(':')

  create: (namespace, options = {}) ->

    Composite = @get namespace

    unless Composite
      return @error "You do not seem to have #{namespace} loaded"

    return @instantiate  Composite, options

  instantiate: (Composite, options = {}) ->
    opts = options.options || _.clone @options
    opts.env = @
    opts.namespace = Composite.namespace
    return new Composite opts


  @createEnv: (options) ->
    return new Environment options

module.exports = Environment
