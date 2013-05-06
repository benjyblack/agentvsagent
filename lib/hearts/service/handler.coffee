actions = require '../engine/actions'
logger = require '../../logger'
types = require './types/hearts_types'
mapper = require './mapper'

module.exports = class Handler
  constructor: (@arena) ->

  _game: (ticket) ->
    @arena.getGame(ticket.gameId)

  _player: (ticket) ->
    game = @_game(ticket)
    game.getPlayer(ticket.agentId)

  enter_arena: (request, result) ->
    player = @arena.createPlayer()
    player.recvStartedGame (err, gameId) ->
      ticket = new types.Ticket(agentId: player.id, gameId: gameId)
      response = new types.EntryResponse(ticket: ticket)

      #player disconnected before response returned
      #if this were updated in npm, would be fine
      # so either need to wrap in a try, or somehow get that newest version
      result null, response

  get_game_info: (ticket, result) ->
    logger.info "Get game info", ticket
    game = @arena.getGame(ticket.gameId)
    player = game.getPlayer(ticket.agentId)

    thriftPosition = mapper.positionToThrift(game.positionOf(player))
    gameInfo = new types.GameInfo(position: thriftPosition)
    logger.info "Returning game info", ticket

    result null, gameInfo

  get_hand: (ticket, result) ->
    logger.info "Get hand", ticket

    @_player(ticket).recvDealt (err, cards) ->
      return result mapper.errorToThrift(err), null if err
      thriftCards = cards.map mapper.cardToThrift
      result null, thriftCards

  pass_cards: (ticket, cards, result) ->
    logger.info "Pass cards", ticket, cards
    player = @_player(ticket)
    mappedCards = cards.map mapper.thriftToCard
    action = new actions.PassCards(player, mappedCards)
    @_game(ticket).handleAction(action)
    player.recvPassed (err, cards) ->
      return result mapper.errorToThrift(err), null if err
      thriftCards = cards.map mapper.cardToThrift
      result null, thriftCards

  get_trick: (ticket, result) ->
    logger.info "Get trick", ticket

    @_player(ticket).recvTurn (err, trick) ->
      return result mapper.errorToThrift(err), null if err
      logger.info "Returning recvTurn", trick
      result null, mapper.trickToThrift(trick)

  play_card: (ticket, card, result) ->
    logger.info "play_card", ticket

    player = @_player(ticket)
    action = new actions.PlayCard(player, mapper.thriftToCard(card))
    @_game(ticket).handleAction(action)
    player.recvEndTrick (err, trick) ->
      return result mapper.errorToThrift(err), null if err
      result null, mapper.trickToThrift(trick)

  get_round_result: (ticket, result) ->
    logger.info "get_round_result", ticket

    @_player(ticket).recvEndRound (err, scores, status) ->
      return result mapper.errorToThrift(err), null if err
      roundResult = new types.RoundResult(scores)
      roundResult.status = switch status
        when "endGame" then types.GameStatus.END_GAME
        when "nextRound" then types.GameStatus.NEXT_ROUND
      result null, roundResult

  get_game_result: (ticket, result) ->
    @_player(ticket).recvEndGame (err, scores) ->
      return result mapper.errorToThrift(err), null if err
      gameResult = new types.GameResult(scores)
      result null, gameResult
