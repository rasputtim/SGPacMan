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
#ifndef _S_G_F_parameter_h
#define _S_G_F_parameter_h
#include "../SGF_Config.h"
#include "../util/SGF_Pointer.h"

/* par�metros devem ser utilizados para controlar a dimens�o din�mica dos valores.
 * valores podem ser inseridos na dimens�o actual e s�o automaticamente retirados
 * Ap�s o retorno da fun��o.
 * � similar a 'parameters' na linguagem Racket (http://racket-lang.org/)
 *
 * Esta classe n�o � thread safe ainda.
 */

#include <vector>


using namespace std;
namespace SGF{
namespace Util{


/**
 * \class CParameter
 *
 * \ingroup SGF_Data_Structures
 *
 * \brief Template para uma Pilha de tipo Gen�rico
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \note sintaxe:  template <> vector<int> Parameter<int>::stack;
 * semelhante a 'parameters' no Racket.
 * http://docs.racket-lang.org/reference/eval-model.html#%28part._parameter-model%29
 * n�o � thread safe.
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 04 de Janeiro de 2012
 */
template <class Value>
class  SGE_API CParameter{
public:
    /** \brief adiciona um novo valor � pilha
	* \param what: objeto a ser adicionado � pilha
	*/
    CParameter(CParameter & parent, const Value & what):
    stack(parent.stack),
    items(0){
        push(what);
    }

    CParameter(CParameter & parent):
    stack(parent.stack),
    items(0){
    }

    CParameter():
    items(0){
        stack = new vector<Value>();
    }


    ~CParameter(){
        for (int i = 0; i < items; i++){
            if (stack->size() > 0){
                stack->pop_back();
            }
        }
    }

	/** \brief adiciona um valor na pilha
	* \param what: objeto a ser adicionado na pilha
	*/
    void push(const Value & what){
        items += 1;
        stack->push_back(what);
    }

    /** \brief pega o valor atual */
    Value current(){
        if (stack->size() > 0){
            return stack->back();
        }
        return Value();
    }

 CReferenceCount<vector<Value> > stack;

protected:
    /** n�mero de coisas adicionadas � pilha por este objeto
	* \note este n�o � o n�mero de itens na fila, porque se h� multiplos
	* objetos CParameter, ent�o cada um deles pode inserir 1 objeto. Assim
	* a pilha ter� v�rios objetos, mas cada CParameter ter� um item = 1.
	*/


 int items;
};

}
  } //end namespace SGF
#endif
