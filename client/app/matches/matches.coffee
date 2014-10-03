'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.matches',
    url: '^/:player/matches'
    sticky: true
    deepStateRedirect: true
