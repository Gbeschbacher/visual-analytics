# Animals - App Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    ($scope) ->

        dataset = [
            ["data1", 30, 15, 13, 123, 345, 231, 123]
        ]
        # this isnt clonedData = dataset[0] because clonedData would be a shallow copy and i need a deep copy
        # clonedData is only used for getting
        clonedData = dataset[0].slice()
        clonedData.splice(0, 1)

        min = Math.min.apply(null, clonedData)
        max = Math.max.apply(null, clonedData)
        scale = chroma.scale(["lightgreen", "darkgreen"]).out("hex").domain([min, max])

        # CATEGORIS = LOCATIONS (z.B. Stickstoff)
        categories  = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7"]

        # PREPARING 2-WAY DATA BINDING FOR CHECKING THE LOCATIONS I WANT TO SEE AS CHARTS ETC.
        $scope.selection = []
        for value, i in categories
            $scope.selection.push
                id: i
                name: value
                checked: true

        for parameter, i in $scope.selection
            new vidatio.BarChart dataset, scale, categories, "test#{i}" if parameter.checked

        $scope.markers = {}
        propertyCount = 0
        for value in clonedData

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

        # triggers on every checkbox change
        $scope.redraw = ->
            $("#chart").empty()

            # select all categories which are checked
            categories = $scope.selection.filter (category) ->
                return category.checked

            # select all names of categories and push it in chartCategories
            chartCategories = []
            for category in categories
                chartCategories.push category.name if category.checked

            # rebuild charts with corresponding data and chartcategories
            # TODO: filter dataset again according to selected categories
            for parameter, i in $scope.selection
                new vidatio.BarChart dataset, scale, chartCategories, "test#{i}" if parameter.checked

]
