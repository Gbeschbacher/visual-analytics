"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataObj, scale) ->

        # C3JS needs a 2d-Array with a string at the beginning
        barData = [["#{dataObj.name}"]]
        # C3JS needs bar-labels as 1D array of strings
        locations = []

        for data in dataObj.values
            barData[0].push data.value
            locations.push data.location

        $ ->
            $("#bar-charts").append("<div class=#{dataObj.name.replace ".", ""}></div>")
            chart = c3.generate
                bindto: ".#{dataObj.name.replace ".", ""}"
                data:
                    columns: barData,
                    type: "bar"
                    color: (color, data) ->
                        return scale data.value
                bar: width: ratio: 0.5
                padding:
                    bottom: 75
                legend: show: false
                axis:
                    x:
                        type: "category"
                        categories: locations
                    y:
                        show: true
                        inner: false
                        label:
                            text: dataObj.name[0].toUpperCase() + dataObj.name.slice(1)
                            position: "outer-middle"

            super(dataObj, chart)
