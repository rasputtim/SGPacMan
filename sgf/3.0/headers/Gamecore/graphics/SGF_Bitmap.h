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
#ifndef _S_G_F_bitmap_h_
#define _S_G_F_bitmap_h_

#include "../../ExternalLibs/SDL2-2.0.3/include/SDL.h"
#include <string>
#include <vector>
#include <iostream>
#include "../SGF_Config.h"
#include "../sprite/defs.h"
#include "SGF_Color.h"
#include "../gui/SGF_Coordinate.h"
#include "../gui/SGF_Rectarea.h"
#include "../util/SGF_UtilStructs.h"
#include "../util/SGF_Thread.h"

#define SCREENX_LIMIT 319
#define SCREENY_LIMIT 239
#define _PI 3.1415926
#define MAX_TEXTURES 10 //! pode armazenar at� 10 texturas


using namespace std;
namespace SGF{
class CFont;
class CTranslucentBitmap;
class CPolygon;

typedef enum {
	USE_TEXTURE,
	USE_SURFACE,
	BOTH_TEXTURE_SURFACE,
	USE_GL_TEXTURE,
	USE_RENDERER,
} BitmapType;

/* thread safe Bitmap
http://www.justsoftwaresolutions.co.uk/threading/thread-safe-copy-constructors.html
*/


struct BitSurfaces{
public:
	BitSurfaces():
	_my_SDLSurface(NULL),
	_my_SDLTexture(NULL),
	_my_GLTexture(NULL),
	_my_gl_bitmap(NULL),
	own(NULL)
	{};
	BitSurfaces(const BitSurfaces & copy,bool deep_copy = false):
	_my_SDLSurface(copy._my_SDLSurface),
	_my_SDLTexture(copy._my_SDLTexture),
	_my_GLTexture(copy._my_GLTexture),
	_my_gl_bitmap(copy._my_gl_bitmap){
	if (deep_copy){
		own = new int;
		*own = 1;
	}else{
		own = copy.own;
		if ( own ){
			*own = *own + 1;
		}
	}
	};
	BitSurfaces & operator=(const BitSurfaces & copy){
	_my_SDLSurface=copy._my_SDLSurface;
	_my_SDLTexture=copy._my_SDLTexture;
	_my_GLTexture=copy._my_GLTexture;
	_my_gl_bitmap=copy._my_gl_bitmap;
	own = copy.own;
    if (own) *own += 1;

	return *this;
	}
	~BitSurfaces(){
		if( _my_gl_bitmap != NULL) {
			free (_my_gl_bitmap);
			_my_gl_bitmap=NULL;
		}
		releaseInternalBitmap();

	};
	void releaseInternalBitmap();
	void start() {
		own = new int;
		*own = 1;
	}
	//void addCopy() {
	//	if (own) *own += 1;
	//}
	SGF_INLINE SDL_Surface * getBitmap() const{
		return _my_SDLSurface;
	}
	SGF_INLINE SDL_Texture * GetTexture() const{
		return _my_SDLTexture;
	}
	SGF_INLINE void * GetGLTexture() const{
		return _my_GLTexture;
	}
	SGF_INLINE Uint8 * getGLBitmap() const{
		return _my_gl_bitmap;
	}
	SGF_INLINE void setBitmap( SDL_Surface * bitmap ){
            if ( bitmap == NULL ){
                cout << "*FATAL* Setting null bitmap" << endl;
            }
			_my_SDLSurface = bitmap;
        }
	SGF_INLINE void setTexture( SDL_Texture * texture ){
            if ( texture == NULL ){
				cout << "*FATAL* Setting null SDL Texture" << endl;
             //   Debug::debug(Debug::error,__FUNCTION__) << "*FATAL* Setting null bitmap" << endl;
			}else{
			_my_SDLTexture=texture;
			}
        }
	SGF_INLINE void setGLTexture( void * texture ){
            if ( texture == NULL ){
				cout << "*FATAL* Setting null GL Texture" << endl;
             //   Debug::debug(Debug::error,__FUNCTION__) << "*FATAL* Setting null bitmap" << endl;
			}else{
			_my_GLTexture=texture;
			}
        }

	 SGF_INLINE void SetGLBitmap( Uint8 * bitmap ){
            if ( bitmap == NULL ){
                cout << "*FATAL* Setting null GL bitmap" << endl;
            }
            _my_gl_bitmap = bitmap;
        }

	


private:
	SDL_Surface * _my_SDLSurface;
	SDL_Texture * _my_SDLTexture;
	void * _my_GLTexture;
	//! ponteiro para a textura interna da classe
	Uint8 * _my_gl_bitmap;
	//! indica se a classe � dona do bitmap interno
	int * own;
	
};
class CBitmap;

struct BaseCBitmap{
	BaseCBitmap()
	{};
	BaseCBitmap(const BaseCBitmap & copy, bool deep_copy):
		_my_bitmap(copy._my_bitmap, deep_copy)
	{};
	
//	BaseCBitmap(const CBitmap & copy):
//		_my_bitmap(copy._my_bitmap)
//	{};
	
	BaseCBitmap & operator=(BaseCBitmap & copy){
		_my_bitmap=copy._my_bitmap;
	};
	BitSurfaces _my_bitmap;
	

};

/**
 * \class CBitmap
 *
 * \ingroup SGF_Graphics
 *
 * \brief Controle de Bitmap, efeitos, drawing, blitting
 *
 * \author (last to touch it) $Autor: Salvatore Giannotta Filho $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: a_materasu@hotmail.com
 *
 * Created on: 05 de Janeiro de 2012
  */
class  SGE_API CBitmap: private BaseCBitmap {



public:

