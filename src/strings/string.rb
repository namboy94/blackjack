# Copyright 2016-2017 Hermann Krumrey <hermann@krumreyh.com>
#
# This file is part of blackjack.
#
# blackjack is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# blackjack is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with blackjack.  If not, see <http://www.gnu.org/licenses/>.

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

# Foregrounds
DEFAULT_FG = 39
BLACK_FG = 30
RED_FG = 31
GREEN_FG = 32
YELLOW_FG = 33
BLUE_FG = 34
MAGENTA_FG = 35
CYAN_FG = 36
LIGHT_GRAY_FG = 37
DARK_GRAY_FG = 90
LIGHT_RED_FG = 91
LIGHT_GREEN_FG = 92
LIGHT_YELLOW_FG = 93
LIGHT_BLUE_FG = 94
LIGHT_MAGENTA_FG = 95
LIGHT_CYAN_FG = 96
WHITE_FG = 97

# Backgrounds
DEFAULT_BG = 49
BLACK_BG = 40
RED_BG = 41
GREEN_BG = 42
YELLOW_BG = 43
BLUE_BG = 44
MAGENTA_BG = 45
CYAN_BG = 46
LIGHT_GRAY_BG = 47
DARK_GRAY_BG = 100
LIGHT_RED_BG = 101
LIGHT_GREEN_BG = 102
LIGHT_YELLOW_BG = 103
LIGHT_BLUE_BG = 104
LIGHT_MAGENTA_BG = 105
LIGHT_CYAN_BG = 106
WHITE_BG = 107