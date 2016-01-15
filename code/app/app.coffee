# Vidatio App
# ===========
"use sFict"

app = angular.module "app", [
    "ui.router"
    "app.controllers"
    "app.factories"
    "app.services"
    "app.factories"
    "app.directives"
    "app.filters"
    "leaflet-directive"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    ($rootScope, $state, $stateParams, $http, $location) ->
]

app.config [
    "$urlRouterProvider"
    "$stateProvider"
    "$locationProvider"
    "$httpProvider"
    ($urlRouterProvider, $stateProvider, $locationProvider, $httpProvider) ->
        $locationProvider.html5Mode true

        $stateProvider

        .state "app",
            url: "/"
            templateUrl: "index/index.html"
            controller: "AppCtrl"
]

