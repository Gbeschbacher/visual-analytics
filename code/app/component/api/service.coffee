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
                    # console.log data
                    deferred.resolve data
                , (error) ->
                    # console.error error
                    deferred.reject error

                return deferred.promise

            getBaseData: ->
                deferred = $q.defer()

                timeframe = "y"

                type = "quarters" if timeframe is "q"
                type = "months" if timeframe is "m"
                type = "weeks" if timeframe is "w"
                type = "year" if timeframe is "y"

                $http
                    method: "GET"
                    url: @baseUrl + "measurements/" + type
                .then (data) ->
                    # console.log data
                    deferred.resolve data
                , (error) ->
                    # console.error error
                    deferred.reject error

                return deferred.promise

        new API
]
