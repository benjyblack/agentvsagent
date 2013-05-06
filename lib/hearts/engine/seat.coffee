Pile = require "../../../lib/hearts/engine/pile"

module.exports = class Seat
  constructor: ->
    @dealt = new Pile()
    @passed = new Pile()
    #TODO:  @received = new Pile()
    @held = new Pile()

  hasPassed: ->
    @passed.cards.length > 0

