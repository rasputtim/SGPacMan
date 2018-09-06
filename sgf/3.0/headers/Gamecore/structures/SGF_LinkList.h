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


#ifndef __SGF_LINKLIST_H__
#define __SGF_LINKLIST_H__

/**
 * \class CLinkedList
 *
 * \ingroup SGF_Data_Structures
 *
 * \brief Cria uma Lista Circular
 *
 * \note ItemType � uma estrutura ou classe, para a qual se deseja criar a lista
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 20 de Janeiro de 2013
 */

/**
Uma lista ligada ou lista encadeada � uma estrutura de dados linear e din�mica. 
Ela � composta por c�lulas que apontam para o pr�ximo elemento da lista. 
Para "ter" uma lista ligada/encadeada, basta guardar seu primeiro elemento, 
e seu �ltimo elemento aponta para uma c�lula nula. 
O esquema a seguir representa uma lista ligada/encadeada com 5 elementos:

C�lula 1 ----> C�lula 2 ---> C�lula 3 ---> C�lula 4 ---> C�lula 5 ---> (Nulo)

Para inserir dados ou remover dados � necess�rio ter um ponteiro que aponte para o 1� elemento 
e outro que aponte para o fim, porque se queremos inserir ou apagar dados que est�o nessas posi��es, 
a opera��o � rapidamente executada. Caso seja necess�rio editar um n� que esteja no meio da lista haver� 
uma busca pela posi��o desejada.

http://pt.wikipedia.org/wiki/Lista_ligada
http://www.ime.usp.br/~pf/algoritmos/aulas/lista.html
*/

template< class ItemType >
class CLinkedList {
public:
						CLinkedList();
						~CLinkedList();

	bool				isListEmpty() const;
	bool				isInList() const;
	int					getNum() const;
	void				clear();

	void				insertBefore( CLinkedList &node );
	void				insertAfter( CLinkedList &node );
	void				addToEnd( CLinkedList &node );
	void				addToFront( CLinkedList &node );

	void				remove();

	ItemType *			getNext() const;
	ItemType *			getPrev() const;

	ItemType *			getOwner() const;
	void				setOwner( ItemType *object );

	CLinkedList *		getListHead() const;
	CLinkedList *		getNextNode() const;
	CLinkedList *		getPrevNode() const;

private:
	CLinkedList *		head;
	CLinkedList *		next;
	CLinkedList *		prev;
	ItemType *			owner;
};

/*
CLinkedList<ItemType>::CLinkedList
Node is initialized to be the head of an empty list
/
/** \brief construtor da lista ligada
* \note O n� � inicializado para ser o n� cabe�a
*/
template< class ItemType >
CLinkedList<ItemType>::CLinkedList() {
	owner	= NULL;
	head	= this;	
	next	= this;
	prev	= this;
}

/*
CLinkedList<ItemType>::~CLinkedList
Removes the node from the list, or if it's the head of a list, removes
all the nodes from the list.
*/

/** \brief remove o n� da lista
* \note se o n� a ser removido for o n� cabe�a, remove a lista toda
*/
template< class ItemType >
CLinkedList<ItemType>::~CLinkedList() {
	clear();
}

/*
CLinkedList<ItemType>::isListEmpty
Returns true if the list is empty.
*/

/** \brief verifica se a lista est� vazia
* \return true se a lista estiver vazia
*/
template< class ItemType >
bool CLinkedList<ItemType>::isListEmpty() const {
	return head->next == head;
}

/*
CLinkedList<ItemType>::isInList
Returns true if the node is in a list.  If called on the head of a list, will always return false.
*/
/** \brief verifica se um n� faz parte da lista
* \note se o n� for o cabe�a, retornar� falso
* \return true se o n� faz parte da lista
*/
template< class ItemType >
bool CLinkedList<ItemType>::isInList() const {
	return head != this;
}

/*
CLinkedList<ItemType>::getNum
Returns the number of nodes in the list.
*/
/** \brief retorna o n�mero de n�s numa lista
*/
template< class ItemType >
int CLinkedList<ItemType>::getNum() const {
	CLinkedList<ItemType>	*node;
	int					num;

	num = 0;
	for( node = head->next; node != head; node = node->next ) {
		num++;
	}

	return num;
}


/** \brief Limpa a lista
* \note Se o n� � o cabe�a (n� head), o m�todo limpa a lista
* \note Se o n� n�o � o cabe�a (n� head), o m�todo simplesmente retira o n� da lista.
*/
template< class ItemType >
void CLinkedList<ItemType>::clear() {
	if ( head == this ) {
		while( next != this ) {
			next->remove();
		}
	} else {
		remove();
	}
}


