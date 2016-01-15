"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset, chartClass) ->

        dataset = [
            ["data1", 30, 15, 13, 123, 345, 231, 123, 123, 123, 123 ,123 ,123 ,123]
        ]

        colorData = dataset[0]
        colorData.splice(0, 1)

        min = Math.min.apply(null, colorData)
        max = Math.max.apply(null, colorData)
        scale = chroma.scale(["lightgreen", "darkgreen"]).out("hex").domain([min, max])

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
