'use strict'

angular.module 'spicyPartyApp'
.controller 'MainCtrl', ($scope, $http, socket, $location, $state) ->
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
    $http.get("/api/data/" + playerName.split(' ').join('.')).success(
      (playerData)->
        $scope.profile = playerData.profile
        $scope.gameLog = playerData.profile.gameLog
        $scope.playerData = playerData
        $scope.recentSearches[playerData.profile.playerName] = {
          time: new Date()
        }
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
    return $location.path() == location
  $scope.computeLast = (last)->
    if typeof last is 'string'
      last = new Date(last)
      last = last.getTime()
      # last = new Date(last.getTime() - (1000 * 60 * 60 * 5))
    since = Date.now()
    console.log(last, since)
    since = since - last
    totalMinutes = parseInt(since/1000/60)
    hours = parseInt(Math.floor(totalMinutes/60)).toString()
    minutes = (totalMinutes % 60).toString()
    if parseInt(hours) > 0
      returnString = hours + ' hours ' + minutes + ' minutes ago'
    else
      returnString = minutes + ' minutes ago'
    return  returnString
  $scope.goTo = (location)->
    $state.go(location)
  $scope.searchPlayer('spicy wyatt zebra')