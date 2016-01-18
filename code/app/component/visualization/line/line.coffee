"use strict"

class vidatio.TimeSeriesChart extends vidatio.Visualization
    constructor: (data) ->

        console.log("TIMESERIES");
        console.log(data);

        columns = []

        months = ["2014-01-01",

        data.json.forEach (index, element, array) ->


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
                    tick: format: '%Y-%m')

            super(data, chart)
