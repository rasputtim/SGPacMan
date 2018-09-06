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


#ifndef __SGF_HASHTABLE_H__
#define __SGF_HASHTABLE_H__

#include "../SGF_Config.h"
#include "../util/SGF_HashUtils.h"
namespace SGF {
/**
===============================================================================

	General hash table. Slower than idHashIndex but it can also be used for
	linked lists and other data structures than just indexes or arrays.

===============================================================================
http://www.ime.usp.br/~pf/mac0122-2002/aulas/hashing.html
http://pt.wikipedia.org/wiki/Tabela_de_dispers%C3%A3o

Uma tabela de dispens�o (= hash table) � uma maneira muito popular de organizar
uma tabela de s�mbolos. Pode-se dizer que tabelas de dispers�o s�o uma generaliza��o
do id�ia de endere�amento direto.

Em ci�ncia da computa��o, uma tabela de dispers�o
(tamb�m conhecida por tabela de espalhamento ou tabela hash, do ingl�s hash)
� uma estrutura de dados especial, que associa chaves de pesquisa a valores.
Seu objetivo �, a partir de uma chave simples, fazer uma busca r�pida e obter
o valor desejado. � algumas vezes traduzida como tabela de escrut�nio.
A fun��o de espalhamento ou fun��o de dispers�o � a respons�vel por gerar um �ndice a partir de determinada chave.
Caso a fun��o seja mal escolhida, toda a tabela ter� um mau desempenho.

O ideal para a fun��o de espalhamento � que sejam sempre fornecidos �ndices �nicos
para as chaves de entrada. A fun��o perfeita seria a que, para quaisquer entradas A e B, sendo A diferente de B,
fornecesse sa�das diferentes. Quando as entradas A e B s�o diferentes e, passando pela
fun��o de espalhamento, geram a mesma sa�da, acontece o que chamamos de colis�o.

Na pr�tica, fun��es de espalhamento perfeitas ou quase perfeitas s�o encontradas
apenas onde a colis�o � intoler�vel (por exemplo, nas fun��es de dispers�o da
criptografia), ou quando conhecemos previamente o conte�do da tabela armazenada.
Nas tabelas de dispers�o comuns a colis�o � apenas indesej�vel, diminuindo o
desempenho do sistema. Muitos programas funcionam sem que seu respons�vel suspeite
que a fun��o de espalhamento seja ruim e esteja atrapalhando o desempenho.

Por causa das colis�es, muitas tabelas de dispers�o s�o aliadas com alguma outra
estrutura de dados, tal como uma lista encadeada ou at� mesmo com �rvores balanceadas.
Em outras oportunidades a colis�o � solucionada dentro da pr�pria tabela.

Colis�es

A fun��o de dispers�o pode calcular o mesmo �ndice para duas chaves diferentes,
uma situa��o chamada colis�o.
Por conta disso, a fun��o deve ser projetada para evitar ao m�ximo a ocorr�ncia
de colis�es. Por mais bem projetada que seja a fun��o de dispers�o, sempre haver�
colis�es. A estrutura de dispers�o utiliza mecanismos para tratar as colis�es, que
dependem de caracter�sticas da tabela usada.

Um bom m�todo de resolu��o de colis�es � essencial, n�o importando a qualidade da
fun��o de espalhamento. Considere um exemplo derivado do paradoxo do anivers�rio:
mesmo que considerarmos que a fun��o selecionar� �ndices aleat�rios uniformemente
em um vetor de um milh�o de posi��es, h� uma chance de 95% de haver uma colis�o
antes de inserirmos 2500 registros.
*/

template< class ItemType >
class CHashTable {
public:
					CHashTable( int newtablesize = 256 );
					CHashTable( const CHashTable<ItemType> &map );
					~CHashTable();

					// returns total size of allocated memory
	size_t			getAllocatedMem() const;
					// returns total size of allocated memory including size of hash table type
	size_t			getSize() const;

	void			set( const char *key, ItemType &value );
	bool			get( const char *key, ItemType **value = NULL ) const;
	bool			remove( const char *key );

	void			clear();
	void			deleteContents();

					// the entire contents can be itterated over, but note that the
					// exact index for a given element may change when new elements are added
	int				getNum() const;
	ItemType *			getIndex( int index ) const;

