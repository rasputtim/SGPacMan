/*
  SGPacMan - Pacman Super Game Fabric
  Copyright (C) 2010-2011 Rasputtim <Rasputtim@hotmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

  */

#ifndef _PAC_GLOBAL_DEFNITIONS_H
#define _PAC_GLOBAL_DEFNITIONS_H

//////////////////////////////////////////////////////
//	DEFINES
//////////////////////////////////////////////////////

#define WNDTITLE	"Pacman Revolutions (" __DATE__ ", " __TIME__ ")"
#define CLSNAME		"Pacman Revolutions"

#define STATE_GAME	0
#define STATE_ENTER_HSCORE 1
#define STATE_VIEW_HSCORE 2
#define STATE_MAP_EDITOR 3
#define STATE_STOPPED 4
#define STATE_EDITOR 5

#define MODE_LEVELS 2
#define MODE_SKINS 1

//#define UP	0
//#define RIGHT 1
//#define DOWN 2
//#define LEFT 3
#define ENTER 4
#define SPACE 5
#define CLICK 6

#define MOVEMOD 3000.0f

#define EXTRA_Y_SPACE 50

#define SMALL_DOTS_SCORE 10
#define LARGE_DOTS_SCORE 50

#define SETTINGSFILE "settings.xml"
#define PACCFGFILE "pacman.xml"
#define CFGFILE "level.xml"
#define OBJFILE "objmap"
#define MAPFILE "map"

#define FRUITDURATION 10000
#define BOOSTTIME 3000

#define MAXENTRIES 8



#endif