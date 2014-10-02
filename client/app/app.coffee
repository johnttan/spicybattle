'use strict'

angular.module 'spicyPartyApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.router',
  'ui.bootstrap',
  'LocalStorageModule',
  'angularMoment',
  'nvd3',
  "ct.ui.router.extras"
]
.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider, $stickyStateProvider) ->
  $urlRouterProvider
  .otherwise '/'
  $locationProvider.html5Mode true

.run ($rootScope, $location) ->
