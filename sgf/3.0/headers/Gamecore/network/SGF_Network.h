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
#ifndef _S_G_F_network_h
#define _S_G_F_network_h

#include <stdint.h>

#include <string>
#include <vector>
#include <exception>
#include "../SGF_Config.h"
#include "../exceptions/SGF_NetException.h"

#ifdef HAVE_NETWORKING
#include "../../ExternalLibs/hawknl/hawknl/nl.h"
#endif





using namespace std;
namespace SGF{

namespace Network{
#ifdef HAVE_NETWORKING
typedef NLsocket Socket;
typedef NLaddress IPAddress;
#else
typedef int Socket;
#endif


const int NO_CONNECTIONS_PENDING = 1;
const int NETWORK_ERROR = 2;

const int DATA_SIZE = 16;

enum Focus{
    INPUT_BOX,
    START_GAME,
    QUIT
};

struct Message{
	Message();
	Message( const Message & m );
	Message( Socket socket );

	uint32_t id;
	uint8_t data[ DATA_SIZE ];
	uint8_t * position;

	Message & operator=( const Message & m );
	Message & operator<<( int x );
	Message & operator<<( unsigned int x );
	Message & operator<<( string p );
	Message & operator>>( int & x );
	Message & operator>>( unsigned int & x );
    Message & operator>>(string & out);

	int size() const;
	uint8_t * dump( uint8_t * buffer ) const;
	/** \brief envia a mensagem atrav�s do socket
	\param socket: socket por onde a mensagem ser� enviada
	*/
	void send( Socket socket ) const;
	void reset();

	string path;

