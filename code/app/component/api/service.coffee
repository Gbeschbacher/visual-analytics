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
                    console.log data
                    deferred.resolve data
                , (error) ->
                    console.error error
                    deferred.reject error

                return deferred.promise

            getBaseData: ->
                deferred = $q.defer()

                timeframe = "q"

                if timeframe is "q"
                    url =  "http://localhost:3000/measurements/quarters"
                else if timeframe is "m"
                    url =  "http://localhost:3000/measurements/months"
                else if timeframe is "w"
                    url =  "http://localhost:3000/measurements/weeks"

                $http
                    method: "GET"
                    url: url
                .then (data) ->
                    console.log data
                    deferred.resolve data
                , (error) ->
                    console.error error
                    deferred.reject error

                return deferred.promise

        new API
]
