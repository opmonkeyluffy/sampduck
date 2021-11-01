/*
    Inventory System
    by Jerry © 2021
    Idea by DuckBatman
*/

/*
    alter table `accounts` add column `InvWeapons` varchar(128) default '0|0|0|0|0';
	alter table `houses` add column `TienBan` int default 0;
	alter table `houses` add column `Fe` int default 0;
	alter table `houses` add column `Cu` int default 0;
	alter table `houses` add column `Au` int default 0;
	alter table `houses` add column `Wood` int default 0;
*/


#include <YSI\y_hooks>

#define INV_WEPSELL 16000
#define INV_WEPSELL_AMOUNT 16001
#define INV_WEPSELL_PRICE 16002
#define INV_WEPSELL_CONFIRM 16003
#define INV_WEP_INTERACT 16004
#define INV_WEP 16005
#define INV_WEAPONS 16006
#define INV_GENERAL1 16007
#define INV_GENERAL2 16008
#define INV_MAIN 16009
#define INV_MATERIALS 16010
#define INV_MATERIALEXTRA 16011
#define INV_SELL_MINERAL 16012
#define INV_SELL_MINERAL_AMOUNT 16013
#define INV_SELL_MINERAL_PRICE 16014
#define INV_SELL_MINERAL_CONFIRM 16015
#define INV_SELL_MATEXTRA 16016
#define INV_SELL_MATEXTRA_AMOUNT 16017
#define INV_SELL_MATEXTRA_PRICE 16018
#define INV_SELL_MATEXTRA_CONFIRM 16019
#define INV_MINERALS 16020
#define INV_SELL_MAGAZINE 16021
#define INV_THUCAN 16022

GetMaxInvQuantity(playerid, type) {
	new amount = 0;
	switch(type) {
		case INV_TYPE_LACANSA: {
			amount = INV_MAX_LACANSA;
		}
		case INV_TYPE_GOICANSA: {
			amount = INV_MAX_GOICANSA;
		}
		case INV_TYPE_MATERIALS: {
			amount = INV_MAX_MATERIALS;
		}
		case INV_TYPE_WOOD: {
			amount = INV_MAX_WOOD;
		}
		case INV_TYPE_MINERAL: {
			amount = INV_MAX_MINERAL;
		}
		case INV_TYPE_MAGAZINE: {
			amount = MAX_MAGAZINES;
		}
		case INV_TYPE_WEAPONAMOUNT: {
			amount = INV_MAX_WEAPON_AMOUNT;
		}
	}
	if(PlayerInfo[playerid][pDonateRank] > 0) amount *= 2;
	
	return amount;
}

InvIfPlayerTrading(playerid) {
	if(GetPVarType(playerid, "InvWepSeller") && IsPlayerConnected(GetPVarInt(playerid, "InvWepSeller"))) {
		return true;
	}
	if(GetPVarType(playerid, "InvTradeMineralSeller") && IsPlayerConnected(GetPVarInt(playerid, "InvTradeMineralSeller"))) {
		return true;
	}
	if(GetPVarType(playerid, "InvTradeMatextraSeller") && IsPlayerConnected(GetPVarInt(playerid, "InvTradeMatextraSeller"))) {

		return true;
	}
	return false;
}

GetMagNameBySlot(slot)
{
	new magName[32];
	switch(slot) {
		case 1: {
			magName = "9mm, Sdpistol";
		}
		case 2: {
			magName = "Shotgun";
		}
		case 3: {
			magName = "Uzi";
		}
		case 4: {
			magName = "TEC-9";
		}
		case 5: {
			magName = "Mp5";
		}
		case 6: {
			magName = "Deagle";
		}
		case 7: {
			magName = "Rilfe";
		}
		case 8: {
			magName = "AK-47";
		}
		case 9: {
			magName = "M4A1";
		}
		case 10: {
			magName = "Spass-12";
		}
		case 11: {
			magName = "Sniper";
		}
	}
	return magName;
}

GetFreeSlotInvWeapon(playerid)
{
    for(new i; i < 5; i++) {
        if(PInventory[playerid][E_INV_WEP][i] == 0) return i;
    }
    return -1;
}

GetPlayerWeaponIDBySlot(playerid, slot) {
    return PInventory[playerid][E_INV_WEP][slot];
}

hook OnPlayerConnect(playerid)
{
    static const empty[E_INV];
    PInventory[playerid] = empty;
}

CMD:tuido(playerid, params[]) {
	if(gPlayerLogged{playerid} != 0) {
        Show_Inventory(playerid);
    }
    return 1;
}

Show_Inventory(playerid, type = 0)
{
    switch(type) {
        case 0: {
            new szDialog[425];
            format(szDialog, sizeof szDialog, "Tong quan\nVu khi\nThuc an\nNguyen lieu\nSuc chua (%s)", PlayerInfo[playerid][pDonateRank] > 0 ? "VIP" : "NORMAL");
            ShowPlayerDialog(playerid, INV_MAIN, DIALOG_STYLE_LIST, "Tui Do", szDialog, "Chon", "Dong");
        }
        case 1: { // general
            Show_InventoryGeneral(playerid);
        }
        case 2: { // weapons
            ShowPlayerDialog(playerid, INV_WEAPONS, DIALOG_STYLE_LIST, "Tui Do Vu khi", "Vu khi\nBang dan", "Chon", "Dong");
        }
		case 3: { // nguyen lieu
			ShowPlayerDialog(playerid, INV_MATERIALS, DIALOG_STYLE_LIST, "Tui Do Khoang San", "Khoang San\nThem", "Chon", "Dong");
		}
		case 4: {
			new string[128];
			format(string, sizeof(string), "Banh mi: %d\nNuoc suoi: %d", PlayerInfo[playerid][pBanhMi], PlayerInfo[playerid][pNuocSuoi]);
			ShowPlayerDialog(playerid, INV_THUCAN, DIALOG_STYLE_LIST, "Tui do thuc an", string, "Chon", "Dong");
		}
    }
    return 1;
}

