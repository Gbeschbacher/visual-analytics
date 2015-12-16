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
        # abstract state for language as parameter in URL
        .state "app",
            abstract: true
            url: "/VA"
            controller: "AppCtrl"
            template: "<ui-view/>"

        # /
        .state "app.index",
            url: "/"
            templateUrl: "index/index.html"


]

