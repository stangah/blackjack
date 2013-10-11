#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
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
    console.log("Dealer wins? #{dealerWins}")
    setTimeout( =>
      @initialize()
      @trigger('newGame')
    , 3000)