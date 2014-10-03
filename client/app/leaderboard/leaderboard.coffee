'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.leaderboard',
    url: 'leaderboard'
    sticky: true
    deepStateRedirect: true
