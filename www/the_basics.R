##***********************************************************************
## this program is free software: you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## this program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the this program.  If not, see
## <http://www.gnu.org/licenses/>.
##
## $Id$

library(logging)
basicConfig()

ls(getLogger())
with(getLogger(), level)
with(getLogger(), names(handlers))
loginfo('does it work?')
logwarn('%s %d', 'my name is', 5)
logdebug('I am a silent child')

addHandler(writeToConsole)
with(getLogger(), names(handlers))
loginfo('test')
logwarn('test')
removeHandler('writeToConsole')
logwarn('test')

addHandler(writeToConsole)
setLevel(30, getHandler('basic.stdout'))
loginfo('test')
logwarn('test')
with(getHandler('basic.stdout'), level)
