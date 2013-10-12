class window.CardView extends Backbone.View

  className: 'card'

  tagName: 'img'

  template: _.template 'img/<%= suitName %><%= rankName %>.png'

  initialize: (params) ->
    @model.on 'change:revealed', => @flip()
    @$el.css("left", 470 - 81*params.index)
    @$el.css("top", -250) unless params.isDealer

    # For any card added beyond the second, we don't need a delay (see callback of animate below).
    index = params.index
    if index > 1 then index = 0

    setTimeout( =>
      @$el.animate({"left": 0, "top":0}, =>
        @model.trigger('finishedAdding'))
    , index*200 + 400*(not not params.isDealer))

  render: ->
    if @model.get 'revealed' then @$el.attr( 'src', @template @model.attributes) else @$el.attr( 'src', 'img/b2fv.png')

  flip: ->
    width = parseInt(@$el.css("width"),10)
    height = @$el.css("height")
    marginright = parseInt(@$el.css("margin-right"),10)
    @$el.animate({ width: 0, height: height, "margin-left": width/2, "margin-right": marginright + width/2}, =>
      @render()
      @$el.animate({width: width, "margin-left": 0, "margin-right": marginright})
    )
