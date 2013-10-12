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
        dealer = @get('dealerHand')
        dealer.at(0).flip()
        while dealer.bestScore() < 17 and dealer.bestScore() > 0
          dealer.hit()
        console.log(dealer.bestScore())
        if (hand.bestScore() > dealer.bestScore()) or dealer.bestScore() > 21
          @endGame(false)
        else
          @endGame(true)
    )

  endGame: (dealerWins) ->
    @set 'playerActive', false
    setTimeout( =>
      if @get("deck").length < 11
        @set "deck", new Deck()
      @initializeGame()
      @trigger('newGame')
    , 3000)