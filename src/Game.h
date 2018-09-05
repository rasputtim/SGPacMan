/*
  SGPacMan - Pacman Super Game Fabric
  Copyright (C) 2010-2011 Rasputtim <a_materasu@hotmail.com>

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

#ifndef _PAC_GAME_H_
#define _PAC_GAME_H_

#include "Sounds.h"
#include "BckgrObj.h"
#include "Pacman.h"
#include "Ghost.h"
#include "hScore.h"
#include "Gamecore/ai/SGF_Map.h"
#include "Gamecore/game/SGF_Control.h"
#include "Gamecore/game/SGF_World.h"

#define NUMOFOBJECTS 6
using namespace SGF;
class Sounds;
namespace SGF {
class CBaseObject;
class CMap;
class CGameControl;
class CBitmap;
class CWorld;
}
class CPacGameControl : public SGF::CGameControl
{


public:
//Contructor Destructor
	//! CMenu_v2 actions

    CPacGameControl();
    ~CPacGameControl();
	// Métodos virtuais herdados da classe Base
	int runMenu() {return true;};
	bool loadConfiguration(){return true;};  //De fato as configurações devems er carregadas antes de inicializar a classe

	//Métodos locais
	//! método que inicailiza os sons
	void initSounds();
	void initWindow();
	void setQuit( bool q ) { quit = q; }
	inline bool getQuit() const { return quit; }
	SGF::CBitmap* getWork() { return work;}
	//! retorna um ponteiro para a classe de controle dos sons
	Sounds* getSnd() { return snd; }
	inline SGF::CBitmap *getScreen() {return work;}

protected:


private:
	CInputManager *pCurInputManager;  //! inicializa Inpout Manager
    //////////////
    //Global
    //////////////
	bool  quit;       //flaq que, se verdadeiro, sair da aplicação
	SGF::CBitmap *work;      //! bitmap que corresponde a janela principal
    Sounds  *snd;  //! ponteiro para a classe de controle de sons
};

class Game :public SGF::CWorld
{
public:
    Game();
    ~Game();
	enum Actions{
			Up,
			Down,
			Left,
			Right,
			Select,
			Back,
			Cancel,
			Modify,
			Pause,
			ChangeSkin,
			InitEditor,
			SaveEditor,
			ShowFPS,
			ActionN,
			ChangeLevel,
			ActionH,
			Click,
			Help,
			TogleSound
		};

	virtual void act() ;
	virtual void draw( SGF::CBitmap * work=NULL );
	void showHelpScreen();
	void showEditorHelpScreen();
	virtual bool isFinished() const {return getGameControl()->getQuit();};

	virtual void reloadLevel();

    //s virtual Script::CEngine * getEngine() const = 0;

	/* upper left hand corner of the screen */
	virtual int getX() {return 0;};
	virtual int getY() {return 0;};
	 /* set to paused */
	virtual void pause() ;
	/* mostra tela de help */
	virtual void help() ;
	virtual bool isPaused() {return ispaused;};

    void getMaps( SGF::CMap *m, SGF::CMap *o);

	void renderEnterHscore();
    void renderViewHscore();
	void setGameControl(CPacGameControl * Game) { gameControl=Game;}
	inline CPacGameControl *getGameControl() const { return gameControl;}
	void addMessage(Network::Message m, Network::Socket from = 0, Network::Socket to = 0){};


    void processInput(int k, int ix = -1, int iy = -1);
    void processLogic();
    void logicGame();
    void logicEnterHscore();

    void nextLvl();
    void gameInit(std::string level="", std::string skin="", bool editor=false);

    void boost();

    int  getState() { return state; }
    void setState( int st);

    void toggleFps() { showfps = !showfps; }

    void clearHscore();

    bool isinit;

    void toggleSound();
    void changeSkin();

    void initEditor();
    void renderEditor();
    void logicEditor();
    void editorSave();
    void setEditorPath(std::string path) {editorpath=path;}
	//! Game Loop Process everything
	static void run(Game & thisGame);
	void doAction(Actions Action, int mousex=0, int mousey=0);
    void PrepareShutdown();

private:
	CPacGameControl * gameControl;
    int
            state,
            counter;  //incrementado a cada vez que executa o método render

    std::string
            fps;

    SDL_Rect
            fpsbox,
            scorebox,
            floatingscorebox;

    unsigned int
            ticks;

    SGF::CBaseObject
            *objects[NUMOFOBJECTS];

    ///////////////////////
    // GAME OBJECTS
    //////////////////////
	SGF::CMap fieldMap, objMap;

    int
            //*map,
            //*objmap,
            key,
            score,
            deadghostcount,	//used to multiplay score for eating ghosts
            lives,
            objscore,
            floatingX,
            floatingY,
            floatingscore,
            floatingscorecounter,
            specialspawntime,
            level,
            namecol[3],
            hscoreselection;

    unsigned int
            soundcounter,
            time,
            oldtime,
            ghosttick,
            fruittick,
            pausetick,
            boosttick;

    bool
            inputwaiting,
            gamestarted,
            vulnflag,
            specialspawned,
            specialeaten,
            specialhasbeenspawned,
            ispaused,
            isboosted,
			showHelp,
            boostavailable,
            levelcleared,
            renderisbusy;
	static bool showfps;
    std::string
            num[10],
            name;

    hScore
            hscore;



    //////////////////////////////////
    // EDITOR OBJECTS
    //////////////////////////////////

    int
            activetool,
            mouseX,
            mouseY;

    std::string
            editorpath;

};

#endif
