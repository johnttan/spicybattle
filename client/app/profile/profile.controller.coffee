'use strict'

angular.module 'spicyPartyApp'
.controller 'ProfileCtrl', ($scope, PlayerData) ->
  $scope.message = 'Hello'
  $scope.champStats = PlayerData.stats.champStats
  $scope.packStats = PlayerData.stats.packStats
  $scope.sortChampKey = 'winRate'
  $scope.reverse = true
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
      _.each($scope.champStats, (el)->
          el.stats.belts = _.map(el.stats.belts, (el1, key)->
              return {name: key, games: el1}
            )
        )
      $scope.gamesAnalyzed = PlayerData.stats.gamesAnalyzed
    )
  $scope.$watch(
    ->
      PlayerData.tier
    ,
    ->
      $scope.tier = PlayerData.tier
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
    if pack
      splitUp = pack.split('_')
      if splitUp[2]
        return splitUp[1] + ' ' + splitUp[2] 
      else
        return splitUp[1]