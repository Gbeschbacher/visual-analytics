"use strict"

class vidatio.LineChart extends vidatio.Visualization
    constructor: (dataset, scale, categories, chartClass) ->

        $ ->
            $("#line-chart").append("<div class=#{chartClass}></div>")
            chart = c3.generate
                bindto: ".#{chartClass}"
                data:
                    columns: dataset,
                    type: "bar"
                    color: (color, data) ->
                        return scale data.value
                bar: width: ratio: 0.5
                padding: right: 30
                legend: show: false
                axis:
                    x:
                        type: "timeseries"
                        tick:
                            format: '%Y-%m-%d'
                        categories: categories
                    y:
                        show: true
                        inner: false
                        label:
                            text: "Schwefelirgendwas"
                            position: "outer-middle"


            super(dataset, chart)
