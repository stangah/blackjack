class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> <span class="score"></span></h2>'

  initialize: ->
    @collection.on
      'add': (card) => @renderCard(card)
      'finishedAdding': =>
        @renderScore()
    @renderInit()

  renderInit: ->
    @$el.html @template @collection
    @collection.each( (card) =>
      @renderCard(card)
    )

  renderCard: (card) ->
    @$el.append new CardView(model: card, isDealer: @collection.isDealer, index: @collection.indexOf(card)).render()

  renderScore: ->
    @$('.score').text("(#{@collection.bestScore()})")

