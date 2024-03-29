class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<p><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> <span class="score"></span></p>'

  initialize: ->
    @collection.on
      'add': (card) => @renderCard(card)
      'updateScore': => @renderScore()
    @renderInit()

  renderInit: ->
    @$el.html @template @collection
    @collection.each( (card) =>
      @renderCard(card)
    )

  renderCard: (card) ->
    @$el.append new CardView(model: card, isDealer: @collection.isDealer, index: @collection.indexOf(card)).render()

  renderScore: ->
    @$('.score').text("(#{@collection.score()})")

