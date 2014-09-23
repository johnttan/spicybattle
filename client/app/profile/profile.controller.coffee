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
          el.totalGames = el.wins + el.losses
          return {name: key, stats: el}
      )
      $scope.packStats = _.map(PlayerData.stats.packStats, (el, key)->
          el.totalGames = el.wins + el.losses
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
  $scope.avatarURL = (urlname)->
    if urlname is 'flame'
      urlname = 'flameprincess'
    else if urlname is 'princessbubblegum'
      urlname = 'pb'
    url = "http://i.cdn.turner.com/toon/games/adventuretime/adventure-time-battle-party/assets/img/champions-icon-" + urlname + ".jpg"
    return url
  $scope.sortChamps = (el)->
    if el.stats.wins is 0
      return  -el.stats.losses
    else
      return el.stats.wins / (el.stats.wins + el.stats.losses)

  $scope.formatPack = (pack)->
    splitUp = pack.split('_')
    if splitUp[2]
      return splitUp[1] + ' ' + splitUp[2] 
    else
      return splitUp[1]