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
## along with this program.  If not, see
## <http://www.gnu.org/licenses/>.
##
## $Id$

library(logging)
logReset()

basicConfig(level='FINEST')
addHandler(writeToFile, file="~/testing.log", level='DEBUG')
with(getLogger(), names(handlers))
loginfo('test %d', 1)
logdebug('test %d', 2)
logwarn('test %d', 3)
logfinest('test %d', 4)
