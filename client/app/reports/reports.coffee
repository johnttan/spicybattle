'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.reports',
    url: '^/:player/reports'
