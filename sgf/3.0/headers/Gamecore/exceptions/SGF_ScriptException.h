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
#ifndef _SGF__script_exception_h
#define _SGF__script_exception_h

#include "all.h"
#include <string>
#include "../SGF_Config.h"
using namespace SMF::Exception;
using namespace std;
namespace SGF {
namespace Exception{
/**
 * \class CScriptException
 *
 * \ingroup SGF_Exceptions
 * 
 * \brief Excess�o de problema no MUGEN 
 *
 * Esta Excess�o � lan�ada quando ocorre algo errado na m�quina de Scripts 
 *
 * 
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 14 de Janeiro de 2014
  */

class  SGE_API CScriptException: public CBase {
public:
	CScriptException();
	CScriptException(const string reason );
	CScriptException(const string & file, const string function, int line, const string & reason);
    
	virtual ~CScriptException() throw();
    
        virtual CBase * copy() const;

        const string getFullReason() const;

        virtual void throwSelf() const {
            throw *this;
        }

	inline const string getReason() const{
            return _my_reason;
	}

protected:
        string _my_reason;
        string _my_file;
		string _my_function;
        int _my_line;
};




} //end namespace Exception
} //end namespace SGF
#endif