	/* equivalent to a GPU shader */
        class CFilter{
        public:
            virtual unsigned int filter(unsigned int pixel) const = 0;
            virtual ~CFilter(){
            }
        };

        static int SCALE_X;
        static int SCALE_Y;
	
	/** 
	\ brief Este � o m�todo inicial da Classe CBitmap
	* Antes de criar qualcrer Objeto CBitmap � necess�rio
	* iniciar o modo gr�fico atrav�s deste m�todo
	* \note � necess�rio inicializar o CBitmap para cada janela a ser utilizada
	* \note � utilizado pela classe CSDL_Manager ap�s inicializar o SDL
	* \param state estrutura que cont�m todos os par�metros de inicializa��o
	* \param i �ndice que indica a qual janela (SDL_Window) se refere esta inicializa��o
	*/
	static int init( SDLState_t *state ,int i=0);

	//=============CONSTRUCTORS==============================
	
	/** \brief Construtor padr�o, cria um bitmap 10x10 pixels 
	* \param window janela a que pertence o bitmap criado
	*/
	CBitmap( int window =0);
	
	/** \brief Cria um novo bitmap padr�o, sem imagem 
	* \param sizex  tamanho horizontal (largura) do bitmap a ser criado
	* \param sizey  tamanho vertical (altura) do bitmap a ser criado
	* \param window janela a que pertence o bitmap criado
	*/
	CBitmap( int sizex, int sizey , int window=0); //usa como default a janela 0, ou Screen[0]
	
	/** \brief Cria um novo bitmap atrav�s de um arquivo 
	* \param load_file nome do arquivo de imagem a ser utilizado para criar o novo bitmap
	* \param window janela a que pertence o bitmap criado
	*/
	CBitmap( const char * load_file, int window=0 );
	
	/** \brief Cria um novo bitmap atrav�s de uma imagem no formato pcx armazenada em buffer 
	* \param image  ponteiro para o buffer da imagem a ser utilizado para criar o novo bitmap
	* \param window janela a que pertence o bitmap criado
	*/
	CBitmap( PCXDATA *image , int window=0);
	
	/** \brief Cria um novo bitmap atrav�s de um arquivo 
	* \param load_file nome do arquivo de imagem a ser utilizado para criar o novo bitmap
	* \param window janela a que pertence o bitmap criado
	*/
	CBitmap( const string & load_file, int window=0 );
	
	/** \brief Cria um novo bitmap atrav�s de um arquivo 
	* \param load_file nome do arquivo de imagem a ser utilizado para criar o novo bitmap
	* \param sizex  tamanho horizontal do bitmap a ser criado
	* \param sizey  tamanho vertical do bitmap a ser criado
	* \param window janela a que pertence o bitmap criado
	*/
	CBitmap( const char * load_file, int sizex, int sizey , int window=0);
	
	/** \brief Cria um novo bitmap, fazendo uma c�pia do Bitmap copy
	* \param copy bitmap original do qual ser� copiado uma parte
	* \param deep_copy  se verdadeiro, copia o buffer (surface e textura) do bitmap copy para o bitmap atual
	*                   se false, s� sopia a o ponteiro para o buffer
	*/
	CBitmap( const CBitmap & copy, bool deep_copy = false );
	
	/** \brief Cria um novo bitmap, copiando o retangulo com tamanho 0,0,sizex,sizey do Bitmap copy
	* \param copy bitmap original do qual ser� copiado uma parte
	* \param sizex tamanho horizontal em pixels do ret�ngulo de c�pia
	* \param sizey tamanho vertical em pixels do ret�ngulo de c�pia
	*/
	CBitmap( const CBitmap & copy, int sizex, int sizey );
	
	
	/** \brief Cria um novo bitmap, copiando o retangulo x,y,w,h do Bitmap copy
	* \param copy bitmap original do qual ser� copiado uma parte
	* \param x coordenada horizontal inicial do ret�ngulo de c�pia
	* \param y coordenada vertical inicial do ret�ngulo de c�pia
	* \param width largura do ret�ngulo de c�pia em pixels
	* \param height altura do ret�ngulo de c�pia em pixels
	* \param bitmapTypeToCopy tipo de c�pia que deve ser feito (S� Surface, s� textura ou ambos);
	*/
	CBitmap( const CBitmap & copy, int x, int y, int width, int height ,BitmapType bitmapTypeToCopy=BOTH_TEXTURE_SURFACE);

	//! Construtores de inicializa��o da tela
	explicit CBitmap( SDL_Surface * who, bool deep_copy = false,bool initconsole = false , int window=0);
	explicit CBitmap( SDL_Window * who, bool deep_copy = false,bool initconsole = false, int window=0 );
	
	/** \brief Cria um novo bitmap atrav�s de uma imagem no formato PCX armazenada em buffer 
	* \param data  ponteiro para o buffer da imagem a ser utilizado para criar o novo bitmap
	* \param length tamanho do buffer em bytes
	* \param mask utiliza ou n�o a m�scara keycolor para criar o bitmap
	* \param window janela a que pertence o bitmap criado
	*/
	
	static CBitmap memoryPCX(unsigned char * const data, const int length, const bool mask = true);
	     
