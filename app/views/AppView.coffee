class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button clickable">Hit</button> <button class="stand-button clickable">Stand</button>
    <div class="player-hand-container hand-container"></div>
    <div class="dealer-hand-container hand-container"></div>
  '

  events:
    "click .hit-button": ->
      if $('.hit-button').hasClass('clickable') then @model.get('playerHand').hit()
    "click .stand-button": ->
      if $('.stand-button').hasClass('clickable') then @model.get('playerHand').stand()

  initialize: ->
    @render()
    @model.on 'newGame', =>
      @render()
    @model.on 'change:playerActive', ->
      $('button').toggleClass("clickable")

  render: ->
    @$el.children().detach()
    @$el.html @template()
    for i in [1..12]
      deckCard = $('<img class="deckCard" src="img/b2fv.png">')
      deckCard.css('top', 125 - 2*i)
      @$el.append(deckCard)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el