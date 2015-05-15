# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2 or later

# Try to remove any dm-crypt mappings
if [ -x /usr/bin/veracrypt ]; then
	ebegin "Removing veracrypt mappings"
	! /usr/bin/veracrypt -l > /dev/null 2>&1  || /usr/bin/veracrypt -d
	eend $?
fi
