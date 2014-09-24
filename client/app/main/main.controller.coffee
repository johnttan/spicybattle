'use strict'
# To to refactor out the big functions.
angular.module 'spicyPartyApp'
.controller 'MainCtrl', ($scope, $http, Recent, PlayerData, $location, $state, $stateParams, Statistics) ->
  $scope.search = {}
  $scope.convertName = PlayerData.convertName
  $scope.playerData = PlayerData
  $scope.recentSearches = Recent.getRecent()
  $scope.gameWin = (game, returnColor)->
    if parseInt(game.elo) > 0
      if returnColor
        return 'blue'
      return 'WIN'
    else
      if returnColor
        return 'red'
      return 'LOSS'
  $scope.tierConvert = (tier)->
    return parseInt(tier) + 1
  $scope.backpackBuild = (game)->
    belt = game.belt.split('_')
    belt[0] = ''
    belt = belt.join(' ')
    build = game.item1 + '/' + game.item2 + '/' + game.item3 + '/' + game.item4 + '/' + game.item5
    return belt + '  ' + build

  errorSearch = do(scope=$scope)->
    return (error)->
      console.log error
      if error is 'Bad Request'
        scope.error = 'Enable your plugin and refresh the game!'
      else
        scope.error = 'No player found'

  $scope.$watch(
    ->
      PlayerData.playerData
    ,
    ->
      if PlayerData.playerData.profile
        $scope.error = ''
      $scope.playerData = PlayerData.playerData
      $scope.profile = PlayerData.profile
      $scope.gameLog = PlayerData.gameLog
      $scope.playerName = PlayerData.playerName
      $scope.recentSearches = PlayerData.recentSearches
    )

  $scope.searchPlayer = (playerName)->
    if playerName
      console.log(playerName, 'searching')
      $scope.lastUpdated = new Date()
      $scope.error = 'Loading Player Data'
      playerName = $scope.convertName(playerName)
      path = $location.path().split('/')
      goState = 'main.'
      secondUrl = 'matches'
      if path[2]
        secondUrl = path[2]
        console.log secondUrl
      goState += secondUrl
      $state.go(goState, {player: playerName})
      $location.path('/' + playerName + '/' + secondUrl)
      PlayerData.searchPlayer(playerName, errorSearch)

  $scope.clearHistory = ->
    $scope.recentSearches = Recent.clearHistory()
  $scope.checkLocation = (location)->
    altLoc = $location.path().split('/')[2]
    if not altLoc
      return '/' is location
    else
      return '/' + $location.path().split('/')[2] is location
  $scope.convertToSec = (ms)->
    return parseInt(ms / 1000)
  $scope.changeToDate = (dateString)->
    dateO = new Date(dateString)
    UTCdate = new Date(Date.UTC(dateO.getFullYear(), dateO.getMonth(), dateO.getDate(), dateO.getHours(), dateO.getMinutes(), dateO.getSeconds(), dateO.getMilliseconds()))
    return UTCdate
  $scope.avatarURL = (urlname)->
    if urlname is 'flame'
      urlname = 'flameprincess'
    else if urlname is 'princessbubblegum'
      urlname = 'pb'
    url = "http://i.cdn.turner.com/toon/games/adventuretime/adventure-time-battle-party/assets/img/champions-icon-" + urlname + ".jpg"
    return url
  $scope.goTo = (location)->
    if $scope.profile and $scope.profile.playerName
      playerName = $scope.convertName($scope.profile.playerName)
      $state.go(location, {player: playerName})
    if location is 'main.leaderboard'
      Statistics.getEloLeaderboard()
      Statistics.getGlobalStats()
      if $scope.profile and $scope.profile.playerName
        playerParam = $scope.convertName($scope.profile.playerName)
      else
        playerParam = 'beta'
      $state.go(location)
  if $stateParams.player and $stateParams.player isnt 'beta'
    playerName = $scope.convertName($stateParams.player, true)
    $scope.searchPlayer(playerName)
