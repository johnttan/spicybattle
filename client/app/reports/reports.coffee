'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.reports',
    url: 'reports'
    views: {
      'reports@main':{
        templateUrl: 'app/reports/reports.html'
        controller: 'ReportsCtrl'
      }
    }
    sticky: true
    deepStateRedirect: true