Show_InventoryGeneral(playerid, type = 0) {
    switch(type) {
        case 0: { // general 1
            new szDialog[2048];
            format(szDialog, sizeof szDialog, "\t{AB2710}Vu khi{FFFFFF}\n");
            for(new i = 0; i < INV_MAX_WEAPON_AMOUNT; i++) {
                if(PInventory[playerid][E_INV_WEP][i] != 0) {
                    format(szDialog, sizeof szDialog, "%s%s\n", szDialog, GetWeaponNameEx(PInventory[playerid][E_INV_WEP][i]));
                }
            }

			new _maxMag = GetMaxInvQuantity(playerid, INV_TYPE_MAGAZINE);
            
            format(szDialog, sizeof szDialog, "%s\t{AB4C09}Bang dan{FFFFFF}\n", szDialog);
            if(PlayerInfo[playerid][pBangDan][ 1 ] > 0) format(szDialog, sizeof szDialog, "%s9mm, Sdpistol\t%s\n" , szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 1 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 6 ] > 0) format(szDialog, sizeof szDialog, "%sDeagle\t%s\n" , szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 6 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 2 ] > 0) format(szDialog, sizeof szDialog, "%sShotgun\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 2 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 5 ] > 0) format(szDialog, sizeof szDialog, "%sMp5\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 5 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 3 ] > 0) format(szDialog, sizeof szDialog, "%sUzi\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 3 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 4 ] > 0) format(szDialog, sizeof szDialog, "%sTEC-9\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 4 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 9 ] > 0) format(szDialog, sizeof szDialog, "%sM4A1\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 9 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 8 ] > 0) format(szDialog, sizeof szDialog, "%sAK-47\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 8 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 10 ] > 0) format(szDialog, sizeof szDialog, "%sSpass-12\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 10 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 11 ] > 0) format(szDialog, sizeof szDialog, "%sSniper\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 11 ], _maxMag));
            if(PlayerInfo[playerid][pBangDan][ 7 ] > 0) format(szDialog, sizeof szDialog, "%sRilfe\t%s", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 7 ], _maxMag));

            ShowPlayerDialog(playerid, INV_GENERAL1, DIALOG_STYLE_MSGBOX, "Tui Do Tong quan", szDialog, "Tiep", "Dong");
        }
        case 1: { // general 2
            new szDialog[2048];
            format(szDialog, sizeof szDialog, "{FFFFFF}La can sa\t%s\n", Dialog_AmountAvailableColor(PlayerInfo[playerid][pCanSa], GetMaxInvQuantity(playerid, INV_TYPE_LACANSA)));
            format(szDialog, sizeof szDialog, "%sGoi can sa\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pCanSaSX], GetMaxInvQuantity(playerid, INV_TYPE_GOICANSA)));
            format(szDialog, sizeof szDialog, "%sTien ban\t$%s\n", szDialog, number_format(PlayerInfo[playerid][pTienBan]));
            format(szDialog, sizeof szDialog, "%sVat lieu\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pMats], GetMaxInvQuantity(playerid, INV_TYPE_MATERIALS)));
            format(szDialog, sizeof szDialog, "%sGo\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pWoodG], GetMaxInvQuantity(playerid, INV_TYPE_WOOD)));
            format(szDialog, sizeof szDialog, "%sPot\t%d\n", szDialog, PlayerInfo[playerid][pPot]);
            format(szDialog, sizeof szDialog, "%sCrack\t%d\n", szDialog, PlayerInfo[playerid][pCrack]);
            format(szDialog, sizeof szDialog, "%sCredits\t%d\n", szDialog, PlayerInfo[playerid][pCredits]);
            format(szDialog, sizeof szDialog, "%s\t\t{AB4C09}Khoang san{FFFFFF}\n", szDialog);
            format(szDialog, sizeof szDialog, "%sFE\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pFe], GetMaxInvQuantity(playerid, INV_TYPE_MINERAL)));
            format(szDialog, sizeof szDialog, "%sCU\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pCu], GetMaxInvQuantity(playerid, INV_TYPE_MINERAL)));
            format(szDialog, sizeof szDialog, "%sAU\t%s\n", szDialog, Dialog_AmountAvailableColor(PlayerInfo[playerid][pAu], GetMaxInvQuantity(playerid, INV_TYPE_MINERAL)));

            ShowPlayerDialog(playerid, INV_GENERAL2, DIALOG_STYLE_MSGBOX, "Tui Do Tong quan 2", szDialog, "Truoc", "Dong");
        }
    }
}

Dialog_AmountAvailableColor(amount, limit) {
    new string[46];
    if(amount < 1) format(string, sizeof string, "{AB321D}%d/%d{FFFFFF}", amount, limit);
    else format(string, sizeof string, "{19AB2F}%d/%d{FFFFFF}", amount, limit);
    return string;
}

Show_InventoryWeapons(playerid, type = 0) {
    switch(type) {
        case 0: { // weapons
            new szDialog[2048];
            format(szDialog, sizeof szDialog, "Ten vu khi\tTrang thai\n");
            for(new i = 0; i < INV_MAX_WEAPON_AMOUNT; i++) {
                if(PInventory[playerid][E_INV_WEP][i] > 0) {
					format(szDialog, sizeof szDialog, "%s%s\t%s\n", szDialog, GetWeaponNameEx(PInventory[playerid][E_INV_WEP][i]),
					(PInventory[playerid][E_INV_WEP_ISUSE][i] == 0) ? ("{d10000}Da cat") : ("{00d123}Dang su dung"));
				}
                else format(szDialog, sizeof szDialog, "%sTrong\n", szDialog);
				if(i == INV_MAX_WEAPON_AMOUNT-1) {
					strcat(szDialog, "Cat het sung vao");
				}
			}
            ShowPlayerDialog(playerid, INV_WEP, DIALOG_STYLE_TABLIST_HEADERS, "Tui Do Vu khi", szDialog, "Chon", "Huy");
        }
        case 1: { // magazines
            new szDialog[2048];
			new _maxMag = GetMaxInvQuantity(playerid, INV_TYPE_MAGAZINE);

            format(szDialog, sizeof szDialog, "Ten bang dan\tSo luong\n\
                {FFFFFF}9mm, Sdpistol\t%s\n\
                Shotgun\t%s\n\
                Uzi\t%s\n\
                TEC-9\t%s\n\
                Mp5\t%s\n\
                Deagle\t%s\n\
                Rilfe\t%s\n\
                AK-47\t%s\n\
                M4A1\t%s\n\
                Spass-12\t%s\n\
                Sniper\t%s", Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 1 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 2 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 3 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 4 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 5 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 6 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 7 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 8 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 9 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 10 ], _maxMag),
                    Dialog_AmountAvailableColor(PlayerInfo[playerid][pBangDan][ 11 ], _maxMag));
            ShowPlayerDialog(playerid, INV_SELL_MAGAZINE, DIALOG_STYLE_TABLIST_HEADERS, "Tui Do Bang dan", szDialog, "Chon", "Dong");
        }
    }
}

Inv_StartTrade(playerid, type = 0) {
    new szDialog[4096];
    format(szDialog, sizeof szDialog, "ID\tTen nguoi choi\n");
    foreach(new i: Player)
    {
        if(i != playerid && ProxDetectorS(5.0, playerid, i))
        {
            format(szDialog, sizeof szDialog, "%s%d\t%s", szDialog, i, GetPlayerNameEx(i));
        }
    }

    switch(type) {
        case 0: { // weapons & magazines
            ShowPlayerDialog(playerid, INV_WEPSELL, DIALOG_STYLE_TABLIST_HEADERS, "Chon nguoi ban muon giao dich", szDialog, "Chon", "Dong");
        }
		case 1: { // minerals
			ShowPlayerDialog(playerid, INV_SELL_MINERAL, DIALOG_STYLE_TABLIST_HEADERS, "Chon nguoi ban muon giao dich", szDialog, "Chon", "Dong");
		}
		case 2: { // material extra
			ShowPlayerDialog(playerid, INV_SELL_MATEXTRA, DIALOG_STYLE_TABLIST_HEADERS, "Chon nguoi ban muon giao dich", szDialog, "Chon", "Dong");
		}
    }
}

hook OnPlayerDisconnect(playerid, reason) {
	if(GetPVarType(playerid, "InvWepSeller") && IsPlayerConnected(GetPVarInt(playerid, "InvWepSeller"))) {
		DeletePVar(GetPVarInt(playerid, "InvWepSeller"), "InvWepSlot");
		DeletePVar(GetPVarInt(playerid, "InvWepSeller"), "InvTradeWith");
		DeletePVar(GetPVarInt(playerid, "InvWepSeller"), "InvWepSellType");
		DeletePVar(GetPVarInt(playerid, "InvWepSeller"), "InvWepSellAmount");
		DeletePVar(GetPVarInt(playerid, "InvWepSeller"), "InvWepSellPrice");
		SendClientMessage(GetPVarInt(playerid, "InvWepSeller"), -1, "Huy giao dich, nguoi do da thoat game");
	}
	if(GetPVarType(playerid, "InvTradeMineralSeller") && IsPlayerConnected(GetPVarInt(playerid, "InvTradeMineralSeller"))) {
		DeletePVar(GetPVarInt(playerid, "InvTradeMineralSeller"), "InvTradeMineral");
		DeletePVar(GetPVarInt(playerid, "InvTradeMineralSeller"), "InvTradeWith");
		DeletePVar(GetPVarInt(playerid, "InvTradeMineralSeller"), "InvTradeMineralAmount");
		DeletePVar(GetPVarInt(playerid, "InvTradeMineralSeller"), "InvTradeMineralPrice");
		SendClientMessage(GetPVarInt(playerid, "InvTradeMineralSeller"), -1, "Huy giao dich, nguoi do da thoat game");
	}
	if(GetPVarType(playerid, "InvTradeMatextraSeller") && IsPlayerConnected(GetPVarInt(playerid, "InvTradeMatextraSeller"))) {
		DeletePVar(GetPVarInt(playerid, "InvTradeMatextraSeller"), "InvTradeMatextra");
		DeletePVar(GetPVarInt(playerid, "InvTradeMatextraSeller"), "InvTradeWith");
		DeletePVar(GetPVarInt(playerid, "InvTradeMatextraSeller"), "InvTradeMatextraAmount");
		DeletePVar(GetPVarInt(playerid, "InvTradeMatextraSeller"), "InvTradeMatextraPrice");
		SendClientMessage(GetPVarInt(playerid, "InvTradeMatextraSeller"), -1, "Huy giao dich, nguoi do da thoat game");
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
		case INV_SELL_MATEXTRA: {
            if(!response) {
                DeletePVar(playerid, "InvTradeMatextra");
                return 1;
            }

            new
                giveplayerid = strval(inputtext);
            
            if(!IsPlayerConnected(giveplayerid)) {
                DeletePVar(playerid, "InvTradeMatextra");
                return SendClientMessage(playerid, -1, "Nguoi do khong online");
            }
            SetPVarInt(playerid, "InvTradeWith", giveplayerid);

            ShowPlayerDialog(playerid, INV_SELL_MATEXTRA_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich nguyen lieu", "Nhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
            return 1;
        }
		case INV_SELL_MATEXTRA_AMOUNT: {
			if(!response) {
				DeletePVar(playerid, "InvTradeMatextra");
				DeletePVar(playerid, "InvTradeWith");
				return 1;
			}
			
			if(!IsPlayerConnected(GetPVarInt(playerid, "InvTradeWith"))) {
				DeletePVar(playerid, "InvTradeMatextra");
				DeletePVar(playerid, "InvTradeWith");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				slot = GetPVarInt(playerid, "InvTradeMatextra"),
				giveplayerid = GetPVarInt(playerid, "InvTradeWith"),
				amount, _current, _bCurrent, _maximum = 2000000000;

			switch(slot) {
				case 0: { // la can sa
					_current = PlayerInfo[playerid][pCanSa];
					_bCurrent = PlayerInfo[giveplayerid][pCanSa];
					_maximum = GetMaxInvQuantity(giveplayerid, INV_TYPE_LACANSA);
				}
				case 1: { // goi can sa
					_current = PlayerInfo[playerid][pCanSaSX];
					_bCurrent = PlayerInfo[giveplayerid][pCanSaSX];
					_maximum = GetMaxInvQuantity(giveplayerid, INV_TYPE_GOICANSA);
				}
				case 2: { // tien ban
					_current = PlayerInfo[playerid][pTienBan];
					_bCurrent = PlayerInfo[giveplayerid][pTienBan];
				}
				case 3: { // vat lieu
					_current = PlayerInfo[playerid][pMats];
					_bCurrent = PlayerInfo[giveplayerid][pMats];
					_maximum = GetMaxInvQuantity(giveplayerid, INV_TYPE_MATERIALS);
				}
				case 4: { // go
					_current = PlayerInfo[playerid][pWoodG];
					_bCurrent = PlayerInfo[giveplayerid][pWoodG];
					_maximum = GetMaxInvQuantity(giveplayerid, INV_TYPE_WOOD);
				}
			}

			if(sscanf(inputtext, "d", amount) || amount < 1 || amount > _current)
			{
				return ShowPlayerDialog(playerid, INV_SELL_MATEXTRA_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich nguyen lieu", "So luong khong hop le!\nNhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
			}

			if(_bCurrent+amount > _maximum) {
				return ShowPlayerDialog(playerid, INV_SELL_MATEXTRA_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich nguyen lieu", "So luong khong hop le! Nguoi do co qua nhieu nguyen lieu loai do.\nNhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
			}

			SetPVarInt(playerid, "InvTradeMatextraAmount", amount);
			ShowPlayerDialog(playerid, INV_SELL_MATEXTRA_PRICE, DIALOG_STYLE_INPUT, "Giao dich nguyen lieu", "Nhap gia tien ban muon ban phia duoi:", "Ban", "Huy");

		}
		case INV_SELL_MATEXTRA_PRICE: {
			if(!response) {
				DeletePVar(playerid, "InvTradeMatextra");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMatextraAmount");
				return 1;
			}
			
			if(!IsPlayerConnected(GetPVarInt(playerid, "InvTradeWith"))) {
				DeletePVar(playerid, "InvTradeMatextra");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMatextraAmount");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				slot = GetPVarInt(playerid, "InvTradeMatextra"),
				amount = GetPVarInt(playerid, "InvTradeMatextraAmount"),
				giveplayerid = GetPVarInt(playerid, "InvTradeWith"),
				price, _current, mineralName[15];

			if(InvIfPlayerTrading(giveplayerid)) {
				DeletePVar(playerid, "InvTradeMatextra");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMatextraAmount");
				return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi do dang co cuoc giao dich khac roi");
			}

			switch(slot) {
				case 0: { // la can sa
					_current = PlayerInfo[playerid][pCanSa];
					mineralName = "La can sa";
				}
				case 1: { // goi can sa
					_current = PlayerInfo[playerid][pCanSaSX];
					mineralName = "Goi can sa";
				}
				case 2: { // tien ban
					_current = PlayerInfo[playerid][pTienBan];
                    mineralName = "Tien ban";
				}
				case 3: { // vat lieu
					_current = PlayerInfo[playerid][pMats];
					mineralName = "Vat lieu";
				}
				case 4: { // go
					_current = PlayerInfo[playerid][pWoodG];
					mineralName = "Go";
				}
			}

			if(_current < amount) {
				DeletePVar(playerid, "InvTradeMatextra");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMatextraAmount");
				return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong co nguyen lieu nay de ban");
			}

			if(sscanf(inputtext, "d", price) || price < 1 || price > 2000000000)
			{
				return ShowPlayerDialog(playerid, INV_SELL_MATEXTRA_PRICE, DIALOG_STYLE_INPUT, "Giao dich nguyen lieu", "So tien khong hop le!\nNhap gia tien ban muon ban phia duoi:", "Tiep", "Huy");
			}

			if(GetPlayerCash(giveplayerid) < price) {
				DeletePVar(playerid, "InvTradeMatextra");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMatextraAmount");
				return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi do khong co du tien");
			}

			SetPVarInt(playerid, "InvTradeMatextraPrice", price);
			SetPVarInt(giveplayerid, "InvTradeMatextraSeller", playerid);
			new string[128];
			format(string, sizeof string, "{FFFFFF}%s muon ban cho ban %s %s voi gia $%s\n\nBan co mua khong?", GetPlayerNameEx(playerid), number_format(amount), mineralName, number_format(price));
			ShowPlayerDialog(giveplayerid, INV_SELL_MATEXTRA_CONFIRM, DIALOG_STYLE_MSGBOX, "Giao dich nguyen lieu", string, "Mua", "Khong");

		}
		case INV_SELL_MATEXTRA_CONFIRM: {
			new sellerid = GetPVarInt(playerid, "InvTradeMatextraSeller");
			if(!response) {
				DeletePVar(sellerid, "InvTradeMatextra");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMatextraAmount");
				DeletePVar(sellerid, "InvTradeMatextraPrice");
				DeletePVar(playerid, "InvTradeMatextraSeller");
				return 1;
			}
			
			if(!IsPlayerConnected(sellerid)) {
				DeletePVar(sellerid, "InvTradeMatextra");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMatextraAmount");
				DeletePVar(sellerid, "InvTradeMatextraPrice");
				DeletePVar(playerid, "InvTradeMatextraSeller");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				slot = GetPVarInt(sellerid, "InvTradeMatextra"),
				amount = GetPVarInt(sellerid, "InvTradeMatextraAmount"),
				giveplayerid = GetPVarInt(sellerid, "InvTradeWith"),
				price = GetPVarInt(sellerid, "InvTradeMatextraPrice"),
				_sellerCurrent, mineralName[12];

			if(playerid != giveplayerid) {
				DeletePVar(sellerid, "InvTradeMatextra");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMatextraAmount");
				DeletePVar(sellerid, "InvTradeMatextraPrice");
				DeletePVar(playerid, "InvTradeMatextraSeller");
				SendClientMessage(playerid, -1, "Co loi xay ra trong qua trinh giao dich, vui long thu lai.");
				SendClientMessage(sellerid, -1, "Co loi xay ra trong qua trinh giao dich, vui long thu lai.");
				return 1;
			}

            switch(slot) {
				case 0: { // la can sa
					_sellerCurrent = PlayerInfo[sellerid][pCanSa];
					mineralName = "La can sa";
				}
				case 1: { // goi can sa
					_sellerCurrent = PlayerInfo[sellerid][pCanSaSX];
					mineralName = "Goi can sa";
				}
				case 2: { // tien ban
					_sellerCurrent = PlayerInfo[sellerid][pTienBan];
                    mineralName = "Tien ban";
				}
				case 3: { // vat lieu
					_sellerCurrent = PlayerInfo[sellerid][pMats];
					mineralName = "Vat lieu";
				}
				case 4: { // go
					_sellerCurrent = PlayerInfo[sellerid][pWoodG];
					mineralName = "Go";
				}
			}

			if(_sellerCurrent < amount) {
				DeletePVar(sellerid, "InvTradeMatextra");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMatextraAmount");
				DeletePVar(sellerid, "InvTradeMatextraPrice");
				DeletePVar(playerid, "InvTradeMatextraSeller");
				return SendClientMessage(playerid, -1, "Nguoi do khong ban nguyen lieu cho ban");
			}

			if(GetPlayerCash(playerid) < price) {
				DeletePVar(sellerid, "InvWepSlot");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvWepSellType");
				DeletePVar(sellerid, "InvWepSellAmount");
				DeletePVar(sellerid, "InvWepSellPrice");
				DeletePVar(playerid, "InvTradeMatextraSeller");
				SendClientMessage(sellerid, -1, "Nguoi do khong du tien de tra");
				return SendClientMessage(playerid, -1, "Ban khong du tien de tra");
			}

			GivePlayerCash(playerid, -price);
			GivePlayerCash(sellerid, price);

            switch(slot) {
				case 0: { // la can sa
					PlayerInfo[sellerid][pCanSa] -= amount;
					PlayerInfo[playerid][pCanSa] += amount;
				}
				case 1: { // goi can sa
					PlayerInfo[sellerid][pCanSaSX] -= amount;
					PlayerInfo[playerid][pCanSaSX] += amount;
				}
				case 2: { // tien ban
                    PlayerInfo[sellerid][pTienBan] -= amount;
					PlayerInfo[playerid][pTienBan] += amount;
				}
				case 3: { // vat lieu
					PlayerInfo[sellerid][pMats] -= amount;
					PlayerInfo[playerid][pMats] += amount;
				}
				case 4: { // go
					PlayerInfo[sellerid][pWoodG] -= amount;
					PlayerInfo[playerid][pWoodG] += amount;
				}
			}
			
			OnPlayerStatsUpdate(playerid);
			OnPlayerStatsUpdate(sellerid);

			new string[128];
			format(string, sizeof string, "%s da ban cho ban %s %s voi gia $%s", GetPlayerNameEx(sellerid), number_format(amount), mineralName, number_format(price));
			SendClientMessage(playerid, -1, string);
			format(string, sizeof string, "Ban da ban cho %s %s %s voi gia $%s", GetPlayerNameEx(playerid), number_format(amount), mineralName, number_format(price));
			SendClientMessage(sellerid, -1, string);

			DeletePVar(sellerid, "InvTradeMatextra");
			DeletePVar(sellerid, "InvTradeWith");
			DeletePVar(sellerid, "InvTradeMatextraAmount");
			DeletePVar(sellerid, "InvTradeMatextraPrice");
			DeletePVar(playerid, "InvTradeMatextraSeller");
			return 1;
		}
		case INV_SELL_MINERAL: {
            if(!response) {
                DeletePVar(playerid, "InvTradeMineral");
                return 1;
            }

            new
                giveplayerid = strval(inputtext);
            
            if(!IsPlayerConnected(giveplayerid)) {
                DeletePVar(playerid, "InvTradeMineral");
                return SendClientMessage(playerid, -1, "Nguoi do khong online");
            }
            SetPVarInt(playerid, "InvTradeWith", giveplayerid);

            ShowPlayerDialog(playerid, INV_SELL_MINERAL_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich khoang san", "Nhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
            return 1;
        }
		case INV_SELL_MINERAL_AMOUNT: {
			if(!response) {
				DeletePVar(playerid, "InvTradeMineral");
				DeletePVar(playerid, "InvTradeWith");
				return 1;
			}
			
			if(!IsPlayerConnected(GetPVarInt(playerid, "InvTradeWith"))) {
				DeletePVar(playerid, "InvTradeMineral");
				DeletePVar(playerid, "InvTradeWith");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				slot = GetPVarInt(playerid, "InvTradeMineral"),
				giveplayerid = GetPVarInt(playerid, "InvTradeWith"),
				amount, _current, _bCurrent;

			switch(slot) {
				case 0: {
					_current = PlayerInfo[playerid][pFe];
					_bCurrent = PlayerInfo[giveplayerid][pFe];
				}
				case 1: {
					_current = PlayerInfo[playerid][pCu];
					_bCurrent = PlayerInfo[giveplayerid][pCu];
				}
				case 2: {
					_current = PlayerInfo[playerid][pAu];
					_bCurrent = PlayerInfo[giveplayerid][pAu];
				}
			}

			if(sscanf(inputtext, "d", amount) || amount < 1 || amount > _current)
			{
				return ShowPlayerDialog(playerid, INV_SELL_MINERAL_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich khoang san", "So luong khong hop le!\nNhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
			}

			if(_bCurrent+amount > GetMaxInvQuantity(giveplayerid, INV_TYPE_MINERAL)) {
				return ShowPlayerDialog(playerid, INV_SELL_MINERAL_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich khoang san", "So luong khong hop le! Nguoi do co qua nhieu khoang san.\nNhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
			}

			SetPVarInt(playerid, "InvTradeMineralAmount", amount);
			ShowPlayerDialog(playerid, INV_SELL_MINERAL_PRICE, DIALOG_STYLE_INPUT, "Giao dich khoang san", "Nhap gia tien ban muon ban phia duoi:", "Ban", "Huy");

		}
		case INV_SELL_MINERAL_PRICE: {
			if(!response) {
				DeletePVar(playerid, "InvTradeMineral");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMineralAmount");
				return 1;
			}
			
			if(!IsPlayerConnected(GetPVarInt(playerid, "InvTradeWith"))) {
				DeletePVar(playerid, "InvTradeMineral");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMineralAmount");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				slot = GetPVarInt(playerid, "InvTradeMineral"),
				amount = GetPVarInt(playerid, "InvTradeMineralAmount"),
				giveplayerid = GetPVarInt(playerid, "InvTradeWith"),
				price, _current, mineralName[6];

			if(InvIfPlayerTrading(giveplayerid)) {
				DeletePVar(playerid, "InvTradeMineral");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMineralAmount");
				return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi do dang co cuoc giao dich khac roi");
			}

			switch(slot) {
				case 0: {
					_current = PlayerInfo[playerid][pFe];
					mineralName = "FE";
				}
				case 1: {
					_current = PlayerInfo[playerid][pCu];
					mineralName = "CU";
				}
				case 2: {
					_current = PlayerInfo[playerid][pAu];
					mineralName = "AU";
				}
			}

			if(_current < amount) {
				DeletePVar(playerid, "InvTradeMineral");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMineralAmount");
				return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong co khoang san nay de ban");
			}

			if(sscanf(inputtext, "d", price) || price < 1 || price > 2000000000)
			{
				return ShowPlayerDialog(playerid, INV_SELL_MINERAL_PRICE, DIALOG_STYLE_INPUT, "Giao dich khoang san", "So tien khong hop le!\nNhap gia tien ban muon ban phia duoi:", "Tiep", "Huy");
			}

			if(GetPlayerCash(giveplayerid) < price) {
				DeletePVar(playerid, "InvTradeMineral");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvTradeMineralAmount");
				return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi do khong co du tien");
			}

			SetPVarInt(playerid, "InvTradeMineralPrice", price);
			SetPVarInt(giveplayerid, "InvTradeMineralSeller", playerid);
			new string[128];
			format(string, sizeof string, "{FFFFFF}%s muon ban cho ban %d %s voi gia $%s\n\nBan co mua khong?", GetPlayerNameEx(playerid), amount, mineralName, number_format(price));
			ShowPlayerDialog(giveplayerid, INV_SELL_MINERAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Giao dich khoang san", string, "Mua", "Khong");

		}
		case INV_SELL_MINERAL_CONFIRM: {
			new sellerid = GetPVarInt(playerid, "InvTradeMineralSeller");
			if(!response) {
				DeletePVar(sellerid, "InvTradeMineral");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMineralAmount");
				DeletePVar(sellerid, "InvTradeMineralPrice");
				DeletePVar(playerid, "InvTradeMineralSeller");
				return 1;
			}
			
			if(!IsPlayerConnected(sellerid)) {
				DeletePVar(sellerid, "InvTradeMineral");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMineralAmount");
				DeletePVar(sellerid, "InvTradeMineralPrice");
				DeletePVar(playerid, "InvTradeMineralSeller");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				slot = GetPVarInt(sellerid, "InvTradeMineral"),
				amount = GetPVarInt(sellerid, "InvTradeMineralAmount"),
				giveplayerid = GetPVarInt(sellerid, "InvTradeWith"),
				price = GetPVarInt(sellerid, "InvTradeMineralPrice"),
				_sellerCurrent, mineralName[6];

			if(playerid != giveplayerid) {
				DeletePVar(sellerid, "InvTradeMineral");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMineralAmount");
				DeletePVar(sellerid, "InvTradeMineralPrice");
				DeletePVar(playerid, "InvTradeMineralSeller");
				SendClientMessage(playerid, -1, "Co loi xay ra trong qua trinh giao dich, vui long thu lai.");
				SendClientMessage(sellerid, -1, "Co loi xay ra trong qua trinh giao dich, vui long thu lai.");
				return 1;
			}

			switch(slot) {
				case 0: {
					_sellerCurrent = PlayerInfo[sellerid][pFe];
					mineralName = "FE";
				}
				case 1: {
					_sellerCurrent = PlayerInfo[sellerid][pCu];
					mineralName = "CU";
				}
				case 2: {
					_sellerCurrent = PlayerInfo[sellerid][pAu];
					mineralName = "AU";
				}
			}

			if(_sellerCurrent < amount) {
				DeletePVar(sellerid, "InvTradeMineral");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMineralAmount");
				DeletePVar(sellerid, "InvTradeMineralPrice");
				DeletePVar(playerid, "InvTradeMineralSeller");
				return SendClientMessage(playerid, -1, "Nguoi do khong ban khoang san cho ban");
			}

			if(GetPlayerCash(playerid) < price) {
				DeletePVar(sellerid, "InvTradeMineral");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvTradeMineralAmount");
				DeletePVar(sellerid, "InvTradeMineralPrice");
				DeletePVar(playerid, "InvTradeMineralSeller");
				SendClientMessage(sellerid, -1, "Nguoi do khong du tien de tra");
				return SendClientMessage(playerid, -1, "Ban khong du tien de tra");
			}

			GivePlayerCash(playerid, -price);
			GivePlayerCash(sellerid, price);

			switch(slot) {
				case 0: {
					PlayerInfo[sellerid][pFe] -= amount;
					PlayerInfo[playerid][pFe] += amount;
				}
				case 1: {
					PlayerInfo[sellerid][pCu] -= amount;
					PlayerInfo[playerid][pCu] += amount;
				}
				case 2: {
					PlayerInfo[sellerid][pAu] -= amount;
					PlayerInfo[playerid][pAu] += amount;
				}
			}
			OnPlayerStatsUpdate(playerid);
			OnPlayerStatsUpdate(sellerid);

			new string[128];
			format(string, sizeof string, "%s da ban cho ban %d %s voi gia $%s", GetPlayerNameEx(sellerid), amount, mineralName, number_format(price));
			SendClientMessage(playerid, -1, string);
			format(string, sizeof string, "Ban da ban cho %s %d %s voi gia $%s", GetPlayerNameEx(playerid), amount, mineralName, number_format(price));
			SendClientMessage(sellerid, -1, string);

			DeletePVar(sellerid, "InvTradeMineral");
			DeletePVar(sellerid, "InvTradeWith");
			DeletePVar(sellerid, "InvTradeMineralAmount");
			DeletePVar(sellerid, "InvTradeMineralPrice");
			DeletePVar(playerid, "InvTradeMineralSeller");
			return 1;
		}
        case INV_WEPSELL: {
            if(!response) {
                DeletePVar(playerid, "InvWepSlot");
                DeletePVar(playerid, "InvWepSellType");
                return 1;
            }

            new
                giveplayerid = strval(inputtext);
            
            if(!IsPlayerConnected(giveplayerid)) {
                DeletePVar(playerid, "InvWepSlot");
                DeletePVar(playerid, "InvWepSellType");
                return SendClientMessage(playerid, -1, "Nguoi do khong online");
            }
            SetPVarInt(playerid, "InvTradeWith", giveplayerid);

            new sell_type = GetPVarInt(playerid, "InvWepSellType");
            switch(sell_type) {
                case 1: { // weapons
                    ShowPlayerDialog(playerid, INV_WEPSELL_PRICE, DIALOG_STYLE_INPUT, "Giao dich vu khi", "Nhap gia tien ban muon ban phia duoi:", "Ban", "Huy");
                }
                case 2: { // magazines
                    ShowPlayerDialog(playerid, INV_WEPSELL_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich bang dan", "Nhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
                }
            }
            
            return 1;
        }
		case INV_WEPSELL_AMOUNT: {
			if(!response) {
				DeletePVar(playerid, "InvWepSlot");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvWepSellType");
				return 1;
			}
			
			if(!IsPlayerConnected(GetPVarInt(playerid, "InvTradeWith"))) {
				DeletePVar(playerid, "InvWepSlot");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvWepSellType");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				sell_type = GetPVarInt(playerid, "InvWepSellType"),
				slot = GetPVarInt(playerid, "InvWepSlot"),
				giveplayerid = GetPVarInt(playerid, "InvTradeWith"),
				amount;
			switch(sell_type) {
				case 2: { // magazines
					if(sscanf(inputtext, "d", amount) || amount < 1 || amount > PlayerInfo[playerid][pBangDan][slot])
					{
						return ShowPlayerDialog(playerid, INV_WEPSELL_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich bang dan", "So luong khong hop le!\nNhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
					}

					if(PlayerInfo[giveplayerid][pBangDan][slot]+amount > GetMaxInvQuantity(giveplayerid, INV_TYPE_MAGAZINE)) {
						return ShowPlayerDialog(playerid, INV_WEPSELL_AMOUNT, DIALOG_STYLE_INPUT, "Giao dich bang dan", "So luong khong hop le! Nguoi do co qua nhieu bang dan.\nNhap so luong ban muon ban phia duoi:", "Tiep", "Huy");
					}

					SetPVarInt(playerid, "InvWepSellAmount", amount);
					ShowPlayerDialog(playerid, INV_WEPSELL_PRICE, DIALOG_STYLE_INPUT, "Giao dich bang dan", "Nhap gia tien ban muon ban phia duoi:", "Ban", "Huy");
				}
			}
		}
		case INV_WEPSELL_PRICE: {
			if(!response) {
				DeletePVar(playerid, "InvWepSlot");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvWepSellType");
				DeletePVar(playerid, "InvWepSellAmount");
				return 1;
			}
			
			if(!IsPlayerConnected(GetPVarInt(playerid, "InvTradeWith"))) {
				DeletePVar(playerid, "InvWepSlot");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvWepSellType");
				DeletePVar(playerid, "InvWepSellAmount");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				sell_type = GetPVarInt(playerid, "InvWepSellType"),
				slot = GetPVarInt(playerid, "InvWepSlot"),
				amount = GetPVarInt(playerid, "InvWepSellAmount"),
				giveplayerid = GetPVarInt(playerid, "InvTradeWith"),
				price;

			if(InvIfPlayerTrading(giveplayerid)) {
				DeletePVar(playerid, "InvWepSlot");
				DeletePVar(playerid, "InvTradeWith");
				DeletePVar(playerid, "InvWepSellType");
				DeletePVar(playerid, "InvWepSellAmount");
				return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi do dang co cuoc giao dich khac roi");
			}
			switch(sell_type) {
				case 1: { // weapons
					if(PInventory[playerid][E_INV_WEP][slot] == 0) {
						DeletePVar(playerid, "InvWepSlot");
						DeletePVar(playerid, "InvTradeWith");
						DeletePVar(playerid, "InvWepSellType");
						DeletePVar(playerid, "InvWepSellAmount");
						return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong co vu khi nay de ban");
					}

					if(sscanf(inputtext, "d", price) || price < 1 || price > 2000000000)
					{
						return ShowPlayerDialog(playerid, INV_WEPSELL_PRICE, DIALOG_STYLE_INPUT, "Giao dich vu khi", "So tien khong hop le!\nNhap gia tien ban muon ban phia duoi:", "Tiep", "Huy");
					}

					if(GetPlayerCash(giveplayerid) < price) {
						DeletePVar(playerid, "InvWepSlot");
						DeletePVar(playerid, "InvTradeWith");
						DeletePVar(playerid, "InvWepSellType");
						DeletePVar(playerid, "InvWepSellAmount");
						return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi do khong co du tien");
					}

					SetPVarInt(playerid, "InvWepSellPrice", price);
					SetPVarInt(giveplayerid, "InvWepSeller", playerid);
					new string[128];
					format(string, sizeof string, "{FFFFFF}%s muon ban cho ban %s voi gia $%s\n\nBan co mua khong?", GetPlayerNameEx(playerid), GetWeaponNameEx(PInventory[playerid][E_INV_WEP][slot]), number_format(price));
					ShowPlayerDialog(giveplayerid, INV_WEPSELL_CONFIRM, DIALOG_STYLE_MSGBOX, "Giao dich vu khi", string, "Mua", "Khong");
				}
				case 2: { // magazines
					if(amount > PlayerInfo[playerid][pBangDan][slot]) {
						DeletePVar(playerid, "InvWepSlot");
						DeletePVar(playerid, "InvTradeWith");
						DeletePVar(playerid, "InvWepSellType");
						DeletePVar(playerid, "InvWepSellAmount");
						return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong co du bang dan");
					}

					if(sscanf(inputtext, "d", price) || price < 1 || price > 2000000000)
					{
						return ShowPlayerDialog(playerid, INV_WEPSELL_PRICE, DIALOG_STYLE_INPUT, "Giao dich bang dan", "So tien khong hop le!\nNhap gia tien ban muon ban phia duoi:", "Tiep", "Huy");
					}

					if(GetPlayerCash(giveplayerid) < price)
					{
						DeletePVar(playerid, "InvWepSlot");
						DeletePVar(playerid, "InvTradeWith");
						DeletePVar(playerid, "InvWepSellType");
						DeletePVar(playerid, "InvWepSellAmount");
						return SendClientMessage(playerid, COLOR_GRAD1, "Nguoi do khong co du tien");
					}

					SetPVarInt(playerid, "InvWepSellPrice", price);
					SetPVarInt(giveplayerid, "InvWepSeller", playerid);
					new string[128];
					format(string, sizeof string, "{FFFFFF}%s muon ban cho ban %d bang dan %s voi gia $%s\n\nBan co mua khong?", GetPlayerNameEx(playerid), amount, GetMagNameBySlot(slot), number_format(price));
					ShowPlayerDialog(giveplayerid, INV_WEPSELL_CONFIRM, DIALOG_STYLE_MSGBOX, "Giao dich bang dan", string, "Mua", "Khong");
				}
			}
		}
		case INV_WEPSELL_CONFIRM: {
			new sellerid = GetPVarInt(playerid, "InvWepSeller");
			if(!response) {
				DeletePVar(sellerid, "InvWepSlot");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvWepSellType");
				DeletePVar(sellerid, "InvWepSellAmount");
				DeletePVar(sellerid, "InvWepSellPrice");
				DeletePVar(playerid, "InvWepSeller");
				return 1;
			}
			
			if(!IsPlayerConnected(sellerid)) {
				DeletePVar(sellerid, "InvWepSlot");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvWepSellType");
				DeletePVar(sellerid, "InvWepSellAmount");
				DeletePVar(sellerid, "InvWepSellPrice");
				DeletePVar(playerid, "InvWepSeller");
				return SendClientMessage(playerid, -1, "Nguoi do khong online");
			}

			new 
				sell_type = GetPVarInt(sellerid, "InvWepSellType"),
				slot = GetPVarInt(sellerid, "InvWepSlot"),
				amount = GetPVarInt(sellerid, "InvWepSellAmount"),
				giveplayerid = GetPVarInt(sellerid, "InvTradeWith"),
				price = GetPVarInt(sellerid, "InvWepSellPrice");

			if(playerid != giveplayerid) {
				DeletePVar(sellerid, "InvWepSlot");
				DeletePVar(sellerid, "InvTradeWith");
				DeletePVar(sellerid, "InvWepSellType");
				DeletePVar(sellerid, "InvWepSellAmount");
				DeletePVar(sellerid, "InvWepSellPrice");
				DeletePVar(playerid, "InvWepSeller");
				SendClientMessage(playerid, -1, "Co loi xay ra trong qua trinh giao dich, vui long thu lai.");
				SendClientMessage(sellerid, -1, "Co loi xay ra trong qua trinh giao dich, vui long thu lai.");
				return 1;
			}

			switch(sell_type) {
				case 2: {
					if(amount > PlayerInfo[sellerid][pBangDan][slot]) {
						DeletePVar(sellerid, "InvWepSlot");
						DeletePVar(sellerid, "InvTradeWith");
						DeletePVar(sellerid, "InvWepSellType");
						DeletePVar(sellerid, "InvWepSellAmount");
						DeletePVar(sellerid, "InvWepSellPrice");
						DeletePVar(playerid, "InvWepSeller");
						return SendClientMessage(playerid, -1, "Nguoi do khong ban bang dan cho ban");
					}

                    if(GetPlayerCash(playerid) < price) {
						DeletePVar(sellerid, "InvWepSlot");
						DeletePVar(sellerid, "InvTradeWith");
						DeletePVar(sellerid, "InvWepSellType");
						DeletePVar(sellerid, "InvWepSellAmount");
						DeletePVar(sellerid, "InvWepSellPrice");
						DeletePVar(playerid, "InvWepSeller");
						SendClientMessage(sellerid, -1, "Nguoi do khong du tien de tra");
						return SendClientMessage(playerid, -1, "Ban khong du tien de tra");
					}

					PlayerInfo[playerid][pBangDan][slot] += amount;
					PlayerInfo[sellerid][pBangDan][slot] -= amount;

					GivePlayerCash(playerid, -price);
					GivePlayerCash(sellerid, price);

					OnPlayerStatsUpdate(playerid);
					OnPlayerStatsUpdate(sellerid);

                    new string[128];
                    format(string, sizeof string, "%s da ban cho ban %d bang dan %s voi gia $%s", GetPlayerNameEx(sellerid), amount, GetMagNameBySlot(slot), number_format(price));
                    SendClientMessage(playerid, -1, string);
                    format(string, sizeof string, "Ban da ban cho %s %d bang dan %s voi gia $%s", GetPlayerNameEx(playerid), amount, GetMagNameBySlot(slot), number_format(price));
                    SendClientMessage(sellerid, -1, string);
				}
				case 1: { // weapons
					if(PInventory[sellerid][E_INV_WEP][slot] == 0) {
						DeletePVar(sellerid, "InvWepSlot");
						DeletePVar(sellerid, "InvTradeWith");
						DeletePVar(sellerid, "InvWepSellType");
						DeletePVar(sellerid, "InvWepSellAmount");
						DeletePVar(sellerid, "InvWepSellPrice");
						DeletePVar(playerid, "InvWepSeller");
						return SendClientMessage(playerid, -1, "Nguoi do khong ban vu khi cho ban");
					}

                    if(GetPlayerCash(playerid) < price) {
						DeletePVar(sellerid, "InvWepSlot");
						DeletePVar(sellerid, "InvTradeWith");
						DeletePVar(sellerid, "InvWepSellType");
						DeletePVar(sellerid, "InvWepSellAmount");
						DeletePVar(sellerid, "InvWepSellPrice");
						DeletePVar(playerid, "InvWepSeller");
						SendClientMessage(sellerid, -1, "Nguoi do khong du tien de tra");
						return SendClientMessage(playerid, -1, "Ban khong du tien de tra");
					}

                    new free_slot = GetFreeSlotInvWeapon(playerid);
                    if(PlayerInfo[playerid][pGuns][GetWeaponSlot(PInventory[sellerid][E_INV_WEP][slot])] != 0) {
                        if(free_slot == -1) {
                            DeletePVar(sellerid, "InvWepSlot");
                            DeletePVar(sellerid, "InvTradeWith");
                            DeletePVar(sellerid, "InvWepSellType");
                            DeletePVar(sellerid, "InvWepSellAmount");
                            DeletePVar(sellerid, "InvWepSellPrice");
                            DeletePVar(playerid, "InvWepSeller");
                            return SendClientMessage(playerid, -1, "Tui do da full o chua roi");
                        }
                    }

					GivePlayerCash(playerid, -price);
					GivePlayerCash(sellerid, price);

					OnPlayerStatsUpdate(playerid);
					OnPlayerStatsUpdate(sellerid);

					new weaponid = GetPlayerWeaponIDBySlot(sellerid, slot);
					if(PInventory[sellerid][E_INV_WEP_ISUSE][slot] == 0) {
						PInventory[sellerid][E_INV_WEP][slot] = 0;
						PInventory[sellerid][E_INV_WEP_ISUSE][slot] = 0;
					}
					else {
						RemovePlayerWeapon(sellerid, weaponid);
						PInventory[sellerid][E_INV_WEP][slot] = 0;
						PInventory[sellerid][E_INV_WEP_ISUSE][slot] = 0;
					}

					PInventory[playerid][E_INV_WEP][free_slot] = weaponid;
					PInventory[playerid][E_INV_WEP_ISUSE][free_slot] = 0;

                    new string[128];
                    format(string, sizeof string, "%s da ban cho ban %s voi gia $%s", GetPlayerNameEx(sellerid), GetWeaponNameEx(weaponid), number_format(price));
                    SendClientMessage(playerid, -1, string);
                    format(string, sizeof string, "Ban da ban cho %s %s voi gia $%s", GetPlayerNameEx(playerid), GetWeaponNameEx(weaponid), number_format(price));
                    SendClientMessage(sellerid, -1, string);
				}
			}

			DeletePVar(sellerid, "InvWepSlot");
			DeletePVar(sellerid, "InvTradeWith");
			DeletePVar(sellerid, "InvWepSellType");
			DeletePVar(sellerid, "InvWepSellAmount");
			DeletePVar(sellerid, "InvWepSellPrice");
			DeletePVar(playerid, "InvWepSeller");
			return 1;
		}
		case INV_WEP_INTERACT: {
			if(!response) return 1;
			new slot = GetPVarInt(playerid, "InvWepSlot");
			new string[64];
			switch(listitem) {
				case 0: { // use
					if(PInventory[playerid][E_INV_WEP][slot] == 0) {
                        DeletePVar(playerid, "InvWepSlot");
						return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong co vu khi nay de su dung");
					}
					new weaponid = PInventory[playerid][E_INV_WEP][slot];
					if(PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] != 0) {
                        DeletePVar(playerid, "InvWepSlot");
						return SendClientMessage(playerid, -1, "Ban dang su dung vu khi cung loai, khong the lay ra them");
					}
                    switch(weaponid) {
						case 22:
						{
							if(PlayerInfo[playerid][pBangDan][1] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 23:
						{
    						if(PlayerInfo[playerid][pBangDan][1] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 24:
						{
							if(PlayerInfo[playerid][pBangDan][6] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 25: //shotgun
						{
							if(PlayerInfo[playerid][pBangDan][2] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 28: //uzi
						{
							if(PlayerInfo[playerid][pBangDan][3] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 32: //tec9
						{
							if(PlayerInfo[playerid][pBangDan][4] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 29: //mp5
						{
							if(PlayerInfo[playerid][pBangDan][5] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 27: // spas
						{
							if(PlayerInfo[playerid][pBangDan][10] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 30: // ak47
						{
							if(PlayerInfo[playerid][pBangDan][8] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 31: // m4
						{
							if(PlayerInfo[playerid][pBangDan][9] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 33: // rifle
						{
							if(PlayerInfo[playerid][pBangDan][7] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
						case 34: // sniper
						{
							if(PlayerInfo[playerid][pBangDan][11] == 0) return SendClientMessage(playerid, -1, "Vu khi nay da het bang dan");
						}
					}
					GivePlayerValidWeapon(playerid, weaponid, 2);
					switch(weaponid) {
					    case 22:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SILENCED","Silence_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 22);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 23:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SILENCED","Silence_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 23);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 24:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SILENCED","Silence_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 24);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 25:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"BUDDY","buddy_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 25);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 27:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"BUDDY","buddy_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 27);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 28:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"UZI","UZI_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 28);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 29:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"TEC","TEC_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 29);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 32:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"TEC","TEC_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 32);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 30:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"PYTHON","python_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 30);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 31:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"PYTHON","python_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 31);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 33:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"PYTHON","python_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 33);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					    case 34:
					    {
					        DangThayDanP{playerid} = true;
							if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"PYTHON","python_reload",2.1,0,0,0,0,0,1);
							GameTextForPlayer(playerid, "DANG THAY DAN!", 1500, 3);
							defer BatDauThayDan( playerid, 34);

							format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
							ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					    }
					}
					PInventory[playerid][E_INV_WEP_ISUSE][slot] = 1;
					format(string, sizeof string, "Ban vua trang bi vu khi %s thanh cong.", GetWeaponNameEx(weaponid));
					SendClientMessage(playerid, -1, string);
                    DeletePVar(playerid, "InvWepSlot");
				}
				case 1: { // hidden
                    SendClientMessage(playerid, COLOR_GRAD1, "Coming soon (Hoang_Khang)");
				}
				case 2: { // sell
                    if(PInventory[playerid][E_INV_WEP][slot] == 0) {
						DeletePVar(playerid, "InvWepSlot");
						DeletePVar(playerid, "InvTradeWith");
						DeletePVar(playerid, "InvWepSellType");
						return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong co vu khi nay de giao dich");
					}

					SetPVarInt(playerid, "InvWepSellType", 1);
					Inv_StartTrade(playerid, 0);
				}
			}
		}
		case INV_WEP: {
			if(!response) return 1;
			if(listitem == INV_MAX_WEAPON_AMOUNT) {
				for(new i = 0; i < 5; i++) {
					if(PInventory[playerid][E_INV_WEP][i] == 0) break;
					if(PInventory[playerid][E_INV_WEP_ISUSE][i] == 0) break;
					PInventory[playerid][E_INV_WEP_ISUSE][i] = 0;
					RemovePlayerWeapon(playerid, PInventory[playerid][E_INV_WEP][i]);
				}
			}
			else {
				SetPVarInt(playerid, "InvWepSlot", listitem);
				ShowPlayerDialog(playerid, INV_WEP_INTERACT, DIALOG_STYLE_LIST, "Tui Do Vu Khi", "Su dung\nCat\nGiao dich", "Chon", "Dong");
			}
		}
		case INV_SELL_MAGAZINE: {
			if(!response) return 1;

			SetPVarInt(playerid, "InvWepSlot", listitem+1);
			SetPVarInt(playerid, "InvWepSellType", 2);
			Inv_StartTrade(playerid, 0);
		}
		case INV_WEAPONS: {
			Show_InventoryWeapons(playerid, listitem);
		}
		case INV_GENERAL1: {
			if(!response) return Show_Inventory(playerid);

			Show_InventoryGeneral(playerid, 1);
		}
		case INV_GENERAL2: {
			if(!response) return Show_Inventory(playerid);

    		Show_InventoryGeneral(playerid, 0);
		}
		case INV_MAIN: {
			if(!response) return 1;

			switch(listitem) {
				case 0: // Tong quan
				{
					Show_Inventory(playerid, 1);
				}
				case 1: // Vu khi
				{
					Show_Inventory(playerid, 2);
				}
				case 2: // Thuc an
				{
					Show_Inventory(playerid, 4);
				}
				case 3: // Nguyen lieu
				{
					Show_Inventory(playerid, 3);
				}
				default: {
					return 1;
				}
			}
		}
		case INV_MATERIALS: {
			if(!response) return 1;

			switch(listitem) {
				case 0: { // khoang san
					new szDialog[1024];
					format(szDialog, sizeof szDialog, "Ten khoang san\tKho{FFFFFF}\n\
						FE\t%s\n\
						CU\t%s\n\
						AU\t%s", Dialog_AmountAvailableColor(PlayerInfo[playerid][pFe], GetMaxInvQuantity(playerid, INV_TYPE_MINERAL)),
							Dialog_AmountAvailableColor(PlayerInfo[playerid][pCu], GetMaxInvQuantity(playerid, INV_TYPE_MINERAL)),
							Dialog_AmountAvailableColor(PlayerInfo[playerid][pAu], GetMaxInvQuantity(playerid, INV_TYPE_MINERAL)));

					ShowPlayerDialog(playerid, INV_MINERALS, DIALOG_STYLE_TABLIST_HEADERS, "Tui Do Khoang San", szDialog, "Chon", "Dong");
				}
				case 1: { // them
					new szDialog[1024];
					format(szDialog, sizeof szDialog, "Ten nguyen lieu\tKho{FFFFFF}\n\
						La can sa\t%s\n\
						Goi can sa\t%s\n\
						Tien ban\t$%s\n\
						Vat lieu\t%s\n\
						Go\t%s",
						Dialog_AmountAvailableColor(PlayerInfo[playerid][pCanSa], GetMaxInvQuantity(playerid, INV_TYPE_LACANSA)),
						Dialog_AmountAvailableColor(PlayerInfo[playerid][pCanSaSX], GetMaxInvQuantity(playerid, INV_TYPE_GOICANSA)),
						number_format(PlayerInfo[playerid][pTienBan]),
						Dialog_AmountAvailableColor(PlayerInfo[playerid][pMats], GetMaxInvQuantity(playerid, INV_TYPE_MATERIALS)),
						Dialog_AmountAvailableColor(PlayerInfo[playerid][pWoodG], GetMaxInvQuantity(playerid, INV_TYPE_WOOD)));
					
					ShowPlayerDialog(playerid, INV_MATERIALEXTRA, DIALOG_STYLE_TABLIST_HEADERS, "Tui Do Nguyen Lieu", szDialog, "Chon", "Dong");
				}
			}
		}
		case INV_MINERALS: {
			if(!response) return 1;

			SetPVarInt(playerid, "InvTradeMineral", listitem);
			Inv_StartTrade(playerid, 1);
		}
		case INV_THUCAN:{
			if(!response) return 1;
			new string[128];
			switch(listitem) {
				case 0: {
					if(PlayerInfo[playerid][pBanhMi] == 0) return SendClientMessage(playerid, COLOR_GREY, "Ban khong co banh mi nao trong tui do.");
					else if(PlayerInfo[playerid][pDoiBung] == 100) return SendClientMessage(playerid, COLOR_GREY, "Hien tai ban khong cam thay doi bung.");
					format(string, sizeof(string), "{FF8000}*{C2A2DA} %s da an mot o banh mi.", GetPlayerNameEx(playerid));
					SetPlayerChatBubble(playerid,string,COLOR_PURPLE,10.0,4000);
					PlayerInfo[playerid][pBanhMi] -= 1;
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerAttachedObject( playerid, 8, 19883, 1, 0.109999, 0.034999, 0.009000, 11.599999, 0.000000, -12.899994, 1.000000, 1.000000, 1.000000);
			        	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0 ,0 ,0 ,1 ,0 );
			        	SetTimerEx("ThoiGianAn", 3000, false, "i", playerid);
			        }
			        if(PlayerInfo[playerid][pDoiBung]+50 > 100) {
						PlayerInfo[playerid][pDoiBung] = 100;
					}
			        else {
						PlayerInfo[playerid][pDoiBung] += 50;
					}
			        new Float:HP;
			        GetPlayerHealth(playerid, HP);
			        if(HP+25 > 100) 
			        {
			        	SetPlayerHealth(playerid, 100);
						PlayerInfo[playerid][pHealth] = 100;
			        }
			        else
			        {
			        	SetPlayerHealth(playerid, HP+25);
						PlayerInfo[playerid][pHealth] += 25;
			        }
					if (PlayerInfo[playerid][pFitness] >= 3)
						PlayerInfo[playerid][pFitness] -= 3;
					else
						PlayerInfo[playerid][pFitness] = 0;
				}
				case 1: {
					if(PlayerInfo[playerid][pNuocSuoi] == 0) return SendClientMessage(playerid, COLOR_GREY, "Ban khong co nuoc suoi nao trong tui do.");
					else if(PlayerInfo[playerid][pKhatNuoc] == 100) return SendClientMessage(playerid, COLOR_GREY, "Hien tai ban khong cam thay khat nuoc.");
					format(string, sizeof(string), "{FF8000}*{C2A2DA} %s da uong mot chai nuoc suoi.", GetPlayerNameEx(playerid));
					SetPlayerChatBubble(playerid,string,COLOR_PURPLE,10.0,4000);
					PlayerInfo[playerid][pNuocSuoi] -= 1;
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerAttachedObject( playerid, 8, 2647, 1, 0.147000, 0.036000, -0.009999, -45.299995, -95.299987, 0.000000, 0.715999, 0.839999, 0.786000);
		        		ApplyAnimation(playerid, "VENDING", "VEND_Drink_P", 4.0, 0 ,0 ,0 ,1 ,0 );
		        		SetTimerEx("ThoiGianAn", 3000, false, "i", playerid);
			        }
			        if(PlayerInfo[playerid][pKhatNuoc]+50 > 100) PlayerInfo[playerid][pKhatNuoc] = 100;
			        else PlayerInfo[playerid][pKhatNuoc] += 50;
			        new Float:HP;
			        GetPlayerHealth(playerid, HP);
			        if(HP+25 > 100) {
			        	SetPlayerHealth(playerid, 100);
			        	PlayerInfo[playerid][pHealth] = 100;
			        }
			        else {
			        	SetPlayerHealth(playerid, HP+25);
			        	PlayerInfo[playerid][pHealth] += 25;
			        }	
					if (PlayerInfo[playerid][pFitness] >= 3)
						PlayerInfo[playerid][pFitness] -= 3;
					else
						PlayerInfo[playerid][pFitness] = 0;
				}
			}

		}
		case INV_MATERIALEXTRA: {
			if(!response) return 1;
			
			SetPVarInt(playerid, "InvTradeMatextra", listitem);
			Inv_StartTrade(playerid, 2);
		}
    }
    return 0;
}

forward ThoiGianAn(playerid);
public ThoiGianAn(playerid)
{
    RemovePlayerAttachedObject( playerid, 8);
    ClearAnimations(playerid);
    return 1;
}