        /* time in microseconds
         * a 64-bit variable can hold
         *                     us     ms     s    m    h    d
         *  years = 2**64.0 / (1000 * 1000 * 60 * 60 * 24 * 365)
         *  years = 584942.417355072
         * worth of microseconds
         */
        uint64_t timestamp;
        Socket readFrom;
};

/*
template <class M>
int totalSize(const vector<M> & messages);

template <class M>
void dump(const vector<M> & messages, uint8_t * buffer );
*/

#ifdef HAVE_NETWORKING

/** \brief envia todas as mensagens atrav�s do socket
\param messages: vetor com as mensagens a serem enviadas
\param socket: socket pelo qual as mensagens ser�o enviadas
*/
void sendAllMessages(const vector<Message> & messages, Socket socket);
/** \brief envia todas as mensagens atrav�s do socket
\param messages: vetor com as mensagens a serem enviadas
\param socket: socket pelo qual as mensagens ser�o enviadas
*/
void sendAllMessages(const vector<Message*> & messages, Socket socket);

/** \brief l� bytes atrav�s do socket
\param socket: socket ao qual os dados ser�o enviados
*/
int8_t read8(Socket socket);

/** \brief l� palavras (2bytes) atrav�s do socket
\param socket: socket ao qual os dados ser�o enviados
*/
int16_t read16( Socket socket );

/** \brief l� words (4 bytes) atrav�s do socket
\param socket: socket ao qual os dados ser�o enviados
*/
int32_t read32( Socket socket );


char * dump16(char * where, int16_t length);

/** \brief envia palavras (2bytes) atrav�s do socket
\param socket: socket ao qual os dados ser�o enviados
\param bytes: buffer com os bytes que ser�o enviados
*/
void send16( Socket socket, int16_t bytes );

/** \brief l� uma string atrav�s do socket especificado
\param socket: socket ao qual a string ser� lida
\param length: tamanho da string que ser� lida
\note um socket deve estar conectado (connect) antes de utilizar readStr.
*/
/* Reads a string by expecting the string to be terminated with a null byte */

string readStr( Socket socket, const uint16_t length );

/** \brief envia uma string atrav�s do socket especificado
\param socket: socket ao qual os dados ser�o enviados
\param str: string a ser enviada
\note um socket deve estar conectado (connect) antes de utilizar sendStr.
*/
/* This will send a string plus its null byte. If you just wanted to send the string
 * without a null byte then use sendBytes(socket, str.c_str(), str.size())
 */
void sendStr( Socket socket, const string & str );

/* Copies the string plus its null byte to the `where' buffer.
 * Returns a pointer that is where + str.size() + 1
 */
char * dumpStr(char * where, const string & str);
char * parse16(char * where, uint16_t * out);
/* Reads a string into 'out' from 'where' that is expected to be 'length' bytes.
 * Right now the function lies, it just does *out = string(where) so if the actual
 * string is longer than 'length' the returned pointer will be into the middle
 * of the 'where' buffer.
 */
char * parseString(char * where, string * out, uint16_t length);

/** \brief envia bytes atrav�s do socket especificado
\param socket: socket ao qual os dados ser�o enviados
\param data: ponteiro bara um buffer onde os dados ser�o armazenados
\param length: tamanho do buffer de leitura
\note um socket deve estar conectado (connect) antes de utilizar sendBytes.
*/
void sendBytes( Socket socket, const uint8_t * data, int length );

void sendBytes( Socket socket, const void * data, int length );


/** \brief l� bytes do socket especificado
\param socket: socket ao qual os dados ser�o lidos
\param data: ponteiro bara um buffer onde os dados ser�o armazenados
\param length: tamanho do buffer de leitura
\note um socket deve estar conectado (connect) antes de utilizar readBytes.
*/
void readBytes( Socket socket, uint8_t * data, int length );

void readBytes( Socket socket, void* data, int length );

/** \brief l� bytes do socket especificado at� um n� maxmimo
\param socket: socket ao qual os dados ser�o lidos
\param data: ponteiro bara um buffer onde os dados ser�o armazenados
\param Maxlength: n� maximo de bytes a serem lidos
\note um socket deve estar conectado (connect) antes de utilizar readBytes.
\note esta fun��o n�o � bloqueante, ou seja se n�o tiver dados a ler ela retorna
*/
int tryReadBytes( Socket socket, void * data, int Maxlength );

/** \brief inicializa o m�dulo NetworK
* \ note antes de utilizar qualquer fun�o deste m�dulo � necess�rio inicializ�-lo
* \return verdadeiro se sucesso
*/
int init();
/** \brief desliga o m�dulo network */
void shutdown();

/** \brief habilita ou desabilita blocking dos sockets
* \param b: true para habilitar o blocking e false para desabilitar
* \ note se habilitado, todas as chamadas aos sockets ir�o bloquear at� que completas.
*/
void blocking( bool b );
/* Enable/disable blocking for a specific socket */
bool blocking(Socket s, bool b);
/* Enable/disable NODELAY -- the Nagle algorithm for TCP */
bool noDelay(Socket s, bool b);

/**
\brief habilita um socket a esperar por conex�es e ent�o aceitar conex�es atrav�s do m�todo acept.
\param s: especifica um socket parra habilitar a espera
*/
void enableListen( Socket s ) throw(Exception::CNetworkException );

/**
\brief retorna um novo objeto do tipo Socket se uma nova conex�o for aceita.
\param s: especifica um objeto socket pronto para aceitar conex�es de entrada
\note O socket retornado s� ir� receber pacotes do n� remoto ao qual ele foi conectado. 
\note As conex�es de entrada j� devem estar habilitadas pela chamada do m�todo listen.
\return Se nenhum erro ocorrer retorna um novo Socket
*/
Socket acceptConnections( Socket s ) throw( Exception::CNetworkException );
/** \brief abre um socket na porta especificada
* \param port: a porta na qual se deseja abrir um socket
*/
Socket openSocket( int port ) throw( Exception::CInvalidPortException );
/** \brief conecta com um servidor numa determinada porta
* \param server: o servidor com o qual se deseja conectar
* \param port: a porta na qual se deseja conectar
*/
Socket connectTo( string server, int port ) throw ( Exception::CNetworkException );
/** \brief fecha o socket
\paran Socket: socket a ser fechado
*/
void closeSocket( Socket );
/** \brief fecha todos os sockets 
*/
void closeAll();

/** \brief converte endere�i IP para string
\param address: ponteiro para o endere�o IP a ser preenchido
\param name: ponteiro para a string com o nme a ser procurado
*/
void ResolveHost(const char *name, IPAddress *address);
/** \brief converte endere�i IP para string
\param address: ponteiro para o endere�o IP a ser convertido
\param string: ponteiro para a string a ser preenchida
*/
void NetAddrToString(IPAddress *address, const char *string );
#if 0
struct IPaddress{
	IPaddress():
	host(0),			/* 32-bit IPv4 host address */
	port(0)
	{};
	IPaddress & operator = ( const  IPaddress &source ){
		//if (&source == this) return *this;
		host=source.host;			/* 32-bit IPv4 host address */
		port=source.port;
		return *this;
	};
	Uint32 host;			/* 32-bit IPv4 host address */
	Uint16 port;			/* 16-bit protocol port */

};
#endif
//IPaddress getRemoteAddress(Socket);
string getRemoteAddressStr(Socket sock);

//! lista com todos os sockets abertos
static vector< Socket > open_sockets;
#endif

}
} //end SGF
#endif
