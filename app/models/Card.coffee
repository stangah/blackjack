class window.Card extends Backbone.Model

  initialize: (params) ->
    @set
      revealed: true
      value: if !params.rank or 10 < params.rank then 10 else params.rank
      suitName: ['s', 'd', 'c', 'h'][params.suit]
      rankName: switch params.rank
        when 0 then 'k'
        when 11 then 'j'
        when 12 then 'q'
        else params.rank

  flip: ->
    @set 'revealed', !@get 'revealed'
    @
