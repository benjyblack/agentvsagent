machina = require('machina')()
Q = require 'q'
logger = require '../lib/logger'
{EventEmitter} = require 'events'

# Time each state, emit 'end' on timeout
AgentState = machina.Fsm.extend
  initialize: (info) ->
    @agent = info.agent
  # "*": ->
  #   console.log "=( =( unexpected message =( =( =(", @state, arguments
  initialState: "waitingForClient"
  states:
    waitingForServer:
      send: (message, data) ->
        @transition "waitingForClient"
        @request.resolve(message: message, data: data || {})

      forward: (message, data, request) ->
        request.reject(new Error("unexpectedMessage"))

    waitingForClient:
      forward: (message, data, @request)->
        @transition "waitingForServer"
        @agent.emit message, data

module.exports = class Agent extends EventEmitter
  constructor: ->
    @state = new AgentState(agent: this)
    @state.on "transition", (details) ->
      # console.log "agent changed state from #{details.fromState} to #{details.toState}, because of #{details.action}"
      logger.verbose "agent changed state from #{details.fromState} to #{details.toState}, because of #{details.action}"

  forward: (message, data) ->
    logger.verbose "forwarding #{message}, #{data}"
    request = Q.defer()
    @state.handle "forward", message, data, request
    request.promise

  send: (message, data) ->
    logger.verbose "sending", message, data
    @state.handle "send", message, data

