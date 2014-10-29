describe "Environment", ->
  Environment = require 'util/environment'
  it "should load", ->
    expect(Environment).be.an.object
  it "should inherit from EventEmitter", ->
    expect(Environment.prototype)
      .be.instanceOf require('events').EventEmitter

  describe "Environment@createEnv", ->
    it "should return instantiated Environment", ->
      expect(Environment.createEnv(fake: 1)).be.instanceOf Environment

  beforeEach ->
    that = this
    @ev = new Environment(fake: 1)
    @FakeConstructed = false
    @FakeComposite = class FakeComposite
      constructor: (opts) ->
        @options = that.FakeConstructed = opts
    @ev.register 'foo:bar', @FakeComposite

  describe "Environment#constructor", ->
    it "should instantiate", ->
      expect(@ev).be.instanceOf Environment

  describe "Environment#error", ->
    it "should fire error event", (done) ->
      @ev.on 'error', ->
        expect(true).be.true
        done()
      @ev.error()

  describe "Environment#namespaces", ->
    it "should return list of namespaces", ->
      @ev.register 'foo:bat', @FakeComposite
      expect(@ev.namespaces()).to.deep.equal ['foo:bar', 'foo:bat']

  describe "Environment#register", ->
    it "should store Composite in _namespaces", ->
      expect(@ev._namespaces['foo:bar']).be.equal(@FakeComposite)
    it "should fire error event", (done) ->
      @ev.on 'error', ->
        expect(true).to.be.true
        done()
      @ev.register()

  describe "Environment#get", ->
    it "should return undefined for invalid namespace", ->
      expect(@ev.get('foo') == undefined).to.be.true
    it "should return stored Composite", ->
      expect(@ev.get 'foo:bar').to.be.equal(@FakeComposite)

  describe "Environment#create", ->
    it "should fire error event", (done) ->
      @ev.on 'error', ->
        expect(true).to.be.true
        done()
      @ev.create 'bar', true
    it "should construct a new Composite of given namespace", ->
      obj = @ev.create 'foo:bar', true
      expect(@FakeConstructed).to.be.equal obj.options
    it "should return constructed object", ->
      obj = @ev.create 'foo:bar', {}
      expect(obj).to.be.instanceOf @FakeComposite
    it "should default options", ->
      obj = @ev.create 'foo:bar'
      expect(obj.options).to.have.property 'fake', 1

  describe "Environment#instantiate", ->
    it "should default options", ->
      obj = @ev.instantiate @FakeComposite
      expect(obj.options).to.have.property 'fake', 1

