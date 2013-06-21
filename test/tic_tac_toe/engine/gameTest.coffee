Game = require "../../../lib/tic_tac_toe/engine/game"
Player = require "../../../lib/tic_tac_toe/player"
should = require("should")

describe "Game", ->
  beforeEach ->
    @player1 = new Player()
    @player2 = new Player()
    @game = new Game(@player1, @player2, @player3, @player4)

  it "has an id", ->
    @game.should.have.property('id')

  it "has players", ->
    @game.players.length.should.equal(2)

  describe "#getPlayer", ->
    it "returns a player by id", ->
      @game.getPlayer(@player2.id).id.should.equal(@player2.id)

    it "returns nothing if player doesn't exist", ->
      should.not.exist(@game.getPlayer("foo"))

