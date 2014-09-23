'use strict'

describe 'Service: PlayerData', ->

  # load the service's module
  beforeEach module 'spicyPartyApp'

  # instantiate service
  PlayerData = undefined
  beforeEach inject (_PlayerData_) ->
    PlayerData = _PlayerData_

  it 'should do something', ->
    expect(!!PlayerData).toBe true
