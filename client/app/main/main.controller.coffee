'use strict'

angular.module 'spicyPartyApp'
.controller 'MainCtrl', ($scope, $http, socket) ->
  $scope.search = {}
  $scope.recentSearches = {}
  $scope.gameWin = (game)->
    if parseInt(game.elo)
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
        )