'use strict'

angular.module 'spicyPartyApp'
.controller 'ReportsCtrl', ($scope, Statistics) ->
  console.log 'reportsctrl'
  Statistics.getEloStats($scope)
  $scope.$watch(
    ->
      return Statistics.eloStats
    ,
    ->
      console.log 'watch fired'
      $scope.data = Statistics.eloStats
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
