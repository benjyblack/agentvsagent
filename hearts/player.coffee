{EventEmitter} = require 'events'
IdGenerator = require './idgenerator'
# Pile = require "./Pile"

module.exports = class Player extends EventEmitter
  constructor: ->
    @id = IdGenerator.generate()
    # @held = new Pile()
    # @takenTricks = []

    @once 'start', (gameId) =>
      @_waitForGame = gameId

  waitForGame: (callback) ->
    if @_waitForGame
      callback @_waitForGame 
    else
      @removeAllListeners 'start'
      @once 'start', callback
