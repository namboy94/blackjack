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

Gem::Specification.new do |gem|
    gem.name        = 'ruby-blackjack'
    gem.version     = File.open('version').read
    gem.summary     = 'Blackjack'
    gem.description = 'A Blackjack CLI game'
    gem.license     = 'GPL-3.0'
    gem.authors     = ['Hermann Krumrey']
    gem.email       = 'hermann@krumreyh.com'
    gem.homepage    = 'https://gitlab.namibsun.net/namboy94/blackjack'
    gem.files       = Dir['Rakefile', '{bin,src,man,test,spec}/**/*', 'README*', 'LICENSE*']
    gem.executables << 'blackjack'
end