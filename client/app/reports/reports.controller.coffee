'use strict'

angular.module 'spicyPartyApp'
.controller 'ReportsCtrl', ($scope, Statistics) ->
  console.log 'reportsctrl'
  $scope.eloStatsData = Statistics.eloStats
  Statistics.getEloStats($scope)
  $scope.$watch(
    ->
      return Statistics.eloStats[0]
    ,
    ->
      if not $scope.eloStatsData[0]
        console.log 'watch fired'
        $scope.eloStatsData = Statistics.eloStats
    )
  $scope.options = {
    chart: {
      transitionDuration: 0
      type: 'scatterChart'
      height: 450
      scatter: {
        onlyCircles: false
      }
      showDistX: true
      showDistY: true
      xAxis: {
        axisLabel: 'Elo difference'
      }
      yAxis: {
        axisLabel: 'Elo gain'
        axisLabelDistance: 30
      }
    }

  }
