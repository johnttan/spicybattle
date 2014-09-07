'use strict'

angular.module 'spicyPartyApp'
.controller 'MainCtrl', ($scope, $http, socket, $location, $state, $stateParams) ->
  $scope.search = {}
  $scope.recentSearches = {}
  $scope.gameWin = (game)->
    if parseInt(game.elo) > 0
      return 'WIN'
    else
      return 'LOSS'
  $scope.tierConvert = (tier)->
    return parseInt(tier) + 1
  $scope.backpackBuild = (game)->
    belt = game.belt.split('_')
    belt[0] = ''
    belt = belt.join(' ')
    build = game.item1 + '/' + game.item2 + '/' + game.item3 + '/' + game.item4 + '/' + game.item5
    return belt + '  ' + build
  $scope.searchPlayer = (playerName)->
    playerName = playerName.split(' ').join('.')
    $http.get("/api/data/" + playerName).success(
      (playerData)->
        $scope.profile = playerData.profile
        $scope.gameLog = playerData.profile.gameLog
        $scope.playerData = playerData
        $scope.recentSearches[playerData.profile.playerName] = {
          time: new Date()
        }
        $state.go('main.matches', {player: playerName})
        $scope.$digest()
      )

  $scope.refreshPlayer = ->
    if $scope.profile
      $http.put("/api/data/" + $scope.profile.playerName.split(' ').join('.')).success(
        (playerData)->
          $scope.profile = playerData.profile
          $scope.gameLog = playerData.profile.gameLog
          $scope.playerData = playerData
          $scope.recentSearches[playerData.profile.playerName] = {
            time: new Date()
          }
          $scope.lastUpdated = new Date()
        )
  $scope.clearHistory = ->
    $scope.recentSearches = {}
  $scope.checkLocation = (location)->
    return '/' +$location.path().split('/')[2] == location
  $scope.computeLast = (last)->
    if typeof last is 'string'
      last = new Date(last)
      last = last.getTime()
      # last = new Date(last.getTime() - (1000 * 60 * 60 * 5))
    since = Date.now()
    since = since - last
    totalMinutes = parseInt(since/1000/60)
    hours = parseInt(Math.floor(totalMinutes/60)).toString()
    minutes = (totalMinutes % 60).toString()
    if parseInt(hours) > 0
      returnString = hours + ' hours ' + minutes + ' minutes ago'
    else
      returnString = minutes + ' minutes ago'
    return  returnString
  $scope.convertToSec = (ms)->
    return parseInt(ms / 1000)
  $scope.avatarURL = (urlname)->
    if urlname is 'flame'
      urlname = 'flameprincess'
    else if urlname is 'princessbubblegum'
      urlname = 'pb'
    url = "http://i.cdn.turner.com/toon/games/adventuretime/adventure-time-battle-party/assets/img/champions-icon-" + urlname + ".jpg"
    return url
  $scope.goTo = (location)->
    $state.go(location)
  if $stateParams.player
    playerName = $stateParams.player.split('.').join(' ')
    console.log(playerName)
    $scope.searchPlayer(playerName)
  # $scope.searchPlayer('spicy wyatt zebra') 