	/**
	\brief cria um Cbitmap que n�o � garantido ser preservado depois que sua fun��o retorna.
	       N�o armazene refer�ncias para este bitmap, e se voc� criar
	       CBitmaps temor�rios, ***n�o*** chame m�todos que tamb�m criem CBitmaps tempor�rios
	\param w tamanho horizontal (largura) do CBitmap
	\param h tamanho vertical (altura) do CBitmap
	**/
    static CBitmap temporaryBitmap(int w, int h);
	/**
	\brief cria um CBitmap que n�o � garantido ser preservado depois que sua fun��o retorna.
	       N�o armazene refer�ncias para este bitmap, e se voc� criar
	       CBitmaps temor�rios, ***n�o*** chame m�todos que tamb�m criem CBitmaps tempor�rios
	\param w tamanho horizontal (largura) do CBitmap
	\param h tamanho vertical (altura) do CBitmap
	**/
	static CBitmap temporaryBitmap2(int w, int h);

    /**
	\brief deleta todos os CBitmaps tempor�rios
	**/
	static void cleanupTemporaryBitmaps();
	virtual ~CBitmap();

	//============  END CONSTRUCTORS===============================
	/**
	\brief cria um Objeto CTransluscentBitmap atrav�s do CBitmap atual
	\note translucent bitmap usa o transpblender para controlar a transparencia do objeto gerado
	**/
	virtual CTranslucentBitmap translucent() const;
	/**
	\brief cria um Objeto CTransluscentBitmap atrav�s do CBitmap atual j� setando os par�metros rgba de transpar�ncia no transpblender
	\param red valor de vermelho usado na transpar�ncia do objeto
	\param green valor de verde usado na transpar�ncia do objeto
	\param blue valor de azul usado na transpar�ncia do objeto
	\param alpha valor de transpar�ncia alpha usado no objeto
	\note translucent bitmap usa o transpblender para controlar a transparencia do objeto gerado
	**/
	virtual CTranslucentBitmap translucent(int red, int green, int blue, int alpha) const;
    
	virtual CPolygon polygon() const;
	virtual void save( const string & str );

	CBitmap & operator=( const CBitmap & );

	virtual void load( const string & str, int window=0 );
    /**
	\brief retorna a largura do CBitmap
	**/
	SGF_INLINE const int getWidth() const{
		return _my_width;
	}
	/**
	\brief retorna a altura do CBitmap
	**/
	SGF_INLINE const int getHeight() const{
		return _my_height;
	}
	/**
	\brief retorna a surface SDL do CBitmap
	**/
	SGF_INLINE SDL_Surface * getBitmap() const{
		return _my_bitmap.getBitmap();
	}
	/**
	\brief retorna a textura SDL do CBitmap
	**/
	SGF_INLINE SDL_Texture * GetTexture() const{
		return _my_bitmap.GetTexture();
	}
	/**
	\brief retorna a extrutura SDLState_t que cont�m estado SDL  do CBitmap
	**/
	SGF_INLINE SDLState_t * GetState() const{
		return _my_state;
	}
	/**
	\brief retorna a window SDL do CBitmap
	**/
	SGF_INLINE SDL_Window * GetWindow() const{
		return _my_state->windows[_my_renderWindow];
	}
	/**
	\brief retorna blend mode da Textura SDL utilizada no CBitmap
	**/
	SGF_INLINE const SDL_BlendMode GetTextureDrawBlendMode() const{
		return _my_texture_draw_blend_mode;
	}
	/**
	\brief retorna atual modo de trabalho do CBitmap
	**/
	SGF_INLINE const int getBitmapMode() const{
		return _my_actual_draw_type;
	}
	/**
	\brief retorna renderer SDL do CBitmap
	**/
	SGF_INLINE SDL_Renderer * getMyRender() const {
		return _my_state->renderers[_my_renderWindow];
	}
	/**
	\brief retorna renderer SDL utilizado numa espec�fica janela de trabalho
	**/
	static SDL_Renderer * getMyRenderer(int RenderWindow) {
		return _my_state->renderers[RenderWindow];
	}
	/**
	\brief retorna o n�mero da janela de trabalho do CBitmap
	**/
	SGF_INLINE const int getMyRenderWindow() const {
		return _my_renderWindow;
	}
	/**
	\brief retorna o caminho do arquivo utilizado para criar o CBitmap, 
	caso ele n�o tenha sido criado de um arquivo, retorna uma string vazia
	**/
	SGF_INLINE const string & getPath() const{
		return path;
	}
	
	//====================SDL Surface Methods======================
private:

	SDL_Surface* CreateSurface(int x,int y); //copiada do videosystem
	SDL_Surface* load_image( string filename );
	SDL_Surface* load_image( const char *  filename );
	SDL_Surface* load_image( BYTE * file, int size ); //used to load PCX Byte sprites
	//! estimate num of segments used to draw circle and arc in openGL
public:
    SDL_Surface* RotatePicture (int rotate, int flip, int smooth); // Nao testei n�o lembro pra que serve
	SDL_Surface* RotateSurface( double angle, double zoomx=1, double zoomy=1 );
	SDL_Surface* SDL_ScaleSurface(SDL_Surface* Surface, Uint16 Width, Uint16 Height)const;
	void convertpixelFormat(); //! convert surface to the current pixel format
	void rotateFromBitmap(double angle, double zoomx=1, double zoomy=1 );
    /* resize the internal Surface. not guaranteed to destroy the internal Surface */
	void resize( const int width, const int height );

