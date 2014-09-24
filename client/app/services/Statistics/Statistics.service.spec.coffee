'use strict'

describe 'Service: Statistics', ->

  # load the service's module
  beforeEach module 'spicyPartyApp'

  # instantiate service
  Statistics = undefined
  beforeEach inject (_Statistics_) ->
    Statistics = _Statistics_

  it 'should do something', ->
    expect(!!Statistics).toBe true
