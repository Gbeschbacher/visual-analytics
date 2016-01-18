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

            getBaseData: (timeframe) ->
                deferred = $q.defer()

                timeframe = timeframe || null

                if timeframe is "m"
                    # for line diagram
                    url =  "http://localhost:3000/measurements/months"
                else
                    # for bar plots and map viz
                    url =  "http://localhost:3000/measurements"

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
