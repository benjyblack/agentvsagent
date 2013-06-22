AbstractPlayer = require '../abstract_player'

module.exports = class Player extends AbstractPlayer
  constructor: ->
    @events = ['startedGame', 'dealt', 'passed', 'turn', 'endTrick', 'endRound', 'endGame']
    super

