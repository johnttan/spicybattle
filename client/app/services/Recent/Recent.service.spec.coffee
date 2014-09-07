'use strict'

describe 'Service: Recent', ->

  # load the service's module
  beforeEach module 'spicyPartyApp'

  # instantiate service
  Recent = undefined
  beforeEach inject (_Recent_) ->
    Recent = _Recent_

  it 'should do something', ->
    expect(!!Recent).toBe true
