'use strict'

angular.module 'spicyPartyApp'
.controller 'ReportsCtrl', ($scope, Statistics) ->
  Statistics.getEloStats()
  $scope.$watch(
    ->
      return Statistics.eloStats
    ,
    ->
      $scope.data = Statistics.eloStats
    )

  $scope.options = {
    chart: {
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
