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
#ifndef _S_G_F_text_input_h
#define _S_G_F_text_input_h

#include <sstream>
#include <string>
#include <map>
#include "../SGF_Config.h"
#include "SGF_InputMap.h"
#include "../util/SGF_Callback.h"
#include "../util/SGF_Pointer.h"
#include "SGF_Keyboard.h"
#include "SGF_Joystick.h"

namespace SGF{




/**
 * \class CTextInput
 *
 * \ingroup SGF_Input
 *
 * \brief ...
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 05 de Janeiro de 2012
  */

class  SGE_API CTextInput: public CInputMap<unsigned char> {
public:
	/** \brief cria um objeto CTextInput
	* \param start:  uma string inicial
	*/
    CTextInput(const string & start = "");

    /* returns true if the text was modified */
	//! CTRL + U = LIMPA O TEXTO
	//! CTRL + D = Deleta ultima palavra digitada
    bool doInput();
    void enable();
    void disable();
	//! Guarda as informa��es de evento enviadas pelo gerenciador de eventos
    struct Event{
        Event():
        start(0),
		text(""),
        length(0),
		windowID(0),
		 editing(false){
        }
		//!construtor de textedit event
		Event(string text, bool editing, int start, int lenght):
        start(start),
		text(text),
		length(lenght),
		windowID(0),
		editing(editing){
		text=text;
        }
		//!construtor de textinput event
		Event(string text, Uint32 windowID):
        start(0),
		text(text),
        length(0),
		windowID(windowID),
		editing(false){
		}

		int start; //O in�cio do cursor de edi��o do texto
		string text;//!O Texto de entrada recebido pelo gerenciador de eventos,
		int length; //! O tamanho do texto sendo editado
		Uint32 windowID; //!A janela que tem o foco do teclado
        //! Se o texto est� sendo editado ou n�o */
        bool editing;
    };
	/** \brief registra um evento de entrada de texto
	* \param text[]: o texto
	* \param windowID: a janela com o  foco
	*/
	void press(const char text[], Uint32 windowID);
	/** \brief registra um evento de edi��o de texto
	* \param text[]: o texto sendo editado
	* \param windowID: a janela com o  foco
	*/
	void edit(const char text[],int start, int lenght, Uint32 windowID);
	/** \brief adiciona um m�todo de callback para um determinado input
	* \param key:  a tecla que ao ser pressionada deve executar o m�todo de callback
	* \param delay: o delay da tecla pressionada
	* \param function: a fun��o de callback
	* \param data: os par�metros a serem passados para a fu��o de callback
	* \param replaceKey: true para trocar a chave caso haja duplica��o e false para adicionar uma chave duplicada
	*/
	void addHandle(CKeyboard::Key key, int delay, callbackVoid_t function, void * data, bool replaceKey=false);
	/** \brief adiciona um m�todo de callback para um determinado input
	* \param key:  a tecla que ao ser pressionada deve executar o m�todo de callback
	* \param function: a fun��o de callback
	* \param data: os par�metros a serem passados para a fu��o de callback
	* \param replaceKey: true para trocar a chave caso haja duplica��o e false para adicionar uma chave duplicada
	*/
	void addBlockingHandle(CKeyboard::Key key, callbackVoid_t function, void * data, bool replaceKey=false);
	/** \brief adiciona um m�todo de callback para um determinado input de joystick
	* \param key:  a tecla que ao ser pressionada deve executar o m�todo de callback
	* \param function: a fun��o de callback
	* \param data: os par�metros a serem passados para a fu��o de callback
	*/
	void addBlockingJoystickHandle(CJoystick::Key key, callbackVoid_t function, void * data);

    inline void setBlockingKeys(){
        blockingKeys = true;
    }

    string getText() const;
    void setText(const string & text);

	/** \brief limpa o texto */

    void clearInput();

	/** \brief indica se o textinput est� habilitado ou n�o */
    bool isEnabled() const {
        return enabled;
    }
	/** \brief a��o a ser executada quando o backspace � pressionado */
    void backspace();
	/** \brief deleta a �ltima palavra do texto */
    void deleteLastWord();
    /* \brief retorna o estado de uma tecla e um evento
	* \param key: a tecla a qual se deseja saber o estado
	*/
/*  
	Util::CReferenceCount<KeyState<unsigned char> > getState(CKeyboard::Key key,int handle){
       Util::CReferenceCount<KeyState<unsigned char>> state = CInputMap<unsigned char>::getState(key);
        if (state == NULL){
            if (blockingKeys){
                set(key, 0, true, key);
            } else {
                set(key, 10, false, key);
            }
            state = CInputMap<unsigned char>::getState(key);
        }
        return state;
    }
	*/
    virtual ~CTextInput();
	void Lock() { textinputLock.acquire();}
	void Unlock() { textinputLock.release();}
protected:
	Util::Thread::LockObject textinputLock;
    int nextHandle();

    ::std::ostringstream text;
    /* whether key repeat is on or off */
    bool blockingKeys;
	bool enabled;
    map<int, CallbackVoid> callbacks;
	int handle;
	//map<Uint32, Event> textState;
	Event textState[4]; //para at� 4 janelas
};
} //end SGF
#endif
