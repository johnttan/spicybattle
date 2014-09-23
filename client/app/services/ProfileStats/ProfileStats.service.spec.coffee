'use strict'

describe 'Service: ProfileStats', ->

  # load the service's module
  beforeEach module 'spicyPartyApp'

  # instantiate service
  ProfileStats = undefined
  beforeEach inject (_ProfileStats_) ->
    ProfileStats = _ProfileStats_

  it 'should do something', ->
    expect(!!ProfileStats).toBe true
