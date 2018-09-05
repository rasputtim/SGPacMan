/*
  SGPacMan - Pacman Super Game Fabric
  Copyright (C) 2010-2011 Rasputtim <Rasputtim@hotmail.com>

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


#include "settings.h"
#include "PacGlobal.h"



int CPacConfiguration::setPath(int mode,std::string str) {
    int i;

    switch (mode) {
    case MODE_LEVELS:
        for (i=0;i<lvlpathcount;i++) {
            if (lvlpath[i]=="levels/" + str + "/") {
                m_lvlpathcurrent.setInteger(i);
                return 0;
            }
        }
        break;
        case MODE_SKINS:
        for (i=0;i<skinspathcount;i++) {
            if (skinspath[i]=="skins/" + str + "/") {
                m_skinspathcurrent.setInteger(i);
                return 0;
            }
        }
        break;
        default:
        break;
    }

    return 1;
}

void CPacConfiguration::loadConfigurations(){
	SGF::CConfiguration::loadConfigurations();
	SGF::CConfiguration::setUserConfigFile(string("data\\PacManConfig.xml"));
	//! define config parameters
	ADDXMLPARAMETER("configuration", "pacman_config", "level_path");
	ADDXMLPARAMETER("configuration", "pacman_config", "level_path");
	ADDXMLPARAMETER("configuration", "pacman_config", "skins_path");
	ADDXMLPARAMETER("configuration", "level_config", "field_width");
	ADDXMLPARAMETER("configuration", "level_config", "field_height");
	ADDXMLPARAMETER("configuration", "level_config", "tile_size");
	ADDXMLPARAMETER("configuration", "level_config", "pac_startx");
	ADDXMLPARAMETER("configuration", "level_config", "pac_starty");
	ADDXMLPARAMETER("configuration", "level_config", "pac_speed");
	ADDXMLPARAMETER("configuration", "level_config", "baddie_startx");
	ADDXMLPARAMETER("configuration", "level_config", "baddie_starty");
	ADDXMLPARAMETER("configuration", "level_config", "baddie_speed");
	ADDXMLPARAMETER("configuration", "level_config", "baddie_iq");
	ADDXMLPARAMETER("configuration", "level_config", "vulnerability_duration");
	ADDXMLPARAMETER("configuration", "level_config", "gatex");
	ADDXMLPARAMETER("configuration", "level_config", "gatey");

	try{
        //carrega o primeiro arquivo de configuração
		SGF::CConfiguration::loadUserConfigurations();
		string cfgFileDir;
        string cfgFileName;
        int level = m_lvlpathcurrent.getInteger();
        if (lvlpath.size()>0) {
        cfgFileDir = this->lvlpath[level];
        }else {
        cfgFileDir = "";
        }
        cfgFileName = cfgFileDir+CFGFILE;
		//carrega o arquivo de configuração do level
		SGF::CConfiguration::setUserConfigFile(cfgFileName);
		SGF::CConfiguration::loadUserConfigurations();
		//retorna o nome do arquivo de configuração atual
		SGF::CConfiguration::setUserConfigFile(string("data\\PacManConfig.xml"));
		//loadConfigurations(CConfiguration::getUserConfigFile().path());
		//loadConfigurations( (lvlpath[lvlpathcurrent] + CFGFILE) );
     } catch ( const CLoadException & le ){
        Debug::debug( Debug::gameEngine,__FUNCTION__ )  << "Notice: Could not load configuration file " << Filesystem::getInstance().configFile().path() << ": " << le.getTrace() << endl;
    } catch ( const CTokenException & t ){
        Debug::debug( Debug::gameEngine,__FUNCTION__ ) <<  "Problem Loading Token: " << t.getTrace() << endl;
    }
}

void CPacConfiguration::loadConfigurations(std::string filename){
			//vector<SGF::CSysVar*> localvars;
			SGF::CConfiguration::setUserConfigFile(filename);
		    SGF::CConfiguration::loadUserConfigurations();
			SGF::CConfiguration::setUserConfigFile(string("data\\PacManConfig.xml"));


}

//----------call back functions


void CPacConfiguration::levelpathCallBack(const char *){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< /*stringParam <<*/ endl;
	CEngineSysVar * customervar=(CEngineSysVar *)SGF::globalSysVarSystem.Find("level_path");
	string valor = string(customervar->getString());
	lvlpath.push_back("levels/" + valor + "/");
	lvlpathcount++;
}
void CPacConfiguration::skinspathCallBack(const char *){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< /*stringParam <<*/ endl;
	CEngineSysVar * customervar=(CEngineSysVar *)SGF::globalSysVarSystem.Find("skins_path");
	string valor = string(customervar->getString());
	skinspath.push_back("skins/" +valor + "/");
	skinspathcount++;
}
CPacConfiguration::CPacConfiguration():
lvlpathcount(0),
skinspathcount(0),
m_lvlpathcurrent("level_path","0", SYSVAR_GAME  ,"current level path"),
m_skinspathcurrent("skins_path","minimal", SYSVAR_GAME,"current skin path"),
m_gatex(" gatex","0", SYSVAR_GAME | SYSVAR_INTEGER,"x coordinate of the gate"),
m_gatey("gatey","0", SYSVAR_GAME | SYSVAR_INTEGER,"y coordinate of the gate"),
m_fieldwidth("field_width","0", SYSVAR_GAME | SYSVAR_INTEGER,"weigth of the field"),
m_fieldheight("field_height","0", SYSVAR_GAME | SYSVAR_INTEGER,"height of the field"),
m_tilesize("tile_size","0", SYSVAR_GAME | SYSVAR_INTEGER,"size of tile in pixels"),
m_pacstartx("pac_startx","0", SYSVAR_GAME | SYSVAR_INTEGER,"x coordinate of pacman starting point"),
m_pacstarty("pac_starty","0", SYSVAR_GAME | SYSVAR_INTEGER,"y coordinate of pacman starting point"),
m_pacspeed("pac_speed","0", SYSVAR_GAME | SYSVAR_INTEGER,"pacman speed"),
m_baddiestartx("baddie_startx","0", SYSVAR_GAME | SYSVAR_INTEGER,"x coordinate of baddie starting point"),
m_baddiestarty("baddie_starty","0", SYSVAR_GAME | SYSVAR_INTEGER,"y coordinate of baddie starting point"),
m_baddiespeed("baddie_speed","0", SYSVAR_GAME | SYSVAR_INTEGER,"speedy of baddies"),
m_baddieiq("baddie_iq","0", SYSVAR_GAME | SYSVAR_INTEGER,""),
m_vuln_duration("vulnerability_duration","0", SYSVAR_GAME | SYSVAR_INTEGER,"vulnerability duration in ticks")
{
addCallBackHandlers();
}

