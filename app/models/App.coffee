#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', new Deck()
    @initializeGame()

  initializeGame: () ->
    @set 'playerHand', @get("deck").dealPlayer()
    @set 'dealerHand', @get("deck").dealDealer()
    @set 'playerActive', true
    @get('playerHand').on(
      bust: (hand) =>
        @endGame(true)
      stand: (hand) =>
        @get('dealerHand').at(0).flip()
        setTimeout( =>
          @dealDealer()
        , 1000)
    )

  dealDealer: ->
    dealer = @get('dealerHand')
    if (dealer.bestScore() < 17)
      dealer.hit()
      setTimeout( =>
        @dealDealer()
      , 1000)
    else
      @evalScores()

  evalScores: ->
    if (@get('playerHand').bestScore() > @get('dealerHand').bestScore()) or @get('dealerHand').bestScore() > 21
      @endGame(false)
    else
      @endGame(true)

  endGame: (dealerWins) ->
    @set 'playerActive', false
    setTimeout( =>
      if @get("deck").length < 11
        @set "deck", new Deck()
      @initializeGame()
      @trigger('newGame')
    , 3000)