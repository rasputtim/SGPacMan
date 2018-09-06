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
#ifndef _time_difference_h
#define _time_difference_h

#include <time.h>
//#include <sys/time.h>
#include <string>
#include "../SGF_Config.h"

using namespace std;
namespace SGF {

/**
 * \class TimeDifference
 *
 * \ingroup SGF_Util
 * 
 * \brief Calcula diferença de tempo entre dois momentos
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \note sintaxe:  template <> vector<int> Parameter<int>::stack;
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 04 de Janeiro de 2012
 */
class  SGE_API TimeDifference{
public:

	/**
	\brief construtor
	**/
	TimeDifference();

	/** 
	\bief inicia a contagem de tempo
	**/
	void startTime();
	/**
	\brief ermina a contagem de tempo
	**/
	void endTime();

	/**
	\brief retorna o tempo decorrido entre a chamada do método startTime e o método endTime
	**/
	unsigned long long int getTime();

	const string printTime();
	const string printTime( const string & s );

	~TimeDifference();

protected:
	unsigned long long start, end;

};
} //end SGF
#endif
