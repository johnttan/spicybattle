'use strict'

angular.module 'spicyPartyApp'
.controller 'LeaderboardCtrl', ($scope, $rootScope, $http) ->
  $rootScope.$on('$stateChangeSuccess', (event, toState, fromState)->
    if toState.name == 'main.leaderboard'
      $http.get('/api/statistics/eloleaderboard')
        .success((leaderboard)->
          $scope.leaders = leaderboard.data
        )
        .error((error)->
          console.log(error)
        )
    )