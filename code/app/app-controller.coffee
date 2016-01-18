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
        ]).then ( (data) ->
            baseData = data[2]

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

            baseData = [
                {
                    name: "Kohlenmonoxid"
                    values: [
                        {
                            location: "Tauernautobahn"
                            lat: 10
                            long: 11
                            value: 0.1
                        }
                        {
                            location: "Tamsweg"
                            lat: 1
                            long: 2
                            value: 0.4
                        }
                        {
                            location: "Zell am See"
                            lat: 3
                            long: 5
                            value: 0.9
                        }
                    ]
                }
                {
                    name: "Stickstoffmonoxid"
                    values: [
                        {
                            location: "Tauernautobahn"
                            lat: 20
                            long: 21
                            value: 0.1
                        }
                        {
                            location: "Tamsweg"
                            lat: 11
                            long: 12
                            value: 0.4
                        }
                        {
                            location: "Zell am See"
                            lat: 13
                            long: 15
                            value: 0.9
                        }
                    ]
                }
            ]

            # TmpData for Barchart
            # plotData = [
            #     ["data1", 30, 15, 13, 123, 345, 231, 123, 123, 123, 123, 123, 123, 123]
            # ]

            init baseData
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

        init = (data) ->

            $scope.selection = data

            for parameter, i in $scope.selection

                {scale, min, max} = colorScale parameter.values

                drawBarChart parameter, scale
                # drawMarker parameter, scale, min, max

        drawBarChart = (data, scale) ->
            new vidatio.BarChart data, scale

        drawMarker = (dataObj, scale, min, max) ->

            for data in dataObj.values
                # TODO: dynamically set markerWidth and Height based on min/max values of function
                markerWidth = markerHeight = 20

                $scope.markers[propertyCount++] =
                    lat: data.lat
                    lng: data.long
                    message: dataObj.name
                    icon:
                        type: "div"
                        iconSize: [markerWidth, markerHeight]
                        html: "<div class='dataMarker' style='color:#{scale(data.value)} !important; background-color:#{scale(data.value)} !important; width:#{markerWidth}px; height:#{markerHeight}px; border-radius:#{markerWidth / 2}px'></div>"

        # triggers on every checkbox change
        $scope.redraw = (parameter) ->
            console.log parameter

            # $("#chart").empty()

            # # select all categories which are checked
            # categories = $scope.selection.filter (category) ->
            #     return category.checked

            # # select all names of categories and push it in chartCategories
            # chartCategories = []
            # for category in categories
            #     chartCategories.push category.name if category.checked

            # # rebuild charts with corresponding data and chartcategories
            # # TODO: filter dataset again according to selected categories
            # for parameter, i in $scope.selection
            #     new vidatio.BarChart dataset, scale, chartCategories, "test#{i}" if parameter.checked

]
