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
                $http(
                    method: "GET"
                    url: @baseUrl + "" + type
                ).then ((data) ->
                    console.log data
                    deferred.resolve data
                ), (error) ->
                    console.log error
                    deferred.reject error

                return deferred.promise

            getBaseData: ->
                deferred = $q.defer()
                $http(
                    method: "POST"
                    url: @baseUrl + "" + type
                    data:
                        "parameter": ["param1", "param2", "param3"]
                        "timeframe": "whut"
                ).then ((data) ->
                    console.log data
                    deferred.resolve data
                ), (error) ->
                    console.log error
                    deferred.reject error

                return deferred.promise

        new API

]
