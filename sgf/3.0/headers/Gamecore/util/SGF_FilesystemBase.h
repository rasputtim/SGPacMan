/*
  SGF - Salvathor Game Fabric  (https://sourceforge.net/projects/sgfabric/)
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
#ifndef _SGF_FilesystemBase_h
#define _SGF_FilesystemBase_h

#include <string>
#include <list>
#include <vector>
#include "../SGF_Config.h"
#include "../exceptions/SGF_FileExceptions.h"
#include "../util/SGF_UtilStructs.h"

using namespace std;
namespace SGF {
namespace Filesystem {


//=================FUNCTIONS=======================

	
	/**
	\brief remove separadores de caminho (/) ou (\) extras
	\param path o caminho a sanitizar
	**/
	string sanitize(string path);
    
	/**
	\brief retorna s� a parte arquivo contida na string filename, removendo a parte folder
	\param filename nome do arquivo contendo
	\return o nome do arquivo ou o diret�rio completo se � apenas um diret�rio
	**/
	string stripDir(const string & filename);
	

	/** 
	\brief retorna s� a parte diret�rio contido na string filename
	\param const char * filename: nome do arquivo contendo
	\return o nome do arquivo ou o diret�rio completo se � apenas um diret�rio
	**/
	string getDirName(const string path);

    /**
	\brief retira a extens�o (parte depois do  ".") do arquivo passado => foo.txt -> foo
	\param const string & filename: nome do arquivo
	\return o nome do arquivo sem a extens�o
	**/
    string removeExtension(const string & str);

	/**
	\brief retira a extens�o (parte depois do  ".") do arquivo passado
	\param filename nome do arquivo
	\return a extens�o do arquivo foo.txt -> txt
	**/
    string checkExtension(const string & str);

	/** 
	\brief retira o diret�rio atual
	\param filename
	\return o filename sem altera��o, caso ele n�o fa�a parte do diret�rio de trabalho
	\return o diret�rio de trabalho sem o filename passado
	\note diret�rio de trabalho /a/b/c/d , filename= c/d, return 
	**/
	string stripBaseDir(const string & filename);
	
	/** 
	\brief verifica se o diret�rio passado est� contido no diret�rio de trabalho (onde a palica��o est� rodando)
	\param filename o caminho passado que ser�verificado
	\return true: se sim
	**/
	bool verifyCompletness(const string & filename);

	/**
	\brief  use recursion to get a list of all the directories (folders) and file names within them
	\param  path caminho inicial
	\param  theList lista que ser� preenchida com os diret�rios e nomes de arquivos
	\warning a estrutura FILELIST guarda o diret�rio e todos os seus arquivos. 
	\warning S� FUNCIONA NO WINDOWS
	**/
	void TransverseDirectory(string path, list<FILELIST>& theList);
	
	/**
	\brief cria uma lista (vetor) com todos os arquivos encontrados, de acordo com o padr�o do par�metro find
	\param datapath caminho no sistema de arquivos
	\param find  wildcard que indica o que procurar. Ex *.ttf
	\return um vetor preenchido com o resultado
	\warning S� FUNCIONA NO WINDOWS
	**/
	vector< string > getFilesString( const string & dataPath, const string & find );
	
	/**
	\brief cria uma lista (vetor) com todos os arquivos encontrados, de acordo com o padr�o do par�metro find
	\param datapath caminho no sistema de arquivos
	\param find  wildcard que indica o que procurar. Ex *.ttf
	\param files o vetor que ser� preenchido com o resultado
	\warning S� FUNCIONA NO WINDOWS
	**/
	void getFiles(const string & dataPath, const string & find,vector<string> &files);
	
	/* same as getFiles but search directories recursively */
    //vector<CAbsolutePath> getFilesRecursive(const CAbsolutePath & dataPath, const string & find, bool caseInsensitive = false);

	/**
	\brief corrige os separadores de diret�rio, de acordo com osistema de arquivos do sistema operacional
	\param filename o caminho a ser corrigido
	**/
	const string correctSlashes( const string &filename );
	
	/**
	\brief corrige os separadores de diret�rio, de acordo com osistema de arquivos do sistema operacional
	\param filename o caminho a ser corrigido
	**/
	char * correctSlashes( char *filename );
	
	string removeEndSlashes(string path);
	/**
	\brief retorna o diret�rio de trabalho da aplica��o, isto �, o diret�rio onde roda o execut�vel
	**/
	string getBaseDir();
	/**
	\brief retorna se o caminho passado � um diret�rio ou n�o
	\return true se for diret�rio e falsecaso contr�rio
	**/
	bool isDirectory(const string & path);
	/**
	\brief retorna se � um arquivo e se pode ser lido, isto �, se existe 
	\param path o caminho a ser verificado
	\return true se � um arquivo e existe e false caso contr�rio
	**/
    bool readableFile(const string & path);
    /**
	\brief retorna se o caminho passado existe no sistema de arquivos
	\return true se o caminho pode ser lido e false caso contr�rio
	**/
	bool readable(const string & path);
	/**
	\brief retira a parte do nome do arquivo  e deixa s� o caminho
	\note esta fun��o altera a string passada
	**/
	void extractPath(char *strPath);
	/**
	\brief separa o caminho passado e cria um vetor com os nomes dos diret�rioes e do arquivo
	\param path caminho a ser dividido
	\return um vetor com os nomes dos diret�rios
	**/
	vector<string> splitPath(string path);
	/**
	\brief  a/b/c/d -> b/c/d 
	**/
	string stripFirstDir(const string & str);
} //end Filesystem
} //end SGF
#endif