    //======END SURFACE METHODS============
	//! release the internal Bitmap
	void detach();

	//=================SDL TEXTURE  METHODS================
	void updateTexture()const;
	SDL_Texture * CreateTextureFromBitmap(int renderWindow=0);
	//! Cria uma nova textura � partiir da Surface atual do Bitmap
	SDL_Texture * copyTextureFromSurface();
	//! Cria uma nova textura � partiir da textura atual do Bitmap
	//! nao esquecer que deve deleter a textura com SDL_DestroyTexture(SDL_Texture* texture) depois de utiliz�la
	SDL_Texture * copyTextureFromTexture();
	//! copia a txtura do bitmap atual � partir da Textura do Bitmap passado como par�metro
	void copyTextureFromBitmap(CBitmap &origem);
	SDL_Texture * createTextureStreaming(int x, int y, int renderWindow=0);
	//! retorna o mode de acesso da textura
	/*
	SDL_TEXTUREACCESS_STATIC  - changes rarely, not lockable
	SDL_TEXTUREACCESS_STREAMING - changes frequently, lockable
	SDL_TEXTUREACCESS_TARGET - can be used as a render target
	*/
	int getTextureAccessMode(); 
	//! retorna treu se o modo de acesso da textura � est�tico
	bool isTextureStatic();
	//! retorna treu se o modo de acesso da textura � streaming
	bool isTextureStreaming();
	//! retorna treu se o modo de acesso da textura � Target
	bool isTextureTarget();
	//=============================================================


	// BLENDING METHODS===========================
	//Modos de blending dos m�todos de rendering do SDL 2.0
	static const SDL_BlendMode MODE_TRANS;
	static const SDL_BlendMode MODE_SOLID;
	static const SDL_BlendMode MODE_ADD;
	static const SDL_BlendMode MODE_MOD;
	//Use this function to set the blend mode for a texture, used by SDL_RenderCopy().
	int SetBlendMode(SDL_BlendMode blendmode) const;
    //Use this function to set the blend mode used for drawing operations (Fill and Line).
	//Todo: mover este m�todo para a classe polygon
	void setDrawBlendMode( SDL_BlendMode type ) const;

	// Modos de blending pr�prios do SGF

	 /* alphaBlender:  Blend between source pixel and destination pixel.
         * Source and dest should be 0-255.
         *source = 64, dest = 128
         * pixel = source_pixel * source / 255 + dest_pixel * dest / 255
         */ 
	static void alphaBlender(int source, int dest);
	static void transBlender( int r, int g, int b, int a );
	static void multiplyBlender( int r, int g, int b, int a );
	static void dissolveBlender( int r, int g, int b, int a );
	static void addBlender( int r, int g, int b, int a );
	static void burnBlender( int r, int g, int b, int a );
	static void colorBlender( int r, int g, int b, int a );
	static void differenceBlender( int r, int g, int b, int a );
	static void dodgeBlender( int r, int g, int b, int a );
	static void hueBlender( int r, int g, int b, int a );
	static void luminanceBlender( int r, int g, int b, int a );
	static void invertBlender( int r, int g, int b, int a );
	static void screenBlender( int r, int g, int b, int a );


	//================LOCK METHODS==============
	void acquire();
	void locksurface();
	void release();
    void unlocksurface();
	//=======END LOCK METHODS==============

    /** converte o bitmap para uma vers�o en escala de cinza
	*/
    virtual CBitmap greyScale();
 	
	//TODO: m�todos que aplicam colorkey diretamente na textura? ser� necess�rio?
	//==M�todos de Transpar�ncia de Colorkey====
	//  Voce determina uma cor do bitmap que ser� totalmente transparente
	/** \brief usa a cor do pixel 0,0 como transpar�ncia
	* \note aplica a transpar�ncia na surface e depois atualiza a textura */
	virtual void applyTrans();
    /** \brief usa cor padr�o (255,0,255) como transpar�ncia
	* \note aplica a transpar�ncia na surface e depois atualiza a textura */
	virtual void applyDefTrans();
    /** \brief  usa cor color como transpar�ncia
		* \note aplica a transpar�ncia na surface e depois atualiza a textura */
	virtual void applyTrans(int color);
	
	/** \brief inicializa qual a cor da m�scara num bitmap que foi criado a partir de uma imagem PCX
	* \param color: defini��o da cor que representa a mascara (keycolor)
	*/
	int SetAlphaMod(int alpha);

	void setPCXMaskColor(Colors::ColorDefinition color);

	/** \brief m�todo que informa qual a cor da m�scara de um bitmap criado � partir de um PCX
	*\ return um inteiro que representa o pixel da cor de m�scara no formato do display
	*/
	unsigned int getPCXMaskColor() const;

	/** \brief m�todo que informa qual a cor da m�scara padr�o
	*\ return um inteiro que representa o pixel da cor de m�scara no formato do display
	*/
	static  int getDefaultColorkey();


	//===Methods de transpar�ncia alpha
	virtual void applyAlphaTrans(const int alpha); //!usa o valor de alpha como transpar�ncia para a surface ou textura como um todo



	virtual void border( int min, int max, int color ) const;

	//=========PIXEL METHODS======================

