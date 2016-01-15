# Animals - App Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    ($scope) ->

        dataset = [
            ["data1", 30, 15, 13, 123, 345, 231, 123, 123, 123, 123 ,123 ,123 ,123]
        ]
        realData = dataset[0]
        realData.splice(0, 1)

        min = Math.min.apply(null, realData)
        max = Math.max.apply(null, realData)
        scale = chroma.scale(["lightgreen", "darkgreen"]).out("hex").domain([min, max])

        new vidatio.BarChart dataset, scale, "test1"
        new vidatio.BarChart dataset, scale, "test2"
        new vidatio.BarChart dataset, scale, "test3"

        $scope.markers = {}
        propertyCount = 0
        for value in realData

            # TODO: dynamically set markerWidth and Height based on values
            markerWidth = markerHeight = 20


            $scope.markers[propertyCount++] =
                lat: 38.716
                lng: -9.13
                message: "Marker Message"
                icon:
                    type: "div"
                    iconSize: [markerWidth, markerHeight]
                    html: "<div class='dataMarker' style='color:#{scale(value)} !important; background-color:#{scale(value)} !important; width:#{markerWidth}px; height:#{markerHeight}px; border-radius:#{markerWidth / 2}px'></div>"

        # TODO: set in center of dataset (bounding box etc.)
        $scope.lisbon =
            lat: 38.716
            lng: -9.13
            zoom: 8
]
