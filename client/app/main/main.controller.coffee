'use strict'
# To to refactor out the big functions.
angular.module 'spicyPartyApp'
.controller 'MainCtrl', ($scope, $http, Recent, $location, $state, $stateParams) ->
  $scope.search = {}
  $scope.recentSearches = Recent.getRecent()
  $scope.addRecent = Recent.addRecent
  $scope.gameWin = (game)->
    if parseInt(game.elo) > 0
      return 'WIN'
    else
      return 'LOSS'
  $scope.tierConvert = (tier)->
    return parseInt(tier) + 1
  $scope.convertName = (playerName, decode)->
    if decode
      return playerName.split('.').join(' ')
    else
      return playerName.split(' ').join('.')
  $scope.backpackBuild = (game)->
    belt = game.belt.split('_')
    belt[0] = ''
    belt = belt.join(' ')
    build = game.item1 + '/' + game.item2 + '/' + game.item3 + '/' + game.item4 + '/' + game.item5
    return belt + '  ' + build
  loadPlayerData = do(scope=$scope, state = $state, location=$location)->
    return (playerData)->
      scope.error = ''
      scope.profile = playerData.profile
      scope.gameLog = playerData.gameLog
      scope.playerData = playerData
      playerName = $scope.convertName(playerData.profile.playerName)
      scope.recentSearches = $scope.addRecent(playerName, playerData)
      state.go('main.matches', {player: playerName})
      location.path('/' + playerName + '/matches')
  errorSearch = do(scope=$scope)->
    return ->
      scope.error = 'No player found'
  errorUpdate = do(scope=$scope)->
    return ->
      scope.error = 'Enable your plugin and refresh the game!'
  $scope.searchPlayer = (playerName)->
    if playerName
      playerName = $scope.convertName(playerName)
      playerCache = Recent.checkRecent(playerName, $scope.searchPlayer)
      $scope.lastUpdated = new Date()
      if playerCache
        console.log('cache found')
        loadPlayerData(playerCache)
      else
        $http.get("/api/data/" + playerName).success(loadPlayerData).error(errorSearch)

  $scope.refreshPlayer = ->
    if $scope.profile
      $http.put("/api/data/" + $scope.profile.playerName.split(' ').join('.')).success(
        (playerData)->
          $scope.error = ''
          $scope.profile = playerData.profile
          $scope.gameLog = playerData.gameLog
          $scope.playerData = playerData
          playerName = $scope.convertName(playerData.profile.playerName)
          $scope.recentSearches = $scope.addRecent(playerName, playerData)
        ).error(errorUpdate)
  $scope.clearHistory = ->
    $scope.recentSearches = Recent.clearHistory()
  $scope.checkLocation = (location)->
    return '/' +$location.path().split('/')[2] is location
  $scope.convertToSec = (ms)->
    return parseInt(ms / 1000)
  $scope.changeToDate = (dateString)->
    dateO = new Date(dateString)
    UTCdate = new Date(Date.UTC(dateO.getFullYear(), dateO.getMonth(), dateO.getDay(), dateO.getHours(), dateO.getMinutes(), dateO.getSeconds(), dateO.getMilliseconds()))
    return UTCdate
  $scope.avatarURL = (urlname)->
    if urlname is 'flame'
      urlname = 'flameprincess'
    else if urlname is 'princessbubblegum'
      urlname = 'pb'
    url = "http://i.cdn.turner.com/toon/games/adventuretime/adventure-time-battle-party/assets/img/champions-icon-" + urlname + ".jpg"
    return url
  $scope.goTo = (location)->
    if $scope.profile
      playerName = $scope.convertName($scope.profile.playerName)
      $state.go(location, {player: playerName})
      $location.path('/' + playerName + '/' + location.split('.')[1])
    
    if location is 'main.leaderboard'
      if $scope.profile
        playerParam = $scope.convertName($scope.profile.playerName)
      else
        playerParam = 'beta'
      $state.go(location, {player: playerParam})
  if $stateParams.player and $stateParams.player isnt 'beta'
    playerName = $scope.convertName($stateParams.player, true)
    $scope.searchPlayer(playerName)
