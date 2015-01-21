class PokerController < ApplicationController
  def index
    
    PokerHand.allow_duplicates = false
    
    @cards = params[:cards]
    
    if not @cards.nil?
      @hand = PokerHand.new(@cards)
    end
    
  end
end
