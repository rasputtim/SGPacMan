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

#include "Sounds.h"



bool Sounds::init() {

    if ( this->isinit)
        return true;

    try {
 	    CSoundManager::init(sndPaths);
        isinit = true;
        Debug::debug(Debug::error,__FUNCTION__)<<"Sounds loaded successfully"<<endl;
    }
    catch ( SMF::Exception::CGeneralError& err ) {
            std::cerr << (err.getFullReason() );
            Debug::debug(Debug::error,__FUNCTION__)<< err.getFullReason() <<endl;
    }
    catch ( ... ) {
        std::cerr << "Unexpected exception in:" << __FUNCTION__;
        Debug::debug(Debug::error,__FUNCTION__)<< "Unexpected exception in App::App()" <<endl;
    } 
    return true;
}

Sounds::Sounds()
{
    
    //set sound paths
    sndPaths[0] = "sound/intro.wav";
    sndPaths[1] = "sound/munch_a.wav";
    sndPaths[2] = "sound/munch_b.wav";
    sndPaths[3] = "sound/large_pellet.wav";
    sndPaths[4] = "sound/ghost_eat.wav";
    sndPaths[5] = "sound/fruit.wav";
    sndPaths[6] = "sound/extra_man.wav";
    sndPaths[7] = "sound/vuln.wav";
    sndPaths[8] = "sound/death.wav";
    sndPaths[9] = "sound/newgame.wav";
    sndPaths[10] = "sound/siren.wav";
    sndPaths[11] = "sound/intermission.wav";
    sndPaths[12] = "sound/booster.wav";
}

Sounds::~Sounds()
{
   
}
