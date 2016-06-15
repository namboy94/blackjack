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

# Class that modifies the String class and equips it with a method to set terminal properties of a string
class String

  # Sets the terminal attributes of the string
  # @param [int Array] attributes the attributes of the string to be set
  # @param [int Array] previous_attributes the attributes to be set after this string. If this parameter is not
  #                                        set, the default terminal values are loaded
  # @return [string] the string with the attributes set
  def set_attributes(attributes, previous_attributes = [])

      mode_start_string = ''
      modes_end_string = "\e[0m"
      attributes.each { |attribute|
          mode_start_string += "\e[#{attribute}m"
      }
      attributed_string = mode_start_string
      attributed_string += self.gsub("\n", "#{modes_end_string}\n#{mode_start_string}")
      attributed_string += modes_end_string

      previous_attributes.each { |attribute|
          attributed_string += "\e[#{attribute}m"
      }
      attributed_string
  end

end

# TODO Maybe replace previous attributes by just replacing all 0m's