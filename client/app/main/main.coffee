'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/:player',
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
