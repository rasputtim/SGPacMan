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


#ifndef _PAC_SOUNDS_H_
#define _PAC_SOUNDS_H_

#include "Gamecore/util/all_sound.h"

//#define NUMOFSOUNDS 13
namespace SGF{
class CSoundManager;
}

class Sounds : public SGF::CSoundManager {
public:
    Sounds();
    ~Sounds();
    bool init();

private:
	std::map<int,std::string> sndPaths;
};


#endif