	int				getSpread() const;

private:
	struct hashnode_s {
		CMyString		key;
		ItemType		value;
		hashnode_s *next;

		hashnode_s( const CMyString &k, ItemType v, hashnode_s *n ) : key( k ), value( v ), next( n ) {};
		hashnode_s( const char *k, ItemType v, hashnode_s *n ) : key( k ), value( v ), next( n ) {};
	};

	hashnode_s **	heads;

	int				m_iTablesize;
	int				m_iNumentries;
	int				m_iTablesizemask;
	int				getHash( const char *key ) const;
};

/*
================
CHashTable<ItemType>::CHashTable
================
*/
template< class ItemType >
SGF_INLINE_FORCED CHashTable<ItemType>::CHashTable( int newtablesize ) {

	assert( MATH::CMath::IsPowerOfTwo( newtablesize ) );

	m_iTablesize = newtablesize;
	assert( m_iTablesize > 0 );

	heads = new hashnode_s *[ m_iTablesize ];
	memset( heads, 0, sizeof( *heads ) * m_iTablesize );

	m_iNumentries		= 0;

	m_iTablesizemask = m_iTablesize - 1;
}

/*
================
CHashTable<ItemType>::CHashTable
================
*/
template< class ItemType >
SGF_INLINE_FORCED CHashTable<ItemType>::CHashTable( const CHashTable<ItemType> &map ) {
	int			i;
	hashnode_s	*node;
	hashnode_s	**prev;

	assert( map.m_iTablesize > 0 );

	m_iTablesize		= map.m_iTablesize;
	heads			= new hashnode_s *[ m_iTablesize ];
	m_iNumentries		= map.m_iNumentries;
	m_iTablesizemask	= map.m_iTablesizemask;

	for( i = 0; i < m_iTablesize; i++ ) {
		if ( !map.heads[ i ] ) {
			heads[ i ] = NULL;
			continue;
		}

		prev = &heads[ i ];
		for( node = map.heads[ i ]; node != NULL; node = node->next ) {
			*prev = new hashnode_s( node->key, node->value, NULL );
			prev = &( *prev )->next;
		}
	}
}

/*
================
CHashTable<ItemType>::~CHashTable<ItemType>
================
*/
template< class ItemType >
SGF_INLINE_FORCED CHashTable<ItemType>::~CHashTable() {
	clear();
	delete[] heads;
}

/*
================
CHashTable<ItemType>::getAllocatedMem
================
*/
template< class ItemType >
SGF_INLINE_FORCED size_t CHashTable<ItemType>::getAllocatedMem() const {
	return sizeof( heads ) * m_iTablesize + sizeof( *heads ) * m_iNumentries;
}

/*
================
CHashTable<ItemType>::getSize
================
*/
template< class ItemType >
SGF_INLINE_FORCED size_t CHashTable<ItemType>::getSize() const {
	return sizeof( CHashTable<ItemType> ) + sizeof( heads ) * m_iTablesize + sizeof( *heads ) * m_iNumentries;
}

/*
================
CHashTable<ItemType>::getHash
================
*/
template< class ItemType >
SGF_INLINE_FORCED int CHashTable<ItemType>::getHash( const char *key ) const {
	return ( Util::getHash( key ) & m_iTablesizemask );
}

/*
================
CHashTable<ItemType>::set
================
*/
template< class ItemType >
SGF_INLINE_FORCED void CHashTable<ItemType>::set( const char *key, ItemType &value ) {
	hashnode_s *node, **nextPtr;
	int hash, s;

	hash = getHash( key );
	for( nextPtr = &(heads[hash]), node = *nextPtr; node != NULL; nextPtr = &(node->next), node = *nextPtr ) {
		s = node->key.Cmp( key );
		if ( s == 0 ) {
			node->value = value;
			return;
		}
		if ( s > 0 ) {
			break;
		}
	}

	m_iNumentries++;

	*nextPtr = new hashnode_s( key, value, heads[ hash ] );
	(*nextPtr)->next = node;
}

/*
================
CHashTable<ItemType>::get
================
*/
template< class ItemType >
SGF_INLINE_FORCED bool CHashTable<ItemType>::get( const char *key, ItemType **value ) const {
	hashnode_s *node;
	int hash, s;

	hash = getHash( key );
	for( node = heads[ hash ]; node != NULL; node = node->next ) {
		s = node->key.Cmp( key );
		if ( s == 0 ) {
			if ( value ) {
				*value = &node->value;
			}
			return true;
		}
		if ( s > 0 ) {
			break;
		}
	}

	if ( value ) {
		*value = NULL;
	}

	return false;
}

/*
================
CHashTable<ItemType>::getIndex

the entire contents can be itterated over, but note that the
exact index for a given element may change when new elements are added
================
*/
template< class ItemType >
SGF_INLINE_FORCED ItemType *CHashTable<ItemType>::getIndex( int index ) const {
	hashnode_s	*node;
	int			count;
	int			i;

	if ( ( index < 0 ) || ( index > m_iNumentries ) ) {
		assert( 0 );
		return NULL;
	}

	count = 0;
	for( i = 0; i < m_iTablesize; i++ ) {
		for( node = heads[ i ]; node != NULL; node = node->next ) {
			if ( count == index ) {
				return &node->value;
			}
			count++;
		}
	}

	return NULL;
}

/*
================
CHashTable<ItemType>::remove
================
*/
template< class ItemType >
SGF_INLINE_FORCED bool CHashTable<ItemType>::remove( const char *key ) {
	hashnode_s	**head;
	hashnode_s	*node;
	hashnode_s	*prev;
	int			hash;

	hash = getHash( key );
	head = &heads[ hash ];
	if ( *head ) {
		for( prev = NULL, node = *head; node != NULL; prev = node, node = node->next ) {
			if ( node->key == key ) {
				if ( prev ) {
					prev->next = node->next;
				} else {
					*head = node->next;
				}

				delete node;
				m_iNumentries--;
				return true;
			}
		}
	}

	return false;
}

/*
================
CHashTable<ItemType>::clear
================
*/
template< class ItemType >
SGF_INLINE_FORCED void CHashTable<ItemType>::clear() {
	int			i;
	hashnode_s	*node;
	hashnode_s	*next;

	for( i = 0; i < m_iTablesize; i++ ) {
		next = heads[ i ];
		while( next != NULL ) {
			node = next;
			next = next->next;
			delete node;
		}

		heads[ i ] = NULL;
	}

	m_iNumentries = 0;
}

/*
================
CHashTable<ItemType>::deleteContents
================
*/
template< class ItemType >
SGF_INLINE_FORCED void CHashTable<ItemType>::deleteContents() {
	int			i;
	hashnode_s	*node;
	hashnode_s	*next;

	for( i = 0; i < m_iTablesize; i++ ) {
		next = heads[ i ];
		while( next != NULL ) {
			node = next;
			next = next->next;
			delete node->value;
			delete node;
		}

		heads[ i ] = NULL;
	}

	m_iNumentries = 0;
}

/*
================
CHashTable<ItemType>::getNum
================
*/
template< class ItemType >
SGF_INLINE_FORCED int CHashTable<ItemType>::getNum() const {
	return m_iNumentries;
}

#if defined(ID_TYPEINFO)
#define __GNUC__ 99
#endif

#if !defined(__GNUC__) || __GNUC__ < 4
/*
================
CHashTable<ItemType>::getSpread
================
*/
template< class ItemType >
int CHashTable<ItemType>::getSpread() const {
	int i, average, error, e;
	hashnode_s	*node;

	// if no items in hash
	if ( !m_iNumentries ) {
		return 100;
	}
	average = m_iNumentries / m_iTablesize;
	error = 0;
	for ( i = 0; i < m_iTablesize; i++ ) {
		numItems = 0;
		for( node = heads[ i ]; node != NULL; node = node->next ) {
			numItems++;
		}
		e = abs( numItems - average );
		if ( e > 1 ) {
			error += e - 1;
		}
	}
	return 100 - (error * 100 / m_iNumentries);
}
#endif

#if defined(ID_TYPEINFO)
#undef __GNUC__
#endif
} //end SGF
#endif /* !__SGF_HASHTABLE_H__ */
