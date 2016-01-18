# VA - App Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    "ApiService"
    "$q"
    ($scope, ApiService, $q) ->

        ###
            MAIN SCOPE STUFF
        ###

        $scope.markers = {}
        $scope.markersBackup = {}
        # Map center is somewhere in the middle of austria
        $scope.center =
            lat: 47.480959
            lng: 13.248624
            zoom: 8

        # Wait for all API-Calls to finish
        $q.all([
            ApiService.getBaseData()
            ApiService.getBaseData("m")
        ]).then ( (data) ->
            barChartData = data[0].data.json
            lineChartData = data[1].data.json

            # baseData looks as follows
            ###
                [
                    {
                        name: Parameter1
                        values: [
                            {
                                lat: 10,
                                long: 11,
                                value: 0.1
                            }, ...
                        ]
                    }, ...
                ]
            ###

            init barChartData, lineChartData
        ), (error) ->
            console.error error

        ###
            FUNCTIONS BELOW
        ###

        colorScale = (dataArray) ->
            values = []
            for data in dataArray
                values.push data.value

            min = Math.min.apply(null, values)
            max = Math.max.apply(null, values)
            return {
                scale: chroma.scale(["lightgreen", "darkgreen"]).out("hex").domain([min, max])
                min: min
                max: max
            }

        init = (barChartData, lineChartData) ->

            new vidatio.TimeSeriesChart(lineChartData)

            $scope.selection = barChartData
            for parameter, i in $scope.selection
                {scale, min, max} = colorScale parameter.values
                new vidatio.BarChart parameter, scale
                drawMarker parameter, scale, min, max

        drawMarker = (dataObj, scale, min, max) ->
            for data, i in dataObj.values

                maxMarkerSize = 20
                minMarkerSize = 1
                normalizedValue = (data.value - min) / (max - min)

                if normalizedValue
                    markerWidth = markerHeight = (maxMarkerSize * normalizedValue)
                else
                    markerWidth = markerHeight = minMarkerSize

                $scope.markers[dataObj.name + "_" + data.location.replace /\W/g, ""] =
                    lat: data.latitude
                    lng: data.longitude
                    message: dataObj.name
                    icon:
                        type: "div"
                        iconSize: [markerWidth, markerHeight]
                        html: "<div class='dataMarker' style='color:#{scale(data.value)} !important; background-color:#{scale(data.value)} !important; width:#{markerWidth}px; height:#{markerHeight}px; border-radius:#{markerWidth / 2}px'></div>"

        # triggers on every checkbox change
        $scope.toggleParameter = (parameter) ->

            # toggles the visibility of charts
            $(".#{parameter.name.replace ".", ""}").toggle()

            # toggles the visibility of markers
            toggleMarker parameter

            return false

        toggleMarker = (parameter) ->

            ###
                check if key in markersBackup exists
                    if yes remove object in markersBackup and add it in markers
                    else remove from markers and add it in markersBackup
            ###
            if Object.keys($scope.markersBackup).some(((key) ->
                ~key.indexOf(parameter.name)
              ))
                for key, value of $scope.markersBackup
                    if ~key.indexOf(parameter.name)
                        $scope.markers[key] = value
                        delete $scope.markersBackup[key]
            else
                for key, value of $scope.markers
                    if ~key.indexOf(parameter.name)
                        $scope.markersBackup[key] = value
                        delete $scope.markers[key]

            return false
]
