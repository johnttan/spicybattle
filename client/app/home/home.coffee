'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.home',
    url: '/'
    templateUrl: 'app/home/home.html'
    controller: 'HomeCtrl'
