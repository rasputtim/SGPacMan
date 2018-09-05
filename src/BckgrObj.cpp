/*
  SGPacMan - Salvat Game Pacman (https://sourceforge.net/projects/sgfpacman/)
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


#include "BckgrObj.h"
#include "settings.h"

extern CPacConfiguration settings;
extern Game game;


void BckgrObj::Draw(int ix, int iy, int obj, int type, int alp) {
    SDL_Rect pos;

    pos.x=ix;
    pos.y=iy;
    pos.h=pos.w=20;

    if (type == 1) {
			foodObj[obj]->applyAlphaTrans(alp);
			foodObj[obj]->Blit(ix,iy);
	}
    else {
		b_mapEl[obj]->applyAlphaTrans(alp);
		b_mapEl[obj]->Blit(ix,iy);

    }
}

void BckgrObj::Draw(int ix, int iy, int obj, int type) {
    Draw(ix,iy,obj,type,255);
}

void BckgrObj::setFruitAlpha(int a) {
    fruitalpha = a;
}

void BckgrObj::draw() {
    SGF::CMap fieldMap;
	SGF::CMap objMap;
    int height,
    width,
    linha,
    coluna;
    SDL_Rect pos;

    height = settings.m_fieldheight.getInteger();
    width = settings.m_fieldwidth.getInteger();
    game.getMaps(&fieldMap, &objMap);

    pacFoodCounter = 0;
	b_mapEl[0]->Blit(); //blit fundo do background

	//DRAW FIELD
    for (linha=0;linha<width;linha++) { //coluna
        for (coluna=0; coluna<height; coluna++) { //linha

            pos.x=coluna*settings.m_tilesize.getInteger();
            pos.y=linha*settings.m_tilesize.getInteger();
            pos.h=20;
            pos.w=20;
			//Debug::debug(Debug::gameEngine) <<" Map Draw Read Value [ " << linha <<" , " <<coluna<<" ]: " << fieldMap.getTyleType(linha,coluna) << endl;
			int typetype = fieldMap.getTyleType(coluna,linha);
			switch (typetype) {
				case upper_left_corner:
					{		//upper left corner
					//Debug::debug(Debug::gameEngine) <<" Map Will Blit upper left corner to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					//b_mapEl[upper_left_corner]->applyAlphaTrans(alpha);
					//b_mapEl[upper_left_corner]->Blit(pos.x,pos.y);
					b_mapElRot[upper_left_corner][3]->applyAlphaTrans(alpha);
					b_mapElRot[upper_left_corner][3]->Blit(pos.x,pos.y);
					break;
					}
				case upper_right_corner:
					{ // upper right corner
                	//Debug::debug(Debug::gameEngine) <<" Map Will Blit upper right corner to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					//b_mapEl[upper_right_corner]->applyAlphaTrans(alpha);
					//b_mapEl[upper_right_corner]->Blit(pos.x,pos.y);
					b_mapElRot[upper_right_corner][3]->applyAlphaTrans(alpha);
					b_mapElRot[upper_right_corner][3]->Blit(pos.x,pos.y);
					
					break;
					}
				case lower_right_corner:
					{		// lower  right corner
                	//Debug::debug(Debug::gameEngine) <<" Map Will Blit lower  right corner to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					//b_mapEl[lower_right_corner]->applyAlphaTrans(alpha);
					//b_mapEl[lower_right_corner]->Blit(pos.x,pos.y);
					b_mapElRot[lower_right_corner][3]->applyAlphaTrans(alpha);
					b_mapElRot[lower_right_corner][3]->Blit(pos.x,pos.y);
					break;
					}
				case lower_left_corner:
					{		// lower left corner
					//Debug::debug(Debug::gameEngine) <<" Map Will Blit lower left corner to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					//b_mapEl[lower_left_corner]->applyAlphaTrans(alpha);
					//b_mapEl[lower_left_corner]->Blit(pos.x,pos.y);
					b_mapElRot[lower_left_corner][3]->applyAlphaTrans(alpha);
					b_mapElRot[lower_left_corner][3]->Blit(pos.x,pos.y);
					break;
					}
				case line:
					{
					//Debug::debug(Debug::gameEngine) <<" Map Will Blit line to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					if (linha==0 || linha == height-1 || (fieldMap.isUnwalkable(coluna-1,linha) && fieldMap.isUnwalkable(coluna+1,linha)))
					{// horizontal line
						//CBitmap temp(*b_mapEl[line],true);
						//temp.applyAlphaTrans(alpha);
						//temp.Blit(pos.x,pos.y);
						
						//b_mapEl[line]->applyAlphaTrans(alpha);
						//b_mapEl[line]->Blit(pos.x,pos.y);
						b_mapElRot[line][3]->applyAlphaTrans(alpha);
						b_mapElRot[line][3]->Blit(pos.x,pos.y);
					}else {	// vertical line

						b_mapElRot[line][0]->applyAlphaTrans(alpha);
						b_mapElRot[line][0]->Blit(pos.x,pos.y);
					}
					break;
					}
				case door:
					{
					//Debug::debug(Debug::gameEngine) <<" Map Will Blit door to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					if (fieldMap.isWalkable(coluna,linha-1) && fieldMap.isWalkable(coluna,linha+1))
					{//ghost door

						//b_mapEl[door]->applyAlphaTrans(alpha);
						//b_mapEl[door]->Blit(pos.x,pos.y);
						b_mapElRot[door][3]->applyAlphaTrans(alpha);
						b_mapElRot[door][3]->Blit(pos.x,pos.y);
					}else 	{	// vertical ghost door

						b_mapElRot[door][0]->applyAlphaTrans(alpha);
						b_mapElRot[door][0]->Blit(pos.x,pos.y);
					}
					break;
					}
				case left_t:
					{
					//Debug::debug(Debug::gameEngine) <<" Map Will Blit left t to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					if (fieldMap.isUnwalkable(coluna,linha-1) && fieldMap.isUnwalkable(coluna,linha+1))
					{ // left T

						//b_mapEl[left_t]->applyAlphaTrans(alpha);
						//b_mapEl[left_t]->Blit(pos.x,pos.y);
						b_mapElRot[left_t][3]->applyAlphaTrans(alpha);
						b_mapElRot[left_t][3]->Blit(pos.x,pos.y);
					}
					else if (fieldMap.isUnwalkable(coluna-1,linha) && fieldMap.isUnwalkable(coluna+1,linha))
					{	// upside down T

						b_mapElRot[left_t][0]->applyAlphaTrans(alpha);
						b_mapElRot[left_t][0]->Blit(pos.x,pos.y);
					}
					break;
					}
				case right_t:
					{
					//Debug::debug(Debug::gameEngine) <<" Map Will Blit right t to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					if (fieldMap.isUnwalkable(coluna,linha-1) && fieldMap.isUnwalkable(coluna,linha+1))
					{ // right T

						//b_mapEl[right_t]->applyAlphaTrans(alpha);
						//b_mapEl[right_t]->Blit(pos.x,pos.y);
						b_mapElRot[right_t][3]->applyAlphaTrans(alpha);
						b_mapElRot[right_t][3]->Blit(pos.x,pos.y);
					}
					else if (fieldMap.isUnwalkable(coluna-1,linha) && fieldMap.isUnwalkable(coluna+1,linha))
					{	// upright  T

						b_mapElRot[right_t][0]->applyAlphaTrans(alpha);
						b_mapElRot[right_t][0]->Blit(pos.x,pos.y);
					}
					break;
					}
				case stub:
					{
					//Debug::debug(Debug::gameEngine) <<" Map Will Blit stub t to [ " << linha <<" , " <<coluna<<" ]: " <<  endl;
					if (fieldMap.getTyleType(coluna-1,linha)==line && fieldMap.isWalkable(coluna+1,linha))
					{//right stub

						//b_mapEl[stub]->applyAlphaTrans(alpha);
						//b_mapEl[stub]->Blit(pos.x,pos.y);
						b_mapElRot[stub][3]->applyAlphaTrans(alpha);
						b_mapElRot[stub][3]->Blit(pos.x,pos.y);
					}else if (fieldMap.getTyleType(coluna+1,linha)==line && fieldMap.isWalkable(coluna-1,linha))
					{	// left stub
               			b_mapElRot[stub][1]->applyAlphaTrans(alpha);
						b_mapElRot[stub][1]->Blit(pos.x,pos.y);
					}else if (fieldMap.getTyleType(coluna,linha+1)==line && fieldMap.isWalkable(coluna,linha-1))
					{	// upper stub
						b_mapElRot[stub][0]->applyAlphaTrans(alpha);
						b_mapElRot[stub][0]->Blit(pos.x,pos.y);
					}else if (fieldMap.getTyleType(coluna,linha-1)==line && fieldMap.isWalkable(coluna,linha+1))
					{// lower stub
						b_mapElRot[stub][2]->applyAlphaTrans(alpha);
						b_mapElRot[stub][2]->Blit(pos.x,pos.y);
					}
						break;
					}
			}

			//so para teste 
			//SGF::CBitmap::BlitRenderToScreen(0);
        }
    }

    //DRAW FOOD OBJECTS

    for (coluna=0;coluna<height;coluna++) {
        for (linha=0; linha<width; linha++) {

            pos.x=coluna*settings.m_tilesize.getInteger()+10; // +10 are needed for correct placement
            pos.y=linha*settings.m_tilesize.getInteger()+10;
            pos.h=20;
            pos.w=20;
			if (objMap.getTyleType(coluna,linha)==1)
           	{  //dots
                foodObj[1]->applyAlphaTrans(alpha);
				foodObj[1]->Blit(pos.x,pos.y);
                pacFoodCounter++;
            }
            if (objMap.getTyleType(coluna,linha)==2)

			{	// BIG DOTS!
                foodObj[2]->applyAlphaTrans(alpha);
				foodObj[2]->Blit(pos.x,pos.y);
                pacFoodCounter++;
            }
            if (objMap.getTyleType(coluna,linha)==3 && specialspawned && !specialeaten)

			{	// fruit
                foodObj[3]->applyAlphaTrans(alpha);
				foodObj[3]->Blit(pos.x,pos.y);
                pacFoodCounter++;
            }
        }
    }

	
}

bool BckgrObj::load() {
	Debug::debug(Debug::gameObject,__FUNCTION__) << "BEGIN" << endl;
	std::string path =  this->getObjectPath();
    int i;
    std::string num[NUMOFMAPTEX];


    for (i=0;i<NUMOFMAPTEX;i++)
        num[i]='0'+i;

    try {
        for (i=0;i<NUMOFMAPTEX;i++) {
            b_mapEl[i] = new SGF::CBitmap((path + "m" + num[i] + ".png").c_str());

			if (b_mapEl[i]->getError() )
                throw SMF::Exception::CGeneralError(num[i] + ": Failed to load map texture: "+(path + "m" + num[i] + ".png").c_str() + " - "+"SMF::Exception::CGeneralError: " + SDL_GetError() );
			else Debug::debug(Debug::gameObject,__FUNCTION__) << "Bitmap created: "<< num[i]<< " -> "<< (path + "m" + num[i] + ".png").c_str()<< endl;

            //set the transparent color key to RGB 255 0 255
            b_mapEl[i]->applyDefTrans();

            for (int j=0;j<4;j++) {
                Debug::debug(Debug::gameObject,__FUNCTION__) << "Criando Rotated Bitmaps" << endl;
				b_mapElRot[i][j] = new SGF::CBitmap(*b_mapEl[i],true);
				b_mapElRot[i][j]->applyDefTrans();
				b_mapElRot[i][j]->rotateFromBitmap((j+1)*90);


				Debug::debug(Debug::gameObject,__FUNCTION__) << "Rotated Bitmap created: texture:"<< b_mapElRot[i][j]->GetTexture()<< endl;
            }
        }
        for (i=1;i<5;i++) {
            foodObj[i] = new SGF::CBitmap((path + "o" + num[i] + ".png").c_str());
			if ( foodObj[i]->getError() )
                throw SMF::Exception::CGeneralError(num[i] + "Failed to load object texture");

           //set the transparent color key to RGB 255 0 255
            foodObj[i]->applyDefTrans();

        }
		
        Debug::debug(Debug::error,__FUNCTION__)<<"Field textures loaded"<<endl;
    }
    catch ( SMF::Exception::CGeneralError &err) {
        std::cerr << err.getFullReason().c_str();
       game.getGameControl()->setQuit(true);
        Debug::debug(Debug::error,__FUNCTION__)<< err.getFullReason() <<endl;
        return false;
    }
    catch ( ... ) {
        std::cerr << "Unexpected exception in BckgrObj::LoadTextures";
		game.getGameControl()->setQuit(true);
        Debug::debug(Debug::error,__FUNCTION__)<< "Unexpected error during Game()" <<endl;
        return false;
    }
	Debug::debug(Debug::gameObject,__FUNCTION__) << "END" << endl;
    return true;
}

BckgrObj::BckgrObj(std::string TexturesPath)
    : SGF::CBaseObject(SGF::CBaseObject::SGFElement),
	pacFoodCounter(0),
    fruitalpha(255),
    specialspawned(false),
    specialeaten(false),
    alpha(255)

{
	this->setObjectPath(TexturesPath);
	int i;

    for (i=0;i<10;i++) {
        b_mapEl[i]=NULL;
        foodObj[i]=NULL;
        for (int j=0;j<3;j++)
            b_mapElRot[i][j]=NULL;
    }
	load();
}

BckgrObj::~BckgrObj()
{
    int i;
	Debug::debug(Debug::gameEngine,__FUNCTION__) << " START DELETING BACKGRUND==========================" << endl;

    for (i=0;i<NUMOFMAPTEX;i++) {

        if ( b_mapEl[i] ) {
			Debug::debug(Debug::gameEngine,__FUNCTION__) << " DELETING MAPEL==========================" << endl;
			delete b_mapEl[i];
		}
        if ( foodObj[i] )  {
			Debug::debug(Debug::gameEngine,__FUNCTION__) << " DELETING FOODOBJ==========================" << endl;
			delete foodObj[i];
		}
        for (int j=0;j<3;j++)
            if ( b_mapElRot[i][j] ) {
				Debug::debug(Debug::gameEngine,__FUNCTION__) << " DELETING MAPELROT==========================" << endl;
				delete b_mapElRot[i][j];
			}
    }
	Debug::debug(Debug::gameEngine,__FUNCTION__) << " END DELETING BACKGRUND==========================" << endl;

}
