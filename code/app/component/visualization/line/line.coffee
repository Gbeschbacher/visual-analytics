"use strict"

class window.vidatio.TimeSeriesChart extends window.vidatio.Visualization
    constructor: (data) ->

        @chart = null

        columns = []
        months = {}
        values = {}

        data.forEach (index, element, array) ->
            if !months.hasOwnProperty index.month
                months[index.month] = 0
            if !values.hasOwnProperty index.parameter
                values[index.parameter] = []

            values[index.parameter].push index.value

        x = ['x']
        for own key, value of months
            x.push(key)
        columns.push x

        for own key, value of values
            tmp = []
            tmp.push(key.substring(0, key.indexOf(" ")))
            tmp = tmp.concat(value)
            columns.push tmp

        $ =>
            @chart = c3.generate
                bindto: '#line-chart'
                data:
                    x: 'x'
                    columns: columns
                axis: x:
                    type: 'timeseries'
                    tick: format: '%Y-%m'

            super(data, @chart)

    getChart: ->
        return @chart
