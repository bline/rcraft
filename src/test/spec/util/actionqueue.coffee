
describe "ActionQueue@", ->
  ActionQueue = require 'util/actionqueue'
  it "should load", ->
    expect(ActionQueue).to.not.be.undefined

  beforeEach ->
    @aq = new ActionQueue ['q1', 'q2', 'q3']

  describe "ActionQueue@constructor", ->
    it "should be defined", ->
      expect(@aq).to.not.be.undefined
    it "should be instance of ActionQueue", ->
      expect(@aq).to.be.an.instanceOf ActionQueue
