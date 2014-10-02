'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.matches',
    url: '^/:player/matches'
    views: {
      'matches@main':{
        templateUrl: 'app/matches/matches.html'
        controller: 'MatchesCtrl'
      }
    }
    sticky: true
    deepStateRedirect: true