void CPacConfiguration::addCallBackHandlers(){
m_lvlpathcurrent.addHandleToObject<CPacConfiguration>(this,&CPacConfiguration::levelpathCallBack);
m_skinspathcurrent.addHandleToObject<CPacConfiguration>(this,&CPacConfiguration::skinspathCallBack);
}

CPacConfiguration::~CPacConfiguration() {}

#if 0
//----------call back functions

void CPacConfiguration::skinspathCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	skinspath.push_back("skins/" + stringParam + "/");
	skinspathcount++;
}
void CPacConfiguration::levelpathCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	lvlpath.push_back("levels/" + stringParam + "/");
	lvlpathcount++;
}

void CPacConfiguration::fieldwidthCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	fieldwidth=atoi(stringParam.c_str());
}
void CPacConfiguration::fieldheightCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	fieldheight=atoi(stringParam.c_str());
}
void CPacConfiguration::tilesizeCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	tilesize=atoi(stringParam.c_str());
}
void CPacConfiguration::pacstartxCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	pacstartx=atoi(stringParam.c_str());
}
void CPacConfiguration::pacstartyCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;

	pacstarty=atoi(stringParam.c_str());
}
void CPacConfiguration::pacspeedCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	pacspeed=atoi(stringParam.c_str());
}
void CPacConfiguration::baddiestartxCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	baddiestartx=atoi(stringParam.c_str());
}
void CPacConfiguration::baddiestartyCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	baddiestarty=atoi(stringParam.c_str());
}
void CPacConfiguration::baddiespeedCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	baddiespeed=atoi(stringParam.c_str());
}
void CPacConfiguration::baddieiqCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	baddieiq=atoi(stringParam.c_str());
}
void CPacConfiguration::vuln_durationCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	vuln_duration=atoi(stringParam.c_str());
}
void CPacConfiguration::gatexCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;
	gatex=atoi(stringParam.c_str());

}
void CPacConfiguration::gateyCallBack(std::string &stringParam){
	Debug::debug( Debug::configuration,__FUNCTION__ ) << "CALL BACK RODANDO - PARAM: "<< stringParam << endl;

gatey=atoi(stringParam.c_str());
}
#endif
                                                                 