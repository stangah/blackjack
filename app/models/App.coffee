#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', new Deck()
    @set 'chips', 100
    @set 'mode', 'betting'

  bet: (bet) ->
    @set 'playerHand', @get("deck").dealPlayer()
    @set 'dealerHand', @get("deck").dealDealer()
    @set 'mode', 'playing'
    @set 'currentBet', bet
    @initializeGame()

  initializeGame: () ->
    @set 'mode', 'playing'
    @trigger('newGame')
    @get('playerHand').on(
      bust: () =>
        @set 'mode', 'waiting'
        @endGame(true)
      stand: () =>
        @set 'mode', 'waiting'
        @get('dealerHand').at(0).flip()
        setTimeout( =>
          @dealDealer()
        , 1000)
    )

  dealDealer: ->
    dealer = @get('dealerHand')
    if (dealer.score() < 17)
      dealer.hit()
      setTimeout( =>
        @dealDealer()
      , 1000)
    else
      @evalScores()

  evalScores: ->
    if (@get('playerHand').score() > @get('dealerHand').score()) or @get('dealerHand').score() > 21
      @endGame(false)
    else
      @endGame(true)

  endGame: (dealerWins) ->
    @set('chips', @get('chips') - (dealerWins*2 - 1) * @get('currentBet'))
    setTimeout( =>
      if @get("deck").length < 11
        @set "deck", new Deck()
      if @get('chips') > 0
        @set 'mode', 'betting'
      else
        @set 'mode', 'gameOver'
    , 2500)