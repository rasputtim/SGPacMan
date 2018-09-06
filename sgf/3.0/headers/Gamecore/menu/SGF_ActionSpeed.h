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
#ifndef _S_G_F_action_speed_h
#define _S_G_F_action_speed_h

#include "../SGF_Config.h"
#include "../exceptions/all.h"

using namespace ::std;
namespace SGF {
class Token;

class  SGE_API CActionSpeed
{
	public:
		// Do whatever is needed for the requested item
		virtual void act();

		CActionSpeed(const Token *token);
	
		virtual ~CActionSpeed();
		
	private:
		// speed
		double speed;
};
} //end SGF
#endif
