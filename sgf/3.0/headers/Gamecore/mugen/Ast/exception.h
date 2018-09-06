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
#ifndef _S_G_E_ast_exception_h
#define _S_G_E_ast_exception_h

#include <exception>
#include "../../exceptions/all.h"
#include "../../SGF_Config.h"


#include <string>

using namespace std;
namespace SGF{

namespace Ast{
class  SGE_API CException: public ::SGF::CMugenException {
public:
    CException(const string & str):
        CMugenException(str){
    }

    virtual ~CException() throw (){
    }

};
} //end AST
} //end SGF
#endif
