// #if defined base
// 		Hatos
//   		Fb.com/haidangtencis
// #endif



#define SERVER_GM_TEXT "DUCKMANCITY"

#include <a_samp>
#include <sscanf2>
#include <a_mysql>	
#include <streamer>
#include <yom_buttons>
#include <ZCMD>
#include <timerfix>

#include <foreach>
#include <YSI\y_timers>
#include <YSI\y_utils>
//#include <crashdetect>
#include <compat>
// #include <H-AC>
#include <sampvoice>
#include <dini>

#if defined SOCKET_ENABLED
#include <socket>
#endif

// Jerry
#define INV_MAX_WEAPON_AMOUNT 5
enum E_INV {
    //weapons
    E_INV_WEP[INV_MAX_WEAPON_AMOUNT],
    E_INV_WEP_ISUSE[INV_MAX_WEAPON_AMOUNT]
}
new PInventory[MAX_PLAYERS][E_INV];

/*------------------------Include-----------------------*/
#include "./includes/base.pwn"

/*------------------------System-------------------------*/

/* Jerry */
// neu khong co file nay thi comment dong phia duoi de build test
#include "./includes/inventory.pwn"

//#pragma disablerecursion
main() {}

public OnGameModeInit()
{
	//LoadTabeldd();
	print("Load GameMode [DONE]");
	g_mysql_Init();
	
	return 1;
}

public OnGameModeExit()
{
    g_mysql_Exit();
	return 1;
}
