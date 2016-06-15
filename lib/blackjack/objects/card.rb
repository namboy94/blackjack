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

# Class that models a playing card. It manages the value of the card in regards to
# blackjack and generates ASCII art of the card
class Card

  # Creates a new card
  # The constructor generates ASCII art of the card and calculates its blackjack value
  def initialize(type, number)

    top = '┌─────────┐'
    bottom = '└─────────┘'
    empty_row = "|         |\n"
    suits = {'spades' => '♠', 'diamonds' => '♦', 'hearts' => '♥', 'clubs' => '♣'}
    special_cards = {10 => '10', 12 => 'B', 13 => 'Q', 14 => 'K'}

    suit = suits[type]
    @ace = false

    if number < 10 and number != 1
      @value = number
      display_number = number.to_s
    elsif number >= 10 and number != 11
      @value = 10
      display_number = special_cards[number]
    else
      @ace = true
      @value = 11
      display_number = 'A'
    end

    offset = 8 - display_number.length

    @backside = self.class.generate_cardback

    @ascii_card = "#{top}\n| #{display_number}" + ' ' * offset + "|\n"
    @ascii_card += empty_row * 2
    @ascii_card += "|    #{suit}    |\n"
    @ascii_card += empty_row * 2
    @ascii_card += '|' + ' ' * offset + "#{display_number} |\n#{bottom}"

  end

  def flip_over
    cached = @ascii_card
    @ascii_card = @backside
    @backside = cached
  end

  def get_ascii_card
    @ascii_card
  end

  def get_value
    @value
  end

  def is_ace
    @ace
  end

  # Prints the card art to the console
  def print_card
    puts @ascii_card
  end

  # Generates a cardback ASCII art
  def self.generate_cardback
    return colorize("┌─────────┐\n" + ("│░░░░░░░░░│\n" * 7) + '└─────────┘', 31)
  end

  def self.colorize(string, mode)
    return "\e[#{mode}m" + string.gsub!("\n", "\e[0m\n\e[#{mode}m") + "\e[0m"
  end
end
