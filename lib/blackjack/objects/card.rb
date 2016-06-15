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
      display_number = number
    elsif number >= 10 and number != 11
      @value = 10
      display_number = special_cards[number]
    else
      @ace = true
      @value = 11
      display_number = 'A'
    end

    @ascii_card = "#{top}\n| #{display_number}       |\n"
    @ascii_card += empty_row * 2
    @ascii_card += "|    #{suit}    |\n"
    @ascii_card += empty_row * 2
    @ascii_card += "|       #{display_number} |\n#{bottom}"

  end

  def print_card
    puts @ascii_card
  end

end

if __FILE__ == $0
  card = Card.new('spades', 11)
  card.print_card
end