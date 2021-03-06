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
#ifndef _SGF__token_exception_h
#define _SGF__token_exception_h

#include <string>
#include "../SGF_Config.h"
#include "all.h"

using namespace SMF;
namespace SGF {
/**
 * \class CTokenException
 *
 * \ingroup SGF_Exceptions
 * 
 * \brief excess�o de tratamento de Tokens 
 *
 * Esta excess�o ocorre no tratamento de Tokens
 * 
 *
 * 
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 04 de Janeiro de 2012
  */
class  SGE_API CTokenException : public SMF::Exception::CBase {
public:
    CTokenException(const string & file, int line, const string reason = "");
    CTokenException(const CTokenException & copy);
    CTokenException(const SMF::Exception::CBase & base);

    virtual ~CTokenException() throw();

    virtual void throwSelf() const {
        throw *this;
    }

protected:

	virtual SMF::Exception::CBase * copy() const;
    virtual inline const string getReason() const {
        return reason;
    }
        string reason;
};
} //end SGF
#endif
