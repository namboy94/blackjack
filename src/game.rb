# Copyright 2016 Hermann Krumrey <hermann@krumreyh.com>
#
# This file is part of ruby-blackjack.
#
# ruby-blackjack is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ruby-blackjack is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ruby-blackjack. If not, see <http://www.gnu.org/licenses/>.

require_relative('objects/card.rb')

# Class that simulates a Blackjack game
class Game

    # Initializes the instance variables used to keep track of the game state
    # @return [nil]
    def initialize
        @deck = generate_deck
        @used_cards = []
        @player_cards = []
        @dealer_cards = []
        @player_score = 0
        @dealer_score = 0
    end


    # Generates a new deck of cards
    # The deck is shuffled directly after creation
    # @return [Card Array] the generated deck
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


    # Draws a new card
    # It automatically stocks up the deck with previously used cards if the deck runs out of cards
    # @return [Card] the newly drawn card
    def draw_card
        if @deck.length == 0
            @deck = @used_cards.shuffle
            @used_cards = []
        end
        @deck.pop
    end


    # Starts a game of roulette. Each player will draw two cards, the dealer's second card will stay
    # top down until the player stands
    # @return [Card Array, Card Array, string] the result of the first few drawings. Refer to evaluate() for details
    def start
        # Let the player draw his cards
        hit
        hit

        # Let the dealer draw his cards
        hit(true)
        result = hit(true)
        @dealer_cards[1].flip_over  # Flip over the card

        result
    end


    # Draws a new card for a player and immediately evaluates the current state of the game
    # @param [Object] dealer flag can be set to make the dealer instead of the player draw a card
    # @return [Card Array, Card Array, string] the result of the drawing. Refer to evaluate() for details
    def hit(dealer = false)
        if dealer
            @dealer_cards.push(draw_card)
            @dealer_score = self.class.calculate_optimal_card_score(@dealer_cards)
        else
            @player_cards.push(draw_card)
            @player_score = self.class.calculate_optimal_card_score(@player_cards)
        end
        evaluate
    end


    # Stops the user interaction. The cards of the user will no longer change, and now the dealer
    # draws cards until he is above 16 points. Afterwards, the game state is evaluated
    # @return [Card Array, Card Array, string] the result of the drawing. Refer to evaluate() for details
    def stand
        @dealer_cards[1].flip_over
        result = [@player_cards.clone, @dealer_cards.clone, 'undecided']
        while @dealer_score < 17 and result[2] == 'undecided'
            result = hit(true)
        end
        if result[2] == 'undecided'
            evaluate(true)
        else
            result
        end
    end


    # Evaluates the current state of the game according to the standard blackjack rules
    # @param [boolean] player_standing flag that is set to evaluate a game once the player has decided to stand
    # @return [Card Array, Card Array, string] the player's cards,
    #                                          the dealer's cards,
    #                                          a string stating the current status of the match.
    #                                          Possible Options:    'loss', if the user lost
    #                                                               'win', if the user won
    #                                                               'draw', if the game ended in a draw
    #                                                               'undecided', if the game is not finished
    def evaluate(player_standing = false)
        player_cards = @player_cards
        dealer_cards = @dealer_cards
        state = 'undecided'
        if @player_score > 21
            state = 'loss'
        elsif @dealer_score > 21
            state = 'win'
        elsif player_standing and @player_score > @dealer_score
            state = 'win'
        elsif player_standing and @player_score < @dealer_score
            state = 'loss'
        elsif player_standing and @player_score == @dealer_score
            state = 'draw'
        end

        if state != 'undecided'
            player_cards, dealer_cards = cleanup
        end

        return player_cards, dealer_cards, state
    end


    # Resets the game to enable starting a new game.
    # @return [Card Array, Card Array] the user's cards and the dealer's cards
    def cleanup
        if @dealer_cards[1].is_flipped
            @dealer_cards[1].flip_over
        end
        @used_cards += @player_cards + @dealer_cards
        @player_score = 0
        @dealer_score = 0
        old_player_cards = @player_cards.clone
        old_dealer_cards = @dealer_cards.clone
        @player_cards = []
        @dealer_cards = []
        return old_player_cards, old_dealer_cards
    end


    # Calculates the optimal amount of points for blackjack for an array of cards
    # @param [Card Array] cards the cards to be checked
    # @return [int] the optimal blackjack value of the cards
    def self.calculate_optimal_card_score(cards)
        score = 0
        aces = 0
        cards.each { |card|
            unless card.is_flipped  # == if card is not flipped
                score += card.get_value
                if card.is_ace
                    aces += 1
                end
            end
        }
        while score > 21 and aces > 0
            aces -= 1
            score -= 10
        end
        score
    end


    # @return [int] the player's current score
    def get_player_score
        @player_score
    end


    # @return [int] the dealer's current score
    def get_dealer_score
        @dealer_score
    end

end