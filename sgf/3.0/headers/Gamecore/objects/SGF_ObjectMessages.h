/*
  SGF - Salvat Game Fabric  (https://sourceforge.net/projects/sgfabric/)
  Copyright (C) 2010-2011 Salvatore Giannotta Filho <a_materasu@hotmail.com>

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

#ifndef _object_messages_h
#define _object_messages_h
#include "../SGF_Config.h"
/* all network messages */
namespace SGF{

namespace CObjectMessages{
    enum NetworkCodes{
        Moved = 0,
        Collided = 1,
    };
}

namespace CharacterMessages{
    enum NetworkCodes{
        Animation = 20,
        Jump = 21,
        Explode = 22,
        Health = 23,
        Fall = 24,
        Ungrab = 25,
        ShowName = 26,
    };
}

namespace PlayerMessages{
    enum NetworkCodes{
        Score = 27,
        Confirm = 28,
    };
}

} //end SGF

#endif
