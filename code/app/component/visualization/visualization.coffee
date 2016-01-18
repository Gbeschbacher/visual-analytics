"use strict"

class window.vidatio.Visualization

    constructor: (dataset, chart) ->
        @dataset = dataset
        @chart = chart

    getChart: =>
        console.info "Visualization getChart called"
        console.log @chart
        return @chart
