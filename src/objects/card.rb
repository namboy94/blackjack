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

require_relative('../strings/string.rb')

# Class that models a playing card. It manages the value of the card in regards to
# blackjack and generates ASCII art of the card
class Card


    # Creates a new card
    # The constructor generates ASCII art of the card and calculates its blackjack value
    # The card is also assigned a cardback.
    # @param [string] type the type of the suit the card belongs to, i.e 'spades', 'hearts' etc.
    # @param [int] number the number of the card. Numbers 2 through 10 are simply the normal numbers,
    #                                             11 is the ace, 12 jack, 13 queen, 14 king
    # @return [nil]
    def initialize(type, number)

        suit, @value, display_number, @ace = determine_card_data(type, number)
        @backside = generate_cardback
        @flipped = false
        @ascii_card = format_card(suit, display_number)
    end


    # Generates an ASCII playing card from the provided information
    # @param [string] suit the suit of the card
    # @param [string] number the number of the card (like 'A' for ace or '10' for 10)
    # @return [string] the ASCII card
    def format_card(suit, number)

        top =       '┌───────────┐'
        empty_row = "|           |\n"
        bottom =    '└───────────┘'

        offset = 10 - number.length

        ascii_card = "#{top}\n| #{number}" + ' ' * offset + "|\n"
        ascii_card += empty_row * 2 + "|     #{suit}     |\n" + empty_row * 2
        ascii_card += '|' + ' ' * offset + "#{number} |\n#{bottom}"
        ascii_card.set_attributes([WHITE_BG, BLACK_FG])
    end


    # Determines the suit of the card, its blackjack value, its number to be shown visually as well as
    # if the card is an ace.
    # @param [string] type the suit identifier string ('spades', 'hearts', 'clubs' or 'diamonds')
    # @param [int] number the number of the card. Should be a number from 1 to 14
    # @return [string, int, string, boolean] the suit of the card, the blackjack value of the card,
    #                                        the string representation of the card number and if the card is an ace
    def determine_card_data(type, number)

        suits = {'spades' => '♠', 'diamonds' => '♦', 'hearts' => '♥', 'clubs' => '♣'}
        special_cards = {10 => '10', 12 => 'B', 13 => 'Q', 14 => 'K'}

        ace = false

        suit = suits[type]
        if type == 'spades' or type == 'clubs'
            suit = suit.set_attributes([BLACK_FG], [WHITE_BG, BLACK_FG])
        else
            suit = suit.set_attributes([RED_FG], [WHITE_BG, BLACK_FG])
        end

        if number < 10 and number != 1
            value = number
            display_number = number.to_s
        elsif number >= 10 and number != 11
            value = 10
            display_number = special_cards[number]
        else
            ace = true
            value = 11  # Set value of ace to 11, since we can then just downgrade the value to 1 if the need arises
            display_number = 'A'
        end

        return suit, value, display_number, ace
    end

    # Generates a cardback ASCII art
    # @return [string] the cardback ASCII art
    def generate_cardback
        ("┌───────────┐\n" +
        ("│░░░░░░░░░░░│\n" * 7) +
         '└───────────┘').set_attributes([WHITE_BG, BLACK_FG])
    end

    # Flips over the card so that the cardback is shown instead of the generated ASCII card
    # @return [nil]
    def flip_over
        cached = @ascii_card
        @ascii_card = @backside
        @backside = cached
        @flipped = !@flipped
    end

    # @return [string] the generated ASCII card, or the cardback if the card is currently flipped
    def get_ascii_card
        @ascii_card
    end

    # @return [int] the blackjack value of the card
    def get_value
        @value
    end

    # @return [boolean] if the card is an ace or not
    def is_ace
        @ace
    end

    # @return [boolean] if the card is flipped or not
    def is_flipped
        @flipped
    end

end
