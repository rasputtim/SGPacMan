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

#ifndef __SGF_CMDVARS_H__
#define __SGF_CMDVARS_H__
#include "../SGF_Config.h"



namespace SGF{
/*
===============================================================================

	Command arguments.

===============================================================================
*/

class CCmdArgs {
public:
							CCmdArgs() { argc = 0; }
							CCmdArgs( const char *text, bool keepAsStrings ) { tokenizeString( text, keepAsStrings ); }

	void					operator=( const CCmdArgs &args );

							// The functions that execute commands get their parameters with these functions.
	int						getArgc() const { return argc; }
							// getArgv() will return an empty string, not NULL if arg >= argc.
	const char *			getArgv( int arg ) const { return ( arg >= 0 && arg < argc ) ? argv[arg] : ""; }
							// Returns a single string containing argv(start) to argv(end)
							// escapeArgs is a fugly way to put the string back into a state ready to tokenize again
	const char *			getArgs( int start = 1, int end = -1, bool escapeArgs = false ) const;
    const char **			getArgs( int *argc );
							// Takes a null terminated string and breaks the string up into arg tokens.
							// Does not need to be /n terminated.
							// Set keepAsStrings to true to only seperate tokens from whitespace and comments, ignoring punctuation
	void					tokenizeString( const char *text, bool keepAsStrings );

	void					appendArg( const char *text );
	void					clear() { argc = 0; }
	

private:
	static const int		MAX_COMMAND_ARGS = 64;
	static const int		MAX_COMMAND_STRING = 2 * MAX_STRING_CHARS;

	int						argc;								// number of arguments
	char *					argv[MAX_COMMAND_ARGS];				// points into tokenized
	char					tokenized[MAX_COMMAND_STRING];		// will have 0 bytes inserted
};


} //end SGF
#endif /* !__SGF_CMDVARS_H__ */
