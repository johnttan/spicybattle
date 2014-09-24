'use strict'

angular.module 'spicyPartyApp'
.controller 'LeaderboardCtrl', ($scope, $rootScope, Statistics) ->
  Statistics.getEloLeaderboard()
  Statistics.getGlobalStats()
  $scope.leaders = Statistics.leaders
  $scope.globalStats = Statistics.globalStats
  $scope.sortChampKey = 'winRate'
  $scope.reverse = true
  $scope.statsView = 'champions'
  $scope.$watch(
    ->
      return Statistics.leaders
    ,
    ->
      $scope.leaders = Statistics.leaders
    )
  $scope.$watch(
    ->
      return Statistics.globalStats
    ,
    ->
      $scope.globalStats = Statistics.globalStats
    )
  $rootScope.$on('$stateChangeSuccess', (event, toState, fromState)->
    if toState.name == 'main.leaderboard'
      Statistics.getEloLeaderboard()
      Statistics.getGlobalStats()
    )
  $scope.avatarURL = (urlname)->
    if urlname is 'flame'
      urlname = 'flameprincess'
    else if urlname is 'princessbubblegum'
      urlname = 'pb'
    url = "http://i.cdn.turner.com/toon/games/adventuretime/adventure-time-battle-party/assets/img/champions-icon-" + urlname + ".jpg"
    return url
  $scope.changeSortKey = (key)->
    if key is $scope.sortChampKey
      console.log key
      $scope.reverse = !$scope.reverse
      console.log $scope.reverse
    else
      $scope.sortChampKey = key
  $scope.sortChamps = (el)->
    if $scope.sortChampKey is 'winRate'
      if el.stats.wins is 0
        return  -el.stats.losses
      else
        return el.stats.averages.wins
    else if $scope.sortChampKey is 'wins' or $scope.sortChampKey is 'losses'
      return el.stats[$scope.sortChampKey]
    else
      return el.stats.averages[$scope.sortChampKey]

  $scope.formatPack = (pack)->
    splitUp = pack.split('_')
    if splitUp[2]
      return splitUp[1] + ' ' + splitUp[2] 
    else
      return splitUp[1]
