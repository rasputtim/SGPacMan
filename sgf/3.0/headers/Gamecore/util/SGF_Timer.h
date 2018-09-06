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
#ifndef _util_timer_h
#define _util_timer_h
#include <iostream>
#include <vector>
#include "../SGF_Config.h"
#include "SGF_Thread.h"

using namespace std;
namespace SGF {
	class CSysVar;
namespace Util{

 typedef void (*timeout)(void * arg);
 typedef void (*callbackTimerFunc)();
   

/**
 * \class CTimer
 *
 * \ingroup SGF_Util
 * 
 * \brief Chama uma função ou método depois de X segundos a menos que stop() seja chamado antes
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
class  SGE_API CTimer{
public:
    
	/**
	\brief cria um timer que roda num thread separado
	\param seconds_to_wait tempo que demorará em segundos até o timer executar o função de callback
	\param func função de callback a ser executada
	\arg argumento da função func
	**/
	CTimer(unsigned int seconds_to_wait, timeout func, void * arg);
    /**
	\brief para o timer
	**/
    void stop();
	/**
	\brief método que roda no thread criado pelo timer, o qual executa a espera e chama a função callback quando o tempo expira
	**/
    friend void * do_wait(void * timer_);

protected:
    unsigned int wait;
    timeout func;
    void * arg;
    bool stopped;
    Thread::Lock lock;
    Thread::ThreadId_t timer;
};

struct TimerI_s{
	TimerI_s(int freq, int tipo):frequency(freq), _my_type(tipo),changeDelay(false){

	}
    int frequency;
	Util::Thread::ThreadId_t my_thread;
	int _my_type;
	bool changeDelay;
};
struct TimerInfo: public TimerI_s{
    TimerInfo( callbackTimerFunc pFunctionPointer, int y):
        TimerI_s(y,2),callBackFunc(NULL){callBackFunc=pFunctionPointer;}

    callbackTimerFunc callBackFunc;
    
	
};

struct TimerInfoWithArgs: public TimerI_s{
    TimerInfoWithArgs( timeout pFunctionPointer, void * args,int y):
        TimerI_s(y,1),callBackFunc(NULL), arg(args){callBackFunc=pFunctionPointer;}

    timeout callBackFunc;
	void * arg;
    
	
};

/**
 * \class CEventTimer
 *
 * \ingroup SGF_Util
 * 
 * \brief Chama uma função ou método periódicamente, após um intervalo de tempo, chamado de frequência
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 04 de Janeiro de 2012
 */
class  SGE_API CEventTimer{
public:
    
	/**
	\brief cria um timer periódico que roda num thread separado
	\param frequencia frequencia em Hz (vezes por segundo) que o callback deverá ser acionado
	\param func função de callback a ser executada
	\arg argumento da função func
	**/
	CEventTimer(string timername, unsigned int frequencia, timeout func, void * arg);
    /**
	\brief cria um timer periódico que roda num thread separado
	\param frequencia frequencia em Hz (vezes por segundo) que o callback deverá ser acionado
	\param func função de callback a ser executada
	**/
	CEventTimer(string timername, unsigned int frequencia, callbackTimerFunc func);
    

	/**
	\brief inicia os timers configurados
	**/
	void startTimer();
	/**
	\brief para todos os timers cadastrados no vetor running_timers
	**/
	static void stopTimers();
	/**
	\brief para o timer
	**/
    void stop();
	/**
	\brief muda o valor da frequência deste timer
	\param newValue novo valor a ser configurado para o timer
	**/
    void changeTimer(int newValue);
	/**
	\brief muda o valor da frequência deste timer de acordo com a Variavel de Sistema passada
	\param varName variável que será utilizada para configurr o valor da frequencia do timer
	**/
	void changeTimer(CSysVar & varName);

static	Util::Thread::ThreadBoolean run_timer_guard;
		
protected:
    static volatile bool run_timer;
    
	unsigned int _my_freq;
	//! função de callback número 1,com argumentos
    timeout _my_funcVoidArg;
	//! argumento da função de callback func
	void * _my_arg;
	//! função de callback numero 2, sem argumentos
	callbackTimerFunc _my_funcNoArg;
	//!save the callbacktype function to use: 1-> com argumentos e 2-> sem argumentos
	int _my_type;
    
	static	Thread::Lock run_timer_lock;
	
	static map <string,  TimerI_s *> running_timers;
private:
	static bool _my_Lock_initialized;
	static bool _my_SGF_timers_initialized;
	TimerI_s * _my_Timer;
	string _my_name;

};


}



} //end SGF
#endif