	/** \brief Retorna um Vetor com as coordenadas (x,Y) de cada um dos pixels de uma determinada cor
	* \param original: pixel representando a cor a ser procurada no bitmap
	* \note: funciona com bitmap , n�o textura ainda
	*/
	vector<Gui::CAbsolutePoint> getPixelsCoord(Colors::PixelColor mask);
	/** \brief Retorna um Vetor com as coordenadas (x,Y) de cada um dos pixels que n�o s�o de uma determinada cor
	* \param original: pixel representando a cor a ser procurada no bitmap
	* \note: funciona com bitmap , n�o textura ainda
	*/
	vector<Gui::CAbsolutePoint> getPixelsCoordInverted(Colors::PixelColor mask);
	/** \brief troca os pixels de um Bitmap
	* \param original: pixel representando a cor de origem, que ser� trocada
	* \param replaced: pixel representando a nova cor, que ser� s�bstituir� o original
	*/
	
	virtual void replaceColor(int original, int replaced);
	virtual void readLine( vector< int > & vec, int y );

    Uint32	getPixelSurface(int x, int y) const;
	void putPixelSurface( int x, int y, Uint32 pixel, bool translucent=false ) const;
	void putPixelSurface( int x, int y, Uint8 r, Uint8 g, Uint8 b) const;
    void putPixelTexture( int x, int y, Uint32 pixel, bool translucent=false ) const;
	void putPixelTexture( int x, int y, Uint8 r, Uint8 g, Uint8 b) const;
    /* respects the current trans mode */
	void putPixelNormal(int x, int y, int pixel) const; //not used anymore
	
	/** \brief m�todo que informa qual o valor do pixel que representa a cor rgb (no formato do display)
	* \param r: quantidade de vermelho
	* \param g: quantidade de verde
	* \param b: quantidade de azul
	* \return um inteiro que representa o pixel da cor RGB no formato do display
	*/
	static  int makeColor(int r, int g, int b);
	static  Colors::ColorDefinition makeSDLColor( int r, int g, int b );
	Colors::ColorDefinition getColor(Uint32 pixel);

	//================DRAW METHODS========================================
	// M�todos que atuam diretamente nos pixels das imagens usanso acesso direto aos pixels via SGF
    
	//virtual void draw(const int x, const int y, const int startWidth, const int startHeight, const int width, const int height, const CBitmap & where) const;
	virtual void draw(const int x, const int y, const int startWidth, const int startHeight, const int width, const int height, CFilter * filter, const CBitmap & where) const;
	virtual void draw(const int x, const int y, CFilter * filter, const CBitmap & where) const;
	
	/* flip horizontally */
	virtual void drawHFlip(const int x, const int y, CFilter * filter, const CBitmap & where) const;
	virtual void drawHFlip(const int x, const int y, const int startWidth, const int startHeight, const int width, const int height, CFilter * filter, const CBitmap & where) const;

	/* flip vertically */
	virtual void drawVFlip( const int x, const int y, CFilter * filter, const CBitmap & where ) const;

    /* flip horizontal and vertical */
	virtual void drawHVFlip( const int x, const int y, CFilter * filter, const CBitmap & where ) const;

	//! m�todo n�o usado ainda, acho que est� com bug
	virtual void drawMaskSurface( const int x, const int y, const CBitmap & where );

	virtual void drawStretched( const int x, const int y, const int new_width, const int new_height, const CBitmap & who )const;
	virtual void drawStretched(const CBitmap & who) const;
	virtual void drawRotate( const int x, const int y, const int angle, const CBitmap & where );
	virtual void drawPivot( const int centerX, const int centerY, const int x, const int y, const int angle, const CBitmap & where );
	virtual void drawPivot( const int centerX, const int centerY, const int x, const int y, const int angle, const double scale, const CBitmap & where );
    virtual void Draw();
	virtual void Stretch( const CBitmap & where ) const;
	virtual void Stretch( const CBitmap & where, const int sourceX, const int sourceY, const int sourceWidth, const int sourceHeight, const int destX, const int destY, const int destWidth, const int destHeight ) const;
	virtual void StretchBy2( const CBitmap & where );
	virtual void StretchBy4( const CBitmap & where );

	static void draw_sprite_ex32(SDL_Surface * dst, SDL_Surface * src, int dx, int dy, int mode, int flip, CBitmap::CFilter * filter, unsigned int maskcolor);
	static void draw_sprite_ex32(SDL_Texture * dst, SDL_Surface * src, int dx, int dy, int mode, int flip, CBitmap::CFilter * filter, unsigned int maskcolor);
	
	static void replace16(SDL_Surface * dst, const int original, const int replace);
	static void replace32(SDL_Surface * dst, const int original, const int replace);
	
	//n�o utilizados, precisa revis�-los e test�-los
	static void draw_sprite_filter_ex16(SDL_Surface * dst, SDL_Surface * src, int x, int y, const CBitmap::CFilter & filter);
	/* caso especial para desenhar um luz light (como numa lampada).
	 * \note o centro da luz �  x,y
	 * \note brilha num tri�ngulo isosceles perfeito.
	 */
	static void light16(SDL_Surface * dst, const int x, const int y, int width, int height, const int start_y, const int focus_alpha, const int edge_alpha, const int focus_color, const int edge_color);


	//=================BLIT METHODS=====================

	/** atualiza o renderer com o conteudo da Textura
     * \note  atualiza na posi��o 0,0
    */
	virtual void Blit() const;
	/** atualiza o renderer com o conteudo da Textura
    * \note  atualiza na posi��o x,y
    * \param x: coordenada x do ponto de in�cio
	* \param y: coordenada y do ponto de in�cio
    */
	virtual void Blit(int x, int y) const;

