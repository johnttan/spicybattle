'use strict'

describe 'Controller: LeaderboardCtrl', ->

  # load the controller's module
  beforeEach module 'spicyPartyApp'
  LeaderboardCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    LeaderboardCtrl = $controller 'LeaderboardCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
