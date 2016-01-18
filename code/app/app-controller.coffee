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
            barChartData = data[0]
            lineChartData = data[1]

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

            barChartData = [
                {
                    name: "kohlenmonoxid"
                    values: [
                        {
                            location: "Tauernautobahn"
                            lat: 47.814979
                            long: 13.034382
                            value: 0.1
                        }
                        {
                            location: "Tamsweg"
                            lat: 47.326501
                            long: 12.794627
                            value: 0.4
                        }
                        {
                            location: "Zell am See"
                            lat: 47.682836
                            long: 13.099793
                            value: 0.9
                        }
                    ]
                }
                {
                    name: "stickstoffmonoxid"
                    values: [
                        {
                            location: "Tauernautobahn"
                            lat: 47.814979
                            long: 13.034382
                            value: 0.1
                        }
                        {
                            location: "Tamsweg"
                            lat: 47.326501
                            long: 12.794627
                            value: 0.4
                        }
                        {
                            location: "Zell am See"
                            lat: 47.682836
                            long: 13.099793
                            value: 0.9
                        }
                    ]
                }
            ]


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

        drawMarker = (dataObj, scale, min, max) ->
            for data, i in dataObj.values

                maxMarkerSize = 20
                minMarkerSize = 1
                normalizedValue = (data.value - min) / (max - min)

                if normalizedValue
                    markerWidth = markerHeight = (maxMarkerSize * normalizedValue)
                else
                    markerWidth = markerHeight = minMarkerSize

                $scope.markers[dataObj.name + "_" + data.location] =
                    lat: data.lat
                    lng: data.long
                    message: dataObj.name
                    icon:
                        type: "div"
                        iconSize: [markerWidth, markerHeight]
                        html: "<div class='dataMarker' style='color:#{scale(data.value)} !important; background-color:#{scale(data.value)} !important; width:#{markerWidth}px; height:#{markerHeight}px; border-radius:#{markerWidth / 2}px'></div>"

        # triggers on every checkbox change
        $scope.toggleParameter = (parameter) ->
            $(".#{parameter.name}").toggle()
            return false
]
