"use strict"

app = angular.module "app.services"

app.factory "ApiService", [
    "$q"
    "$http"
    ($q, $http) ->
        class API
            baseUrl: "http://localhost:3000/"

            getData: (type) ->
                deferred = $q.defer()

                $http
                    method: "GET"
                    url: @baseUrl + "" + type
                .then (data) ->
                    deferred.resolve data
                , (error) ->
                    deferred.reject error

                return deferred.promise

            getBaseData: (timeframe) ->
                deferred = $q.defer()

                timeframe = timeframe or null
                type = if timeframe is "m" then "/months" else ""

                $http
                    method: "GET"
                    url: @baseUrl + "measurements" + type
                .then (data) ->
                    deferred.resolve data
                , (error) ->
                    deferred.reject error

                return deferred.promise

        new API
]
