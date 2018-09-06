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
#ifndef sdl_joystick_h
#define sdl_joystick_h

#include <SDL.h>
#include "all.h"
#include "../SGF_Config.h"
#include "SGF_ButtonMapping.h"

using namespace std;
namespace SGF{

class CButtonMapping;

/**
 * \class CSDLJoystick
 *
 * \ingroup SGF_Input
 * 
 * \brief Controle do Joystick
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 05 de Janeiro de 2012
  */

class CSDLJoystick :public CJoystick {
public:
    virtual void poll();

	/** Este m�todo verifica o hardware do joystick, e se algum bot�o 
	* estiver precionado, hat ou motion, preenche um struct JoystickInput e retorna
	* um joystick do tipo PSX tem 12 bot�es
	* n�o computa o tempo que o bot�o ficou precionado
	*/
    virtual JoystickInput readAll();
   
	/** Retorna o ID do Joystick */
	virtual int getDeviceId() const;
	/** Adiciona um evento com o bot�o precionado
	* no vetor de eventos da classe friend CJoystick
	*/
    virtual void pressButton(int button);
    virtual void releaseButton(int button);
    /** Adiciona um evento de movimento de axis com qual axis foi
	* movimentada
	* no vetor de eventos da classe friend CJoystick
	* TODO: registrar a quandidade de movimento (motion)
	*/
	virtual void axisMotion(int axis, int motion);
	/** Adiciona um evento de movimento de hat 
	* no vetor de eventos da classe friend CJoystick
	* TODO: registrar a quandidade de movimento (motion)
	*/
	virtual void hatMotion(int motion);

    virtual ~CSDLJoystick();

    friend class CJoystick;
	/** Esta vari�vel armazena o n�mero de bot�es do joystick */
	int number_of_buttons;
    
	/** Esta vari�vel armazena o n�mero de axis do joystick 
	* Axis 0 � para dire��o direita e esquerda
	* Axis um � para dire��o cima e baixo 
	*/
	int number_of_axis;
    int number_of_balls;
    int number_of_hats;
protected:
	   /* convert buttons between what SGF wants and what sdl wants */
    int to_native_button(int button);
    int from_native_button(int button);
	Util::CReferenceCount<CButtonMapping> buttonMapping;
	SDL_Joystick *stick;
    CSDLJoystick(int id=0);
};
} //end SGF
#endif
