Seat = require './seat'
Suit = require './suit'
Rank = require './rank'
Trick = require './trick'

module.exports = class Round
  constructor: ->
    @north = new Seat()
    @east = new Seat()
    @south = new Seat()
    @west = new Seat()

    @tricks = []

  currentTrick: ->
    @tricks[@tricks.length - 1]

  newTrick: ->
    if @tricks.length == 0
      # TODO: refactor out positions array
      positions = ["north", "east", "south", "west"]

      startingPosition = do (positions) =>
        for position in positions
          return position if @[position].held.findCard(Suit.CLUBS, Rank.TWO)

      @tricks.push(new Trick(startingPosition))
    else
      winner = @currentTrick().winner()
      @tricks.push(new Trick(winner))
      # @tricks.push(new Trick("north"))

  allHavePassed: ->
    @north.hasPassed() && @east.hasPassed() && @south.hasPassed() && @west.hasPassed()

