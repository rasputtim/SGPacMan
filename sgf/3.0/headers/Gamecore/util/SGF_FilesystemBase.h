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
	\brief retorna só a parte arquivo contida na string filename, removendo a parte folder
	\param filename nome do arquivo contendo
	\return o nome do arquivo ou o diretório completo se é apenas um diretório
	**/
	string stripDir(const string & filename);
	

	/** 
	\brief retorna só a parte diretório contido na string filename
	\param const char * filename: nome do arquivo contendo
	\return o nome do arquivo ou o diretório completo se é apenas um diretório
	**/
	string getDirName(const string path);

    /**
	\brief retira a extensão (parte depois do  ".") do arquivo passado => foo.txt -> foo
	\param const string & filename: nome do arquivo
	\return o nome do arquivo sem a extensão
	**/
    string removeExtension(const string & str);

	/**
	\brief retira a extensão (parte depois do  ".") do arquivo passado
	\param filename nome do arquivo
	\return a extensão do arquivo foo.txt -> txt
	**/
    string checkExtension(const string & str);

	/** 
	\brief retira o diretório atual
	\param filename
	\return o filename sem alteração, caso ele não faça parte do diretório de trabalho
	\return o diretório de trabalho sem o filename passado
	\note diretório de trabalho /a/b/c/d , filename= c/d, return 
	**/
	string stripBaseDir(const string & filename);
	
	/** 
	\brief verifica se o diretório passado está contido no diretório de trabalho (onde a palicação está rodando)
	\param filename o caminho passado que seráverificado
	\return true: se sim
	**/
	bool verifyCompletness(const string & filename);

	/**
	\brief  use recursion to get a list of all the directories (folders) and file names within them
	\param  path caminho inicial
	\param  theList lista que será preenchida com os diretórios e nomes de arquivos
	\warning a estrutura FILELIST guarda o diretório e todos os seus arquivos. 
	\warning SÓ FUNCIONA NO WINDOWS
	**/
	void TransverseDirectory(string path, list<FILELIST>& theList);
	
	/**
	\brief cria uma lista (vetor) com todos os arquivos encontrados, de acordo com o padrão do parâmetro find
	\param datapath caminho no sistema de arquivos
	\param find  wildcard que indica o que procurar. Ex *.ttf
	\return um vetor preenchido com o resultado
	\warning SÓ FUNCIONA NO WINDOWS
	**/
	vector< string > getFilesString( const string & dataPath, const string & find );
	
	/**
	\brief cria uma lista (vetor) com todos os arquivos encontrados, de acordo com o padrão do parâmetro find
	\param datapath caminho no sistema de arquivos
	\param find  wildcard que indica o que procurar. Ex *.ttf
	\param files o vetor que será preenchido com o resultado
	\warning SÓ FUNCIONA NO WINDOWS
	**/
	void getFiles(const string & dataPath, const string & find,vector<string> &files);
	
	/* same as getFiles but search directories recursively */
    //vector<CAbsolutePath> getFilesRecursive(const CAbsolutePath & dataPath, const string & find, bool caseInsensitive = false);

	/**
	\brief corrige os separadores de diretório, de acordo com osistema de arquivos do sistema operacional
	\param filename o caminho a ser corrigido
	**/
	const string correctSlashes( const string &filename );
	
	/**
	\brief corrige os separadores de diretório, de acordo com osistema de arquivos do sistema operacional
	\param filename o caminho a ser corrigido
	**/
	char * correctSlashes( char *filename );
	
	string removeEndSlashes(string path);
	/**
	\brief retorna o diretório de trabalho da aplicação, isto é, o diretório onde roda o executável
	**/
	string getBaseDir();
	/**
	\brief retorna se o caminho passado é um diretório ou não
	\return true se for diretório e falsecaso contrário
	**/
	bool isDirectory(const string & path);
	/**
	\brief retorna se é um arquivo e se pode ser lido, isto é, se existe 
	\param path o caminho a ser verificado
	\return true se é um arquivo e existe e false caso contrário
	**/
    bool readableFile(const string & path);
    /**
	\brief retorna se o caminho passado existe no sistema de arquivos
	\return true se o caminho pode ser lido e false caso contrário
	**/
	bool readable(const string & path);
	/**
	\brief retira a parte do nome do arquivo  e deixa só o caminho
	\note esta função altera a string passada
	**/
	void extractPath(char *strPath);
	/**
	\brief separa o caminho passado e cria um vetor com os nomes dos diretórioes e do arquivo
	\param path caminho a ser dividido
	\return um vetor com os nomes dos diretórios
	**/
	vector<string> splitPath(string path);
	/**
	\brief  a/b/c/d -> b/c/d 
	**/
	string stripFirstDir(const string & str);
} //end Filesystem
} //end SGF
#endif