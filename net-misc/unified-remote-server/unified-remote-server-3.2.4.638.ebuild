# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://www.unifiedremote.com/download/linux-x86-rpm -> ${PF}-x86.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S=${WORKDIR}

src_unpack() {
	rpm_src_unpack ${A}
	cd "${S}"
}

src_install () {
	cd "${S}/usr/share"
	insinto /usr/share/applications
	doins applications/urserver.desktop
	insinto /usr/share/icons
	doins icons/urserver.png
	insinto /usr/share/icons/hicolor/48x48/apps
	doins icons/hicolor/48x48/apps/urserver.png
	insinto /usr/share/icons/hicolor/72x72/apps
	doins icons/hicolor/72x72/apps/urserver.png
	insinto /usr/share/icons/hicolor/96x96/apps
	doins icons/hicolor/96x96/apps/urserver.png
	insinto /usr/share/pixmaps
	doins pixmaps/urserver.png
	dodir /opt/urserver
	cd "${S}/opt/urserver"
	exeinto /opt/urserver
	doexe urserver
	doexe urserver-start
	doexe urserver-stop
	insinto /opt/urserver
	doins urserver-autostart.desktop
	dodir /opt/urserver/manager
	into /opt/urserver/manager
	doins manager/*.css
	doins manager/*.html
	doins manager/*.js
	dodir /opt/urserver/manager/bootstrap
	dodir /opt/urserver/manager/bootstrap/assets
	doins manager/bootstrap/assets/*
	dodir /opt/urserver/manager/bootstrap/css
	doins manager/bootstrap/css/*
	dodir /opt/urserver/manager/bootstrap/fonts
	doins manager/bootstrap/fonts/*
	dodir /opt/urserver/manager/bootstrap/js
	doins manager/bootstrap/js/*
	dodir /opt/urserver/manager/codemirror
	doins manager/codemirror/*
	dodir /opt/urserver/manager/font-awesome
	dodir /opt/urserver/manager/font-awesome/css
	doins manager/font-awesome/css/*
	dodir /opt/urserver/manager/font-awesome/fonts
	doins manager/font-awesome/fonts/*
	dodir /opt/urserver/manager/img
	doins manager/img/*
	dodir /opt/urserver/manager/jquery
	doins manager/jquery/*
	dodir /opt/urserver/manager/lodash
	doins manager/lodash/*
	dodir /opt/urserver/manager/ractive
	doins manager/ractive/*
	dodir /opt/urserver/manager/ur
	doins manager/ur/*
	dodir /opt/urserver/remotes
	dodir /opt/urserver/remotes/Core
	dodir /opt/urserver/remotes/Core/FS
	doins remotes/Core/FS/*
	dodir /opt/urserver/remotes/Core/HTTP
	doins remotes/Core/HTTP/*
	dodir /opt/urserver/remotes/Core/Input
	doins remotes/Core/Input/*
	dodir /opt/urserver/remotes/Core/Keyboard
	doins remotes/Core/Keyboard/*
	dodir /opt/urserver/remotes/Core/Log
	doins remotes/Core/Log/*
	dodir /opt/urserver/remotes/Core/Mouse
	doins remotes/Core/Mouse/*
	dodir /opt/urserver/remotes/Core/OS
	doins remotes/Core/OS/*
	dodir /opt/urserver/remotes/Core/Script
	doins remotes/Core/Script/*
	dodir /opt/urserver/remotes/Core/Win
	doins remotes/Core/Win/*
	dodir /opt/urserver/remotes/Examples/IR
	doins remotes/Examples/IR/*
	dodir /opt/urserver/remotes/Examples/Keys
	doins remotes/Examples/Keys/*
	dodir /opt/urserver/remotes/Examples/Run
	doins remotes/Examples/Run/*
	dodir /opt/urserver/remotes/Examples/Scripts
	doins remotes/Examples/Scripts/*
	dodir /opt/urserver/remotes/Examples/USB-UIRT
	doins remotes/Examples/USB-UIRT/*
	dodir /opt/urserver/remotes/Main/"Basic Input"
	doins remotes/Main/"Basic Input"/*
	dodir /opt/urserver/remotes/Main/"Basic Input MT"
	doins remotes/Main/"Basic Input MT"/*
	dodir /opt/urserver/remotes/Main/Beamer
	doins remotes/Main/Beamer/*
	dodir /opt/urserver/remotes/Main/"Beamer File Picker"
	doins remotes/Main/"Beamer File Picker"/*
	dodir /opt/urserver/remotes/Main/"Boxee Keyboard"
	doins remotes/Main/"Boxee Keyboard"/*
	dodir /opt/urserver/remotes/Main/"Boxee Keyboard Legacy"
	doins remotes/Main/"Boxee Keyboard Legacy"/*
	dodir /opt/urserver/remotes/Main/"Boxee Web"
	doins remotes/Main/"Boxee Web"/*
	dodir /opt/urserver/remotes/Main/BSPlayer
	doins remotes/Main/BSPlayer/*
	dodir /opt/urserver/remotes/Main/"CD-DVD Tray"
	doins remotes/Main/"CD-DVD Tray"/*
	dodir /opt/urserver/remotes/Main/Chrome
	doins remotes/Main/Chrome/*
	dodir /opt/urserver/remotes/Main/Command
	doins remotes/Main/Command/*
	dodir /opt/urserver/remotes/Main/"Daum PotPlayer"
	doins remotes/Main/"Daum PotPlayer"/*
	dodir /opt/urserver/remotes/Main/EyeTV
	doins remotes/Main/EyeTV/*
	dodir /opt/urserver/remotes/Main/"File Manager"
	doins remotes/Main/"File Manager"/*
	dodir /opt/urserver/remotes/Main/Firefox
	doins remotes/Main/Firefox/*
	dodir /opt/urserver/remotes/Main/foobar2000
	doins remotes/Main/foobar2000/*
	dodir /opt/urserver/remotes/Main/"GOM Player"
	doins remotes/Main/"GOM Player"/*
	dodir /opt/urserver/remotes/Main/"Google Music"
	doins remotes/Main/"Google Music"/*
	dodir /opt/urserver/remotes/Main/"Google Presentation"
	doins remotes/Main/"Google Presentation"/*
	dodir /opt/urserver/remotes/Main/"Hulu Desktop"
	doins remotes/Main/"Hulu Desktop"/*
	dodir /opt/urserver/remotes/Main/"Hulu Web"
	doins remotes/Main/"Hulu Web"/*
	dodir /opt/urserver/remotes/Main/IE
	doins remotes/Main/IE/*
	dodir /opt/urserver/remotes/Main/iPhoto
	doins remotes/Main/iPhoto/*
	dodir /opt/urserver/remotes/Main/iTunes
	doins remotes/Main/iTunes/*
	dodir /opt/urserver/remotes/Main/JRiver
	doins remotes/Main/JRiver/*
	dodir /opt/urserver/remotes/Main/Keyboards
	doins remotes/Main/Keyboards/*
	dodir /opt/urserver/remotes/Main/Keynote
	doins remotes/Main/Keynote/*
	dodir /opt/urserver/remotes/Main/KMPlayer
	doins remotes/Main/KMPlayer/*
	dodir /opt/urserver/remotes/Main/"Kodi Keyboard"
	doins remotes/Main/"Kodi Keyboard"/*
	dodir /opt/urserver/remotes/Main/"Kodi Web"
	doins remotes/Main/"Kodi Web"/*
	dodir /opt/urserver/remotes/Main/"Launcher (Linux)"
	doins remotes/Main/"Launcher (Linux)"/*
	dodir /opt/urserver/remotes/Main/"Launcher (Mac)"
	doins remotes/Main/"Launcher (Mac)"/*
	dodir /opt/urserver/remotes/Main/"Mac OS X"
	doins remotes/Main/"Mac OS X"/*
	dodir /opt/urserver/remotes/Main/Magnifier
	doins remotes/Main/Magnifier/*
	dodir /opt/urserver/remotes/Main/Media
	doins remotes/Main/Media/*
	dodir /opt/urserver/remotes/Main/MediaMonkey
	doins remotes/Main/MediaMonkey/*
	dodir /opt/urserver/remotes/Main/MediaPortal
	doins remotes/Main/MediaPortal/*
	dodir /opt/urserver/remotes/Main/Monitor
	doins remotes/Main/Monitor/*
	dodir /opt/urserver/remotes/Main/MPC-BE
	doins remotes/Main/MPC-BE/*
	dodir /opt/urserver/remotes/Main/MPC-HC
	doins remotes/Main/MPC-HC/*
	dodir /opt/urserver/remotes/Main/MPlayerX
	doins remotes/Main/MPlayerX/*
	dodir /opt/urserver/remotes/Main/MusicBee
	doins remotes/Main/MusicBee/*
	dodir /opt/urserver/remotes/Main/Netflix
	doins remotes/Main/Netflix/*
	dodir /opt/urserver/remotes/Main/"Netflix App"
	doins remotes/Main/"Netflix App"/*
	dodir /opt/urserver/remotes/Main/Numpad
	doins remotes/Main/Numpad/*
	dodir /opt/urserver/remotes/Main/Opera
	doins remotes/Main/Opera/*
	dodir /opt/urserver/remotes/Main/Pandora
	doins remotes/Main/Pandora/*
	dodir /opt/urserver/remotes/Main/Performance
	doins remotes/Main/Performance/*
	dodir /opt/urserver/remotes/Main/Picasa
	doins remotes/Main/Picasa/*
	dodir /opt/urserver/remotes/Main/Pixel
	doins remotes/Main/Pixel/*
	dodir /opt/urserver/remotes/Main/Plex
	doins remotes/Main/Plex/*
	dodir /opt/urserver/remotes/Main/"Plex Keyboard"
	doins remotes/Main/"Plex Keyboard"/*
	dodir /opt/urserver/remotes/Main/Power
	doins remotes/Main/Power/*
	dodir /opt/urserver/remotes/Main/"PowerPoint Advanced"
	doins remotes/Main/"PowerPoint Advanced"/*
	dodir /opt/urserver/remotes/Main/"PowerPoint Basic"
	doins remotes/Main/"PowerPoint Basic"/*
	dodir /opt/urserver/remotes/Main/"QuickTime Player"
	doins remotes/Main/"QuickTime Player"/*
	dodir /opt/urserver/remotes/Main/Safari
	doins remotes/Main/Safari/*
	dodir /opt/urserver/remotes/Main/Screen
	doins remotes/Main/Screen/*
	dodir /opt/urserver/remotes/Main/"Scroll Wheel"
	doins remotes/Main/"Scroll Wheel"/*
	dodir /opt/urserver/remotes/Main/"Send Text"
	doins remotes/Main/"Send Text"/*
	dodir /opt/urserver/remotes/Main/"Server Manager"
	doins remotes/Main/"Server Manager"/*
	dodir /opt/urserver/remotes/Main/SlideShow
	doins remotes/Main/SlideShow/*
	dodir /opt/urserver/remotes/Main/SoundCloud
	doins remotes/Main/SoundCloud/*
	dodir /opt/urserver/remotes/Main/Spotify
	doins remotes/Main/Spotify/*
	dodir /opt/urserver/remotes/Main/"Spotify Advanced"
	doins remotes/Main/"Spotify Advanced"/*
	dodir /opt/urserver/remotes/Main/"Spotify Advanced (Legacy)"
	doins remotes/Main/"Spotify Advanced (Legacy)"/*
	dodir /opt/urserver/remotes/Main/Spy
	doins remotes/Main/Spy/*
	dodir /opt/urserver/remotes/Main/Start
	doins remotes/Main/Start/*
	dodir /opt/urserver/remotes/Main/"Task Manager"
	doins remotes/Main/"Task Manager"/*
	dodir /opt/urserver/remotes/Main/TellStick
	doins remotes/Main/TellStick/*
	dodir /opt/urserver/remotes/Main/"TellStick Live"
	doins remotes/Main/"TellStick Live"/*
	dodir /opt/urserver/remotes/Main/TwitchTV
	doins remotes/Main/TwitchTV/*
	dodir /opt/urserver/remotes/Main/USB-UIRT
	doins remotes/Main/USB-UIRT/*
	dodir /opt/urserver/remotes/Main/VLC
	doins remotes/Main/VLC/*
	dodir /opt/urserver/remotes/Main/"VLC Web"
	doins remotes/Main/"VLC Web"/*
	dodir /opt/urserver/remotes/Main/Volume
	doins remotes/Main/Volume/*
	dodir /opt/urserver/remotes/Main/Winamp
	doins remotes/Main/Winamp/*
	dodir /opt/urserver/remotes/Main/Windows
	doins remotes/Main/Windows/*
	dodir /opt/urserver/remotes/Main/"Windows 8"
	doins remotes/Main/"Windows 8"/*
	dodir /opt/urserver/remotes/Main/"Windows Media Center"
	doins remotes/Main/"Windows Media Center"/*
	dodir /opt/urserver/remotes/Main/"Windows Media Player"
	doins remotes/Main/"Windows Media Player"/*
	dodir /opt/urserver/remotes/Main/"Windows Photo Viewer"
	doins remotes/Main/"Windows Photo Viewer"/*
	dodir /opt/urserver/remotes/Main/"XBMC Keyboard"
	doins remotes/Main/"XBMC Keyboard"/*
	dodir /opt/urserver/remotes/Main/"XBMC Web"
	doins remotes/Main/"XBMC Web"/*
	dodir /opt/urserver/remotes/Main/YouTube
	doins remotes/Main/YouTube/*
}
