"use strict"

class window.vidatio.Visualization

    constructor: (dataset, chart) ->
        @dataset = dataset
        @chart = chart
        console.log @chart

    getChart: ->
        console.info "Visualization getChart called"
        console.log @chart
        return @chart
