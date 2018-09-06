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

#ifndef __SGF__UTIL_STRUCTS_H_
#define __SGF__UTIL_STRUCTS_H_

#include "../../ExternalLibs/SDL2-2.0.3/include/SDL.h"
#ifdef _WIN32
#include <io.h>
#else
#include <sys/io.h>
#endif
#include <string>
#include <vector>
#include <list>
#include <iostream>
#include "../SGF_Config.h"
//#include "graphics/SGF_Bitmap.h"

#ifndef BYTE
typedef unsigned char BYTE;
#endif


using namespace std;
namespace SGF {
class CBitmap;

/*
//Define Blit flags
#define BLT_NORMAL          0x21
#define BLT_NORMALFLIPH     0x22
#define BLT_NORMALFLIPV     0x23
#define BLT_NORMALFLIPHV    0x24

//Some define for screen
#define XMAX 319
#define YMAX 239
*/
/*
 * Size of the screen in pixels
 */
/*
#define	SCREEN_W	640
#define	SCREEN_H	480

//The screen attributes
const int SCREEN_BPP = 32;
*/
// A structure to hold a directory and all its filenames.
struct FILELIST
{
	string path;
	vector<string> theList;
};

//Sff Subheader
struct SFFSUBHEADER
{
	long NextSubheaderFileOffset;
	long LenghtOfSubheader;
	short x;
	short y;
	short GroubNumber;
	short ImageNumber;
	short IndexOfPrevious;
	bool  PalletSame;
	unsigned char BALNK[13];

};


struct messagesize{
	messagesize():w(0),h(0){};
	messagesize & operator = ( const  messagesize& source ){
		w=source.w;
		h=source.h;
		return *this;
	}
	messagesize( const  messagesize& source ){
		if(&source==this) return;
		w=source.w;
		h=source.h;

	}
    int w;
    int h;

	};

typedef struct messagesize MESSAGESIZE ;

/* A simple test program framework */

#define SDL_NO_COMPAT
#include "../../ExternalLibs/SDL2-2.0.3/include/SDL.h"

#define VERBOSE_VIDEO   0x00000001
#define VERBOSE_MODES   0x00000002
#define VERBOSE_RENDER  0x00000004
#define VERBOSE_EVENT   0x00000008
#define VERBOSE_AUDIO   0x00000010

//! TOTO  ///   Colocar essas estruturas dendtro do SDL Manager

struct windowInfo_s{
		windowInfo_s():title(NULL),
			icon(NULL),
			x(0),y(0),w(0),h(0),flags(0){}
		const char *title;
		const char *icon;
		int x,y,w,h;
		Uint32 flags;
	};

struct sdlModules_s {
	sdlModules_s():
	TTF(false),
	AUDIO(false),
	VIDEO(false),
	WINDOW(false),
	TIMER(false),
	JOYSTICK(false),
	FRAMERATEMANAGER(false),
	FASTEVENTS(false),
	TEXTSUPPORT(false),
	NETWORK(false){}

	sdlModules_s (sdlModules_s &copy):
		SGFCpConstr(TTF)
		SGFCpConstr(AUDIO)
		SGFCpConstr(VIDEO)
		SGFCpConstr(WINDOW)
		SGFCpConstr(TIMER)
		SGFCpConstr(JOYSTICK)
		SGFCpConstr(FRAMERATEMANAGER)
		SGFCpConstr(FASTEVENTS)
		SGFCpConstr(TEXTSUPPORT)
		SGFCpConstrLast(NETWORK)
		{}
	sdlModules_s & operator=(sdlModules_s &copy) {
		if (this == &copy) return *this;
		SGFCpField(TTF)
		SGFCpField(AUDIO)
		SGFCpField(VIDEO)
		SGFCpField(WINDOW)
		SGFCpField(TIMER)
		SGFCpField(JOYSTICK)
		SGFCpField(FRAMERATEMANAGER)
		SGFCpField(FASTEVENTS)
		SGFCpField(TEXTSUPPORT)
		SGFCpField(NETWORK)
		return *this;
	}

