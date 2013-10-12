class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button action">Hit</button> <button class="stand-button action">Stand</button>
    <button class="bet-10 bet clickable">Bet 10</button> <button class="bet-20 bet clickable">Bet 20</button> <button class="bet-50 bet clickable">Bet 50</button>
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
      $('action').toggleClass("clickable")

  render: ->
    console.log(@model.get "chips")
    if @model.get("chips") < 50
      clippy = $('.clippy')
      clippy.animate({'bottom': 20}, 3000)
    @$el.children().detach()
    @$el.html @template()
    for i in [1..12]
      deckCard = $('<img class="deckCard" src="img/b2fv.png">')
      deckCard.css('top', 125 - 2*i)
      @$el.append(deckCard)
    for j in [1..Math.floor(@model.get('chips')/5)]
      chip = $('<img class="chip" src="img/chip' + Math.floor(Math.random() * 3) + '.png">')
      chip.css('top', 500-5*Math.floor((j+1)/3) - (not not (j % 3 == 1))*20)
      chip.css('margin-left', 30*(j%3) + (Math.random()*2-1))
      @$el.append(chip)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el