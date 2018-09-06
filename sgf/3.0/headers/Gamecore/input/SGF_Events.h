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
#ifndef _S_G_F_events_h
#define _S_G_F_events_h

/* handles global events from the system such as
 *   window manager events (press X button)
 *   keyboard/mouse/joystick input (for some backends like SDL)
 */

#include <vector>
#include "../SGF_Config.h"
#include "SGF_Keyboard.h"
#include "SGF_Mouse.h"
#include "SGF_Joystick.h"
#include "../util/SGF_Pointer.h"
#include "SGF_TextInput.h"

using namespace std;
namespace SGF{
namespace Util{
	class WaitThread;
}
namespace Input{


/**
 * \class CEventManager
 *
 * \ingroup SGF_Input
 * 
 * \brief Gerenciador de Eventos
 *
 * Recebe os eventos do gerenciador de eventos e tranforma em eventos SGF
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 05 de Janeiro de 2012
  */

class  SGE_API CEventManager{
public:

    CEventManager();
    virtual void run(CKeyboard & keyboard, map<int, Util::CSmartPtr_MT<CJoystick> > joysticks, Util::CSmartPtr_MT<CMouse> mouse,Util::CSmartPtr_MT<CTextInput> textinput);
	virtual void waitForThread(Util::Thread::WaitThread & thread);
    virtual ~CEventManager();

 //Mapeamento de teclas do teclado
#ifdef USE_SDL
    typedef SDL_Keycode KeyType;
#else
    typedef int KeyType;
#endif

    inline const vector<KeyType> & getBufferedKeys() const {
        return keys;
    }
    void deferResizeEvents(bool defer);
    void enableKeyBuffer();
    void disableKeyBuffer();

private:
    enum Event{
        CloseWindow,
        ResizeScreen,
        Key
    };
	 struct ResizeEvent{
        Event type;
        int width;
        int height;
        bool enable;
    };
    virtual void dispatch(Event type, int arg1, int arg2);
    virtual void dispatch(Event type, int arg1);
    virtual void dispatch(Event type);
	

#ifdef USE_SDL
    virtual void HandleEventInput(CKeyboard &, map<int, Util::CSmartPtr_MT<CJoystick> > joysticks, Util::CSmartPtr_MT<CMouse> mouse, Util::CSmartPtr_MT<CTextInput> textinput);
#endif

    vector<KeyType> keys;
    bool bufferKeys;
	bool deferResize;
    /* Only need the last event */
    ResizeEvent resize;
};


/**
 * \class CLogic
 *
 * \ingroup SGF_Input
 * 
 * \brief Loop de jogo padr�o
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 05 de Janeiro de 2012
  */
class  SGE_API CLogic{
public:
	enum type{
		PT_Logic = 0x0001,
		FPS_Dep_GS_Const=0x0002,   //O FPS depende de uma Game Speed Constante
		FPS_Dep_GS_Const_Adv = 0x0004,
		FPS_Dep_GF_Const_MAdv = 0x0008,
		GS_Dep_FPS_Var=0x00010,  // O Game Speed depende de uma FPS vari�vel
		GS_Dep_FPS_Var_Adv=0x00020,  // O Game Speed depende de uma FPS vari�vel
		GS_Const_FPS_Max=0x0040,
		GS_Const_InDep_FPS_Var=0x0080,  // O Game speed � constante, e n�o depende do FPS
		
	};
	CLogic(type _type=PT_Logic):m_logicType(_type){};
    /** roda um ciclo de l�gica do jogo */
    virtual void run(int delay=0) = 0;
    /**indica que o loop do jogo deve terminar */
    virtual bool done() = 0;

    /* retorna o n�mero de ticks l�gicos para um dado n�mero de
     * ticks reais.
     */
    virtual double ticks(double systemTicks) = 0;

    virtual ~CLogic();
	static unsigned long long int logicTime; //! registra o tempo que dura para roda a l�gica do jogo
	static int runCount; //registra quantas vezes a l�gica ser� executada antes do pr�ximo draw
    type m_logicType;
};

/**
 * \class CDraw
 *
 * \ingroup SGF_Input
 * 
 * \brief Loop de Desenho do Jogo na Tela Padr�o
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 05 de Janeiro de 2012
  */

class  SGE_API CDraw{
public:
	CDraw();
    /** \brief m�todo que desenha o jogo na tela 
	* \param fps: passa o valor de fps para o m�todo de desenhho. Evita o uso de um m�todo getFPS()
	*/
	virtual void draw(double fps=0) = 0;
    virtual ~CDraw();

	/* called by the standardLoop */
	/** \brief m�todo chamado dentro do loop para atualizar o n�mero de frames que est�o sendo desenhados
	*/
    virtual void updateFrames();
	/** brief m�todo que retorna o valor de Frames por segundo
	* \return n�mero de frames que est�o sendo desenhados por segundo
	*/
    virtual double getFps() const;
	static unsigned long long int frameTime; //! registra o tempo que dura para desenhar o jogo na tela

protected:
	//! vari�vel que guarda o n�mero de frames desenhados
	int frames;
    //! vari�vel que guarda o �ltimo c�lculo de frames por segundo realizado
    double fps;
	//! apenas um contador
	unsigned int contador;
	unsigned int delay; //! armazena o delay em ms
	unsigned int second_counter;
};

void SGE_standardLoop(CLogic & logic, CDraw & draw);

}
} //end SGF
#endif
