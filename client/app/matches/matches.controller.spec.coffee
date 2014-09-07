'use strict'

describe 'Controller: MatchesCtrl', ->

  # load the controller's module
  beforeEach module 'spicyPartyApp'
  MatchesCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MatchesCtrl = $controller 'MatchesCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