	/** atualiza o renderer com o conteudo da Textura
    * \note  atualiza na posi��o DestX,DestX
    * \param DestX: coordenada x do ponto destino
	* \param DestY: coordenada y do ponto destino 
	* \param DestW = -1 significa usar o bitmap inteiro 
    * \param DestH = -1 significa usar o bitmap inteiro 
    */
	virtual void Blit( const int OrigX, const int OrigY, const int width, const int height, const int Destx, const int Desty,int DestW=-1, int DestH=-1) const;


	/** atualiza o default renderer com o conte�do da textura,
    * alongando a mesma at� o tamanho da janela
	* \note blita na posi��o 0,0
	*/
	virtual void BlitStretched() const;
	/** atualiza o default renderer com o conte�do da textura,
    * alongando a mesma at� o tamanho da janela
    * \param x: coordenada x do ponto de in�cio
	* \param y: coordenada y do ponto de in�cio
	*/
	virtual void BlitStretched(int x, int y)const ;
	/** atualiza a janela com o conte�do do renderer
	*/
	virtual void BlitToScreen() const;
	static void BlitRenderToScreen(int window);
	/** atualiza a janela com o conte�do da surface
	* \note s� funciona no modo SDL 1.2
	*/
	//virtual void BlitToScreen(const int upper_left_x, const int upper_left_y) const;

	// m�todos de draw que utilizam o Blit do SDL
	
	//==== Blit the surface to another CBitmap
	//!copia a surface do Bitmap Atual para a Surface do bitmap Destino
	virtual void BlitSurface( const CBitmap & where ) const;
	//!copia a surface do Bitmap Atual para a Surface do bitmap Destino
	virtual void BlitSurface( const int x, const int y, const CBitmap & where ) const;
	//!copia a surface do Bitmap Atual para a Surface do bitmap Destino
	virtual void BlitSurface( const int SrcX, const int SrcY, const int Dstx, const int DstY, const CBitmap & where ) const;
	//!copia a surface do Bitmap Atual para a Surface do bitmap Destino
	virtual void BlitSurface( const int SrcX, const int SrcY, const int width, const int height, const int DstX, const int DstY, const CBitmap & where ) const;
	
	//!==== Blit the Surface to the Default Renderer
	virtual void BlitSurface( const int SrcX, const int SrcY, const int width, const int height, const int DstX, const int DstY) const;
	virtual void BlitSurface() const;
	//!==== Blit the Surface to the Default Renderer and to the Screen
	virtual void BlitSurfaceToScreen( const int SrcX, const int SrcY, const int width, const int height) const;
	virtual void BlitSurfaceToScreen( const int SrcX, const int SrcY, const int width, const int height, const int DstX, const int DstY) const;

	virtual void Blit( const string & xpath ) const;
								
	virtual void BlitMasked( const int sourceX1, const int sourceY, const int sourceWidth, const int sourceHeight, const int destX, const int destY, const CBitmap & where ) const;
	/** atualiza a textura com o trabalho feito na Surface, depois atuializa o render e depois coloca na janela
    * alongando a mesma at� o tamanho da janela
    * \param x: coordenada x do ponto de in�cio
	* \param y: coordenada y do ponto de in�cio
	*/
	virtual void BlitSurfaceToScreen( bool stretched=false);
	virtual void BlitAreaToScreen(const int upper_left_x, const int upper_left_y) const;
	virtual void BlitFromScreen(const int x, const int y) const;


	// =================m�todos de preenchimento

	virtual void fill(Uint8 r, Uint8 g, Uint8 b,Uint8 a=255 ) const;
	virtual void fill(Uint32 pixel ) const;
	virtual void fill( Colors::ColorDefinition color, Uint8 a=255 ) const;

	virtual void fill(int x, int y, int w, int h, int pixel);
	
	virtual void fill_all_screen( Uint8 r, Uint8 g, Uint8 b,Uint8 a=255 ) const;

	SGF_INLINE void clear() const{
		this->fill( 0,0,0 );
	}
	SGF_INLINE void clear_all_screen() const{
		this->fill_all_screen( 0,0,0 );
	}
    SGF_INLINE void clearToMask() const{
		this->fill(getDefaultColorkey());
	}


	//===============TEXT and  FONT METHODS=====================
	//! Render the string to this surface or texture depending on the bitmapmode
	virtual void Render(char *string,int x,int y, Colors::ColorDefinition textColor, CFont *fonte) const;  //!render SDL_ttf text to dst surface
	
	//! escolhe a cor padr�o para o render
	void SetDefColor(int R, int G, int B, int A);
	//===========ERROR================
	//ainda n�o defini como ser� o tratamento de erros.
	bool getError();
	bool getError() const;
	
	//!Display debug information to the debug file
	void debugSelf() const;

	
	//Tanto para surface quanto para textura, dependendo do modo
	void setClipRect( int x1, int y1, int x2, int y2 ) const;
	void getClipRect( int& x1, int &y1, int& x2, int& y2 ) const;





    static double getScale();


	void SetFullScreen();
	void SetWindowed();
	void SetWindowMode(int w, int h);
	//static int setGfxModeText();
	static int setGfxModeFullscreen( int x, int y );
	static int setGfxModeWindowed( int x, int y );





	// Bitmap Modes for CBitmap
	//! indicate if it will work on texture, surface, both...
	static const BitmapType DRAW_TYPE_TEXTURE;
	static const BitmapType DRAW_TYPE_SURFACE;
	static const BitmapType DRAW_TYPE_TEX_SURF;
	static const BitmapType DRAW_TYPE_GL;
	static const BitmapType DRAW_TYPE_RENDERER;
	static BitmapType DRAW_TYPE_DEFAULT;

