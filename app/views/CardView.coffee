class window.CardView extends Backbone.View

  className: 'card'

  tagName: 'img'

  template: _.template 'img/<%= suitName %><%= rankName %>.png'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html
    @$el.attr( 'src', @template @model.attributes)
    @$el.addClass 'covered' unless @model.get 'revealed'
