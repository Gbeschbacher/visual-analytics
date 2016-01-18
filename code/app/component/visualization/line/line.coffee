"use strict"

class window.vidatio.TimeSeriesChart extends window.vidatio.Visualization
    constructor: (data) ->
        @chart = null

        @columns = []
        @chartBackup = []
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
        @columns.push x

        for own key, value of values
            tmp = []
            tmp.push(key.substring(0, key.indexOf(" ")))
            tmp = tmp.concat(value)
            @columns.push tmp


        $ =>
            @chart = c3.generate
                bindto: '#line-chart'
                data:
                    x: 'x'
                    columns: @columns
                axis:
                    x:
                        type: 'timeseries'
                        tick:
                            format: '%Y-%m'
                        label:
                            text: 'Monat'
                            position: 'outer-center'
                    y:
                        label:
                            text: 'Schadstoffwert'
                            position: 'outer-middle'
                size:
                    height: 400

            super(data, @chart)

    toggle: (id) ->
        id = "PM2.5" if id is "Pm2.5"
        id = "PM10" if id is "Pm10"

        found = false

        # Check if the line needs to be added or removed
        # found = true means that it needs to be added
        for line, idx in @chartBackup
            if id in line
                found = true
                break

        if found
            @chart.load
                columns: [
                    line
                ]
            @chartBackup.splice idx, 1
        else
            for line, i in @columns
                if id in line
                    @chartBackup.push line
                    @chart.load
                        unload: [id]