	//! Modes Of Work
	//! Work with texture, bitmap, both direct to the render
	SGF_INLINE void useTexture() { _my_actual_draw_type= USE_TEXTURE; };
	SGF_INLINE void useSurface(){ _my_actual_draw_type=USE_SURFACE; };
	SGF_INLINE void useRenderer(){ _my_actual_draw_type=USE_RENDERER; };
	SGF_INLINE void useGLTexture(){ _my_actual_draw_type=USE_GL_TEXTURE; };
	SGF_INLINE void useTexture()const { _my_actual_draw_type= USE_TEXTURE; };
	SGF_INLINE void useSurface()const { _my_actual_draw_type=USE_SURFACE; };
	SGF_INLINE void useRenderer()const{ _my_actual_draw_type=USE_RENDERER; };
	SGF_INLINE void useGLTexture()const{ _my_actual_draw_type=USE_GL_TEXTURE; };
	

	
	void setBitmapMode( BitmapType mode )const;

	// these are used on drw methods
	enum DrawMethod{
	SPRITE_NO_FLIP=0x1,
	SPRITE_V_FLIP=0x2,
	SPRITE_H_FLIP=0x4,
	SPRITE_NORMAL=0x8,
	SPRITE_LIT=0x10,
	SPRITE_TRANS=0x20,
	};
	// importadas do CvideoSystem // very old methods i think i do not use them anymore
    //fun��es obsoletas do openmugen original: evitar usar
    void DrawRect16(Sint16 x,Sint16 y,Sint16 w,Sint16 h,Uint8 R,Uint8 G,Uint8 B);
    void DrawRect32(Sint32 x,Sint32 y,Sint32 w,Sint32 h,Uint8 R,Uint8 G,Uint8 B);
    void DrawText(int x,int y,char *strText,...);
    void FilterImage();
    
	/** converte uma imgem para o formato surface do SDL
	* \note n�o utilizado mais. foi substituido pelo SDL_ConvertSurface
	*/
	SDL_Surface* ConvertImageToSDL(BYTE *byImageData,Colors::ColorDefinition* ColorPallet);
	/** converte uma imgem para o formato surface do SDL
	* \note n�o utilizado mais. foi substituido pelo SDL_ConvertSurface
	*/
	SDL_Surface* ConvertImageToSDL32(BYTE *byImageData,Colors::ColorDefinition* ColorPallet);
    CBitmap *ConvetToDysplayFormat();

	//OpenGL
	//! Desenha a superf�cie OpenGL
	void DrawGLScene();  // Draw GL
	void DrawGLCube(int texturenum, float size=2.0, float xcenter=0.0,float ycenter=0.0,float zcenter=0.0,float rotate_x=0.0,float xspeed=0.0, float rotate_y=0.0, float yspeed=0.0,float rotate_z=0.0, float zspeed=0.0, float z=-0.5);
	void DrawGLTexture(int texturenum,float rotate_x=0.0,float xspeed=0.0, float rotate_y=0.0, float yspeed=0.0,float rotate_z=0.0, float zspeed=0.0, float z=-0.5);

	//! Coloca a superf�cie openGL na tela
	void BlitGLToScreen(); // Blit GLTexture to Screen
	//! Retorna o bitmap interno do objeto criado
	int CreateGLTexture();
	// convert bitmap to GL format
	int ConvertToTexture();
	//! retorna a textura OpenGL referente ao CBitmap da Classe
	SGF_INLINE Uint8 * GetGLBitmap() const {
		return _my_bitmap.getGLBitmap();
	}

	//========OPENGL METHODS - used on the OPEN GL Mode of the CBitmap CLass
	
	void ClearGL()const;
	void Switch2D();
    void Switch3D();
	void Triangle(const float x1, const float y1, const float x2, const float y2,const float x3,const float y3, int R=255, const int G=255, const int B=255); // Draw Colored Triangle
    void TriangleFill(const float x1, const float y1, const float x2, const float y2,const float x3,const float y3,const int R=255, const int G=255, const int B=255, bool rotate=0,float angle=0.0); // Draw Colored Triangle
    
