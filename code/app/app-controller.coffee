# Animals - App Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    "$rootScope"
    ($scope, $rootScope) ->

        data = []

        new vidatio.BarChart data, "test1"
        new vidatio.BarChart data, "test2"
        new vidatio.BarChart data, "test3"

]
