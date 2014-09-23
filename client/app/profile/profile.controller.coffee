'use strict'

angular.module 'spicyPartyApp'
.controller 'ProfileCtrl', ($scope, PlayerData) ->
  $scope.message = 'Hello'
  $scope.champStats = PlayerData.stats.champStats
  $scope.packStats = PlayerData.stats.packStats

  $scope.$watch(
    ->
      PlayerData.stats
    ,
    ->
      $scope.champStats = _.map(PlayerData.stats.champStats, (el, key)->
          return {name: key, stats: el}
        )
      $scope.packStats = _.map(PlayerData.stats.packStats, (el, key)->
        return {name: key, stats: el}
      )
      $scope.gamesAnalyzed = PlayerData.stats.gamesAnalyzed
    )
  $scope.$watch(
    ->
      PlayerData.stats.packStats
    ,
    ->
  )

  $scope.sortChamps = (el)->
    return el.stats.wins / (el.stats.wins + el.stats.losses)