	//!Desenha um Quadrado azul
    void Box(const float x1, const float y1,const float x2, float y2, const int R=255, const int G=255, const int B=255,bool rotate=0,float angle=0.0); //Draw a Blue Box
	void BoxFill(const float x1,const float y1,const float x2, float y2, const int R=255, const int G=255, const int B=255, bool rotate=0,float angle=0.0); //Draw a Blue Box
	void BoxTex(int filter, const float x1, const float y1,const float x2, float y2, const int R=255, const int G=255, const int B=255,bool rotate=0,float angle=0.0); //Draw a Blue Box
	void GL_Line(const float x1=0.0,const float y1=0.0,const float x2=0.0,const float y2=0.0, const int R=255, const int G=255, const int B=255, const float z1=0.0,const float z2=0.0);
	void Point(const float x=0.0,const float y=0.0,const int R=255, const int G=255, const int B=255, const float z=0.0);
    //!Desenha um Circulo
    void CircleFill(const float x,const float y,const float radius,const int R=255, const int G=255, const int B=255,bool rotate=0,float angle=0.0); //Draw a Blue Circle
    void Circle(const float x,const float y,const float radius,const int R=255, const int G=255, const int B=255,bool rotate=0,float angle=0.0); //Draw a  Circle
	//void Arc(const float x, const float y, const float ang1, const float ang2, const float radius/*, const Uint32 pixel, Uint8 A=255*/ ) const;
    void Arc(const float x, const float y, const float startAngle, const float endAngle, const float radius, const int R=255,const int G=255,const int B=255/*, Uint8 A=255*/ ) const;
	void ArcFill(const float x, const float y, const float startAngle, const float endAngle, const float radius, const int R=255,const int G=255,const int B=255/*, Uint8 A=255*/ ) const;
	void Star(const float x, const float y, const float ang1, const float ang2, const float radius/*, const Uint32 pixel, Uint8 A=255*/ ) const;
    void SetLineWidth(float width=1);
    //! inicializa light no OpenGL
	void SetGLLight();
    //! Determina como a ilumina��o ser� usada
    void SetGLLightAmbient(float a,float b,float c,float d); /* white ambient light at half intensity (rgba) */
	void SetGLLightDiffuse(float a,float b,float c,float d);  /* super bright, full intensity diffuse light. */
	void SetGLLightPosition(float x,float y,float z,float p);  /* position of light (x, y, z, (position of light)) */
    void EnGLLight();
	void DisGLLight();
	//! inicializa o blending
	void SetGLBlending();
	//! Habilita o Blend para este bitmap
    void EnGLBlending();
    //! Habilita o Blend para este bitmap
    void DisGLBlending();
   

	static SDLState_t * _my_state;
	void setCreatedFromPCX(bool type){
		createdFromPCX=type;
	}
	void setBitPCXMaskColor(Colors::ColorDefinition color){
	bitPCXMaskColor=color;
	}
protected:
	
	//Util::Thread::LockObject bitmapLock;
	float GetNumCircleSegments(float radius) const;
	void fillSurface( Uint32 pixel) const;  //! preenche apenas a surface
	void fillTexture( Uint8 r, Uint8 g, Uint8 b, Uint8 a) const; //!preenche apenas a Textura


	// Text methods
	void RenderToTexture(char *string,int x,int y, Colors::ColorDefinition textColor, CFont *fonte) const;  //!render SDL_ttf text to dst surface
	void RenderToSurface(char *string,int x,int y, Colors::ColorDefinition textColor, CFont *fonte) const;

	//Clip Rect Methods
	void setSurfaceClipRect( int x1, int y1, int x2, int y2 ) const;
	void setTextureClipRect( int x1, int y1, int x2, int y2 ) const;
	
	void getSurfaceClipRect(int & x1, int & y1, int & x2, int & y2) const;
	void getTextureClipRect(int & x1, int & y1, int & x2, int & y2) const;

	
	mutable RectArea ClipRectText;  //!usado para delimitar o ret�ngulo nas opera��es com textura
    

    SGF_INLINE void setBitmap( SDL_Surface * bitmap ){
            _my_bitmap.setBitmap(bitmap);
        }
	SGF_INLINE void setTexture( SDL_Texture * texture ){
            
			_my_bitmap.setTexture(texture);
			
        }
    SGF_INLINE void SetGLBitmap( Uint8 * bitmap ){
		this->_my_bitmap.SetGLBitmap(bitmap);
        }


	void internalLoadFile( const char * load_file, int window );


	//! converte coordenada do eixo X 2D para 3D
	float ConvertXto3D(int x);
	//! converte coordenada do eixo Y 2D para 3D
	float ConvertYto3D(int y);
	//! converte coordenada do eixo X 2D para 3D
	float ConvertXto3D(float x);
	//! converte coordenada do eixo Y 2D para 3D
	float ConvertYto3D(float y);
	//! converte coordenada do eixo X 3D para 2D
	float ConvertXto2D(float x);
	//! converte coordenada do eixo Y 3D para 2D
	float ConvertYto2D(float y);
	//! determina a textura interno do objeto

	//!inicializa��o do OpenGL
	void InitGL(int width, int height);  // GL Functions
	static CBitmap * temporary_bitmap;
	static CBitmap * temporary_bitmap2;


	//! indica se ocorreu algum erro
	mutable bool error;
	// indica se o modo 3d est� habilitado
	bool GL3D;
	// indica se o modo 2D est� habilitado
	bool GL2D;
	//! caminho da imagem
	string path;
	//! armazenamento para uma textura
    int texture[MAX_TEXTURES]; /* storage for one texture  */
    //!Armazenamento de um GL CBitmapt
	//void *raw;
	//! indica se o openGl est� habilitado ou n�o
	static bool GLenabled;
  //======================  SDL 2

	//! define janela padr�o de renderiza��o
	int _my_renderWindow;
	
	mutable SDL_BlendMode _my_texture_draw_blend_mode; // set the blend mode for a texture, used by SDL_RenderCopy().
	mutable BitmapType _my_actual_draw_type;  //determina o type de drawing a usar (textura, surface, GL, etc)
	mutable BitmapType _my_default_draw_type;
	int _my_width,_my_height;
	bool createdFromPCX; //!indica que este bitmap foi criado atrav�s de uma imagem pcx
	//! se foi criado de um PCX, indica qual a cor da mascara, sen�o indica a cor de m�scara padr�o (255,0,255)
     Colors::ColorDefinition bitPCXMaskColor;

	friend class CTranslucentBitmap;
	
	//BitSurfaces _my_bitmap;
    
};


} //end namespace SGF
#endif
