"use strict"

class window.vidatio.Visualization

    constructor: (@dataset, @chart) ->

    getChart: ->
        console.info "Visualization getChart called"
        return @chart
