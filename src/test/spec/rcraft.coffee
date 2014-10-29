###
  ======== A Handy Little Mocha Reference ========
  http://mochajs.org/


  # Mocha Hooks
  before ->
    # runs before all tests in this block
  after ->
    # runs after all tests in this block
  beforeEach ->
    # runs before each test in this block
  afterEach ->
    # runs after each test in this block

  # "All hooks can be invoked with an optional description, making it easier to
  # pinpoint errors in your tests. If hooks are given named functions those
  # names will be used if no description is supplied."
  beforeEach namedFun = ->
    # beforeEach:namedFun
  beforeEach "some description", ->
    # beforeEach:some description

  # If hook takes a done callback argument, it's treated
  # as an async test.

  # example:
  describe "Interfaces", ->
    # happens before each it()
    beforeEach (done) ->
      @user = new User 'foo'
      db.clear -> done()

    # waits for done() to be called
    describe "AsyncInterface", ->
      describe "#save()", ->
        it "should save without error", (done) ->
          @user.save (err) ->
            throw err if err
            done()

    # just don't take a `done` argument callback passed to it() and
    # Mocha will treat the test as sync
    describe "SyncInterface", ->
      describe "#save()", ->
        it "should save without error", ->
          @user.save()

###

Rcraft = require '../../lib/rcraft'

describe "awesome", ->
  it "should be awesome.", ->
    expect(Rcraft.awesome()).to.be.equal 'awesome'

