#Copyright 2016 Hermann Krumrey
#
#This file is part of ruby-blackjack.
#
#    ruby-blackjack is a program that lets a user play Blackjack using
#    a command line interface.
#
#    ruby-blackjack is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    ruby-blackjack is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with ruby-blackjack. If not, see <http://www.gnu.org/licenses/>.
#

require_relative('objects/card.rb')

# Class that simulates a Blackjack game
# noinspection RubyTooManyInstanceVariablesInspection
class Game

  # Initializes the instance variables used to keep track of the game
  def initialize
    @player_score = 0
    @dealer_score = 0
    @player_ace_count = 0
    @dealer_ace_count = 0

    @deck = generate_deck
    @used_cards = []
    @player_cards = []
    @dealer_cards = []
  end

  # Generates a new deck of cards
  # @return the generated deck
  def generate_deck
    deck = []
    suits = %w(spades hearts diamonds clubs)
    (2...15).each { |i|
      suits.each { |suit|
        deck.push(Card.new(suit, i))
      }
    }
    deck.shuffle
  end

  # Simulates the player's turn
  # @return [boolean or Array[Card]] the evaluation of the turn. Check the evaluate() method for more information
  def player_hit
    @player_cards.push(draw_card) # Draw new card
    # Get new score
    @player_score, @player_ace_count = evaluate_drawn_card(@player_score, @player_ace_count, @player_cards.last)
    @player_score, @player_ace_count = normalize_score(@player_score, @player_ace_count)
    evaluate
  end

  # Simulates the dealer's turn
  # @return [boolean or Array[Card]] the evaluation of the turn. Check the evaluate() method for more information
  def dealer_hit
    @dealer_cards.push(draw_card) # Draw new card
    # Get new score
    @dealer_score, @dealer_ace_count = evaluate_drawn_card(@dealer_score, @dealer_ace_count, @dealer_cards.last)
    @dealer_score, @dealer_ace_count = normalize_score(@dealer_score, @dealer_ace_count)
    evaluate
  end

  # Evaluates the current state of the game according to the standard blackjack rules
  # @return [boolean or Array[Card]] false, if the player is busted
  #                                  true, if the dealer is busted
  #                                  the lists of cards if both players are still in the run
  def evaluate
    if @player_score > 21
      cleanup
      false
    elsif @dealer_score > 21
      cleanup
      true
    else
      return @player_cards, @dealer_cards
    end
  end

  # If the player decides to no longer receive cards, this method should be called
  # @return [boolean or Array[Card]] the evaluation of the turn. Check the evaluate() method for more information
  def player_stand
    while @dealer_score < 17
      dealer_hit
    end
    evaluate
  end

  # Resets the game to make room for a new one
  def cleanup
    @used_cards += @player_cards + @dealer_cards
    @player_cards = []
    @dealer_cards = []
    @player_score = 0
    @dealer_score = 0
    @player_ace_count = 0
    @dealer_ace_count = 0
  end

  # Normalizes the score to be the largest possible value under 22.
  # It essentially devalues the aces until the score is below 22 or there are no cards left
  # @param [int] current_score the current non-normalized score
  # @param [int] ace_count the current amount of fully valued aces
  # @return [int, int] the new values for the input parameters
  def normalize_score(current_score, ace_count)
    while current_score > 21 and ace_count > 0
      ace_count -= 1
      current_score -= 10
    end
    return current_score, ace_count
  end

  # Evaluates the value of a newly drawn card. It is also checked if the card is an ace or not
  # @param [Object] current_score the current score of the player drawing the card
  # @param [Object] ace_count the current amount of aces the player has
  # @param [Card] drawn_card the drawn card
  # @return [int, int] the new current score and amount of aces
  def evaluate_drawn_card(current_score, ace_count, drawn_card)
    current_score += drawn_card.get_value
    if drawn_card.is_ace
      ace_count += 1
    end
    return current_score, ace_count
  end

  # Draws a new card
  # It automatically stocks up the deck with previously used cards
  # @return [Card] the newly drawn card
  def draw_card
    if @deck.length == 0
      @deck = @used_cards.shuffle
      @used_cards = []
    end
    @deck.pop
  end
end