/** 
* \brief Remove um node da lista	
*/
template< class ItemType >
void CLinkedList<ItemType>::remove() {
	prev->next = next;
	next->prev = prev;

	next = this;
	prev = this;
	head = this;
}

/*
Places the node before the existing node in the list.  If the existing node is the head,
then the new node is placed at the end of the list.
*/

/**
* CLinkedList<ItemType>::insertBefore
* \brief coloca o novo n� antes do n� atual na lista.
* \brief Se o n� atual for o cabe�a, o novo n� � colocado no final da lista 
* \param node: O n� a ser inserido
*/

template< class ItemType >
void CLinkedList<ItemType>::insertBefore( CLinkedList &node ) {
	remove();

	next		= &node;
	prev		= node.prev;
	node.prev	= this;
	prev->next	= this;
	head		= node.head;
}

/*
CLinkedList<ItemType>::insertAfter
Places the node after the existing node in the list.  If the existing node is the head,
then the new node is placed at the beginning of the list.
*/
/** \brief coloca o n� depois do n� atual da lista
* \note se o n� atual for o cabe�a, o novo n� � colocado no in�cio da lista
* \param O n� a ser inserido
*/
template< class ItemType >
void CLinkedList<ItemType>::insertAfter( CLinkedList &node ) {
	remove();

	prev		= &node;
	next		= node.next;
	node.next	= this;
	next->prev	= this;
	head		= node.head;
}

/*
CLinkedList<ItemType>::addToEnd
Adds node at the end of the list
*/
/** \brief adiciona o n� no final da lista
* \param o n� a ser inserido
*/
template< class ItemType >
void CLinkedList<ItemType>::addToEnd( CLinkedList &node ) {
	insertBefore( *node.head );
}

/*
CLinkedList<ItemType>::addToFront
Adds node at the beginning of the list
*/
/** \brief  adiciona o n� no in�cio da lista
* \param node: o n� a ser inserido
*/
template< class ItemType >
void CLinkedList<ItemType>::addToFront( CLinkedList &node ) {
	insertAfter( *node.head );
}

/*
CLinkedList<ItemType>::getListHead
Returns the head of the list.  If the node isn't in a list, it returns
a pointer to itself.
*/
/** \brief retorna o n� cabe�a da lista
* \return um ponteiro para o n� cabe�a
*/
template< class ItemType >
CLinkedList<ItemType> *CLinkedList<ItemType>::getListHead() const {
	return head;
}

/*
CLinkedList<ItemType>::getNext
Returns the next object in the list, or NULL if at the end.
*/
/** \brief retorna o pr�ximo objeto na lista, ou NULO caso esteja no final da lista
* \return Um ponteiro para o objeto do pr�ximo n�
*/
template< class ItemType >
ItemType *CLinkedList<ItemType>::getNext() const {
	if ( !next || ( next == head ) ) {
		return NULL;
	}
	return next->owner;
}

/*
CLinkedList<ItemType>::getPrev
Returns the previous object in the list, or NULL if at the beginning.
*/
/** \brief retorna o objeto anterior
* \return Um ponteiro para  o objeto do n� anteior
*/
template< class ItemType >
ItemType *CLinkedList<ItemType>::getPrev() const {
	if ( !prev || ( prev == head ) ) {
		return NULL;
	}
	return prev->owner;
}

/*
CLinkedList<ItemType>::getNextNode
Returns the next node in the list, or NULL if at the end.
*/
/** \brief retorna op pr�ximo n�
* \return Um ponteiro para o pr�ximo n� da lista
*/
template< class ItemType >
CLinkedList<ItemType> *CLinkedList<ItemType>::getNextNode() const {
	if ( next == head ) {
		return NULL;
	}
	return next;
}

/*
CLinkedList<ItemType>::getPrevNode
Returns the previous node in the list, or NULL if at the beginning.
*/
/** \brief retorna o n� anterior da lista
* \return um ponteiro para o n� anterior
*/
template< class ItemType >
CLinkedList<ItemType> *CLinkedList<ItemType>::getPrevNode() const {
	if ( prev == head ) {
		return NULL;
	}
	return prev;
}

/*
CLinkedList<ItemType>::getOwner
Gets the object that is associated with this node.
*/
/** \brief retorna o objeto associaso ao n� atual
*  \ return Um ponteiro para o objeto em quest�o
*/
template< class ItemType >
ItemType *CLinkedList<ItemType>::getOwner() const {
	return owner;
}

/*
CLinkedList<ItemType>::setOwner
Sets the object that this node is associated with.
*/
/** \brief configura o objeto ao qual este n� est� associado
* \param Up ponteiro para o objeto em quest�o
*/
template< class ItemType >
void CLinkedList<ItemType>::setOwner( ItemType *object ) {
	owner = object;
}

#endif /* !__LINKLIST_H__ */
