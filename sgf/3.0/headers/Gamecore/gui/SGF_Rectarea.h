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
#ifndef _SGF_gui_rectarea_h
#define _SGF_gui_rectarea_h

#include "../../ExternalLibs/SDL2-2.0.3/include/SDL.h"
#include "../SGF_Config.h"
#include "../graphics/SGF_Color.h"

using namespace std;
namespace SGF{
/**
 * \class CPopupBox
 *
 * \ingroup SGF_Gui
 * 
 * \brief Controle de Retângulos (Áreas)
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 05 de Janeiro de 2012
  */

struct RectArea
{
	RectArea();
	RectArea(int x, int y, int w, int h);
	bool empty();
	inline int getX1() const { return x; }
    inline int getY1() const { return y; }
	inline int getX2() const { return x + width; }
	inline int getY2() const { return y + height; }
	inline int getW() const { return width; }
    inline int getH() const { return height; }
	void clear();
	bool operator==( const RectArea &);
	bool operator!=( const RectArea &);
	RectArea & operator= (const RectArea &);
	
	int x;
	int y;
	int width; 
	int height;
	int bodyAlpha;
	int borderAlpha;
	int radius;
    Colors::ColorDefinition bodyColor;  //body color
	Colors::ColorDefinition borderColor;  //border color
	
};
} //end SGF
#endif
