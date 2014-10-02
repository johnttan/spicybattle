'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.home',
    url: ''
    views: {
      'home@main':{
        templateUrl: 'app/home/home.html'
        controller: 'HomeCtrl'
      }
    }
    sticky: true
    deepStateRedirect: true
