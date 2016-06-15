# Copyright 2016 Hermann Krumrey
#
# This file is part of ruby-blackjack.
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

require_relative('game.rb')
require_relative('strings/string.rb')

# Class that offers an interactive interface for the user to play blackjack
class BlackjackCli

    # Constructor for the BlackJackCli class
    # @return [nil]
    def initialize
        puts 'Blackjack CLI started'.set_attributes([47, 30])
        @blackjack = Game.new
    end

    # the main game loop. It continually asks the user for a new choice of either hit or stand
    # @return [nil]
    def game_loop
        new_game = true

        while true
            if new_game
            print_result(@blackjack.start)
            new_game = false
        end

        result = nil
        case get_play_command
            when "stand\n"
                result = @blackjack.stand
            when "hit\n"
                result = @blackjack.hit
            else
                puts 'Something went wrong'
        end

        print_result(result)

        if result[2] == 'win'
            puts 'You won!'.set_attributes([47, 30])
        elsif result[2] == 'loss'
            puts 'You lost :('.set_attributes([47, 30])
        elsif result[2] == 'draw'
            puts "It's a draw".set_attributes([47, 30])
        end

        if result[2] != 'undecided'
            new_game = true
            pause_when_game_ends
        end

        end
    end

    # This pauses the game until the user presses enter/return before starting a new game
    # @return [nil]
    def pause_when_game_ends
        puts 'Press enter to start a new game'.set_attributes([47, 30])
        gets
    end

    # Prints the current game state based on the results of a hit or stand action
    # @param [Card Array, Card Array] result the result to be displayed
    # @return [nil]
    def print_result(result)
        puts "Player Cards: (#{Game.calculate_optimal_card_score(result[0])})".set_attributes([47, 30])
        puts format_cards(result[0])
        puts "\nDealer Cards: (#{Game.calculate_optimal_card_score(result[1])})".set_attributes([47, 30])
        puts format_cards(result[1])
    end

    # Formats cards to be displayed side-by-side
    # @param [Card Array] cards the cards to be displayed
    # @return [string] a formatted string of all cards side by side
    def format_cards(cards)
        cards_string = ''

        card_parts = []
        cards.each { |card|
            card_parts.push(card.get_ascii_card.split("\n"))
        }

        if card_parts.length == 0
            return ''
        end

        (0...card_parts[0].length).each { |i|
            card_parts.each { |card_part|
                cards_string += card_part[i] + '   '
            }
            cards_string += "\n"
        }
        cards_string
    end

    # Gets the user's input on what to do next
    # @return [string] the (validated) user input
    def get_play_command
    puts 'What would you like to do? (hit|stand)'.set_attributes([47, 30])
    input = gets
    while not input == "hit\n" and not input == "stand\n"
        puts "Please enter 'hit' or 'stand'".set_attributes([47, 30])
        input = gets
    end
    input
    end

end

if __FILE__ == $0
cli = BlackjackCli.new
cli.game_loop
end
