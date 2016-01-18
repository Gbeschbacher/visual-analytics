"use strict"

class vidatio.TimeSeriesChart extends vidatio.Visualization
    constructor: (dataObj, scale) ->

        # C3JS needs a 2d-Array with a string at the beginning
        barData = [["data1"]]
        locations = []

        for data in dataObj.values
            barData[0].push data.value
            locations.push data.location

        $ ->
            chart = c3.generate(
                bindto: '#line-chart'
                data:
                    x: 'x'
                    columns: [
                        [ 'x', '2013-01-01', '2013-01-02', '2013-01-03', '2013-01-04', '2013-01-05', '2013-01-06' ]
                        [ 'data1', 200, 30, 100, 400, 150, 250 ]
                        [ 'data2', 130, 340, 200, 500, 250, 350 ]
                    ]
                axis: x:
                    type: 'timeseries'
                    tick: format: '%Y-%m-%d')

            super(dataObj, chart)
