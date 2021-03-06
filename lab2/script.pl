#! /usr/bin/perl

# Convert a MP3 clip (or any binary data, for that matter)
# into intel-hex, for easy downloading or programming into
# the memory of a microcontroller system.
# Copyright (c) 2000, PJRC.COM, LLC

# typical usage:
#   mp3_to_hex < file.mp3 > file.hex

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


# where the data will be placed in memory
$addr = 0x0;

while (1) {
	$len = read(STDIN, $data, 32);
	break if $len < 1;
        @array = unpack("C$len", $data);
	$sum = $len + ($addr & 255) + ($addr >> 8);
	printf ":%02X%04X00", $len, $addr;
	for ($i=0; $i < $len; $i++) {
		printf "%02X", $array[$i];
		$sum += $array[$i]
	}
	printf "%02X\n", -$sum & 255;
	$addr += $len;
	last if $len < 32;
}
print ":00000001FF\n";



