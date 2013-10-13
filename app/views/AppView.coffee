class window.AppView extends Backbone.View

  template: _.template '
    <button class="action-button hit-button" style="display: none">Hit</button> <button class="action-button stand-button" style="display: none">Stand</button>
    <button class="bet-button" data="10">Bet 10</button> <button class="bet-button" data="20">Bet 20</button> <button class="bet-button" data="50">Bet 50</button>
    <div class="player-hand-container hand-container"></div>
    <div class="dealer-hand-container hand-container"></div>
  '

  events:
    "click .hit-button": ->
      if @model.get('mode') == 'playing' then @model.get('playerHand').hit()
    "click .stand-button": ->
      if @model.get('mode') == 'playing' then @model.get('playerHand').stand()
    "click .bet-button": (event) ->
      button = $(event.currentTarget)
      @model.bet button.attr('data')

  initialize: ->
    @render(false)
    @model.on 'change:mode', (model, value) =>
      if value == "playing"
        @render(true)
        $('.action-button').show()
        $('.bet-button').hide()
      else if value == "betting"
        @render(false)
        $('.bet-button').hide()
        chips = @model.get 'chips'
        $('.bet-button').filter( -> return parseInt($(@).attr("data"),10) <= chips).show()
      else if value == "gameOver"
        @render(false)
      else
        setTimeout( ->
          $('.action-button').hide()
        , 1000)

  render: (renderHand = true) ->
    chips = @model.get 'chips'
    if chips <= 50
      clippy = $('.clippy')
      clippy.animate({'bottom': 20}, 3000)
    @$el.children().detach()
    @$el.html @template()
    for i in [1..12]
      deckCard = $('<img class="deckCard" src="img/b2fv.png">')
      deckCard.css('top', 125 - 2*i)
      @$el.append(deckCard)
    if chips > 0
      for j in [1..Math.floor(@model.get('chips')/5)]
        chip = $('<img class="chip" src="img/chip' + Math.floor(Math.random() * 3) + '.png">')
        chip.css('top', 500-5*Math.floor((j+1)/3) - (j % 3 == 1)*20)
        chip.css('margin-left', 30*(j%3) + (Math.random()*2-1))
        @$el.append(chip)
    if renderHand
      @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
      @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    else
      @$('.player-hand-container').html('')
      @$('.dealer-hand-container').html('')