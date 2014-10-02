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
  convert = {
    'a':'0'
    'b':'1'
    'c':'2'
    'd':'3'
    'e':'4'
  }
  convertFour = {
    'a':'Bronze'
    'b':'Silver'
    'c':'Gold'
    'd':'Teal'
    'e':'Purple'
  }
  $scope.tierConvert = (tier)->
    if tier
      if tier[0] is '4'
        return convertFour[tier[1]]
      else
        return tier[0] + '/' + convert[tier[1]]
    else
      return
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
        scope.error = 'No player found. Remember to search for full name and be registered with extension. Check FAQ.'

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
  $scope.$watch(
    ->
      PlayerData.tier
    ,
    ->
      $scope.tier = PlayerData.tier
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
      PlayerData.searchPlayer(playerName, errorSearch)

  $scope.clearHistory = ->
    $scope.recentSearches = Recent.clearHistory()
  $scope.checkLocation = (location)->
    if location is 'main.home'
      bool = $state.is(location) or $state.is('main')
      return bool
    return $state.is(location)
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
    if location is 'main.home' or location is 'main.reports'
      $state.go(location)
    if $scope.profile and $scope.profile.playerName
      playerName = $scope.convertName($scope.profile.playerName)
      $state.go(location, {player: playerName})
    if location is 'main.leaderboard'
      Statistics.getEloLeaderboard()
      Statistics.getGlobalStats()
      $state.go('main.leaderboard')
  console.log $stateParams
  initialurl = $location.path().split('/')[1].toLowerCase()
  if initialurl
    if initialurl isnt 'leaderboard' and initialurl isnt 'reports'
      console.log $location.path().split('/')[1]
      playerName = $scope.convertName($location.path().split('/')[1], true)
      $scope.searchPlayer(playerName)
    else
      $scope.goTo('main.' + initialurl)