		bool TTF;
		bool AUDIO;
		bool VIDEO;
		bool WINDOW;
		bool TIMER;
		bool JOYSTICK;
		bool FRAMERATEMANAGER;
		bool FASTEVENTS;
		bool TEXTSUPPORT;
		bool NETWORK;

	};

typedef struct
SDLState{

	SDLState(int numWindows):
	flags(0),
    verbose(0),

    /* Video info */
    videodriver(NULL),
    display(0),
	Scaler(NULL),
	Buffer(NULL),
	depth(32),
    refresh_rate(0),
    num_windows(numWindows),

    /* Renderer info */
    renderdriver(NULL),
    render_flags(0),
	skip_renderer(SDL_FALSE),

    /* Audio info */
    audiodriver(NULL),

    /* GL settings */
    gl_red_size(3),
    gl_green_size(3),
    gl_blue_size(2),
    gl_alpha_size(0),
    gl_buffer_size(0),
    gl_depth_size(16),
    gl_stencil_size(0),
    gl_double_buffer(1),
    gl_accum_red_size(0),
    gl_accum_green_size(0),
    gl_accum_blue_size(0),
    gl_accum_alpha_size(0),
    gl_stereo(0),
    gl_multisamplebuffers(0),
    gl_multisamplesamples(0),
    gl_retained_backing(1),
    gl_accelerated(-1),
    gl_major_version(2),
    gl_minor_version(1){
    window_infos = (windowInfo_s **) malloc(numWindows *
                                        sizeof(*window_infos));
	for (int i=0; i< numWindows;i++) {

		window_infos[i]= new windowInfo_s();
	}
	windows = (SDL_Window **) malloc(numWindows *
                                        sizeof(*windows));
    renderers = (SDL_Renderer **) SDL_malloc(numWindows *
                                        sizeof(*renderers));
	Screen = (CBitmap **) SDL_malloc(numWindows *
                                        sizeof(*Screen));

		 if (!window_infos || !windows || !renderers|| !Screen) {
            //s SMF::Debug::debug(Debug::error,__FUNCTION__) << "Out of memory" <<endl;
            //return NULL;
        }

	audiospec.freq = 22050;
    audiospec.format = AUDIO_S16;
    audiospec.channels = 2;
    audiospec.samples = 2048;


	}

	~SDLState(){
	if (Scaler!=NULL){ delete Scaler; Scaler=NULL;}
	if (Buffer!=NULL){ delete Buffer; Buffer=NULL;}
	if (renderdriver!=NULL){ delete renderdriver; renderdriver=NULL;}
    if (audiodriver!=NULL){ delete audiodriver; audiodriver=NULL;}
	if (videodriver!=NULL){ delete videodriver; videodriver=NULL;}

	if (window_infos) {
	    free(window_infos);
    }

	if (windows) {

		for (int i = 0; i < num_windows; ++i) {
            if (windows[i]) {
                SDL_DestroyWindow(windows[i]);
            }
        }
		SDL_free(windows);
    }

	if (renderers) {
		for (int i = 0; i < num_windows; ++i) {
            if (renderers[i]) {
                SDL_DestroyRenderer(renderers[i]);
            }
        }
        SDL_free(renderers);
	}



	for (int i =0 ;i < num_windows; i++) if (Screen[i]) {delete Screen[i]; Screen[i]=NULL;}
	if(Screen) ::SDL_free(Screen);


	}
#if 0
	SDLState &operator=( SDLState  & copy) {

    Uint32 flags;
    Uint32 verbose;

    /* Video info */
    const char *videodriver;
    int display;
	windowInfo_s **window_infos;
	SDL_Window **windows;
	CBitmap **Screen;
	Scaler(MULL);
	Buffer(NULL);
	int depth;
    int refresh_rate;
    num_windows(numWindows)

    /* Renderer info */
    renderdriver(NULL);
    Uint32 render_flags;
    skip_renderer(false);
	SDL_Renderer **renderers;

    /* Audio info */
    audiodriver(NULL);
    audiospec;

    /* GL settings */
    gl_red_size;
    gl_green_size;
    gl_blue_size;
    gl_alpha_size;
    gl_buffer_size;
    gl_depth_size;
    gl_stencil_size;
    gl_double_buffer;
    gl_accum_red_size;
    gl_accum_green_size;
    gl_accum_blue_size;
    gl_accum_alpha_size;
    gl_stereo;
    gl_multisamplebuffers;
    gl_multisamplesamples;
    gl_retained_backing;
    gl_accelerated;
    gl_major_version;
    gl_minor_version;

	sdlModules_s initModules; // guardar informa��es dos m�dulos que devem ser inicializados
	sdlModules_s startedModules;
	}

#endif
	/* SDL init flags */

    //char **argumentos;
    Uint32 flags;
    Uint32 verbose;

    /* Video info */
    const char *videodriver;
    int display;
	windowInfo_s **window_infos;
	SDL_Window **windows;
	CBitmap **Screen; // contem o bitmap (CBitmap) que representa a janela
	CBitmap * Scaler;
	CBitmap * Buffer;
	int depth;
    int refresh_rate;
    int num_windows;

    /* Renderer info */
    const char *renderdriver;
    Uint32 render_flags;
    SDL_bool skip_renderer;
	SDL_Renderer **renderers;

    /* Audio info */
    const char *audiodriver;
    SDL_AudioSpec audiospec;

    /* GL settings */
    int gl_red_size;
    int gl_green_size;
    int gl_blue_size;
    int gl_alpha_size;
    int gl_buffer_size;
    int gl_depth_size;
    int gl_stencil_size;
    int gl_double_buffer;
    int gl_accum_red_size;
    int gl_accum_green_size;
    int gl_accum_blue_size;
    int gl_accum_alpha_size;
    int gl_stereo;
    int gl_multisamplebuffers;
    int gl_multisamplesamples;
    int gl_retained_backing;
    int gl_accelerated;
    int gl_major_version;
    int gl_minor_version;

	sdlModules_s initModules; // guardar informa��es dos m�dulos que devem ser inicializados
	sdlModules_s startedModules;   // guardar inform~��es dos m�dulos que j� foram inicializados
} SDLState_t;

typedef struct {
	int		num;
	int		minSize;
	int		maxSize;
	int		totalSize;
} memoryStats_t;
#if 0
typedef struct
CMathState{
	//mem heap
	CHeap *			mem_heap;
	memoryStats_t	mem_total_allocs;
	memoryStats_t	mem_frame_allocs;
	memoryStats_t	mem_frame_frees;
	//math init

}CMathState_s;
#endif	
typedef enum {
	CPUID_NONE							= 0x00000,
	CPUID_UNSUPPORTED					= 0x00001,	// unsupported (386/486)
	CPUID_GENERIC						= 0x00002,	// unrecognized processor
	CPUID_INTEL							= 0x00004,	// Intel
	CPUID_AMD							= 0x00008,	// AMD
	CPUID_MMX							= 0x00010,	// Multi Media Extensions
	CPUID_3DNOW							= 0x00020,	// 3DNow!
	CPUID_SSE							= 0x00040,	// Streaming SIMD Extensions
	CPUID_SSE2							= 0x00080,	// Streaming SIMD Extensions 2
	CPUID_SSE3							= 0x00100,	// Streaming SIMD Extentions 3 aka Prescott's New Instructions
	CPUID_ALTIVEC						= 0x00200,	// AltiVec
	CPUID_HTT							= 0x01000,	// Hyper-Threading Technology
	CPUID_CMOV							= 0x02000,	// Conditional Move (CMOV) and fast floating point comparison (FCOMI) instructions
	CPUID_FTZ							= 0x04000,	// Flush-To-Zero mode (denormal results are flushed to zero)
	CPUID_DAZ							= 0x08000,	// Denormals-Are-Zero mode (denormal source operands are set to zero)
	CPUID_SSE4							= 0x10000,	// Streaming SIMD Extentions 4
	CPUID_SSE41							= 0x20000,	// Streaming SIMD Extentions 4.1
	CPUID_SSE42							= 0x40000,	// Streaming SIMD Extentions 4.2
	CPUID_AVX							= 0x80000,	// Streaming AVX
} cpuid_t;
} //end namespace SGF
#endif
