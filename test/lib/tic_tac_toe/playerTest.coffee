Player = require "../../../lib/tic_tac_toe/player"

describe "Player", ->
  beforeEach ->
    @player = new Player()

  it "has an id", ->
    expect(@player).to.have.property('id')

  describe "#forward", ->
    it "returns a promise that will be resolved on send", (done) ->
      expect(@player.forward()).to.eventually.eql(message: "foo", data: {foo: "bar"}).notify(done)

      @player.send("foo", {foo: "bar"})

    it "returns a promise that will be resolved with no data on send", (done) ->
      expect(@player.forward()).to.eventually.eql(message: "foo", data: {}).notify(done)

      @player.send("foo")

    it "emits the message", (done) ->
      @player.on 'message', (type, data) ->
        expect(type).to.equal("foo")
        expect(data).to.eql({foo: "bar"})
        done()

      @player.forward("foo", {foo: "bar"})

    it "moves to waiting for server", ->
      @player.forward()
      expect(@player.state.state).to.equal("waitingForServer")

    it "returns an error if called twice", (done) ->
      @player.forward()
      expect(@player.forward()).to.be.rejected.with("unexpectedMessage").notify(done)

  describe "#send", ->
