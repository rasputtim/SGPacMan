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


#ifndef _PAC_BACKGROUND_
#define _PAC_BACKGROUND_

#include "Gamecore/objects/SGF_Object.h"
#include "Game.h"

#define NUMOFMAPTEX 10
using namespace SGF;
class CGame;

class BckgrObj :
	public SGF::CBaseObject
{
public:
	enum tiletype{
		background =0,
		line,
		door,
		upper_left_corner,
		upper_right_corner,
		lower_right_corner,
		lower_left_corner,
		right_t,
		left_t,
		stub
};
    BckgrObj(std::string TexturesPathath);
    ~BckgrObj();

	//! métodos herdados da classe pai
	void draw(); //should be render or init
	//virtual void act( SGF::CObjectList & others, SGF::CTheater * world, SGF::CObjectList * add=NULL ){};
	virtual void act(){};
	virtual void draw(SGF::CBitmap * work, int rel_x, int rel_y){};
	virtual int getWidth() const {return 0;}//width;};
	virtual int getHeight() const {return 0;}// height;}
	bool load();

	void Draw(int ix, int iy, int obj=3, int type=1);
    void Draw(int ix, int iy, int obj, int type, int alp);

    virtual void reset() {};   /* avoid compiler warnings */



    void setSpecialSpawned(bool b) {specialspawned = b;	}
    void setSpecialEaten(bool b) {specialeaten = b;	}

    int getObjCount() {	return pacFoodCounter;	}

    void setFruitAlpha(int a);

private:
 	SGF::CBitmap
			*b_mapEl[NUMOFMAPTEX],
            *foodObj[NUMOFMAPTEX],  //objects that pacman may eat
            *b_mapElRot[NUMOFMAPTEX][4];

    int
            pacFoodCounter, //to ocunt the number of food elements on the map
            fruitalpha;

    bool
            specialspawned,
            specialeaten;

	int alpha;


};

#endif
