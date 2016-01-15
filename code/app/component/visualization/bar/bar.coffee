"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset, scale, chartClass) ->

        $ ->
            $("#chart").append("<div class=#{chartClass}></div>")
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
                        type: "category"
                        categories: ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8", "cat9", "cat10", "cat11", "cat12", "cat13" ]
                    y:
                        show: true
                        inner: false
                        label:
                            text: "Schwefelirgendwas"
                            position: "outer-middle"


            super(dataset, chart)
