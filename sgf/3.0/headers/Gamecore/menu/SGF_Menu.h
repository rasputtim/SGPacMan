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
#ifndef _menu_h
#define _menu_h

#include <vector>
#include <string>
#include "../SGF_Config.h"

#include "../exceptions/all.h"
#include "../graphics/all.h"

#include "../gui/SGF_Box.h"
#include "SGF_StructsMenu.h"
#include "../util/SGF_Token.h"

#ifdef _MSC_VER
#ifndef uint32_t
	typedef unsigned __int32 uint32_t;
#endif
#endif

namespace SGF {
class CTTFFont;
class CBitmap;
class CMenuOption;
class Token;
class CMenuAnimation;
class COptionFactory;
class CGame;
namespace Menu {

/// Cria um Menu na Tela, de acordo com o arquivo de defini��o criado pelo usu�rio
/**
* Cria um Menu na Tela, de acordo com o arquivo de defini��o criado pelo usu�rio. 
* Com  a possibilidade de escolher as op��es selecionadas
* Construtores: tr�s construtores:
* O primeiro sem nenhum par�metro
* O segundo recebe um par�metro string, que � o nome do arquivo onde est�o os tokens que ser�o lidos e definir�o o formato do Menu
* O terceiro recebe um Token que j� foi lido 
*/
class  SGE_API CMenu {
public:

	CMenu(){} ///< Construtor 1, sem par�metros
	virtual ~CMenu(){} ///< Destrutor da Classe

    //! Menu Pai
    Menu::CMenu *parent;

private:

	string _name;
 
};
} //end namespace Menu
} //end SGF
#endif
