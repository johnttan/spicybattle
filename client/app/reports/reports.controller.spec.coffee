'use strict'

describe 'Controller: ReportsCtrl', ->

  # load the controller's module
  beforeEach module 'spicyPartyApp'
  ReportsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ReportsCtrl = $controller 'ReportsCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
