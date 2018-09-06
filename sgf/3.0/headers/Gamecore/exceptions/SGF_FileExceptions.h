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
#ifndef _SGF_File_Exceptions_h
#define _SGF_File_Exceptions_h

#include <string>
#include "../SGF_Config.h"
#include "all.h"

using namespace SMF;
using namespace std;
namespace SGF {
	namespace Exception{
		namespace Filesystem {

			   class  SGE_API CException: public SMF::Exception::CBase {
    public:
        CException(const string & where, int line, const string & file);
        CException(const string & where, int line, const SMF::Exception::CBase & nested, const string & file);
        CException(const CException & copy);
        virtual ~CException() throw ();
        virtual void throwSelf() const {
            throw *this;
        }

    protected:
        virtual const string getReason() const;

        virtual SMF::Exception::CBase * copy() const {
            return new CException(*this);
        }

    private:
        string reason;
    };

    class  SGE_API CNotFound: public CException {
    public:
        CNotFound(const string & where, int line, const string & file);
        CNotFound(const string & where, int line, const SMF::Exception::CBase & nested, const string & file);
        virtual ~CNotFound() throw();
        CNotFound(const CNotFound & copy);
        virtual void throwSelf() const {
            throw *this;
        }
    protected:
        virtual SMF::Exception::CBase * copy() const {
            return new CNotFound(*this);
        }
    };

  
  	class Eof: public ::std::exception {
        public:
            Eof(){
            }

            virtual ~Eof() throw (){
            }
    };

		}//end Filesystem
	} //end Exceptions
} //end SGF
#endif