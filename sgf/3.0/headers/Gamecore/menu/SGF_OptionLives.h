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
#ifndef _option_lives_h
#define _option_lives_h

#include "SGF_MenuOption.h"
#include "SGF_MenuV2.h"
using namespace std;
namespace SGF {


class CToken;
namespace Menu {
	class CMenuOption;
/*! Handles key reconfiguration */
class  SGE_API COptionLives : public CMenuOption{
public:
    // Do logic before run part
    virtual void logic();

    // Finally it has been selected, this is what shall run 
    // endGame will be set true if it is a terminating option
    //virtual void run(bool &endGame);
	virtual void run(const Menu::CContext &);
	virtual void load(const Token *token)throw( CLoadException ) {};
    // This is to pass paramaters to an option ie a bar or something
    virtual bool leftKey();
    virtual bool rightKey();
    
    virtual string getText();

    COptionLives(const Gui::CContextBox & parent,const Token *token)throw( CLoadException );

    virtual ~COptionLives();
private:
    int lblue, lgreen;
    int rblue, rgreen;
};
}
} //end SGF
#endif

