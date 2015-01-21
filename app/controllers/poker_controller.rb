class PokerController < ApplicationController
  def index
    
    @cards = params[:cards]
    
    if not @cards.nil?
      @hand = PokerHand.new(@cards)
    end
    
  end
end
