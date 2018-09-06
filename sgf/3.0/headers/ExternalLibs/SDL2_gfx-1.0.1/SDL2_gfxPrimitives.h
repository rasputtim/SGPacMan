/* 

SDL2_gfxPrimitives.h: graphics primitives for SDL

Copyright (C) 2012  Andreas Schiffler

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.

3. This notice may not be removed or altered from any source
distribution.

Andreas Schiffler -- aschiffler at ferzkopp dot net

*/

#ifndef _SDL2_gfxPrimitives_h
#define _SDL2_gfxPrimitives_h

#include <math.h>
#ifndef M_PI
#define M_PI	3.1415926535897932384626433832795
#endif

#include "SDL.h"

/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

	/* ----- Versioning */

#define SDL2_GFXPRIMITIVES_MAJOR	1
#define SDL2_GFXPRIMITIVES_MINOR	0
#define SDL2_GFXPRIMITIVES_MICRO	1


	/* ---- Function Prototypes */

#ifdef _MSC_VER
#  if defined(DLL_EXPORT) && !defined(LIBSDL2_GFX_DLL_IMPORT)
#    define SDL2_GFXPRIMITIVES_SCOPE __declspec(dllexport)
#  else
#    ifdef LIBSDL2_GFX_DLL_IMPORT
#      define SDL2_GFXPRIMITIVES_SCOPE __declspec(dllimport)
#    endif
#  endif
#endif
#ifndef SDL2_GFXPRIMITIVES_SCOPE
#  define SDL2_GFXPRIMITIVES_SCOPE extern
#endif

	/* Note: all ___Color routines expect the color to be in format 0xRRGGBBAA */

	/* Pixel */

	SDL2_GFXPRIMITIVES_SCOPE int pixelColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int pixelRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Horizontal line */

	SDL2_GFXPRIMITIVES_SCOPE int hlineColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 x2, Sint16 y, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int hlineRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 x2, Sint16 y, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Vertical line */

	SDL2_GFXPRIMITIVES_SCOPE int vlineColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y1, Sint16 y2, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int vlineRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y1, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Rectangle */

	SDL2_GFXPRIMITIVES_SCOPE int rectangleColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int rectangleRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1,
		Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Rounded-Corner Rectangle */

	SDL2_GFXPRIMITIVES_SCOPE int roundedRectangleColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int roundedRectangleRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1,
		Sint16 x2, Sint16 y2, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Filled rectangle (Box) */

	SDL2_GFXPRIMITIVES_SCOPE int boxColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int boxRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2,
		Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Rounded-Corner Filled rectangle (Box) */

	SDL2_GFXPRIMITIVES_SCOPE int roundedBoxColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int roundedBoxRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2,
		Sint16 y2, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Line */

	SDL2_GFXPRIMITIVES_SCOPE int lineColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int lineRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1,
		Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* AA Line */

	SDL2_GFXPRIMITIVES_SCOPE int aalineColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int aalineRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1,
		Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Thick Line */
	SDL2_GFXPRIMITIVES_SCOPE int thickLineColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, 
		Uint8 width, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int thickLineRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, 
		Uint8 width, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Circle */

	SDL2_GFXPRIMITIVES_SCOPE int circleColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int circleRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Arc */

	SDL2_GFXPRIMITIVES_SCOPE int arcColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int arcRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, 
		Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* AA Circle */

	SDL2_GFXPRIMITIVES_SCOPE int aacircleColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int aacircleRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y,
		Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Filled Circle */

	SDL2_GFXPRIMITIVES_SCOPE int filledCircleColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 r, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int filledCircleRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y,
		Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Ellipse */

	SDL2_GFXPRIMITIVES_SCOPE int ellipseColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int ellipseRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y,
		Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* AA Ellipse */

	SDL2_GFXPRIMITIVES_SCOPE int aaellipseColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int aaellipseRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y,
		Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Filled Ellipse */

	SDL2_GFXPRIMITIVES_SCOPE int filledEllipseColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int filledEllipseRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y,
		Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Pie */

	SDL2_GFXPRIMITIVES_SCOPE int pieColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad,
		Sint16 start, Sint16 end, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int pieRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad,
		Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Filled Pie */

	SDL2_GFXPRIMITIVES_SCOPE int filledPieColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad,
		Sint16 start, Sint16 end, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int filledPieRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad,
		Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Trigon */

	SDL2_GFXPRIMITIVES_SCOPE int trigonColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int trigonRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3,
		Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* AA-Trigon */

	SDL2_GFXPRIMITIVES_SCOPE int aatrigonColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int aatrigonRGBAText(SDL_Renderer * renderer,  Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3,
		Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Filled Trigon */

	SDL2_GFXPRIMITIVES_SCOPE int filledTrigonColorText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int filledTrigonRGBAText(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3,
		Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Polygon */

	SDL2_GFXPRIMITIVES_SCOPE int polygonColorText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int polygonRGBAText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy,
		int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* AA-Polygon */

	SDL2_GFXPRIMITIVES_SCOPE int aapolygonColorText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int aapolygonRGBAText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy,
		int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Filled Polygon */

	SDL2_GFXPRIMITIVES_SCOPE int filledPolygonColorText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int filledPolygonRGBAText(SDL_Renderer * renderer, const Sint16 * vx,
		const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Textured Polygon */

	SDL2_GFXPRIMITIVES_SCOPE int texturedPolygonText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, SDL_Surface * texture,int texture_dx,int texture_dy);

	/* Bezier */

	SDL2_GFXPRIMITIVES_SCOPE int bezierColorText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, int s, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int bezierRGBAText(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy,
		int n, int s, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Characters/Strings */

	SDL2_GFXPRIMITIVES_SCOPE void gfxPrimitivesSetFontText(const void *fontdata, Uint32 cw, Uint32 ch);
	SDL2_GFXPRIMITIVES_SCOPE void gfxPrimitivesSetFontRotationText(Uint32 rotation);
	SDL2_GFXPRIMITIVES_SCOPE int characterColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, char c, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int characterRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y, char c, Uint8 r, Uint8 g, Uint8 b, Uint8 a);
	SDL2_GFXPRIMITIVES_SCOPE int stringColorText(SDL_Renderer * renderer, Sint16 x, Sint16 y, const char *s, Uint32 color);
	SDL2_GFXPRIMITIVES_SCOPE int stringRGBAText(SDL_Renderer * renderer, Sint16 x, Sint16 y, const char *s, Uint8 r, Uint8 g, Uint8 b, Uint8 a);

	/* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif

#endif				/* _SDL2_gfxPrimitives_h */
