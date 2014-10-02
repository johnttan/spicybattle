'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.leaderboard',
    url: 'leaderboard'
    views: {
      'leaderboard@main':{
        templateUrl: 'app/leaderboard/leaderboard.html'
        controller: 'LeaderboardCtrl'
      }
    }
    sticky: true
    deepStateRedirect: true
