
describe "ActionQueue", ->
  ActionQueue = require 'util/actionqueue'
  it "should load", ->
    expect(ActionQueue).to.not.be.undefined

  beforeEach ->
    @aq = new ActionQueue ['q1', 'q2', 'q3']
    @addFunc1 = (next) => @foo1Ran = true; next()
    @addFunc2 = (next) => @foo2Ran = true; next()
    @addFunc3 = (next) => @foo3Ran = true; next()
    @aq.add 'q1', @addFunc1
    @aq.add 'q2', @addFunc2
    @aq.add 'q3', @addFunc3

  describe "ActionQueue@constructor", ->
    it "should be defined", ->
      expect(@aq).to.not.be.undefined
    it "should be instance of ActionQueue", ->
      expect(@aq).to.be.an.instanceOf ActionQueue

  describe "ActionQueue#add", ->
    it "should add it to the queue", ->
      expect(@aq._queues.q1.jobs[0]).to.equal @addFunc1
      expect(@aq._queues.q2.jobs[0]).to.equal @addFunc2
      expect(@aq._queues.q3.jobs[0]).to.equal @addFunc3

  describe "ActionQueue#run", ->
    it "should execute queue", ->
      @aq.run 'q1', => expect(@foo1Ran).to.be.true
      @aq.run 'q2', => expect(@foo2Ran).to.be.true
      @aq.run 'q3', => expect(@foo3Ran).to.be.true
    it "should emit error", (done) ->
      @aq.on 'error', (e) ->
        console.log e
        expect(true).to.be.true
        done()
      @aq.add 'q1', (next) -> next 'error'
      @aq.run 'q1'

