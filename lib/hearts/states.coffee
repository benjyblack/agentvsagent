und = require 'underscore'
logger = require '../logger'
Pile = require './pile'
Round = require './round'

class State
  constructor: (@game) ->

  run: ->

  handleAction: (action) ->
    @beforeAction && @beforeAction()
    error = action.validate(@game)
    if !error
      action.execute(@game)
      @afterAction()
    else
      @game.abort(action.player, error)

exports.StartingGame = class StartingGame extends State
  run: ->
    logger.verbose "Starting game with players:", @game.players.map (p) -> p.id
    positions = ["north", "east", "west", "south"]

    for player in und.shuffle(@game.players)
      @game.positions[positions.shift()] = player

      player.out.sendStartedGame @game.id

    @game.stack.push("startingRound")
    @game.nextState()

exports.StartingRound = class StartingRound extends State
  run: ->
    @game.rounds.push(new Round())

    @game.stack.push("endingRound")
    for _ in [1..13]
      @game.stack.push("startingTrick")

    passing = ["passingLeft", "passingRight", "passingAcross"][(@game.rounds.length - 1) % 4]
    if passing
      @game.stack.push(passing)
    @game.stack.push("dealing")
    @game.nextState()

exports.Dealing = class Dealing extends State
  run: ->
    logger.verbose "Dealing"
    @deal()
    @game.nextState()

  deal: ->
    deck = Pile.createShuffledDeck()

    positions = ["north", "east", "south", "west"]

    for position in positions
      seat = @game.currentRound()[position]
      deck.moveCardsTo(13, seat.dealt)
      seat.dealt.copyAllCardsTo(seat.held)
      @game.positions[position].out.sendDealt seat.dealt.cards

exports.Passing = class Passing extends State
  constructor: (game, @direction) ->
    super(game)

  run: ->
    logger.verbose "Passing", @direction

  afterAction: (action) ->
    logger.verbose "Handled passing action"

    if @game.currentRound().allHavePassed()
      @exchange()
      @game.nextState()

  exchange: ->
    passing =
      right: [["north", "west"], ["east", "north"], ["south", "east"], ["west", "south"]]
      left: [["north", "east"], ["east", "south"], ["south", "west"], ["west", "north"]]
      across: [["north", "south"], ["east", "west"], ["south", "north"], ["west", "east"]]

    strategy = passing[@direction]

    game = @game
    do (strategy, game) ->
      for pair in strategy
        do ->
          round = game.currentRound()
          fromPosition = pair[0]
          toPosition = pair[1]
          fromSeat = round[fromPosition]
          toSeat = round[toPosition]
          passedCards = fromSeat.passed.cards

          for card in passedCards
            fromSeat.held.moveCardTo(card, toSeat.held)

          game.positions[toPosition].out.sendPassed passedCards

exports.StartingTrick = class StartingTrick extends State
  run: ->
    @game.currentRound().newTrick()
    @game.stack.push("endingTrick")
    for position in @game.currentRound().currentTrick().positionsFromLeader().reverse()
      @game.stack.push("waitingForCardFrom" + position.charAt(0).toUpperCase() + position.slice(1))
    @game.nextState()

exports.WaitingForCard = class WaitingForCard extends State
  constructor: (game, @position) ->
    super(game)

  run: ->
    logger.verbose "Waiting for card from #{@position}, for #{@game.turnTime}"
    @game.positions[@position].out.sendTurn @game.currentRound().currentTrick()
    @timer = setTimeout =>
      logger.verbose "Timeout!"
      @game.abort(@game.positions[@position], {type: "invalidMove", message: "Your action took longer than allowed"})
    , @game.turnTime

  beforeAction: ->
    clearTimeout(@timer)

  afterAction: ->
    logger.verbose "Handling action while waiting for card from", @position
    @game.nextState()

exports.EndingTrick = class EndingTrick extends State
  run: ->
    logger.verbose "Trick ended"
    for player in @game.players
      player.out.sendEndTrick @game.currentRound().currentTrick()
    @game.nextState()

exports.EndingRound = class EndingRound extends State
  run: ->
    logger.verbose "round ended", @game.currentRound().scores()
    if @game.maxPenaltyReached()
      @game.stack.push("endingGame")
      for player in @game.players
        player.out.sendEndRound @game.currentRound().scores(), 'endGame'
    else
      @game.stack.push("startingRound")
      for player in @game.players
        player.out.sendEndRound @game.currentRound().scores(), 'nextRound'

    # Should this pause and wait for all bots
    # to check in before moving to the next round?
    @game.nextState()

exports.EndingGame = class EndingGame extends State
  run: ->
    logger.info "sending scores", @game.scores()
    for player in @game.players
      player.out.sendEndGame @game.scores()
    @game.stack.push("gameEnded")
    @game.nextState()

exports.GameEnded = class GameEnded extends State
  handleAction: ->

  run: ->
    logger.info "game ended"
    @game.emit 'gameEnded'



