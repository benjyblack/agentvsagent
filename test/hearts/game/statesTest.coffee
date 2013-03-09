Game = require("../../../hearts/game")
Pile = require("../../../hearts/game/pile")
Card = require("../../../hearts/game/card")
Suit = require("../../../hearts/game/suit")
Rank = require("../../../hearts/game/rank")
Player = require("../../../hearts/player")
states = require("../../../hearts/game/states")
actions = require("../../../hearts/game/actions")
should = require("should")

describe "states", ->
  beforeEach ->
    @player1 = new Player()
    @player2 = new Player()
    @player3 = new Player()
    @player4 = new Player()
    @game = new Game(@player1, @player2, @player3, @player4)

    @nextStateCalls = 0
    @game.nextState = =>
      @nextStateCalls++


  describe "StartingGame", ->
    beforeEach ->
      @state = new states.StartingGame(@game)

    it "assigns each player a position", ->
      @state.run()

      positions = [
        @game.positions.north.id
        @game.positions.east.id
        @game.positions.south.id
        @game.positions.west.id
      ]

      players = @game.players.map (player) -> player.id

      positions.sort().should.eql players.sort()

    it "emits a started event on the players", (done) ->
      @player1.once 'started', (gameId) =>
        gameId.should.equal(@game.id)
        done()

      @state.run()

    it "pushes the next states on the stack", ->
      @game.stack.should.have.length(0)
      @state.run()
      @game.stack.should.have.length(1)
      @game.stack[0].should.equal("startingRound")

    it "goes to the next state", ->
      @state.run()
      @nextStateCalls.should.equal(1)

  describe "StartingRound", ->
    beforeEach ->
      @state = new states.StartingRound(@game)

    it "pushes the next states on the stack", ->
      @game.stack.should.have.length(0)
      @state.run()
      @game.stack.should.have.length(16)
      @game.stack[15].should.equal("dealing")
      @game.stack[14].should.equal("passingRight")
      @game.stack[13].should.equal("startingTrick")
      @game.stack[1].should.equal("startingTrick")
      @game.stack[0].should.equal("endingRound")

    it "goes to the next state", ->
      @state.run()
      @nextStateCalls.should.equal(1)

  describe "Dealing", ->
    beforeEach ->
      @game.states.startingGame.run()
      @game.states.startingRound.run()
      @nextStateCalls = 0
      @state = new states.Dealing(@game)

    it "deals cards to all players", ->
      @state.run()
      @game.currentRound().north.dealt.cards.should.have.length(13)
      @game.currentRound().north.held.cards.should.have.length(13)
      @game.currentRound().east.dealt.cards.should.have.length(13)
      @game.currentRound().east.held.cards.should.have.length(13)
      @game.currentRound().south.dealt.cards.should.have.length(13)
      @game.currentRound().south.held.cards.should.have.length(13)
      @game.currentRound().west.dealt.cards.should.have.length(13)
      @game.currentRound().west.held.cards.should.have.length(13)

    it "goes to the next state", ->
      @state.run()
      @nextStateCalls.should.equal(1)

    it "emits a dealt event on the players", (done) ->
      @player1.once 'dealt', (cards) =>
        cards.should.have.length(13)
        done()

      @state.run()

  describe "Passing", ->
    beforeEach ->
      @game.states.startingGame.run()
      @game.states.startingRound.run()
      @game.states.dealing.run()
      @nextStateCalls = 0
      @state = new states.Passing(@game, "left")

    it "get cards from players", ->
      cards = Card.all()[0..2]
      action = new actions.PassCards(@game.positions.north, cards)

      @state.handleAction(action)

      @game.currentRound().north.passed.cards.should.eql(cards)

    it "goes to the next state and emits an event after all four have passed cards", (done) ->
      cards = Card.all()[0..2]
      @state.handleAction new actions.PassCards(@game.positions.north, cards)
      @state.handleAction new actions.PassCards(@game.positions.east, cards)
      @state.handleAction new actions.PassCards(@game.positions.south, cards)
      @game.positions.north.once 'passed', (cards) ->
        cards.should.have.length(3)
        done()

      @state.handleAction new actions.PassCards(@game.positions.west, cards)
      @nextStateCalls.should.equal(1)

    it "does not go to the next state if the same player passes four times", ->
      cards = Card.all()[0..2]
      @state.handleAction new actions.PassCards(@game.positions.north, cards)
      @state.handleAction new actions.PassCards(@game.positions.north, cards)
      @state.handleAction new actions.PassCards(@game.positions.north, cards)
      @state.handleAction new actions.PassCards(@game.positions.north, cards)
      @nextStateCalls.should.equal(0)

    describe "strategies", ->
      setup = ->
        @northPassedCards = @game.currentRound().north.dealt.cards[0..2]
        @state.handleAction new actions.PassCards(@game.positions.north, @northPassedCards)

        @eastPassedCards = @game.currentRound().east.dealt.cards[0..2]
        @state.handleAction new actions.PassCards(@game.positions.east, @eastPassedCards)

        @southPassedCards = @game.currentRound().south.dealt.cards[0..2]
        @state.handleAction new actions.PassCards(@game.positions.south, @southPassedCards)

        @westPassedCards = @game.currentRound().west.dealt.cards[0..2]
        @state.handleAction new actions.PassCards(@game.positions.west, @westPassedCards)

        @nextStateCalls.should.equal(1)

      it "passes left", ->
        @state.direction = "left"
        setup.apply(this)

        for card in @northPassedCards
          should.not.exist(@game.currentRound().north.held.findCard(card.suit, card.rank))
          @game.currentRound().north.passed.findCard(card.suit, card.rank).should.equal(card)
          @game.currentRound().east.held.findCard(card.suit, card.rank).should.equal(card)

      it "passes right", ->
        @state.direction = "right"
        setup.apply(this)

        for card in @northPassedCards
          should.not.exist(@game.currentRound().north.held.findCard(card.suit, card.rank))
          @game.currentRound().north.passed.findCard(card.suit, card.rank).should.equal(card)
          @game.currentRound().west.held.findCard(card.suit, card.rank).should.equal(card)

      it "passes across", ->
        @state.direction = "across"
        setup.apply(this)

        for card in @northPassedCards
          should.not.exist(@game.currentRound().north.held.findCard(card.suit, card.rank))
          @game.currentRound().north.passed.findCard(card.suit, card.rank).should.equal(card)
          @game.currentRound().south.held.findCard(card.suit, card.rank).should.equal(card)

  describe "StartingTrick", ->
    beforeEach ->
      @game.states.startingGame.run()
      @game.states.startingRound.run()

      @game.currentRound().east.held.addCard(new Card(Suit.CLUBS, Rank.TWO))

      @nextStateCalls = 0

    it "adds a trick to the round", ->
      @game.currentRound().tricks.should.have.length(0)
      @game.states.startingTrick.run()
      @game.currentRound().tricks.should.have.length(1)
      @game.currentRound().currentTrick().played.addCard({})
      @game.states.startingTrick.run()
      @game.currentRound().tricks.should.have.length(2)

    it "adds the next states", ->
      @game.stack.splice(0, @game.stack.length)
      @game.stack.should.have.length(0)
      @game.states.startingTrick.run()
      @game.stack.should.have.length(5)
      @game.stack[4].should.equal("waitingForCardFromEast")
      @game.stack[3].should.equal("waitingForCardFromSouth")
      @game.stack[2].should.equal("waitingForCardFromWest")
      @game.stack[1].should.equal("waitingForCardFromNorth")
      @game.stack[0].should.equal("endingTrick")

    it "goes to the next state", ->
      @game.states.startingTrick.run()

      @nextStateCalls.should.equal(1)

  describe "WaitingForCard", ->
    beforeEach ->
      @game.states.startingGame.run()
      @game.states.startingRound.run()
      @game.states.startingTrick.run()
      @nextStateCalls = 0

    it "applies the card to the player", ->
      state = new states.WaitingForCard(@game, "north")
      card = Card.all()[0]
      action = new actions.PlayCard(@game.positions.north, card)
      state.handleAction(action)

      @game.currentRound().currentTrick().played.cards[0].should.equal(card)

    it "emits an event on the player with the current trick", (done) ->
      @game.positions.north.once 'turn', (trick) =>
        trick.should.equal @game.currentRound().currentTrick()
        done()
      state = new states.WaitingForCard(@game, "north").run()


    it "goes to the next state", ->
      state = new states.WaitingForCard(@game, "north")
      card = Card.all()[0]
      action = new actions.PlayCard(@game.positions.north, card)
      state.handleAction(action)

      @nextStateCalls.should.equal(1)

  describe "EndingTrick", ->
    beforeEach ->
      @game.states.startingGame.run()
      @game.states.startingRound.run()
      @game.states.startingTrick.run()
      @nextStateCalls = 0

    it "emits end trick event on each player", (done) ->
      @game.positions.north.once 'endTrick', (trick) =>
        trick.should.equal @game.currentRound().currentTrick()
        done()

      new states.EndingTrick(@game).run()


    it "goes to the next state", ->
      new states.EndingTrick(@game).run()
      @nextStateCalls.should.equal(1)

  describe "EndingRound", ->
    beforeEach ->
      @game.states.startingGame.run()
      @game.stack = []
      @nextStateCalls = 0

    it "starts a new round if no one is over 100, and emits new round on each player", (done) ->
      @game.rounds.push({ scores: -> { north: 10, east: 0, south: 15, west: 1 }})

      @game.positions.north.once 'endRound', (round, status) ->
        status.should.equal 'nextRound'
        round.north.should.equal(10)
        round.east.should.equal(0)
        round.south.should.equal(15)
        round.west.should.equal(1)
        done()

      @game.states.endingRound.run()
      @game.stack[0].should.equal("startingRound")
      @nextStateCalls.should.equal(1)

    it "ends the game if someone reaches 100, and emits game end on each player", (done) ->
      @game.rounds.push({ scores: -> { north: 101, east: 0, south: 15, west: 1 }})

      @game.positions.north.once 'endRound', (round, status) ->
        status.should.equal 'endGame'
        round.north.should.equal(101)
        round.east.should.equal(0)
        round.south.should.equal(15)
        round.west.should.equal(1)
        done()

      @game.states.endingRound.run()
      @game.stack.should.have.length(1)
      @game.stack[0].should.equal("endingGame")
      @nextStateCalls.should.equal(1)



