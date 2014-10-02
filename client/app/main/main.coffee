'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/',
    templateUrl: 'app/main/main.html',
    controller: 'MainCtrl'
