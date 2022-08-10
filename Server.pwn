main()
{
	new a[][] = {"Unarmed (Fist)","Brass K"};
	#pragma unused a
} //the highest land point in sa = 526.8
//cp1251_general_ci
//144 длина строки, но ставим 128
// Сделать античит для грузчиков и рудников, доработать систему антирекламы
// Добавить логи денег общих и банков фракции
// eject добавить функцию для копов
// ========== [ Инклуды ] ==========
#include <a_samp>
#include <a_mysql>
#include <foreach>
#include <utils>
#include <streamer>
#include <inc>
#include <sscanf2>
#include <Pawn.CMD>
// ========== [ Замена % в диалогах ] ==========
new CHECK_DIALOGS[32767 char];
stock SPD(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
    CHECK_DIALOGS{dialogid} = style;
    SetPVarInt(playerid, "USEDIALOGID", dialogid);
    return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}
#if defined _ALS_ShowPlayerDialog
    #undef ShowPlayerDialog
#else
    #define _ALS_ShowPlayerDialog
#endif
// ========== [ Дефайны ] ==========
#define GN(%1) PlayerInfo[%1][pName]
#define publics%0(%1) forward%0(%1); public%0(%1)
#define COLOR_LIGHTRED 			0xFF6347AA
#define COLOR_GREY 				0xAFAFAFAA
// ========== [ MySQL ] ==========
#define mysql_host "94.23.206.162"
#define mysql_user "gs62243"
#define mysql_pass "bzlQk1v7Jn"
#define mysql_db "gs62243"
// ========== [ Переменные ] ==========
new Text:URL[MAX_PLAYERS],keyses = 0,noooc = 0,antiooc, antioocsend;
new cfact[MAX_PLAYERS][40];
new bool:dostup[MAX_PLAYERS],pdostup[MAX_PLAYERS],reporttext[MAX_PLAYERS][120],preport[MAX_PLAYERS],reportid[MAX_PLAYERS],areportid[MAX_PLAYERS], Float:TeleportDest[MAX_PLAYERS][3][10],TeleportDests[MAX_PLAYERS][2][10];
new Menu:Admin,Float:PosAdmin[MAX_PLAYERS][3],PosAdmins[MAX_PLAYERS][2],gSpectateID[MAX_PLAYERS],SpecAd[MAX_PLAYERS],SpecID[MAX_PLAYERS],Text:ReconText[MAX_PLAYERS],smschat[MAX_PLAYERS],chat[MAX_PLAYERS] = 0,noobchat[MAX_PLAYERS],fchat[MAX_PLAYERS],cchat[MAX_PLAYERS];
new bool:Login[MAX_PLAYERS],clearanim[MAX_PLAYERS],Float:Fuell[MAX_VEHICLES],caridhouse[MAX_PLAYERS],zavodis[MAX_VEHICLES],VehicleLight[MAX_VEHICLES] = 0,gCarLock[MAX_VEHICLES],IsLocked[MAX_VEHICLES],dchat=1,takephone[MAX_PLAYERS];
new Weapons[MAX_PLAYERS][47],gFam[MAX_PLAYERS],keys[MAX_PLAYERS],InviteOffer[MAX_PLAYERS],Uninvitereason[MAX_PLAYERS][20],proverkaforma[MAX_PLAYERS],HealOffer[MAX_PLAYERS],HealPrice[MAX_PLAYERS],LomkaOffer[MAX_PLAYERS],LomkaPrice[MAX_PLAYERS],NarkSeansOffer[MAX_PLAYERS],NarkSeansPrice[MAX_PLAYERS], seans[MAX_PLAYERS],strR[256][256];
new PlayerCuffed[MAX_PLAYERS],CuffedTime[MAX_PLAYERS],Tazer[MAX_PLAYERS],TazerTime[MAX_PLAYERS];
new smspricesf = 50,smspricels = 50,smspricelv = 50,ringsf = 500,ringls = 500,ringlv = 500,smssf = 0,smsls = 0,smslv = 0;
new gag[MAX_PLAYERS],Drugtime[MAX_PLAYERS] = 0,PhoneOnline[MAX_PLAYERS];
new Float:player_VehHealth[MAX_PLAYERS],Float:HealthVeh[MAX_PLAYERS];
static bool:FindCP[MAX_PLAYERS];
static bool:Nointim[MAX_PLAYERS];
static bool:NotServerAvto[MAX_VEHICLES]={false,false,...};
static qweqwe[MAX_PLAYERS];
new duty[MAX_PLAYERS];
new offlist[MAX_PLAYERS] = 0;
new player_NoCheckTimeVeh[MAX_PLAYERS],timer2[MAX_PLAYERS],TT,Float: PlayerHealth[MAX_PLAYERS],Float: Armour[MAX_PLAYERS],SelectCharID[MAX_PLAYERS],InviteSkin[MAX_PLAYERS],OldSkin[MAX_PLAYERS],SelectChar[MAX_PLAYERS],bool:Works[MAX_PLAYERS],JobCP[MAX_PLAYERS],CP[MAX_PLAYERS];
new PicCP[MAX_PLAYERS],mesh[MAX_PLAYERS],usemesh[MAX_PLAYERS],JobAmmount[MAX_PLAYERS],useguns[MAX_PLAYERS], GetPlayerMetall[MAX_PLAYERS], bool:PlayerStartJob[MAX_PLAYERS],JobCarTime[MAX_PLAYERS],AutoBusJob[MAX_PLAYERS];
new ChosenSkin[MAX_PLAYERS],SelectCharPlace[MAX_PLAYERS],Menu:bomj[2],Menu:ChoseSkin,CharPrice[MAX_PLAYERS],AutoBusCheck[MAX_PLAYERS],ChosenPlayer[MAX_PLAYERS];
new PickupUp[MAX_PLAYERS] = {-1, ...},alha,mast[3],burger[4],pizza[4],tengreen[2],jizzy,chekmatlva[13],chekmats[5],rabota1,Army,carpick[3], medicsf[2],medicls[2];
new banksf,ebanksf[MAX_PLAYERS],mysti,pigpen,paint,shop[4],victim[2],sportzal[2],ammonac[6],picjob,dinamicash[MAX_PLAYERS];
new lspic[2],rmpic[2],narko[2],lcnpic[2],yakexit[2],sfn[2],pdd,buygunzakon[4],fbi[2],lspd[6];
new sfpd[6],lvpdpic[7],autoschool[2],marenter[6],bankpic[2],serdce[6],ballasvhod[2],rifa[2],vagospic[2];
new aztecpic[2],groove[2],clothes,cashs,grib[53],skinshop[4],gunarm[2],zip[2],plen[2],zona[2],sklad[2],parashut,Menu:skinshopmagaz,paras1;
new bool:zips[MAX_PLAYERS];
new startnarko[MAX_PLAYERS] = 0,send[MAX_PLAYERS];
new CallCost[MAX_PLAYERS];
new weather = 14;
new forma[MAX_PLAYERS];
enum pInfo
{
	pID,
    pName[MAX_PLAYER_NAME],
	pKey[48],
	pLevel,
	pExp,
	pAdmin,
	pDostup[33],
	pSex,
	Float:pHP,
 	pChar,
 	pModel,
 	pLeader,
 	pMember,
 	pRank,
 	pJob,
 	pCash,
 	pBank,
 	pPayCheck,
	pKrisha,
	pDolg,
 	pVIP,
 	pVoennik,
 	pGrib,
 	pDrugs,
 	pNarcoZavisimost,
 	pMats,
 	pKills,
 	pWantedDeaths,
 	pArrested,
 	pZakonp,
	pVodPrava,
	pFlyLic,
	pBoatLic,
	pGunLic,
	pBizLic,
 	pMute,
	pPnumber,
	pPhoneBook,
	pZvonok,
	pMobile,
	pPayDay,
	pKongfuSkill,
	pBoxSkill,
	pKickboxSkill,
	pZvezdi,
	pJailed,
	pJailTime,
	pCar,
	pFuelcar,
	pWarns,
	pSlot[13],
	pSlotammo[13],
	pALip[15],
	pLip[15],
	pDataReg[11],
	pLDate,
	pKeyip
};
new PlayerInfo[MAX_PLAYERS][pInfo];
enum frInfo
{
	fLsnews,
	fSfnews,
	fLvnews,
	fBallas,
	fVagos,
	fGrove,
	fAztek,
	fRifa,
	fKazna,
	fNalog,
	fMCLS,
	fMCSF,
	fMCprice,
	fmatslva,
	fmatssfa,
	fmatslspd,
	fmatssfpd,
	fmatslvpd,
	fmatsfbi,
	fmatslcn,
	fmatsrm,
	fmatsyakuza,
	fmatsballas,
	fmatsgrove,
	fmatsrifa,
	fmatsaztecas,
	fmatsvagos
};
new FracBank[1][frInfo];
enum hInfo
{
	hID,
	hStreet[30],
	hNumber,
	Float:hEntrancex,
	Float:hEntrancey,
	Float:hEntrancez,
	Float:hExitx,
	Float:hExity,
	Float:hExitz,
	Float:hExitc,
	Float:hLabelx,
	Float:hLabely,
	Float:hLabelz,
	Float:hCarx,
	Float:hCary,
	Float:hCarz,
	Float:hCarc,
	hOwner[25],
	hPrice,
	hInt,
	hLock,
	hCheck,
	hClass,
	hAreaEnter,
	hMIcon,
	Text3D:hTextEnter,
	hMats
};
new HouseInfo[1000][hInfo];
new TOTALHOUSE = 0;

enum afker
{
	Float:AFK_Coord, Float:AFK_Coords,VarEx,Var,
}
new PlayerEx[MAX_PLAYERS][afker];
enum PickInfo
{
    Float: PickX,
    Float: PickY,
    Float: PickZ
}
new PickupInfo[MAX_PICKUPS][PickInfo];
new ghour = 0,timeshift = 0;
new MySql_Base,QUERY[2000];
new TransportDuty[MAX_PLAYERS],TransportMoney[MAX_PLAYERS],TransportValue[MAX_PLAYERS],Float:TaxiProbeg[MAX_PLAYERS] = 0.0,TaxiTime[MAX_PLAYERS],Text3D:taxi3d[MAX_VEHICLES],Float:Probeg[MAX_VEHICLES] = 0.0;
new Text: TaxiProbegs[MAX_PLAYERS],Text: TaxiTimes[MAX_PLAYERS],Text: TransportMoneys[MAX_PLAYERS],Text:Box1,Text:Box2,Text: TaxiProbegss[MAX_PLAYERS],Text: TaxiTimess[MAX_PLAYERS],Text: TransportMoneyss[MAX_PLAYERS];
new STimer[MAX_PLAYERS], Text:Box,Text:Speed,Text:KMShow[MAX_PLAYERS],Text:KmShow[MAX_PLAYERS],Text:SpeedShow[MAX_PLAYERS],Text:Fuel,Text:FuelShow[MAX_PLAYERS],Text:FillShow[MAX_PLAYERS],Text:EngineShow[MAX_PLAYERS],Text:LightShow[MAX_PLAYERS],Text:TextProbegs[MAX_PLAYERS],Text:Probegs[MAX_PLAYERS],Text:Status,Text:StatusShow[MAX_PLAYERS],Text3D:fare3dtext[MAX_VEHICLES],Barrier;
new medicsls[7],medicssf[8],armysfcar[29],armylvcar[22],matslvcar[6],lspdcar[20],sfpdcar[23],lvpdcar[15],fbicar[9],sfnewscar[6],lsnewscar[6],lvnewscar[6],govcar[5],liccar[10];
new yakcar[10],ruscar[12],lcncar[9],azteccar[6],matsfuraaztek[1],vagoscar[7],matsfuravagos[1],grovecar[7],matsfuragrove[1],rifacar[6],matsfurarifa[1],ballascar[9],matsfura[1];
new prodcar[9],mater[6],benzovoz[10],mehanik[13],taxicar[31],bus[4],rentcarsf[6],rentcarls[14],arendlod[4],hotdogcar[9];
enum pMat
{
	mCapasity, mLoad,
};
new MatHaul[6][pMat];
new RulesMSG[17][] = {
	{"1. Игровой процесс\n"},
	{"Запрещено:\n"},
	{"- Использование любых программ скриптов читов и.т.п. дающие нечестное преймущество в игре.\n"},
	{"- Использование багов (Ошибок, Неисправностей мода).\n"},
	{"- Использовать ESC в целях ухода от погони/смерти.\n"},
	{"- Убивать игроков на спавне (Место возрождения, базы организаций).\n"},
	{"- Убивать игроков при помощи транспорта (Давить, Стрелять с водительского места).\n"},
	{"- Убийство/нанесение физического вреда игрокам без причины (ДМ - Death Match).\n"},
	{"- Злоупотребление игровыми возможностями для создания неудобств игрокам.\n\n"},
	{"2. Ник в игре:\n"},
	{"- (сменить ник можно через /mm >> Сменить ник)\n"},
	{"- Ник должен состоять из Имени_Фамилии с заглавных букв.\n"},
	{"Запрещено:\n"},
	{"- Запрещено использовать чужие (уже кем-то занятые) ники.\n"},
	{"- Запрещено использовать ники, содержащие нецензурные или оскорбительные слова.\n"},
	{"- Отправлять более одной заявки в час (Исключение: Просьба Администрации).\n"},
	{"- Если вам отказали в смене ника, Значит нельзя.\n"}
};
new IPMSG[6][] = {
	{"IP проверка обезопасит Ваш аккаунт от взлома!\n"},
	{"Если Ваш IP адрес будет изменён, система потребуют ключ безопасности\n\n"},
	{"Для того чтобы включить/отключить защиту \n"},
	{"Введите /mm - [7] Безопасность\n\n"},
	{"Обязательно установите ключ безопасности!\n"},
	{"Рекомендуем использовать трудный пароль, содержащий набор букв и цифр.\n- Ни когда не разглошайте свой пароль другим людям/знакомым.\n- Не используйте свой пароль на сторонних серверах, это может вызвать взлом вашего аккаунта"}
};
new rabotaMSG[12][] = {
	{"Здесь вы можете подработать грузчиком\n"},
	{"\n"},
	{"В здании на против, вы найдете раздевалку,\n"},
	{"А так же кассу, где Вы будете получать деньги за работу.\n\n"},
	{"\n"},
	{"Чтобы начать работу, необходимо переодеться в рабочую форму.\n"},
	{"Далее, берите в вагоне мешок, и несите его на склад.\n"},
	{"За один мешок, Вам будут платить 40 рублей.\n"},
	{"\n"},
	{"Как только Вы захотите завершить рабочий день,\n"},
	{"Пройдите к кассе.\n"},
	{"\n"}
};
new pdddialogMSG[13][] = {
	{"<< 1. Общие правила >>\n\n"},
	{"Обгон транспортного средства разрешен только с левой стороны,\n"},
	{"при этом водители обязаны убедиться, что встречная полоса свободна на достаточном для обгона расстояние.\n"},
	{"При ДТП водители обязаны позвонить в полицию, и дождаться ДПС\n\n"},
	{"<< 2. Скорость движения >> \n\n"},
	{"В переделах города разрешается движение транспортных средств со скоростью не более 50 км/ч.\n"},
	{"В жилых зонах и на дворовых территориях не более 30 км/ч\n\n"},
	{"<< 3. Остановка и стоянка >>\n\n"},
	{"Остановка и стоянка транспортных средств разрешаются на правой стороне дороги на обочине.\n"},
	{"В специальных отведённых для этого местах\n\n"},
    {"<< 4. ДПС >> \n\n"},
	{"При виде автомобиля с включённой сереной, водитель обязан сбавить скорость и прижаться к обочине.\n"},
	{"Водитель обязан предъявить паспорт/лицензии, если тот попросил"}
};
new ChangeSkin[MAX_PLAYERS];
new BomjMen[8][1] = {200,230,134,135,79,78,137,212};
new BomjWomen[4][1] = {90,55,151,40};
new JoinPed[126][1] = {
	{280},//LSPD1
	{281},//LSPD2
	{282},//LSPD3
	{283},//LSPD4
	{284},//LSPD5
	{285},//LSPD6
	{288},//LSPD7
	{141},//LSPD8
	//============
	{286},//FBI1
	{163},//FBI2
	{164},//FBI3
	{165},//FBI4
	{166},//FBI5
	{76},//FBI6
	//============
	{287},//armySF1
	{191},//armySF2
	//============
	{70},//Mediki1
	{274},//Mediki2
	{275},//Mediki3
	{276},//Mediki4
	{219},//Mediki5
	//============
	{223},//LCN1
	{124},//LCN2
	{113},//LCN3
	{214},//LCN4
	//============
	{120},//YAKUZA1
	{123},//YAKUZA3
	{169},//YAKUZA2
	{186},//YAKUZA4
	//============
	{57},//Meria1
	{150},//Meria2
	{98},//Meria3
	{187},//Meria4
	{147},//Meria5
	//============
	{280},//SFPD1
	{281},//SFPD2
	{282},//SFPD3
	{283},//SFPD4
	{284},//SFPD5
	{285},//SFPD6
	{288},//SFPD7
	{141},//SFPD8
	//===========
	{250},//SF NEWS1
	{261},//SF NEWS2
	{211},//SF NEWS3
	{217},//SF NEWS4
	//===========
	{171},//Kazino1
	{11},//Kazino2
	//===========
	{59},//Instructors1
	{172},//Instructors2
	{189},//Instructors3
	{240},//Instructors4
	//==========
	{280},//LVPD1
	{281},//LVPD2
	{282},//LVPD3
	{283},//LVPD4
	{284},//LVPD5
	{285},//LVPD6
	{288},//LVPD7
	{141},//LVPD8
	//==========
	{112},//Russian mafia1
	{111},//Russian mafia2
	{125},//Russian mafia4
	{272},//Russian mafia3
	{214},//Russian mafia5
	//==========
	{105},//GROOVE1
	{106},//GROOVE2
	{107},//GROOVE3
	{269},//GROOVE4
	{270},//GROOVE5
	{271},//GROOVE6
	{195},//Groove girl
	//==========
	{114},//Aztecas1
	{115},//Aztecas2
	{116},//Aztecas3
	{41},//Aztec girl
	//==========
	{102},//BALLAS1
	{103},//BALLAS2
	{104},//BALLAS3
	{13},//Ballas girl
	//==========
	{173},//RIFA2
	{174},//RIFA1
	{175},//RIFA3
	{56},//Riva girl
	//==========
	{108},//VAGOS1
	{109},//vagospic[1]
	{110},//VAGOS3
	{12},//Vagos girl
	//==========
	{287},//Army LV1
	{191},//Army LV2
	//==========
	{250},//LS NEWS1
	{261},//LS NEWS2
	{211},//LS NEWS3
	{217},//LS NEWS4
	{287},//=========Гермаия
	{287},
	{191},
	{287},
	{287},///===========Россия
	{191},
	{287},
	{230},//=========Бомжи мужики
	{200},
	{134},
	{135},
	{79},
	{78},
	{77},///===========Бомжи бабы
	{130},
	{129},
	{23},///===========RACERS
	{29},
	{176},
	{177},
	{180},
	{93},
	{134},///===========Бомжи
	{135},
	{137},
	{212},
	{77},
	{134},
    {61},///===========Адмирал
	{171},
	{11},
	{172}
};
//================ Учебная =====================================================
new LessonCar[MAX_PLAYERS],LessonStat[MAX_PLAYERS],pLessonCar[MAX_PLAYERS],TakingLesson[MAX_PLAYERS];
enum
{
	CHECKPOINT_1,CHECKPOINT_2,CHECKPOINT_3,CHECKPOINT_4,CHECKPOINT_5,CHECKPOINT_6,CHECKPOINT_7,CHECKPOINT_8,CHECKPOINT_9,CHECKPOINT_10,CHECKPOINT_11, CHECKPOINT_13,CHECKPOINT_14,CHECKPOINT_15,CHECKPOINT_16,CHECKPOINT_17,CHECKPOINT_18,CHECKPOINT_19,CHECKPOINT_20,CHECKPOINT_21,CHECKPOINT_22,CHECKPOINT_23,
	CHECKPOINT_24,CHECKPOINT_25,CHECKPOINT_26,CHECKPOINT_27,CHECKPOINT_28,CHECKPOINT_29,CHECKPOINT_30,CHECKPOINT_31,CHECKPOINT_32,CHECKPOINT_33,CHECKPOINT_34, CHECKPOINT_35,CHECKPOINT_36,CHECKPOINT_37,CHECKPOINT_38,CHECKPOINT_40,CHECKPOINT_41,CHECKPOINT_42,CHECKPOINT_43,CHECKPOINT_44,CHECKPOINT_45,CHECKPOINT_46,
	CHECKPOINT_47,CHECKPOINT_48,CHECKPOINT_49,CHECKPOINT_50,CHECKPOINT_51,CHECKPOINT_52,CHECKPOINT_53,CHECKPOINT_54,CHECKPOINT_55,CHECKPOINT_56,CHECKPOINT_57, CHECKPOINT_58,CHECKPOINT_59,CHECKPOINT_60,CHECKPOINT_61,CHECKPOINT_62,CHECKPOINT_63,CHECKPOINT_64,CHECKPOINT_65,CHECKPOINT_66,
}
stock bool:strequal(const string1[], const string2[], bool:ignorecase = false, length = cellmax)
{
    new
        s1 = string1[0],
        s2 = string2[0];

    if ((s1 == '\0' || s2 == '\0') && (s1 != s2))
        return false;

    return strcmp(string1, string2, ignorecase, length) == 0;
}
stock Float:GetDistanceBetweenPlayers(p1,p2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
	{
		return -1.00;
	}
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}
// ========== [ Команды ] ==========
// ========== [ Администраторские ] ==========
new req[128];
cmd:ahelp(playerid)
{
    if(PlayerInfo[playerid][pAdmin] == 0 || !dostup[playerid]) return 1;
	if(PlayerInfo[playerid][pAdmin] >= 1) SendClientMessage(playerid,0x6495EDFF,"<1> /a /adminkey /pm /rl /re /g /slap /mute /mutelist /prison /prisonlist /tp {num} /hp /skin /mark {num} /gotomark {num}");
	if(PlayerInfo[playerid][pAdmin] >= 2) SendClientMessage(playerid,0x6495EDFF,"<2> /warn /nchat /cfact /chat /cchat /smschat /kick /gm /amembers /oa /o /fid /am /wanted");
	if(PlayerInfo[playerid][pAdmin] >= 3) SendClientMessage(playerid,0x6495EDFF,"<3> /ban /gethere /uval /setspawn  /veh /delveh /alock /spveh /atazer /disarm /setskin /ainvite /sethp /aad /givegun /uncuff /lomka /freeze");
	if(PlayerInfo[playerid][pAdmin] >= 4) SendClientMessage(playerid,0x6495EDFF,"<4> /makeleader /agiverank /iban /unwarn /spcar /spcars /agl /weather /obj /noooc /atune /tpcor /int");
	if(PlayerInfo[playerid][pAdmin] >= 5) SendClientMessage(playerid,0x6495EDFF,"<5> /unban /gmx /sethpprice");
	if(PlayerInfo[playerid][pAdmin] >= 6) SendClientMessage(playerid,0x6495EDFF,"<6> /setstat /delacc /makeadmin /skey /askin /payday /cmd /houselist /setpos /setposcar");
    return 1;
}
cmd:alogin(playerid)
{
    if(PlayerInfo[playerid][pAdmin] == 0) return 1;
	SPD(playerid,10,DIALOG_STYLE_PASSWORD,"Доступ администратора","Введите пароль доступа администратора\nПароль должен содержать от 16 до 32 символов.","Ок","Отмена");
	return 1;
}
cmd:adminkey(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] == 0) return 1;
    if(sscanf(params, "s[33]", params[0])) return SendClientMessage(playerid, -1, "Введите: /adminkey [новый пароль]");
	if(strlen(params[0]) < 8 || strlen(params[0]) > 32) return SendClientMessage(playerid, -1, "Пароль должен содержать от 8 до 32 символов");
    strmid(PlayerInfo[playerid][pDostup],params[0], 0, strlen(params[0]), 33);
	mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET `Dostup` = '%s' WHERE `Name` = '%s'",params[0],GN(playerid));
	mysql_tquery(MySql_Base, QUERY, "", "");
	format(req,sizeof(req),"Новый пароль:{FFFFFF} %s",PlayerInfo[playerid][pDostup]);
	SPD(playerid,0,DIALOG_STYLE_MSGBOX, "Пароль доступа", req, "Ок", "");
	return 1;
}
cmd:admins(playerid)
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	SendClientMessage(playerid, 0xFFFF00AA, "Админы Online:");
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pAdmin] >= 1 && PlayerInfo[i][pAdmin] <= 5)
		{
			format(req,sizeof(req),"%s[%d] | lvl: %d",GN(i),i,PlayerInfo[i][pAdmin]);
			if(GetPlayerState(i) == PLAYER_STATE_SPECTATING && gSpectateID[i] != INVALID_PLAYER_ID)
			{
			    format(req,sizeof(req),"%s | в наблюдении за %s[%d]",req,GN(SpecAd[i]),SpecAd[i]);
			}
			if(PlayerEx[i][Var] > 1)
			{
			    format(req,sizeof(req),"%s | AFK: %s",req,ConvertSeconds(PlayerEx[i][Var]));
			}
			SendClientMessage(playerid,-1,req);
		}
	}
	return 1;
}
cmd:admin(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: (/a)dmin [текст]");
	format(req, sizeof(req), "> %s[%d]{FFFFFF}[%d]: %s", GN(playerid), playerid,PlayerInfo[playerid][pAdmin],params[0]);
	ABroadCast(0xFF9900AA,req,1);
	return 1;
}
alias:admin("a");
cmd:pm(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "us[128]", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /pm [id] [текст]");
	if(preport[params[0]] >= 1)
	{
	    format(req, sizeof(req), "Ответ: %s",params[1]);
		SendClientMessage(params[0], 0xFFFF00AA, req);
		format(req, sizeof(req), "{FFDEAD}Ваше обращение: %s",reporttext[params[0]]);
		SendClientMessage(params[0], -1, req);
		format(req, sizeof(req), "Ответ к %s[%d]: %s (от: %s)", GN(params[0]), params[0],params[1],GN(playerid));
		ABroadCast(0xA85400AA,req,1);
		preport[params[0]] = 0;
		reporttext[params[0]] = "-";
	}
	else
	{
		format(req, sizeof(req), "Сообщение от администратора: %s",params[1]);
		SendClientMessage(params[0], 0xFFFF00AA, req);
		format(req, sizeof(req), "Сообщение к %s[%d]: %s (от: %s)", GN(params[0]), params[0],params[1],GN(playerid));
		ABroadCast(0xA85400AA,req,1);
	}
	AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),1,params[1],0);
	SetPVarInt(params[0], "ReportFlood", 0);
	return 1;
}
cmd:rl(playerid)
{
    new string[2048],num = 0;
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	foreach(new i : Player)
	{
	    if(preport[i] >= 1)
	    {
	        if(PlayerInfo[i][pLeader] >= 1) format(string,sizeof(string),"%s{FFCC00}%s[%d]:%s{FFFFFF}\n",string,GN(i),i,reporttext[i]);
			else if(!SetInvite(PlayerInfo[i][pMember], PlayerInfo[i][pRank])) format(string,sizeof(string),"%s{33FF33}%s[%d]:%s{FFFFFF}\n",string,GN(i),i,reporttext[i]);
			else format(string,sizeof(string),"%s%s[%d]:%s\n",string,GN(i),i,reporttext[i]);
			reportid[num] = i;
			num++;
		}
	}
	if(num == 0) return SendClientMessage(playerid, COLOR_GREY, "Нет открытых вопросов");
	SPD(playerid,12,DIALOG_STYLE_LIST,"Открытые вопросы",string,"Выбрать","Отмена");
	return 1;
}
cmd:re(playerid, params[])
{
    new Float:x,Float:y,Float:z;
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /re(con) [id]");
	if(params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, "Нельзя наблюдать за самим собой");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "Игрок не найден");
	if(GetPlayerState(params[0]) == PLAYER_STATE_SPECTATING && gSpectateID[params[0]] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "Администратор в режиме наблюдения");
	if(PlayerInfo[params[0]][pAdmin] > 0 && PlayerInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid, COLOR_GREY, "Наблюдение за администрацией запрещено!");
	if(GetPlayerState(params[0]) != 1 && GetPlayerState(params[0]) != 2 && GetPlayerState(params[0]) != 3) return SendClientMessage(playerid, COLOR_GREY, "Игрок не вступил в игру");
	if(!(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING))
	{
		GetPlayerPos(playerid,x,y,z);
	    PosAdmin[playerid][0] = x;
	    PosAdmin[playerid][1] = y;
	    PosAdmin[playerid][2] = z;
	    PosAdmins[playerid][0] = GetPlayerVirtualWorld(playerid);
	    PosAdmins[playerid][1] = GetPlayerInterior(playerid);
	}
	SpecAd[playerid] = params[0];
	SpecID[params[0]] = playerid;
	StartSpectate(playerid, params[0]);
	TextDrawShowForPlayer(playerid, ReconText[playerid]);
	return 1;
}
alias:re("recon","ку");
cmd:reoff(playerid)
{
	if(PlayerInfo[playerid][pAdmin] < 1) return 1;
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		StopSpectate(playerid);
		GameTextForPlayer(playerid, "~w~Recon ~r~Off", 5000, 4);
	}
	return 1;
}
cmd:slap(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /slap [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	new Float:shealth,Float:slx, Float:sly, Float:slz;
	GetPlayerHealth(params[0], shealth);
	SetPlayerHealthAC(params[0], shealth-5);
	GetPlayerPos(params[0], slx, sly, slz);
	SetPlayerPos(params[0], slx, sly, slz+5);
	PlayerPlaySound(params[0], 1130, slx, sly, slz+5);
	format(req, sizeof(req), "Админ %s дал(а) пинка %s",GN(playerid), GN(params[0]));
	ABroadCast(0xBFC0C2FF,req,1);
	return 1;
}
cmd:mute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	new paramss[40];
	strmid(paramss,params, 0, strlen(params), 40);
	if(sscanf(params, "uDS[30]",params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /mute [id] [минуты] [причина]");
    if((0 > params[1] < 180) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid,-1, "Время молчанки может быть от 0 до 180 минут");
    PlayerInfo[params[0]][pZakonp] -= 1;
	if(PlayerInfo[params[0]][pMute] == 0)
	{
		if(sscanf(paramss, "uds[30]",params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /mute [id] [минуты] [причина]");
		if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	    format(req, sizeof(req), "Администратор: %s получил(а) молчанку",GN(params[0]));
		SendClientMessage(params[0],COLOR_LIGHTRED, req);
		if(params[1] > 0)
		{
 			PlayerInfo[params[0]][pMute] = params[1]*60;
      		format(req, sizeof(req), "Причина нарушения: %s, время: %d мин.",params[2],params[1]);
			SendClientMessage(params[0], COLOR_LIGHTRED, req);
			format(req, sizeof(req), "Администратор %s: %s получил(а) молчанку на %d мин. Причина: %s",GN(playerid), GN(params[0]),params[1],params[2]);
			ABroadCast(COLOR_LIGHTRED,req,1);
		}
		else
		{
		    PlayerInfo[params[0]][pMute] = -1;
 			format(req, sizeof(req), "Причина нарушения: %s, время: 0 мин.",params[2]);
			SendClientMessage(params[0], COLOR_LIGHTRED, req);
			format(req, sizeof(req), "Администратор %s: %s получил(а) молчанку на 0 мин. Причина: %s",GN(playerid), GN(params[0]),params[2]);
			ABroadCast(COLOR_LIGHTRED,req,1);
		}
		format(req, sizeof(req), "%s получил молчанку", GN(params[0]));
		ProxDetector(1,50.0, params[0], req, COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),2,params[2],params[1]);
		return 1;
	}
	else if(PlayerInfo[params[0]][pMute] != 0 && (!sscanf(paramss, "uds[30]",params[0],params[1],params[2])))
	{
	    if(sscanf(params, "uds[30]")) return SendClientMessage(playerid, -1, "1Введите: /mute [id] [минуты] [причина]");
		if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
		if(params[1] > 0)
		{
		    if(PlayerInfo[params[0]][pMute] == -1) return SendClientMessage(playerid,COLOR_GREY, "У человека вечный мут");
 			PlayerInfo[params[0]][pMute] += params[1]*60;
    		format(req, sizeof(req), "Администратор: %s получил(а) молчанку",GN(params[0]));
			SendClientMessage(params[0],COLOR_LIGHTRED, req);
      		format(req, sizeof(req), "Причина нарушения: %s, время: %d(+%d) мин.",params[2],PlayerInfo[params[0]][pMute]/60,params[1]);
			SendClientMessage(params[0], COLOR_LIGHTRED, req);
			format(req, sizeof(req), "Администратор %s: %s получил(а) молчанку на %d(+%d) мин. Причина: %s",GN(playerid), GN(params[0]),PlayerInfo[params[0]][pMute]/60,params[1],params[2]);
			ABroadCast(COLOR_LIGHTRED,req,1);
		}
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),2,params[2],params[1]);
		return 1;
	}
 	else if(PlayerInfo[params[0]][pMute] != 0)
	{
	    if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
		PlayerInfo[params[0]][pMute] = 0;
		format(req, sizeof(req), "Администратор %s: у %s снята молчанка",GN(playerid), GN(params[0]));
		ABroadCast(COLOR_LIGHTRED, req,1);
		SendClientMessage(params[0],COLOR_LIGHTRED, "Администратор: Вам снята молчанка.");
		format(req, sizeof(req), "У %s снята молчанка", GN(playerid));
		ProxDetector(1,50.0, params[0], req, COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
		PlayerInfo[params[0]][pZakonp] += 1;
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),2,"-",0);
		return 1;
	}
	return 1;
}
cmd:mutelist(playerid)
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	new countmute = 0;
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pMute] != 0)
		{
			format(req, sizeof(req), "%s[%d]: %d мин", GN(i), i,PlayerInfo[i][pMute]/60);
			countmute++;
			SendClientMessage(playerid, 0x9ACD32AA, req);
		}
	}
	if(countmute == 0) return SendClientMessage(playerid, 0xB4B5B7FF, "Нет игроков с молчанкой");
	format(req, sizeof(req), "Всего: %d человек!", countmute);
	SendClientMessage(playerid, 0x7FB151FF, req);
	return 1;
}
cmd:kick(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
    if(sscanf(params, "us[30]", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /kick [id] [причина]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(PlayerInfo[params[0]][pAdmin] > 0 && PlayerInfo[playerid][pAdmin] < 6)
	{
	    format(req, sizeof(req), "Администратор %s: %s кикнут. Причина: %s", GN(playerid),GN(params[0]), params[1]);
		ABroadCast(COLOR_LIGHTRED, req,1);
	    format(req, sizeof(req), "Администраторы %s и %s сняты. Причина: попытка кика", GN(playerid),GN(params[0]));
		ABroadCast(COLOR_LIGHTRED, req,1);
		PlayerInfo[playerid][pAdmin] = 0;
		PlayerInfo[params[0]][pAdmin] = 0;
		KickFix(playerid);
		KickFix(params[0]);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),4,params[1],0);
		return 1;
	}
	format(req, sizeof(req), "Администратор %s: %s кикнут. Причина: %s", GN(playerid),GN(params[0]), params[1]);
	ABroadCast(COLOR_LIGHTRED, req,1);
	AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),4,params[1],0);
	PlayerInfo[params[0]][pZakonp] -= 2;
	KickFix(params[0]);
	return 1;
}
cmd:prison(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "uis[30]", params[0],params[1],params[2])) return	SendClientMessage(playerid, -1, "Введите: /prison [id] [время(0-180)] [причина]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if((0 > params[1] < 180) && PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid,-1, "Время пребывания в ФДМ может быть от 0 до 180 минут");
	PlayerInfo[params[0]][pZakonp] -= 2;
	PlayerInfo[params[0]][pZvezdi] = 0;
	if(PlayerInfo[params[0]][pJailTime] == 0)
	{
		PlayerInfo[params[0]][pJailed] = 4;
		PlayerInfo[params[0]][pJailTime] = params[1]*60;
		format(req, sizeof(req), "Вы были временно изолированы за нарушения на %d мин. Причина: %s",params[1],params[2]);
		SendClientMessage(params[0], COLOR_LIGHTRED, req);
		format(req, sizeof(req), "Администратор %s: %s был временно изолирован на %d мин. Причина: %s", GN(playerid),GN(params[0]),params[1],params[2]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		format(req, sizeof(req), "%s был временно изолирован.", GN(params[0]));
		ProxDetector(1,50.0, params[0], req, COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),3,params[2],params[1]);
		SetPVarInt(params[0], "FDMFlood", gettime() + 20);
		SetPlayerInterior(params[0], 0);
		SetPlayerVirtualWorld(params[0], 1001);
		SetPlayerPos(params[0],5508.3706,1244.7594,23.1886);
		DeleteWeapons(params[0]);
	}
	else if(PlayerInfo[params[0]][pJailTime] > 0 && PlayerInfo[playerid][pAdmin] >= 2)
	{
	    PlayerInfo[params[0]][pJailTime] += params[1]*60;
        format(req, sizeof(req), "Вы были временно изолированы за нарушения на %d(+%d) мин. Причина: %s",PlayerInfo[params[0]][pJailTime]/60,params[1],params[2]);
		SendClientMessage(params[0], COLOR_LIGHTRED, req);
		format(req, sizeof(req), "Администратор %s: %s был временно изолирован на %d(+%d) мин. Причина: %s", GN(playerid),GN(params[0]),PlayerInfo[params[0]][pJailTime]/60,params[1],params[2]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),3,params[2],PlayerInfo[params[0]][pJailTime]);
		SetPVarInt(params[0], "FDMFlood", gettime() + 20);
		SetPlayerInterior(params[0], 0);
		SetPlayerVirtualWorld(params[0], 1001);
		SetPlayerPos(params[0],5508.3706,1244.7594,23.1886);
		DeleteWeapons(params[0]);
	}
	return 1;
}
cmd:unprison(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return	SendClientMessage(playerid, -1, "Введите: /unprison [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	PlayerInfo[params[0]][pZakonp] += 2;
	PlayerInfo[params[0]][pJailed] = 0;
	PlayerInfo[params[0]][pJailTime] = 0;
	SpawnPlayer(params[0]);
	AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),3,"-",0);
	SendClientMessage(params[0], COLOR_LIGHTRED, "Администратор вытащил Вас из тюрьмы");
	SendClientMessage(playerid, COLOR_GREY, "Вы вытащили игрока из ФДМ");
	return 1;
}
cmd:prisonlist(playerid)
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	new countprison = 0;
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pJailed] == 4)
		{
			format(req, sizeof(req), "%s[%d]: %d мин", GN(i), i,PlayerInfo[i][pJailTime]/60);
			countprison++;
			SendClientMessage(playerid, -1, req);
		}
	}
	if(countprison == 0) return SendClientMessage(playerid, 0xB4B5B7FF, "Нет игроков в ФДМ");
	format(req, sizeof(req), "Всего: %d человек!", countprison);
	SendClientMessage(playerid, 0xFFFF00AA, req);
	return 1;
}
cmd:tp(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(!sscanf(params, "i", params[0]) && (params[0] >= 0 && params[0] < 42))
	{
	    if(0 <= params[0] <= 6) return SetPVarInt(playerid, "USEDIALOGID", 19), OnDialogResponse(playerid, 19, 1, params[0], "");
	    else if(7 <= params[0] <= 18) return SetPVarInt(playerid, "USEDIALOGID", 20), OnDialogResponse(playerid, 20, 1, params[0]-7, "");
	    else if(19 <= params[0] <= 26) return SetPVarInt(playerid, "USEDIALOGID", 21), OnDialogResponse(playerid, 21, 1, params[0]-19, "");
	    else if(27 <= params[0] <= 35) return SetPVarInt(playerid, "USEDIALOGID", 22), OnDialogResponse(playerid, 22, 1, params[0]-27, "");
		return 1;
	}
	new listitems[] = "- Общественные места\n- Гос. структуры\n- Нелегальные структуры\n- Прочее";
	SPD(playerid, 18, DIALOG_STYLE_LIST, "Teleport List", listitems, "Выбрать", "Закрыть");
	return true;
}
cmd:hp(playerid)
{
	if (PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(IsPlayerInAnyVehicle(playerid))
	{
	    AnRepairVehicle(GetPlayerVehicleID(playerid));
		Fuell[GetPlayerVehicleID(playerid)] = 100;
		PlayerInfo[playerid][pFuelcar] = 100;
	}
	SetPlayerHealthAC(playerid, 100.0);
	PlayerInfo[playerid][pHP] = 100;
	return true;
}
cmd:fid(playerid)
{
	if(PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Список фракций","[0] Гражданский\n[1] LSPD\n[2] FBI\n[3] Army SF\n[4] MCSF\n[5] LCN\n[6] Yakuza\n[7] Мэрия\n[8] Казино\n[9] Новости СФ\n[10] SFPD\n[11] Инструкторы\n[12] Ballas Gang\n[13] Vagos Gang\n[14] RM\n[15] Grove Street\n[16] Новости ЛС\n[17] Aztecas Gang\n[18] Rifa Gang\n[19] Army LV\n[20] Новости ЛВ\n[21] SWAT\n[22] MC LS\n","Ок","");
	return 1;
}
cmd:cfact(playerid,params[])
{
	new num;
    if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
    new	paramss[40];
	strmid(paramss,params, 0, strlen(params), 40);
    if(sscanf(params, "s[2] ", params[0]))
	{
		SendClientMessage(playerid, -1, "Используйте: /cfact [+|-|0] [спецификатор/спецификаторы через пробелы]");
		SendClientMessage(playerid, -1, "Специф-ры: Ид фракции (30-все) или 100-фермы, 101-такси, 102-дальноб, 103-пожарные, 104-пилоты, 110-все работы, 111-все работы+фермы");
		SendClientMessage(playerid, -1, "Специф-ры груп фракций: M-Мафии, G-Банды, A-Армии, C-ПД, ДПС и ФБР, N-Новости, E-МЧС, F-NG и Казино, R-Байкеры и Стритрейсеры");
		return 1;
	}
	format(req, sizeof(req), "%s: %s", params[0], params[1]);
	ABroadCast(COLOR_LIGHTRED, req,1);
	if(strcmp(params[0], "+", true) == 0) num = 1,SendClientMessage(playerid, -1, "Прослушка +");
	else if(strcmp(params[0], "-", true) == 0) num = 2,SendClientMessage(playerid, -1, "Прослушка -");
	else if(strcmp(params[0], "0", true) == 0)
	{
		for(new i = 1; i < 35; i++)
	    {
	        cfact[playerid][i] = 0;
	    }
	    SendClientMessage(playerid, -1, "Прослушка чатов отключена");
		return 1;
	}
	sscanf(paramss, "{s[2]}s[20]", params[1]);
	if(num == 1)
	{
	    SendClientMessage(playerid, -1, "Прослушка ++");
		if(!strcmp(params[1], "100", false))
		{
		    format(req, sizeof(req), "1%s: %s", params[0], params[1]);
			ABroadCast(COLOR_LIGHTRED, req,1);
		    for(new i = 1; i < 30; i++)
		    {
		        cfact[playerid][i] = 1;
		    }
		    SendClientMessage(playerid, -1, "Все фракции добавлены в контроль");
		    return 1;
		}
		if(strcmp(params[1], "100", true) == 0)
		{
			format(req, sizeof(req), "2%s: %s", params[0], params[1]);
			ABroadCast(COLOR_LIGHTRED, req,1);
			cfact[playerid][31] = 1;
		    SendClientMessage(playerid, -1, "Фермы добавлены в контроль");
		}
		if(strcmp(params[1], "101", true) == 0)
		{
		   	format(req, sizeof(req), "3%s: %s", params[0], params[1]);
			ABroadCast(COLOR_LIGHTRED, req,1);
			cfact[playerid][32] = 1;
		    SendClientMessage(playerid, -1, "Такси добавлены в контроль");
		}
	 	if(strcmp(params[1], "102", true) == 0)
		{
		   	format(req, sizeof(req), "4%s: %s", params[0], params[1]);
			ABroadCast(COLOR_LIGHTRED, req,1);
			cfact[playerid][33] = 1;
		    SendClientMessage(playerid, -1, "Дальнобойщики добавлены в контроль");
		}
	 	if(strcmp(params[1], "103", true) == 0)
		{
		    format(req, sizeof(req), "4%s: %s", params[0], params[1]);
			ABroadCast(COLOR_LIGHTRED, req,1);
			cfact[playerid][34] = 1;
		    SendClientMessage(playerid, -1, "Пожарники добавлены в контроль");
		}
	 	if(strcmp(params[1], "105", true) == 0)
		{
		    format(req, sizeof(req), "4%s: %s", params[0], params[1]);
			ABroadCast(COLOR_LIGHTRED, req,1);
			cfact[playerid][35] = 1;
		    SendClientMessage(playerid, -1, "Пилоты добавлены в контроль");
		}
		if(strcmp(params[1], "110", true) == 0)
		{
			cfact[playerid][32] = 1;
			cfact[playerid][33] = 1;
			cfact[playerid][34] = 1;
			cfact[playerid][35] = 1;
		    SendClientMessage(playerid, -1, "Все работы добавлены в контроль");
		}
		if(strcmp(params[1], "110", true) == 0)
		{
		    cfact[playerid][31] = 1;
			cfact[playerid][32] = 1;
			cfact[playerid][33] = 1;
			cfact[playerid][34] = 1;
			cfact[playerid][35] = 1;
		    SendClientMessage(playerid, -1, "Все работы и фермы добавлены в контроль");
		}
		if(strcmp(params[1], "M", true) == 0)
		{
            SendClientMessage(playerid, -1, "Все M добавлены в контроль");
		}
	}
	if(num == 2)
	{
	    if(strcmp(params[1], "30", true) == 0)
		{
		    for(new i = 1; i < 30; i++)
		    {
		        cfact[playerid][i] = 0;
		    }
		    SendClientMessage(playerid, -1, "Все фракции удалены из контроля");
		    return 1;
		}
		if(strcmp(params[1], "100", true) == 0)
		{
			cfact[playerid][31] = 0;
		    SendClientMessage(playerid, -1, "Фермы удалены из контроля");
		}
		if(strcmp(params[1], " 101", true) == 0)
		{
			cfact[playerid][32] = 0;
		    SendClientMessage(playerid, -1, "Такси удалены из контроля");
		}
	 	if(strcmp(params[1], " 102", true) == 0)
		{
			cfact[playerid][33] = 0;
		    SendClientMessage(playerid, -1, "Дальнобойщики удалены из контроля");
		}
	 	if(strcmp(params[1], " 103", true) == 0)
		{
			cfact[playerid][34] = 0;
		    SendClientMessage(playerid, -1, "Пожарники удалены из контроля");
		}
	 	if(strcmp(params[1], " 105", true) == 0)
		{
			cfact[playerid][35] = 0;
		    SendClientMessage(playerid, -1, "Пилоты удалены из контроля");
		}
		if(strcmp(params[1], " 110", true) == 0)
		{
			cfact[playerid][32] = 0;
			cfact[playerid][33] = 0;
			cfact[playerid][34] = 0;
			cfact[playerid][35] = 0;
		    SendClientMessage(playerid, -1, "Все работы удалены из контроля");
		}
		if(strcmp(params[1], "110", true) == 0)
		{
		    cfact[playerid][31] = 0;
			cfact[playerid][32] = 0;
			cfact[playerid][33] = 0;
			cfact[playerid][34] = 0;
			cfact[playerid][35] = 0;
		    SendClientMessage(playerid, -1, "Все работы и фермы удалены из контроля");
		}
		if(strcmp(params[1], "M", false) == 0)
		{

		}
	}
    //if(level < 0 || level > 21) return SendClientMessage(playerid, -1, "Некорректный ид фракции");
	//if(level > 1) fchat[playerid] = level,SendClientMessage(playerid, -1, "Прослушка чата фракции включена. Используйте ид фракции 0 для отключения");
	//if(level == 0) fchat[playerid] = 0,SendClientMessage(playerid, -1, "Прослушка чата фракции отключена.");
	return true;
}
cmd:am(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
	if(sscanf(params, "s[148]", params[0])) return SendClientMessage(playerid, -1, "Введите: /am [текст]");
	new num = 0;
	foreach(new i : Player)
	{
	    if(GetDistanceBetweenPlayers(playerid,i) <= 200.0) num++;
	}
    format(req, sizeof(req), "<< %s: %s >>", GN(playerid), params[0],num);
	ProxDetector(4,200.0, playerid, req,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA);
	format(req, sizeof(req), "<< %s: %s (%d)>>", GN(playerid), params[0],num);
	SendClientMessage(playerid, 0xFFFF00AA, req);
	return 1;
}
cmd:skin(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, -1, "Введите: /skin [id скина]");
	if(params[0] > 311 || params[0] < 1) { SendClientMessage(playerid, COLOR_GREY, "Неправильный ID скина!"); return 1; }
	SetPlayerSkin(playerid, params[0]);
	PlayerPlaySound(playerid, 1132, 0.0, 0.0, 0.0);
	return true;
}
cmd:g(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /g(oto) [id]");
	new Float:plocx,Float:plocy,Float:plocz;
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(GetPlayerState(params[0]) != 1 && GetPlayerState(params[0]) != 2 && GetPlayerState(params[0]) != 3) return SendClientMessage(playerid, -1, "Игрок не вступил в игру!");
	GetPlayerPos(params[0], plocx, plocy, plocz);
	if (GetPlayerState(playerid) == 2)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), plocx, plocy+4, plocz);
	}
	else
	{
		SetPlayerPos(playerid,plocx,plocy+2, plocz);
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(params[0]));
		SetPlayerInterior(playerid, GetPlayerInterior(params[0]));
	}
	SendClientMessage(playerid, -1, "Вы были телепортированы!");
	return true;
}
alias:g("goto");
cmd:mark(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "i", params[0])) params[0] = 0;
	GetPlayerPos(playerid, TeleportDest[playerid][0][params[0]],TeleportDest[playerid][1][params[0]],TeleportDest[playerid][2][params[0]]);
	TeleportDests[playerid][0][params[0]] = GetPlayerVirtualWorld(playerid);
	TeleportDests[playerid][1][params[0]] = GetPlayerInterior(playerid);
	SendClientMessage(playerid, -1, "Точка телепортирования установлена!");
	return true;
}
cmd:gotomark(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1 || !dostup[playerid]) return 1;
	if(sscanf(params, "i", params[0])) params[0] = 0;
	if (GetPlayerState(playerid) == 2)
	{
		new tmpcar = GetPlayerVehicleID(playerid);
		SetVehiclePos(tmpcar, TeleportDest[playerid][0][params[0]],TeleportDest[playerid][1][params[0]],TeleportDest[playerid][2][params[0]]);
	}
	else
	{
		SetPlayerPos(playerid, TeleportDest[playerid][0][params[0]],TeleportDest[playerid][1][params[0]],TeleportDest[playerid][2][params[0]]);
	}
	SetPlayerVirtualWorld(playerid,TeleportDests[playerid][0][params[0]]);
	SetPlayerInterior(playerid,TeleportDests[playerid][1][params[0]]);
	SendClientMessage(playerid, -1, "Вы были телепортированы!");
	return true;
}
cmd:warn(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
	if(sscanf(params, "uis[30]", params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /warn [id] [кол-во дней] [причина]");
	if(PlayerInfo[params[0]][pAdmin] > 0 && PlayerInfo[playerid][pAdmin] < 6)
	{
	    format(req, sizeof(req), "Администратор %s: %s кикнут. Причина: %s", GN(playerid),GN(params[0]), params[2]);
		ABroadCast(COLOR_LIGHTRED, req,1);
	    format(req, sizeof(req), "Администраторы %s и %s сняты. Причина: попытка варна", GN(playerid),GN(params[0]));
		ABroadCast(COLOR_LIGHTRED, req,1);
		PlayerInfo[playerid][pAdmin] = 0;
		PlayerInfo[params[0]][pAdmin] = 0;
		KickFix(playerid);
		KickFix(params[0]);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),5,params[2],0);
		return 1;
	}
	new year, month,day,h,mmm,s,years, months,days,hs,ms,ss;
	getdate(year, month, day);
	gettime(h,mmm,s);
	PlayerInfo[params[0]][pWarns] += 1;
	if(PlayerInfo[params[0]][pWarns] >= 3)
	{
		timestamp_to_date(mktime(h,0,0,day+7,month,year),years,months,days,hs,ms,ss);
		ban(PlayerInfo[params[0]][pID],GN(params[0]),PlayerInfo[playerid][pID],GN(playerid),params[2],mktime(h,0,0,day+7,month,year));
		format(req, sizeof(req), "Администратор: %s заблокирован(а) на 7 дней [3 предупреждения]. Причина: %s ",GN(params[0]), params[3]);
		SendClientMessage(params[0], COLOR_LIGHTRED, req);
		format(req, sizeof(req), "Разблокировка аккаунта произойдёт %02i/%02i/%02i после %02i час(а/ов)", days,months,years,hs);
		SendClientMessage(params[0], COLOR_LIGHTRED, req);
		format(req, sizeof(req), "Администратор %s: %s заблокирован(а) на 7 дней [3 предупреждения]. Причина: %s ",GN(playerid), GN(params[0]), params[2]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		format(req, sizeof(req), "%s заблокирован(а)[3 предупреждения]", GN(params[0]));
		ProxDetector(1,50.0, params[0], req, COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),6,params[2],7);
		format(QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Name` = '%s'",GN(params[0]));
		mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",9,params[0],"");
		PlayerInfo[params[0]][pMember] = 0;
		PlayerInfo[params[0]][pLeader] = 0;
		PlayerInfo[params[0]][pJob] = 0;
		PlayerInfo[params[0]][pZakonp] -= 4;
		KickFix(params[0]);
		return 1;
	}
	format(req, sizeof(req), "Администратор %s: %s выдано предупреждение[%d/3] на %d дн. Причина: %s", GN(playerid), GN(params[0]), PlayerInfo[params[0]][pWarns],params[1],params[2]);
	ABroadCast(COLOR_LIGHTRED,req,1);
	format(req, sizeof(req), "Администратор: Вам выдано предупреждение на %d дн. Причина: %s",params[1],params[2]);
	SendClientMessage(params[0], COLOR_LIGHTRED, req);
	format(req, sizeof(req), "%s получил(а) предупреждение", GN(params[0]));
	ProxDetector(1,50.0, params[0], req, COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
	timestamp_to_date(mktime(h,0,0,day+params[1],month,year),years,months,days,hs,ms,ss);
	format(req, sizeof(req), "Снятие предупреждения произойдёт %02i/%02i/%02i после %02i час(а/ов)", days,months,years,hs);
	SendClientMessage(params[0], COLOR_LIGHTRED, req);
	warn(PlayerInfo[params[0]][pID],GN(params[0]),PlayerInfo[playerid][pID],GN(playerid),params[2],mktime(h,0,0,day+params[1],month,year));
	AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),5,params[2],params[1]);
	PlayerInfo[params[0]][pZakonp] -= 3;
	PlayerInfo[params[0]][pMember] = 0;
	PlayerInfo[params[0]][pLeader] = 0;
	PlayerInfo[params[0]][pJob] = 0;
	KickFix(params[0]);
	return true;
}
cmd:gm(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
    if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /gm [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	new Float:boomx, Float:boomy, Float:boomz;
	GetPlayerPos(params[0],boomx, boomy, boomz);
	CreateExplosion(boomx, boomy, boomz, 5, 0.1);
	format(req, sizeof(req), "Администратор %s: %s проверен на GM", GN(playerid), GN(params[0]));
	ABroadCast(COLOR_LIGHTRED, req, 3);
	return true;
}
cmd:setspawn(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /setspawn [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	format(req, sizeof(req), "Администратор %s: %s заспавнен",GN(playerid), GN(params[0]));
	ABroadCast(COLOR_LIGHTRED,req,3);
	Spawn_Player(params[0]);
	return true;
}
cmd:amembers(playerid, params[])
{
    new null;
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /amembers [id фракции]");
	if(params[0] < 1 || params[0] > 21) return SendClientMessage(playerid, -1, "Некорректный ид фракции!");
	SendClientMessage(playerid, 0x6495EDFF, "Текущий состав организации (( онлайн )):");
	foreach(new i : Player)
	{
		if (IsPlayerConnected(i))
		{
			format(req, sizeof(req), "");
			if (PlayerInfo[i][pLeader] == params[0]) format(req, sizeof(req), "%s (( ранг: Лидер, id: %d ))",GN(i),i), null++;
			else if (PlayerInfo[i][pMember] == params[0]) format(req, sizeof(req), "%s (( ранг: %d, id: %d ))",GN(i),PlayerInfo[i][pRank],i), null++;
			if (strlen(req) > 1) SendClientMessage(playerid, 0xF5DEB3AA, req);
		}
	}
	format(req,sizeof(req),"{F5DEB3}Всего в организации:{81F781} %d{F5DEB3} человек",null);
	SendClientMessage(playerid, -1, req);
	return true;
}
cmd:noooc(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
   	new	paramss[20];
	strmid(paramss,params, 0, strlen(params), 20);
    sscanf(params, "d", params[0]);
	if(params[0] == 0)
	{
	    if(sscanf(paramss, "dD", params[0],params[1])) return	SendClientMessage(playerid, -1, "Введите: /noooc [1 включить / 0 отключить] [задержка в секундах]");
	    antiooc = 1;
	    noooc = 0;
	    SendClientMessageToAll(-1, "Общий чат выключен администратором!");
	    
	}
	if(params[0] == 1)
	{
	    if(sscanf(paramss, "dd", params[0],params[1])) return	SendClientMessage(playerid, -1, "Введите: /noooc [1 включить / 0 отключить] [задержка в секундах]");
	    noooc = 1;
		antiooc = params[1];
	    SendClientMessageToAll(-1, "Общий чат включен администратором!");
	    format(req, sizeof(req), "Задержка: %d секунд",params[1]);
	    ABroadCast(-1, req, 1);
	}
	return true;
}
cmd:ooc(playerid, params[])
{
	if ((!noooc) && (PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid])) return 	SendClientMessage(playerid, 0xB4B5B7FF, "Общий чат выключен администратором!");
	if(IsMute(playerid)) return 1;
	new is1=0;
	new r=0;
	while(strlen(params[is1]))
	{
		if('0'<=params[is1]<='9')
		{
			new is2=is1+1;
			new p=0;
			while(p==0)
			{
				if('0'<=params[is2]<='9'&&strlen(params[is2])) is2++;
				else
				{
					strmid(strR[r],params,is1,is2,256);
					if(strval(strR[r])<256) r++;
					is1=is2;
					p=1;
				}
			}
		}
		is1++;
	}
	if(r>=4)
	{
		format(req, sizeof(req), "В /o | Игрок %s | ID| %d: %s",GN(playerid),playerid,params);
		ABroadCast(COLOR_LIGHTRED, req, 1);
		for(new z=0;z<r;z++)
		{
			new pr2;
			while((pr2=strfind(params,strR[z],true))!=-1) for(new i=pr2,j=pr2+strlen(strR[z]);i<j;i++) params[i]='*';
		}
		return 1;
	}
	if(sscanf(params, "s[148]", params[0])) return	SendClientMessage(playerid, -1, "Введите: (/o)oc [текст]");
	if(strfind(params,"www",true)!=-1 || strfind(params,".ru",true)!=-1 || strfind(params,".net",true)!=-1 || strfind(params,".com",true)!=-1 || strfind(params,"http",true)!=-1)
	{
		format(req,sizeof(req),"В /o | Игрок %s| ID | %d | Текст: %s", GN(playerid), playerid, params);
		SendClientMessage(playerid, COLOR_LIGHTRED, req);
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] == 0 && gettime() < antioocsend) return SendClientMessage(playerid, COLOR_GREY, "Нельзя так часто писать в ООС чат");
	antioocsend = gettime()+antiooc;
	format(req, sizeof(req), "<< %s[%d]: %s >>", GN(playerid), playerid, params[0]);
	SendClientMessageToAll(0xE0FFFFAA, req);
	return 1;
}
alias:ooc("o");
cmd:oa(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
    if(sscanf(params, "s[148]", params[0])) return SendClientMessage(playerid, -1, "Введите: /oa [текст]");
	if(PlayerInfo[playerid][pAdmin] >= 6)format(req, sizeof(req), "<< {D83636}[Ген. администратор] {E0FFFF}%s[%d]: %s >>",GN(playerid),playerid, params[0]);// 6 ранг админа
	else if(PlayerInfo[playerid][pAdmin] == 5)format(req, sizeof(req), "<< {00CC00}[Гл. администратор] {E0FFFF}%s[%d]: %s >>",GN(playerid),playerid, params[0]);// 6 ранг админа
	else if(PlayerInfo[playerid][pAdmin] == 4)format(req, sizeof(req), "<< {00FF99}[Ст. администратор] {E0FFFF}%s[%d]: %s >>",GN(playerid),playerid, params[0]);// 5ранг админа
	else if(PlayerInfo[playerid][pAdmin] == 3)format(req, sizeof(req), "<< {114D71}[Администратор] {E0FFFF}%s[%d]: %s >>",GN(playerid),playerid, params[0]);// 4ранг модера
	else if(PlayerInfo[playerid][pAdmin] == 2)format(req, sizeof(req), "<< {FFFF33}[Мл. администратор] {E0FFFF}%s[%d]: %s >>",GN(playerid),playerid, params[0]);// 3ранг модера
	SendClientMessageToAll(-1, req);
	return 1;
}
cmd:nchat(playerid)
{
    if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
	if(!noobchat[playerid]) noobchat[playerid] = 1,SendClientMessage(playerid, -1, "Чат новичков включен");
	else if(noobchat[playerid]) noobchat[playerid] = 0,SendClientMessage(playerid, -1, "Чат новичков выключен");
	return true;
}
cmd:ban(playerid,params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "uds[20]", params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /ban [id] [кол-во дней] [причина]");
	new year, month,day,h,mmm,s,years, months,days,hs,ms,ss;
	getdate(year, month, day);
	gettime(h,mmm,s);
	if(PlayerInfo[params[0]][pAdmin] > 0 && PlayerInfo[playerid][pAdmin] < 6)
	{
	    format(req, sizeof(req), "Администратор %s: %s кикнут. Причина: %s", GN(playerid),GN(params[0]), params[2]);
		ABroadCast(COLOR_LIGHTRED, req,1);
	    format(req, sizeof(req), "Администраторы %s и %s сняты. Причина: попытка бана", GN(playerid),GN(params[0]));
		ABroadCast(COLOR_LIGHTRED, req,1);
		PlayerInfo[playerid][pAdmin] = 0;
		PlayerInfo[params[0]][pAdmin] = 0;
		KickFix(playerid);
		KickFix(params[0]);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),6,params[2],0);
		return 1;
	}
	ban(PlayerInfo[params[0]][pID],GN(params[0]),PlayerInfo[playerid][pID],GN(playerid),params[2],mktime(h,0,0,day+params[1],month,year));
	timestamp_to_date(mktime(0,0,0,day+params[1],month,year),years,months,days,hs,ms,ss);
	format(req, sizeof(req), "Администратор: %s заблокирован(а) на %d дн. Причина: %s ",GN(params[0]), params[1], params[2]);
	SendClientMessage(params[0], COLOR_LIGHTRED, req);
	format(req, sizeof(req), "Разблокировка аккаунта произойдёт %02i/%02i/%02i после %02i час(а/ов)", days,months,years,hs);
	SendClientMessage(params[0], COLOR_LIGHTRED, req);
	format(req, sizeof(req), "Администратор %s: %s заблокирован(а) на %d дн. Причина: %s ",GN(playerid), GN(params[0]), params[1], params[2]);
	ABroadCast(COLOR_LIGHTRED,req,1);
	format(req, sizeof(req), "%s заблокирован(а). Причина: %s", GN(params[0]),params[2]);
	ProxDetector(1,50.0, params[0], req, COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
	AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),6,params[2],params[1]);
	mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Name` = '%s'",GN(params[0]));
	mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",9,params[0],"");
	PlayerInfo[params[0]][pMember] = 0;
	PlayerInfo[params[0]][pLeader] = 0;
	PlayerInfo[params[0]][pJob] = 0;
	PlayerInfo[params[0]][pZakonp] -= 4;
	KickFix(params[0]);
	return 1;
}
/*cmd:offban(playerid,params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "uds[20]", params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /offban [id] [кол-во дней] [причина]");
	new year, month,day,h,m,s,years, months,days,hs,ms,ss,string[150];
	getdate(year, month, day);
	gettime(h,m,s);
	if(IsPlayerConnected(params[0])) return SendClientMessage(playerid, -1, "Человек онлайн. Используйте /ban");
	new name[25] = bigstr(params[0],idx);
	mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Name` = '%s'",name);
	mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",9,params[0],"");
	if(PlayerInfo[giveplayerid][pAdmin] > 0 && PlayerInfo[playerid][pAdmin] < 6)
	{
		format(string, sizeof(string), "Администратор %s: %s забанен. Причина: %s", GN(playerid),GN(giveplayerid), text);
		ABroadCast(COLOR_LIGHTRED, string,1);
	    format(string, sizeof(string), "[OFFBAN] Администраторы %s и %s сняты. Причина: попытка бана", GN(playerid),GN(giveplayerid));
		ABroadCast(COLOR_LIGHTRED, string,1);
        mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET `Admin` = '0' WHERE `Name` = '%s'",GN(playerid));
		mysql_tquery(MySql_Base, QUERY, "", "");
		PlayerInfo[playerid][pAdmin] = 0;
		KickFix(playerid);
		AdmLog(GN(playerid),giveplayerid,6,text,0);
		return 1;
	}
	ban(GN(giveplayerid),GN(playerid),text,mktime(h,0,0,day+level,month,year));
	timestamp_to_date(mktime(0,0,0,day+level,month,year),years,months,days,hs,ms,ss);
	format(string, sizeof(string), "Администратор: %s заблокирован(а) на %d дн. Причина: %s ",GN(giveplayerid), level, text);
	SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
	format(string, sizeof(string), "Разблокировка аккаунта произойдёт %02i/%02i/%02i после %02i час(а/ов)", days,months,years,hs);
	SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
	format(string, sizeof(string), "Администратор %s: %s заблокирован(а) на %d дн. Причина: %s ",GN(playerid), GN(giveplayerid), level, text);
	ABroadCast(COLOR_LIGHTRED,string,1);
	AdmLog(GN(playerid),GN(giveplayerid),6,text,level);
	PlayerInfo[giveplayerid][pMember] = 0;
	PlayerInfo[giveplayerid][pLeader] = 0;
	PlayerInfo[giveplayerid][pJob] = 0;
	KickFix(giveplayerid);
	return 1;
}*/
cmd:gethere(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /gethere [id]");
	new Float:plocx,Float:plocy,Float:plocz;
	if(GetPlayerState(params[0]) != 1 && GetPlayerState(params[0]) != 2 && GetPlayerState(params[0]) != 3) return	SendClientMessage(playerid, -1, "Игрок не вступил в игру!");
	GetPlayerPos(playerid, plocx, plocy, plocz);
	if (GetPlayerState(params[0]) == 2)
	{
		SetVehiclePos(GetPlayerVehicleID(params[0]), plocx, plocy+4, plocz);
		SetPlayerInterior(params[0],GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(params[0],GetPlayerVirtualWorld(playerid));
	}
	else
	{
		SetPlayerPos(params[0],plocx,plocy+2, plocz);
		SetPlayerInterior(params[0],GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(params[0],GetPlayerVirtualWorld(playerid));
	}
	if(PlayerInfo[playerid][pAdmin] < 6) return SendClientMessage(params[0], -1, "Вас телепортировал(а) администратор Sectum RP");
	if(PlayerInfo[playerid][pAdmin] == 6) return SendClientMessage(params[0], 0x6495EDFF, "Вас телепортировал(а) Генеральная администрация Sectum Role Play");
	return true;
}
cmd:uval(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "us[20]", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /uval [id игрока] [причина]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
    //if(strlen(params[1])) strmid(params[1],"не указано", 0, 12, 13);
    if(PlayerInfo[params[0]][pLeader] > 0 && PlayerInfo[playerid][pAdmin] < 4) return SendClientMessage(playerid, -1, "Игрок является лидеров");
    if(PlayerInfo[params[0]][pLeader] > 0 || (!SetInvite(PlayerInfo[params[0]][pMember], PlayerInfo[params[0]][pRank])))
    {
   		format(req,sizeof(req), "%s является лидером/заместителем. Уволить?",GN(params[0]));
		SPD(playerid,67,DIALOG_STYLE_MSGBOX,"Предупреждение",req, "Да", "Нет");
		InviteOffer[playerid] = params[0];
		strmid(Uninvitereason[playerid],params[1], 0, strlen(params[1]), 20);
		return 1;
    }
	if (PlayerInfo[params[0]][pMember] > 0)
	{
		format(req, sizeof(req), "Вы уволены из организации администратором %s. Причина: %s", GN(playerid),params[1]);
		SendClientMessage(params[0], 0x6495EDFF, req);
		SendClientMessage(params[0], -1, "Теперь вы обычный гражданин...");
		format(req, sizeof(req), "Администратор %s: %s выгнан из организации. Причина: %s", GN(playerid),GN(params[0]),params[1]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		format(req,sizeof(req),"%d->0 Adm",PlayerInfo[params[1]][pRank]);
		RangLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),PlayerInfo[params[0]][pMember],3,params[1],req);
		PlayerInfo[params[0]][pMember] = 0;
		PlayerInfo[params[0]][pLeader] = 0;
		PlayerInfo[params[0]][pRank] = 0;
		PlayerInfo[params[0]][pModel] = 0;
		SetPlayerInterior(params[0], 0);
		SetPlayerArmourAC(params[0],0);
		DeleteWeapons(params[0]);
		ResetPlayerWeapons(params[0]);
		Spawn_Player(params[0]);
	}
	return 1;
}
cmd:alock(playerid)
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	new Float:cx,Float:cy,Float:cz;
	GetVehiclePos(GetNearestVehicle(playerid), cx, cy, cz);
	if(PlayerToPoint(4.0, playerid, cx, cy, cz))
	{
	    if(gCarLock[GetNearestVehicle(playerid)] == 0)
	    {
	        SendClientMessage(playerid, -1, "Машина закрыта!");
			LockCar(GetNearestVehicle(playerid));
			IsLocked[GetNearestVehicle(playerid)] = 1;
			gCarLock[GetNearestVehicle(playerid)] = 1;
		}
		else
		{
			SendClientMessage(playerid, -1, "Машина открыта!");
			UnLockCar(GetNearestVehicle(playerid));
			IsLocked[GetNearestVehicle(playerid)] = 0;
			gCarLock[GetNearestVehicle(playerid)] = 0;
		}
	}
	return 1;
}
cmd:spveh(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
    if(sscanf(params, "df", params[0],params[1])) return SendClientMessage(playerid,-1,"Введите: /spveh [1-все, 2-пустые] [радиус]");
	new Float:pos = floatstr(params[1]),Float:car_x,Float:car_y,Float:car_z;
	if((pos > 300.00) && PlayerInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid, -1, "Радиус не должен превышать 300!");
	for(new cars=0;cars<MAX_VEHICLES;cars++)
	{
		if(GetVehicleModel(cars) > 399)
		{
			GetVehiclePos(cars,car_x,car_y,car_z);
			if(IsPlayerInRangeOfPoint(playerid,pos,car_x,car_y,car_z))
			{
				if(params[0] == 2)
				{
                    if(!IsVehicleOccupied(cars))
					{
					    SetVehicleToRespawn(cars);
					}
				}
				if(params[0] == 1)
				{
                    SetVehicleToRespawn(cars);
				}
			}
		}
	}
	if(params[0] == 2)
	{
		format(req,sizeof(req),"Администратор %s: все незанятые машины заспавнены в радиусе: %0.1f", GN(playerid),pos);
		ABroadCast(COLOR_LIGHTRED,req,1);
	}
	if(params[0] == 1)
	{
		format(req,sizeof(req),"Администратор %s: все машины заспавнены в радиусе: %0.1f", GN(playerid),pos);
		ABroadCast(COLOR_LIGHTRED,req,1);
	}
	return 1;
}
cmd:veh(playerid, params[])
{
    new createdvehs;
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(GetPlayerInterior(playerid)) return  SendClientMessage(playerid, 0xB4B5B7FF, "Команда доступна только на улице");
	if(sscanf(params, "iII", params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /veh [carid] [цвет1] [цвет2]");
	if(params[0] < 400 || params[0] > 611) return SendClientMessage(playerid, COLOR_GREY, "Номер машины не может быть меньше 400 и больше чем 611!");
 	if(params[1] < 0 || params[1] > 255) { params[1] = -1; }
	if(params[2] < 0 || params[2] > 255) { params[2] = -1; }
	new intt = GetPlayerInterior(playerid);
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid, X,Y,Z);
	createdvehs = CreateVehicle(params[0], X,Y,Z, 0.0, params[1], params[2], 60000);
	PutPlayerInVehicle(playerid, createdvehs, 0);
	zavodis[createdvehs] = 0;
	VehicleLight[createdvehs] = 0;
	Fuell[createdvehs] = 100;
	IsLocked[createdvehs] = 0;
	gCarLock[createdvehs] = 0;
	NotServerAvto[GetPlayerVehicleID(playerid)]=true;
	UnLockCar(createdvehs);
	LinkVehicleToInterior(createdvehs, intt);
	format(req, sizeof(req), "Транспортное средство создано, ID: %d.", params[0]);
	SendClientMessage(playerid, -1, req);
	return 1;
}
cmd:delveh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER && GetPlayerState(playerid)!=PLAYER_STATE_PASSENGER) return SendClientMessage(playerid, 0xB4B5B7FF, "Нужно находиться в созданной машине");
	new vehicle=GetPlayerVehicleID(playerid);
	if(!NotServerAvto[vehicle]) return SendClientMessage(playerid, 0xB4B5B7FF, "Нельзя стереть серверный автомобиль!");
	DestroyVehicle(vehicle);
	NotServerAvto[vehicle] = false;
	return true;
}
cmd:atazer(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	params[0] = GetClosestPlayer(playerid);
	if(!ProxDetectorS(30.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, "Нет ни кого рядом");
	format(req, sizeof(req), "Администратор %s обездвижил(а) всех на 15 секунд", GN(playerid));
	ProxDetector(1,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	TogglePlayerControllable(params[0], 0);
	SetPlayerSpecialAction(params[0],SPECIAL_ACTION_HANDSUP);
	Tazer[params[0]] = 1;
	TazerTime[params[0]] = 10;
	return true;
}
cmd:disarm(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /disarm [радиус]");
    new Float:pos = floatstr(params[0]),Float:player_x,Float:player_y,Float:player_z;
    foreach(new i : Player)
    {
    	GetPlayerPos(i,player_x,player_y,player_z);
   	 	if(IsPlayerInRangeOfPoint(i,pos,player_x,player_y,player_z))
      	{
       		ResetPlayerWeapons(i);
         	SendClientMessage(i, -1,"Администратор изьял ваше оружие.");
       	}
    }
    format(req,sizeof(req),"Администратор %s изъял оружие в радиусе %0.2f",GN(playerid),pos);
    ABroadCast(COLOR_LIGHTRED,req,1);
    return true;
}
cmd:hpall(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
    if(sscanf(params, "f", params[0])) return SendClientMessage(playerid, -1, "Введите: /hpall [Радиус]");
    new Float:pos = floatstr(params[0]),Float:player_x,Float:player_y,Float:player_z;
    foreach(new i : Player)
    {
    	GetPlayerPos(i,player_x,player_y,player_z);
   	 	if(IsPlayerInRangeOfPoint(playerid,pos,player_x,player_y,player_z))
      	{
       		SetPlayerHealthAC(i,100.0);
            PlayerInfo[i][pHP] = 100;
            SendClientMessage(i, -1, "Администратор пополнил(а) Вам здоровье.");
       	}
    }
    format(req,sizeof(req),"Администратор %s пополнил здоровье в радиусе %0.2f",GN(playerid),pos);
    ABroadCast(COLOR_LIGHTRED,req,1);
    return true;
}
cmd:setskin(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
    if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /setskin [id игрока/ник] [id скина]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(params[1] > 299 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, "Неправильный ID скина!");
	format(req, sizeof(req), "Администратор %s выдал Вам временный скин", GN(playerid));
	SendClientMessage(params[0], 0x6495EDFF, req);
	format(req, sizeof(req), "Вы выдали игроку %s[%d] временный скин [%d]", GN(params[0]),params[0],params[1]);
	SendClientMessage(playerid, 0x6495EDFF, req);
	SetPlayerSkin(params[0], params[1]);
	return true;
}
cmd:ainvite(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /ainvite [id] [фракция]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, "Игрок в машине!");
	if(PlayerInfo[params[0]][pWarns] >= 1) return SendClientMessage(playerid, COLOR_GREY,"У игрока Warn.");
	InviteOffer[params[0]] = params[1];
	switch(params[1])
	{
		case 2: InviteSkin[params[0]] = 295;
	    case 1,10,21: InviteSkin[params[0]] = 280;
	    case 3,19: InviteSkin[params[0]] = 287;
	    case 4,22: InviteSkin[params[0]] = 70;
	    case 5:InviteSkin[params[0]] = 223;
	    case 6:InviteSkin[params[0]] = 120;
	    case 7:InviteSkin[params[0]] = 57;
	    case 8:InviteSkin[params[0]] = 171;
	    case 9,16,20:InviteSkin[params[0]] = 250;
	    case 11:InviteSkin[params[0]] = 59;
	    case 12:InviteSkin[params[0]] = 102;
	    case 13:InviteSkin[params[0]] = 108;
	    case 14:InviteSkin[params[0]] = 111;
	    case 15:InviteSkin[params[0]] = 106;
	    case 17:InviteSkin[params[0]] = 115;
	    case 18:InviteSkin[params[0]] = 174;
	}
	format(req, sizeof(req), "Вы пригласили %s вступить в организацию.",GN(params[0]));
	SendClientMessage(playerid, 0x6495EDFF, req);
	format(req,sizeof(req), "Администратор %s приглашает Вас присоедениться к %s\n- Вы согласны?",GN(playerid),GetFrac(params[1]));
	SPD(params[0],33,DIALOG_STYLE_MSGBOX,"Приглашение",req, "Да", "Нет");
	RangLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),1,params[1],"-","0->1 Adm");
	return true;
}
cmd:sethp(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /sethp [id] [уровень hp]");
	if(params[1] > 255) return SendClientMessage(playerid, 0xB4B5B7FF, "[Ошибка] Установить можно не более 255 хп");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	SetPlayerHealthAC(params[0], params[1]);
	PlayerInfo[params[0]][pHP] = params[1];
	format(req, sizeof(req), "Уровень hp установлен игроку %s",GN(params[0]));
	SendClientMessage(playerid, -1, req);
	return 1;
}
cmd:smschat(playerid)
{
    if(PlayerInfo[playerid][pAdmin] < 2 || !dostup[playerid]) return 1;
	if(!smschat[playerid]) smschat[playerid] = 1,SendClientMessage(playerid, -1, "Слушать СМС ON");
	else if(smschat[playerid]) smschat[playerid] = 0,SendClientMessage(playerid, -1, "Слушать СМС OFF");
	return true;
}
cmd:cchat(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(!cchat[playerid]) cchat[playerid] = 1,SendClientMessage(playerid,COLOR_GREY, "Сообщения о присоединении игроков включены");
	else if(cchat[playerid]) cchat[playerid] = 0,SendClientMessage(playerid, COLOR_GREY, "Сообщения о присоединении игроков выключены");
	return true;
}
cmd:aad(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /aad [сообщение]");
	format(req, sizeof(req), "Администратор %s: %s", GN(playerid), params[0]);
	SendClientMessageToAll(COLOR_LIGHTRED, req);
	return 1;
}
cmd:givegun(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "udd", params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /givegun [id] [id оружия] [патроны]");
	if(params[1] <1||params[1] > 9999) { SendClientMessage(playerid, 0xB4B5B7FF, "Нельзя меньше 1 или больше 9999 патронов!"); return true; }
	if(params[2] <1||params[2] > 46) { SendClientMessage(playerid, 0xB4B5B7FF, "Неправильный ид оружия(от 1 до 46)!"); return true; }
	if(!IsPlayerConnected(params[0])) return 1;
	GiveWeapon(params[0], params[1], params[2]);
	SendClientMessage(playerid, 0xB4B5B7FF, "Оружие выдано");
	return true;
}
cmd:freeze(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /freeze [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	TogglePlayerControllable(params[0], 0);
	format(req, sizeof(req), "Админ %s заморозил %s",GN(playerid), GN(params[0]));
	ABroadCast(0xBFC0C2FF,req,3);
	return 1;
}
cmd:unfreeze(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /unfreeze [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	TogglePlayerControllable(params[0], 1);
	format(req, sizeof(req), "Админ %s разморозил %s",GN(playerid), GN(params[0]));
	ABroadCast(0xBFC0C2FF,req,3);
	return 1;
}
cmd:makeleader(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /makeleader [id] [Number(1 - 22)]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(params[1] > 22 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, "Нельзя меньше 1 или больше 22!");
	if(PlayerInfo[params[0]][pWarns] >= 1) return SendClientMessage(playerid, 0xFF0000AA,"У игрока Warn.");
	PlayerInfo[params[0]][pLeader] = params[1];
	PlayerInfo[params[0]][pMember] = params[1];
	PlayerInfo[params[0]][pJob] = 0;
	SendClientMessage(params[0], 0xFF0000AA, "Используйте клавишу 'Быстрый бег' (пробел по умолчанию)");
	SendClientMessage(params[0], 0xFF0000AA, "Используйте клавишу 'Вверх,вниз' (W,S по умолчанию)");
	format(req, sizeof(req), "Вы были назначены контролировать данную фракцию администратором %s",GN(playerid));
	SendClientMessage(params[0], 0x6495EDFF, req);
	SendClientMessage(params[0], -1, "(( Обратитесь к администратору лидеров для получения модераторства на форуме ))");
    format(req, sizeof(req), "Администратор %s: %s назначен контролировать фракцию %s.", GN(playerid),GN(params[0]),GetFrac(params[1]));
	ABroadCast(COLOR_LIGHTRED,req,3);
	AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),7,"-",params[1]);
	switch(PlayerInfo[params[0]][pMember])
	{
	    case 1,10,21: { PlayerInfo[params[0]][pRank] = 15, InviteSkin[params[0]] = 280; }
	    case 2: { PlayerInfo[params[0]][pRank] = 8, InviteSkin[params[0]] = 286; }
	    case 3: { PlayerInfo[params[0]][pRank] = 16, InviteSkin[params[0]] = 61; }
	    case 4,22: { PlayerInfo[params[0]][pRank] = 8, InviteSkin[params[0]] = 70; }
	    case 5: { PlayerInfo[params[0]][pRank] = 10, InviteSkin[params[0]] = 223; }
	    case 6: { PlayerInfo[params[0]][pRank] = 10, InviteSkin[params[0]] = 120; }
	    case 7: { PlayerInfo[params[0]][pRank] = 6, InviteSkin[params[0]] = 57; }
	    case 8: { PlayerInfo[params[0]][pRank] = 5, InviteSkin[params[0]] = 171; }
	    case 9,16,20: { PlayerInfo[params[0]][pRank] = 6, InviteSkin[params[0]] = 261; }
	    case 11: { PlayerInfo[params[0]][pRank] = 8, InviteSkin[params[0]] = 59; }
	    case 12: { PlayerInfo[params[0]][pRank] = 10, InviteSkin[params[0]] = 102; }
	    case 13: { PlayerInfo[params[0]][pRank] = 11, InviteSkin[params[0]] = 108; }
	    case 14: { PlayerInfo[params[0]][pRank] = 8, InviteSkin[params[0]] = 111; }
	    case 15: { PlayerInfo[params[0]][pRank] = 10, InviteSkin[params[0]] = 106; }
	    case 17: { PlayerInfo[params[0]][pRank] = 10, InviteSkin[params[0]] = 115; }
	    case 18: { PlayerInfo[params[0]][pRank] = 10, InviteSkin[params[0]] = 174; }
	    case 19:{ PlayerInfo[params[0]][pRank] = 16, InviteSkin[params[0]] = 287; }
	}
	SetPlayerInterior(params[0],5);
	SetPlayerVirtualWorld(params[0],1);
	ShowMenuForPlayer(ChoseSkin,params[0]);
	SetPlayerPos(params[0],222.3489,-8.5845,1002.2109);
	SetPlayerFacingAngle(params[0],266.7302);
	SetPlayerCameraPos(params[0],225.3489,-8.5845,1002.2109);
	SetPlayerCameraLookAt(params[0],222.3489,-8.5845,1002.2109);
	TogglePlayerControllable(params[0], 0);
	SelectCharID[params[0]] = PlayerInfo[params[0]][pMember];
	SelectCharPlace[params[0]] = 1;
	PlayerInfo[params[0]][pModel] = InviteSkin[params[0]];
	SetPlayerHealthAC(params[0], 100);
	PlayerInfo[params[0]][pHP] =100;
	SetPlayerSkin(params[0], InviteSkin[params[0]]);
	if(Login[params[0]]) SaveAccount(params[0]);
	return 1;
}
cmd:agiverank(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /agiverank [id игрока] [ранг]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(PlayerInfo[params[0]][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, "Человек не состоит во фракции!");
	if(PlayerInfo[params[0]][pLeader] >= 1) return SendClientMessage(playerid, COLOR_GREY, "Человек является лидером!");
	if(SetRank(params[1],PlayerInfo[params[0]][pMember])) return SendClientMessage(playerid, COLOR_GREY, "Некорректный ранг!");
	if(PlayerInfo[params[0]][pRank] <= params[1])
	{
		format(req,sizeof(req),"Администратор %s: %s повышен с %d до %d ранга(%s) ", GN(playerid),GN(params[0]),PlayerInfo[params[0]][pRank],params[1],GetFrac(PlayerInfo[params[0]][pMember]));
	    ABroadCast(COLOR_LIGHTRED,req,3);
	    format(req, sizeof(req), "Вы были повышены до %d ранга администратором", params[1]);
		SendClientMessage(params[0], 0x6495EDFF, req);
	}
	if(PlayerInfo[params[0]][pRank] > params[1])
	{
		format(req,sizeof(req),"Администратор %s: %s понижен с %d до %d ранга(%s) ", GN(playerid),GN(params[0]),PlayerInfo[params[0]][pRank],params[1],GetFrac(PlayerInfo[params[0]][pMember]));
	    ABroadCast(COLOR_LIGHTRED,req,1);
	    format(req, sizeof(req), "Вы были понижены до %d ранга администратором", params[1]);
		SendClientMessage(params[0], 0x6495EDFF, req);
	}
	format(req,sizeof(req),"%d->%d Adm",PlayerInfo[params[0]][pRank],params[1]);
	RangLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),PlayerInfo[params[0]][pMember],2,"-",req);
	PlayerInfo[params[0]][pRank] = params[1];
	return 1;
}
cmd:iban(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "us[30]", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /iban [id] [причина]");
	new year, month,day,h,mmm,s;
	getdate(year, month, day);
	gettime(h,mmm,s);
	if(PlayerInfo[params[0]][pAdmin] > 0 && PlayerInfo[playerid][pAdmin] < 6)
	{
	    format(req, sizeof(req), "Администратор %s: %s кикнут. Причина: %s", GN(playerid),GN(params[0]), params[1]);
		ABroadCast(COLOR_LIGHTRED, req,1);
	    format(req, sizeof(req), "Администраторы %s и %s сняты. Причина: попытка бана", GN(playerid),GN(params[0]));
		ABroadCast(COLOR_LIGHTRED, req,1);
		PlayerInfo[playerid][pAdmin] = 0;
		PlayerInfo[params[0]][pAdmin] = 0;
		KickFix(playerid);
		KickFix(params[0]);
		AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),6,params[1],0);
		return 1;
	}
	ban(PlayerInfo[params[0]][pID],GN(params[0]),PlayerInfo[playerid][pID],GN(playerid),params[1],-1);
	format(req, sizeof(req), "Администратор: %s заблокирован(а) навечно. Причина: %s ",GN(params[0]), params[1]);
	SendClientMessage(params[0], COLOR_LIGHTRED, req);
	format(req, sizeof(req), "Администратор %s: %s заблокирован(а) навечно. Причина: %s ",GN(playerid), GN(params[0]), params[1]);
	ABroadCast(COLOR_LIGHTRED,req,1);
	format(req, sizeof(req), "%s заблокирован(а) навечно. Причина: %s", GN(params[0]),params[1]);
	ProxDetector(1,50.0, params[0], req, COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
	AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),6,params[1],-1);
	mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Name` = '%s'",GN(params[0]));
	mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",9,params[0],"");
	PlayerInfo[params[0]][pMember] = 0;
	PlayerInfo[params[0]][pLeader] = 0;
	PlayerInfo[params[0]][pJob] = 0;
	PlayerInfo[params[0]][pZakonp] -= 4;
	KickFix(params[0]);
	return 1;
}
cmd:unwarn(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /unwarn [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(PlayerInfo[params[0]][pWarns] <= 0) return SendClientMessage(playerid, 0xAA3333AA, "Варнов нет");
	PlayerInfo[params[0]][pWarns] -= 1;
	format(req,sizeof(req),"Администратор %s: у %s снят варн", GN(playerid), GN(params[0]));
	ABroadCast(COLOR_LIGHTRED,req,2);
	SendClientMessage(params[0], 0x33AA33AA, "C Вас снят Warn");
	mysql_format(MySql_Base,QUERY,sizeof(QUERY), "DELETE FROM `warn` WHERE `Name` = '%s' LIMIT 1",GN(params[0]));
	mysql_tquery(MySql_Base,QUERY,"","");
	return 1;
}
cmd:spcar(playerid)
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	return 1;
}
cmd:spcars(playerid)
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	for(new cars = 0; cars < MAX_VEHICLES; cars++)
	{
		if(!IsVehicleOccupied(cars))
		{
			SetVehicleToRespawn(cars);
		}
	}
	format(req,sizeof(req),"Администратор %s: все незанятые машины заспавнены", GN(playerid));
	ABroadCast(COLOR_LIGHTRED,req,1);
	return 1;
}
cmd:weather(playerid,params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /weather [id погоды]");
	if((params[0] < 0||params[0] > 45)&& params[0]!=-68) return SendClientMessage(playerid, COLOR_GREY, "Неправильный ID(от 0 до 45, -68)");
	weather = params[0];
	SetWeather(params[0]);
	format(req,sizeof(req),"Администратор %s: погода изменена на %d", GN(playerid), params[0]);
	ABroadCast(COLOR_LIGHTRED,req,4);
	return 1;
}
cmd:obj(playerid,params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
    ShowPlayerDialog(playerid,68, DIALOG_STYLE_LIST, "Создание / Изменение объекта","Создать объект\nВыбрать объект","Выбрать","Отмена");
    return true;
}
cmd:agl(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /agl [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	SPD(playerid, 63, DIALOG_STYLE_LIST, "Выдача лицензий:", "- Водительские права\n- Лицензия на полёты\n- Лицензия на вождение водного транспорта\n- Лицензия на оружие\n- Лицензия на бизнес", "Ок", "Отмена");
	ChosenPlayer[playerid] = params[0];
	return 1;
}
cmd:atune(playerid)
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "Вы должны быть в автомобиле");
	SPD(playerid, 35, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел тюнинг\nЦвет\nВинилы\nЗакись азота", "Выбрать", "Назад");
	return true;
}
cmd:unban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 5 || !dostup[playerid]) return 1;
	if(sscanf(params, "s[26]", params[0])) return SendClientMessage(playerid, -1, "Введите: /unban [ник]");
	mysql_format(MySql_Base,QUERY,sizeof(QUERY), "SELECT * FROM `ban` WHERE `Name` = '%s'",params[0]);
	mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",8,playerid,params[0]);
	return 1;
}
cmd:gmx(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 5 || !dostup[playerid]) return 1;
	SendClientMessageToAll(0xF5DEB3AA,"{ECF2B6}Внимание! Происходит рестарт сервера, это займёт менее 30 секунд");
	SendClientMessageToAll(0xF5DEB3AA,"{ECF2B6}Администрация Sectum RolePlay приносит извинения, за предоставленные неудобства");
	SaveMySQL(0);
	GameModeExit();
	return 1;
}
cmd:delacc(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	if(sscanf(params, "s[26]", params[0])) return SendClientMessage(playerid, -1, "Введите: /delacc [ник]");
	format(QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Name` = '%s'",params[0]);
	mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",12,playerid,params[0]);
	return 1;
}
cmd:setstat(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	if(sscanf(params, "udd", params[0],params[1],params[2]))
	{
	    SendClientMessage(playerid, -1, "Введите: /setstat [id] [номер] [кол-во]");
		SendClientMessage(playerid, -1, "1. Уровень | 2. Материалы | 3. Скин | 4. Номер тел.");
		SendClientMessage(playerid, -1, "5. Кол-во EXP | 6. VIP (1-3) | 7. Работа | 8. Деньги в банке.");
		SendClientMessage(playerid, -1, "9. Счёт мобильного | 10. Наличные | 11. Наркотики ");
		SendClientMessage(playerid, -1, "12. Машина | 13. Наркозависимость | 14. Проценты двиг.");
		SendClientMessage(playerid, -1, "Навыки: 15. Бокс | 16. Конг Фу | 17. Кик Бокс.");
		return true;
	}
	switch (params[1])
	{
		case 1:
		{
			PlayerInfo[params[0]][pLevel] = params[2];
			DollahScoreUpdate();
			format(req, sizeof(req), "Уровень игрока изменён: %d.", params[2]);
		}
		case 2:
		{
			PlayerInfo[params[0]][pMats] = params[2];
			format(req, sizeof(req), "Материалы: %d.", params[2]);
		}
		case 3:
		{
			PlayerInfo[params[0]][pChar] = params[2];
			format(req, sizeof(req), "Скин игрока установлен на: %d.", params[2]);
		}
		case 4:
		{
			PlayerInfo[params[0]][pPnumber] = params[2];
			format(req, sizeof(req), "Новый номер тел. игрока: %d.", params[2]);
		}
		case 5:
		{
			PlayerInfo[params[0]][pExp] = params[2];
			format(req, sizeof(req), "EXP игрока изменены на: %d.", params[2]);
		}
		case 6:
		{
			PlayerInfo[params[0]][pVIP] = params[2];
			format(req, sizeof(req), "VIP аккаунт уровня: %d.", params[2]);
		}
		case 7:
		{
			PlayerInfo[params[0]][pJob] = params[2];
			format(req, sizeof(req), "Работа: %d.", params[2]);
		}
		case 8:
		{
			PlayerInfo[params[0]][pBank] = params[2];
			format(req, sizeof(req), "Баланс в банке: %d рублей.", params[2]);
		}
		case 9:
		{
			PlayerInfo[params[0]][pMobile] = params[2];
			format(req, sizeof(req), "Баланс телефона: %d рублей.", params[2]);
		}
		case 10:
		{
			PlayerInfo[params[0]][pCash] = params[2];
			format(req, sizeof(req), "Наличные: %d рублей.", params[2]);
		}
		case 11:
		{
			PlayerInfo[params[0]][pDrugs] = params[2];
			format(req, sizeof(req), "Кол-во наркотиков: %d.", params[2]);
		}
		case 12:
		{
			PlayerInfo[params[0]][pCar] = params[2];
			//PlayerInfo[playerid][pProcent] = 100;
			//PlayerInfo[playerid][pPokraska] = 0;
			format(req, sizeof(req), "Текущая машина игрока: %d.", params[2]);
		}
		case 13:
		{
			PlayerInfo[params[0]][pNarcoZavisimost] = params[2];
			format(req, sizeof(req), "Наркозависимость: %d.", params[2]);
		}
		case 14:
		{
			//PlayerInfo[params[0]][pProcent] = params[2];
			//format(req, sizeof(req), "Состояник двигателя: %d.", params[2]);
		}
		case 15:
		{
			PlayerInfo[params[0]][pBoxSkill] = params[2];
			format(req, sizeof(req), "[Состояние] Бокс: %d.", params[2]);
		}
		case 16:
		{
			PlayerInfo[params[0]][pKongfuSkill] = params[2];
			format(req, sizeof(req), "[Состояние] Конг Фу: %d.", params[2]);
		}
		case 17:
		{
			PlayerInfo[params[0]][pKickboxSkill] = params[2];
			format(req, sizeof(req), "[Состояние] Кик Бокс: %d.", params[2]);
		}
		default:
		{
			format(req, sizeof(req), "[Ошибка]");
		}

	}
	SendClientMessage(playerid, 0xB4B5B7FF, req);
	if(Login[params[0]]) SaveAccount(playerid);
	return true;
}
cmd:makeadmin(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /makeadmin [id] [уровень]");
	if(params[1] > 6 || params[1] < 0) return SendClientMessage(playerid, 0xAFAFAFAA, "Нельзя меньше установить 1 или больше 6!");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(PlayerInfo[params[0]][pAdmin] == 0)
	{
	    format(req,sizeof(req),"Администратор %s: %s назначен на пост Администратора", GN(playerid),GN(params[0]));
	    ABroadCast(COLOR_LIGHTRED,req,5);
	    format(req, sizeof(req), "Вы были назначены администратором %s на %d уровень администрирования",GN(playerid), params[1]);
		SendClientMessage(params[0], 0x6495EDFF, req);
		SendClientMessage(params[0], -1, "Введите /alogin, чтобы установить пароль. Для просмотра команд, введите после авторизации /ahelp");
	    pdostup[params[0]] = 1;
	}
	if(PlayerInfo[params[0]][pAdmin] <= params[1] && PlayerInfo[params[0]][pAdmin] != 0)
	{
		format(req,sizeof(req),"Администратор %s: %s повышен до %d уровня Администратора", GN(playerid),GN(params[0]),params[1]);
	    ABroadCast(COLOR_LIGHTRED,req,5);
	}
	if(PlayerInfo[params[0]][pAdmin] > params[1] && params[1] != 0)
	{
		format(req,sizeof(req),"Администратор %s: %s понижен до %d уровня Администратора", GN(playerid),GN(params[0]),params[1]);
	    ABroadCast(COLOR_LIGHTRED,req,5);
	}
	if(params[1] == 0)
	{
	    format(req,sizeof(req),"Администратор %s: %s снят с поста Администратора", GN(playerid),GN(params[0]));
	    ABroadCast(COLOR_LIGHTRED,req,5);
	}
	dostup[params[0]] = false;
	PlayerInfo[params[0]][pAdmin] = params[1];
	return 1;
}
cmd:skey(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	if(keyses == 0)
	{
	    keyses = 1;
	    SendClientMessage(playerid, -1, "Клавиши включены");
	}
	else
	{
	    keyses = 0;
	    SendClientMessage(playerid, -1, "Клавиши выключены");
	}
	return 1;
}
cmd:askin(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
    if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /askin [id игрока/ник] [id скина]");
	if(params[1] > 311 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, "Неправильный ID скина!");
	format(req, sizeof(req), "Администратор %s выдал Вам постоянный скин", GN(playerid));
	SendClientMessage(params[0], 0x6495EDFF, req);
	format(req, sizeof(req), "Вы выдали игроку %s[%d] постоянный скин [%d]", GN(params[0]),params[0],params[1]);
	SendClientMessage(playerid, 0x6495EDFF, req);
	PlayerInfo[params[0]][pChar] = params[1];
	SetPlayerSkin(params[0], params[1]);
	return true;
}
cmd:tpcor(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "dddDD", params[0],params[1],params[2],params[3],params[4])) return SendClientMessage(playerid,-1,"Введите: /tpcor [x] [y] [z] [inter] [world]");
	SetPlayerPos(playerid,params[0],params[1],params[2]);
	SetPlayerInterior(playerid,params[3]);
	SetPlayerVirtualWorld(playerid,params[4]);
	return true;
}
cmd:int(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 || !dostup[playerid]) return 1;
	if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /int [1-135]");
	switch(params[0])
	{
	    case 1: SetPlayerPos(playerid,-25.884499,-185.868988,1003.549988), SetPlayerInterior(playerid,17);
		case 2: SetPlayerPos(playerid,6.091180,-29.271898,1003.549988), SetPlayerInterior(playerid,10);
		case 3: SetPlayerPos(playerid,-30.946699,-89.609596,1003.549988), SetPlayerInterior(playerid,18);
		case 4: SetPlayerPos(playerid,-25.132599,-139.066986,1003.549988), SetPlayerInterior(playerid,16);
		case 5: SetPlayerPos(playerid,-27.312300,-29.277599,1003.549988), SetPlayerInterior(playerid,4);
		case 6: SetPlayerPos(playerid,-26.691599,-55.714897,1003.549988), SetPlayerInterior(playerid,6);
		case 7: SetPlayerPos(playerid,-1827.147338,7.207418,1061.143554), SetPlayerInterior(playerid,14);
		case 8: SetPlayerPos(playerid,2.384830,33.103397,1199.849976), SetPlayerInterior(playerid,1);
		case 9: SetPlayerPos(playerid,315.856170,1024.496459,1949.797363), SetPlayerInterior(playerid,9);
		case 10: SetPlayerPos(playerid,286.148987,-40.644398,1001.569946), SetPlayerInterior(playerid,1);
		case 11: SetPlayerPos(playerid,286.800995,-82.547600,1001.539978), SetPlayerInterior(playerid,4);
		case 12: SetPlayerPos(playerid,296.919983,-108.071999,1001.569946), SetPlayerInterior(playerid,6);
		case 13: SetPlayerPos(playerid,314.820984,-141.431992,999.661987), SetPlayerInterior(playerid,7);
		case 14: SetPlayerPos(playerid,316.524994,-167.706985,999.661987), SetPlayerInterior(playerid,6);
		case 15: SetPlayerPos(playerid,302.292877,-143.139099,1004.062500), SetPlayerInterior(playerid,7);
		case 16: SetPlayerPos(playerid,235.508994,1189.169897,1080.339966), SetPlayerInterior(playerid,3);
		case 17: SetPlayerPos(playerid,225.756989,1240.000000,1082.149902), SetPlayerInterior(playerid,2);
		case 18: SetPlayerPos(playerid,223.043991,1289.259888,1082.199951), SetPlayerInterior(playerid,1);
		case 19: SetPlayerPos(playerid,225.630997,1022.479980,1084.069946), SetPlayerInterior(playerid,7);
		case 20: SetPlayerPos(playerid,295.138977,1474.469971,1080.519897), SetPlayerInterior(playerid,15);
		case 21: SetPlayerPos(playerid,328.493988,1480.589966,1084.449951), SetPlayerInterior(playerid,15);
		case 22: SetPlayerPos(playerid,385.803986,1471.769897,1080.209961), SetPlayerInterior(playerid,15);
		case 23: SetPlayerPos(playerid,375.971985,1417.269897,1081.409912), SetPlayerInterior(playerid,15);
		case 24: SetPlayerPos(playerid,490.810974,1401.489990,1080.339966), SetPlayerInterior(playerid,2);
		case 25: SetPlayerPos(playerid,447.734985,1400.439941,1084.339966), SetPlayerInterior(playerid,2);
		case 26: SetPlayerPos(playerid,227.722992,1114.389893,1081.189941), SetPlayerInterior(playerid,5);
		case 27: SetPlayerPos(playerid,260.983978,1286.549927,1080.299927), SetPlayerInterior(playerid,4);
		case 28: SetPlayerPos(playerid,221.666992,1143.389893,1082.679932), SetPlayerInterior(playerid,4);
		case 29: SetPlayerPos(playerid,27.132700,1341.149902,1084.449951), SetPlayerInterior(playerid,10);
		case 30: SetPlayerPos(playerid,-262.601990,1456.619995,1084.449951), SetPlayerInterior(playerid,4);
		case 31: SetPlayerPos(playerid,22.778299,1404.959961,1084.449951), SetPlayerInterior(playerid,5);
		case 32: SetPlayerPos(playerid,140.278000,1368.979980,1083.969971), SetPlayerInterior(playerid,5);
		case 33: SetPlayerPos(playerid,234.045990,1064.879883,1084.309937), SetPlayerInterior(playerid,6);
		case 34: SetPlayerPos(playerid,-68.294098,1353.469971,1080.279907), SetPlayerInterior(playerid,6);
		case 35: SetPlayerPos(playerid,-285.548981,1470.979980,1084.449951), SetPlayerInterior(playerid,15);
		case 36: SetPlayerPos(playerid,-42.581997,1408.109985,1084.449951), SetPlayerInterior(playerid,8);
		case 37: SetPlayerPos(playerid,83.345093,1324.439941,1083.889893), SetPlayerInterior(playerid,9);
		case 38: SetPlayerPos(playerid,260.941986,1238.509888,1084.259888), SetPlayerInterior(playerid,9);
		case 39: SetPlayerPos(playerid,1038.509888,-0.663752,1001.089966), SetPlayerInterior(playerid,3);
		case 40: SetPlayerPos(playerid,446.622986,509.318970,1001.419983), SetPlayerInterior(playerid,12);
		case 41: SetPlayerPos(playerid,2216.339844,-1150.509888,1025.799927), SetPlayerInterior(playerid,15);
		case 42: SetPlayerPos(playerid,833.818970,7.418000,1004.179993), SetPlayerInterior(playerid,3);
		case 43: SetPlayerPos(playerid,-100.325996,-22.816500,1000.741943), SetPlayerInterior(playerid,3);
		case 44: SetPlayerPos(playerid,964.376953,2157.329834,1011.019958), SetPlayerInterior(playerid,1);
		case 45: SetPlayerPos(playerid,-2239.569824,130.020996,1035.419922), SetPlayerInterior(playerid,6);
		case 46: SetPlayerPos(playerid,662.641601,-571.398803,16.343263), SetPlayerInterior(playerid,0);
		case 47: SetPlayerPos(playerid,614.581420,-23.066856,1004.781250), SetPlayerInterior(playerid,1);
		case 48: SetPlayerPos(playerid,612.508605,-129.236114,1001.992187), SetPlayerInterior(playerid,3);
		case 49: SetPlayerPos(playerid,-1786.603759,1215.553466,28.531250), SetPlayerInterior(playerid,0);
		case 50: SetPlayerPos(playerid,-2048.605957,162.093444,28.835937), SetPlayerInterior(playerid,1);
		case 51: SetPlayerPos(playerid,2170.284,1618.629,999.9766), SetPlayerInterior(playerid,1);
		case 52: SetPlayerPos(playerid,1889.975,1018.055,31.88281), SetPlayerInterior(playerid,10);
		case 53: SetPlayerPos(playerid,-2158.719971,641.287964,1052.369995), SetPlayerInterior(playerid,1);
		case 54: SetPlayerPos(playerid,1133.069946,-9.573059,1000.750000), SetPlayerInterior(playerid,12);
		case 55: SetPlayerPos(playerid,207.737991,-109.019997,1005.269958), SetPlayerInterior(playerid,15);
		case 56: SetPlayerPos(playerid,204.332993,-166.694992,1000.578979), SetPlayerInterior(playerid,14);
		case 57: SetPlayerPos(playerid,207.054993,-138.804993,1003.519958), SetPlayerInterior(playerid,3);
		case 58: SetPlayerPos(playerid,203.778000,-48.492397,1001.799988), SetPlayerInterior(playerid,1);
		case 59: SetPlayerPos(playerid,226.293991,-7.431530,1002.259949), SetPlayerInterior(playerid,5);
		case 60: SetPlayerPos(playerid,161.391006,-93.159156,1001.804687), SetPlayerInterior(playerid,18);
		case 61: SetPlayerPos(playerid,493.390991,-22.722799,1000.686951), SetPlayerInterior(playerid,17);
		case 62: SetPlayerPos(playerid,501.980988,-69.150200,998.834961), SetPlayerInterior(playerid,11);
		case 63: SetPlayerPos(playerid,-227.028000,1401.229980,27.769798), SetPlayerInterior(playerid,18);
		case 64: SetPlayerPos(playerid,460.099976,-88.428497,999.621948), SetPlayerInterior(playerid,4);
		case 65: SetPlayerPos(playerid,454.973950,-110.104996,999.717957), SetPlayerInterior(playerid,5);
		case 66: SetPlayerPos(playerid,452.489990,-18.179699,1001.179993), SetPlayerInterior(playerid,1);
		case 67: SetPlayerPos(playerid,681.474976,-451.150970,-25.616798), SetPlayerInterior(playerid,1);
		case 68: SetPlayerPos(playerid,366.923980,-72.929359,1001.507812), SetPlayerInterior(playerid,10);
		case 69: SetPlayerPos(playerid,365.672974,-10.713200,1001.869995), SetPlayerInterior(playerid,9);
		case 70: SetPlayerPos(playerid,372.351990,-131.650986,1001.449951), SetPlayerInterior(playerid,5);
		case 71: SetPlayerPos(playerid,377.098999,-192.439987,1000.643982), SetPlayerInterior(playerid,17);
		case 72: SetPlayerPos(playerid,244.411987,305.032990,999.231995), SetPlayerInterior(playerid,1);
		case 73: SetPlayerPos(playerid,271.884979,306.631989,999.325989), SetPlayerInterior(playerid,2);
		case 74: SetPlayerPos(playerid,291.282990,310.031982,999.154968), SetPlayerInterior(playerid,3);
		case 75: SetPlayerPos(playerid,302.181000,300.722992,999.231995), SetPlayerInterior(playerid,4);
		case 76: SetPlayerPos(playerid,322.197998,302.497986,999.231995), SetPlayerInterior(playerid,5);
		case 77: SetPlayerPos(playerid,346.870025,309.259033,999.155700), SetPlayerInterior(playerid,6);
		case 78: SetPlayerPos(playerid,-959.873962,1952.000000,9.044310), SetPlayerInterior(playerid,17);
		case 79: SetPlayerPos(playerid,388.871979,173.804993,1008.389954), SetPlayerInterior(playerid,3);
		case 80: SetPlayerPos(playerid,220.4109,1862.277,13.147), SetPlayerInterior(playerid,0);
		case 81: SetPlayerPos(playerid,772.112000,-3.898650,1000.687988), SetPlayerInterior(playerid,5);
		case 82: SetPlayerPos(playerid,774.213989,-48.924297,1000.687988), SetPlayerInterior(playerid,6);
		case 83: SetPlayerPos(playerid,773.579956,-77.096695,1000.687988), SetPlayerInterior(playerid,7);
		case 84: SetPlayerPos(playerid,1527.229980,-11.574499,1002.269958), SetPlayerInterior(playerid,3);
		case 85: SetPlayerPos(playerid,1523.509888,-47.821198,1002.269958), SetPlayerInterior(playerid,2);
		case 86: SetPlayerPos(playerid,2496.049805,-1693.929932,1014.750000), SetPlayerInterior(playerid,3);
		case 87: SetPlayerPos(playerid,1263.079956,-785.308960,1091.959961), SetPlayerInterior(playerid,5);
		case 88: SetPlayerPos(playerid,1291.725341,-788.319885,96.460937), SetPlayerInterior(playerid,0);
		case 89: SetPlayerPos(playerid,516.650,-18.611898,1001.459961), SetPlayerInterior(playerid,3);
		case 90: SetPlayerPos(playerid,2464.109863,-1698.659912,1013.509949), SetPlayerInterior(playerid,2);
		case 91: SetPlayerPos(playerid,2526.459961,-1679.089966,1015.500000), SetPlayerInterior(playerid,1);
		case 92: SetPlayerPos(playerid,2543.659912,-1303.629883,1025.069946), SetPlayerInterior(playerid,2);
		case 93: SetPlayerPos(playerid,1212.019897,-28.663099,1001.089966), SetPlayerInterior(playerid,3);
		case 94: SetPlayerPos(playerid,744.542969,1437.669922,1102.739990), SetPlayerInterior(playerid,6);
		case 95: SetPlayerPos(playerid,1204.809937,-11.586800,1001.089966), SetPlayerInterior(playerid,2);
		case 96: SetPlayerPos(playerid,1204.809937,13.586800,1001.089966), SetPlayerInterior(playerid,2);
		case 97: SetPlayerPos(playerid,940.921997,-17.007000,1001.179993), SetPlayerInterior(playerid,3);
		case 98: SetPlayerPos(playerid,964.106995,-53.205498,1001.179993), SetPlayerInterior(playerid,3);
		case 99: SetPlayerPos(playerid,-2661.009766,1415.739990,923.305969), SetPlayerInterior(playerid,3);
		case 100: SetPlayerPos(playerid,-2637.449951,1404.629883,906.457947), SetPlayerInterior(playerid,3);
		case 101: SetPlayerPos(playerid,-735.5619504,484.351318,1371.952270), SetPlayerInterior(playerid,1);
		case 102: SetPlayerPos(playerid,-794.8064,491.6866,1376.195), SetPlayerInterior(playerid,1);
		case 103: SetPlayerPos(playerid,-835.2504,500.9161,1358.305), SetPlayerInterior(playerid,1);
		case 104: SetPlayerPos(playerid,-813.431518,533.231079,1390.782958), SetPlayerInterior(playerid,1);
		case 105: SetPlayerPos(playerid,2350.339844,-1181.649902,1028.000000), SetPlayerInterior(playerid,5);
		case 106: SetPlayerPos(playerid,2807.619873,-1171.899902,1025.579956), SetPlayerInterior(playerid,8);
		case 107: SetPlayerPos(playerid,318.564972,1118.209961,1083.979980), SetPlayerInterior(playerid,5);
		case 108: SetPlayerPos(playerid,1412.639893,-1.787510,1000.931946), SetPlayerInterior(playerid,1);
		case 109: SetPlayerPos(playerid,1302.519897,-1.787510,1000.931946), SetPlayerInterior(playerid,18);
		case 110: SetPlayerPos(playerid,2522.0,-1673.383911,14.8), SetPlayerInterior(playerid,0);
		case 111: SetPlayerPos(playerid,-219.322601,1410.444824,27.773437), SetPlayerInterior(playerid,18);
		case 112: SetPlayerPos(playerid,2324.419922,-1147.539917,1050.719971), SetPlayerInterior(playerid,12);
		case 113: SetPlayerPos(playerid,-972.4957,1060.983,1358.914), SetPlayerInterior(playerid,10);
		case 114: SetPlayerPos(playerid,411.625977,-21.433298,1001.799988), SetPlayerInterior(playerid,2);
		case 115: SetPlayerPos(playerid,418.652985,-82.639793,1001.959961), SetPlayerInterior(playerid,3);
		case 116: SetPlayerPos(playerid,412.021973,-52.649899,1001.959961), SetPlayerInterior(playerid,12);
		case 117: SetPlayerPos(playerid,-204.439987,-26.453999,1002.299988), SetPlayerInterior(playerid,16);
		case 118: SetPlayerPos(playerid,-204.439987,-8.469600,1002.299988), SetPlayerInterior(playerid,17);
		case 119: SetPlayerPos(playerid,-204.439987,-43.652496,1002.299988), SetPlayerInterior(playerid,3);
		case 120: SetPlayerPos(playerid,246.783997,63.900200,1003.639954), SetPlayerInterior(playerid,6);
		case 121: SetPlayerPos(playerid,246.375992,109.245995,1003.279968), SetPlayerInterior(playerid,10);
		case 122: SetPlayerPos(playerid,288.745972,169.350998,1007.179993), SetPlayerInterior(playerid,3);
		case 123: SetPlayerPos(playerid,1494.429932,1305.629883,1093.289917), SetPlayerInterior(playerid,3);
		case 124: SetPlayerPos(playerid,-2029.719971,-115.067993,1035.169922), SetPlayerInterior(playerid,3);
		case 125: SetPlayerPos(playerid,420.484985,2535.589844,10.020289), SetPlayerInterior(playerid,10);
		case 126: SetPlayerPos(playerid,-2184.751464,2413.111816,5.156250), SetPlayerInterior(playerid,0);
		case 127: SetPlayerPos(playerid,-1397.782470,-203.723114,1051.346801), SetPlayerInterior(playerid,7);
		case 128: SetPlayerPos(playerid,-1398.103515,933.445434,1041.531250), SetPlayerInterior(playerid,15);
		case 129: SetPlayerPos(playerid,-1428.809448,-663.595886,1060.219848), SetPlayerInterior(playerid,4);
		case 130: SetPlayerPos(playerid,-1486.861816,1642.145996,1060.671875), SetPlayerInterior(playerid,14);
		case 131: SetPlayerPos(playerid,-1401.830000,107.051300,1032.273000), SetPlayerInterior(playerid,1);
		case 132: SetPlayerPos(playerid,1382.615600,2184.345703,11.023437), SetPlayerInterior(playerid,0);
		case 133: SetPlayerPos(playerid,297.9414,-64.3876,1001.5156), SetPlayerInterior(playerid,4);
		case 134: SetPlayerPos(playerid,302.1602,-164.7588,999.6105), SetPlayerInterior(playerid,6);
		case 135: SetPlayerPos(playerid,614.31,-125.22,997.99), SetPlayerInterior(playerid,3);
	}
	return 1;
}
cmd:payday(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	PayDay();
	return 1;
}
cmd:cmd(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	if(sscanf(params, "us[148]", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /cmd [id] [command]");
	format(req,sizeof(req),"%s",params[1]);
    OnPlayerCommandText(params[0], req);
	return 1;
}
cmd:houselist(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;

	return 1;
}
cmd:setpos(playerid, params[])
{
	new string[30];
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	if(sscanf(params, "ds[20]ddd", params[0],string,params[1],params[2],params[3])) return SendClientMessage(playerid, -1, "Введите: /setpos [id] [улица] [номер дома] [класс] [цена]");
	if(params[2] > 7 || params[2] < 1) return SendClientMessage(playerid, -1, "Неправильный ид класса(от 1 до 7)");
	new Float: lwx, Float:lwy, Float:lwz;
	GetPlayerPos(playerid, lwx, lwy, lwz);
	strmid(HouseInfo[params[0]][hStreet],string, 0, strlen(string), 30);
	strmid(HouseInfo[params[0]][hOwner],"None", 0, 5, 5);
	HouseInfo[params[0]][hNumber] = params[1];
	HouseInfo[params[0]][hID] = params[0];
	HouseInfo[params[0]][hEntrancex] = lwx;
	HouseInfo[params[0]][hEntrancey]= lwy;
	HouseInfo[params[0]][hEntrancez] = lwz;
	HouseInfo[params[0]][hClass] = params[2];
	HouseInfo[params[0]][hInt] = params[2];
	HouseInfo[params[0]][hPrice] = params[3];
 	new object = CreateObject(19175, lwx, lwy, lwz+2, 0.0,0.0,0.0);
    SetPVarInt(playerid, "SelectedHouse", object);
    SetPVarInt(playerid, "SelectedHouseid", params[0]);
    EditObject(playerid, object);
	return 1;
}// еще координаты выхода и машины, лейбла
cmd:setposcar(playerid, params[])
{
	new string[100];
	if(PlayerInfo[playerid][pAdmin] < 6 || !dostup[playerid]) return 1;
	if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /setposcar [id]");
	new Float:X,Float:Y,Float:Z,Float:Angle; GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
	HouseInfo[params[0]][hCarx] = X;
	HouseInfo[params[0]][hCary]= Y;
	HouseInfo[params[0]][hCarz] = Z;
	HouseInfo[params[0]][hCarc] = Angle;
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `houses` (`hID`,`hStreet`,`hNumber`,`hEntrancex`,`hEntrancey`,`hEntrancez`,`hLabelx`,`hLabely`,`hLabelz`,`hCarx`,`hCary`,`hCarz`,`hCarc`,`hOwner`,`hPrice`,`hClass`)");
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "%s VALUES ('%d','%s','%d', '%f','%f','%f','%f','%f','%f','%f','%f','%f','%f', '%s','%d','%d')",QUERY,HouseInfo[params[0]][hID],HouseInfo[params[0]][hStreet],HouseInfo[params[0]][hNumber],HouseInfo[params[0]][hEntrancex],HouseInfo[params[0]][hEntrancey],
	HouseInfo[params[0]][hEntrancez],HouseInfo[params[0]][hLabelx],HouseInfo[params[0]][hLabely],HouseInfo[params[0]][hLabelz],HouseInfo[params[0]][hCarx],HouseInfo[params[0]][hCary],HouseInfo[params[0]][hCarz],HouseInfo[params[0]][hCarc],HouseInfo[params[0]][hOwner],HouseInfo[params[0]][hPrice],HouseInfo[params[0]][hClass]);
	mysql_tquery(MySql_Base,QUERY,"","");
	format(string,sizeof(string),"Дом создан [ id:%d, улица:%s, номер дома:%d, класс:%d, цена:%d ]",HouseInfo[params[0]][hID],HouseInfo[params[0]][hStreet],HouseInfo[params[0]][hNumber],HouseInfo[params[0]][hClass],HouseInfo[params[0]][hPrice]);
	SendClientMessage(playerid, COLOR_GREY, string);
	return 1;
}
/*else if(strcmp(cmd, "/setklass", true) == 0)
{
	if(PlayerInfo[playerid][pAdmin] >= 6)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid, -1, "Введите: /setklass [квартира] [класс]");
		new house = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return	SendClientMessage(playerid, -1, "Введите: /setklass [квартира] [класс]");
		new klass;
		klass = strval(tmp);
		if(!strlen(tmp)) return SendClientMessage(playerid, -1, "Введите: /setklass [квартира] [класс]");
		HouseInfo[house][hClass] = klass;
		SendClientMessage(playerid, -1, "Класс установлен");
	}
	return 1;
}
else if(strcmp(cmd, "/getschet", true) == 0)
{
	if(PlayerInfo[playerid][pAdmin] >= 6)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return	SendClientMessage(playerid, -1, "Введите: /getschet [квартира]");
		new house = strval(tmp);
		format(string, sizeof(string), "Счёт домашний: %d",HouseInfo[house][hCheck]);
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}
else if(strcmp(cmd, "/setschet", true) == 0)
{
	if(PlayerInfo[playerid][pAdmin] >= 6)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return	SendClientMessage(playerid, -1, "Введите: /setchet [квартира] [cчет дома]");
		new house = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return		SendClientMessage(playerid, -1, "Введите: /setchet [квартира] [счет дома]");
		new cena;
		cena = strval(tmp);
		if(!strlen(tmp)) return SendClientMessage(playerid, -1, "Введите: /setchet [квартира] [счет дома]");
		HouseInfo[house][hCheck] = cena;
		SendClientMessage(playerid, -1, "Счет дома установлен");
	}
	return 1;
}
else if(strcmp(cmd, "/sethousemats", true) == 0)
{
	if(PlayerInfo[playerid][pAdmin] >= 6)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return	SendClientMessage(playerid, -1, "Введите: /sethousemats [квартира] [маты]");
		new house = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return		SendClientMessage(playerid, -1, "Введите: /sethousemats [квартира] [маты дома]");
		new cena;
		cena = strval(tmp);
		if(!strlen(tmp))return SendClientMessage(playerid, -1, "Введите: /sethousemats [квартира] [маты дома]");
		HouseInfo[house][hMats] = cena;
		SendClientMessage(playerid, -1, "Маты дома установлены");
	}
	return 1;
}
else if(strcmp(cmd, "/setcena", true) == 0)
{
	if(PlayerInfo[playerid][pAdmin] >= 6)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))return SendClientMessage(playerid, -1, "Введите: /setcena [квартира] [цена]");
		new house = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return	SendClientMessage(playerid, -1, "Введите: /setcena [квартира] [цена]");
		new cena;
		cena = strval(tmp);
		if(!strlen(tmp)) return	SendClientMessage(playerid, -1, "Введите: /setcena [квартира] [цена]");
		HouseInfo[house][hValue] = cena;
		SendClientMessage(playerid, -1, "Цена установлена");
	}
	return 1;
}
*/
// ========== [ Фракционные ] ==========
cmd:offlist(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3 && dostup[playerid])
	{
	    if(sscanf(params, "dd", params[0],params[1])) return SendClientMessage(playerid,-1,"Введите: /offlist [id фракции] [страница] для листания списка");
		offlist[playerid] = params[1];
		mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Member` = '%d'",params[0]);
		mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",11,playerid,"");
	}
	if(PlayerInfo[playerid][pLeader] >= 1 && PlayerInfo[playerid][pAdmin] == 0)
	{
	    if(sscanf(params, "d", params[0])) SendClientMessage(playerid,-1,"Введите: /offlist [страница] для листания списка");
		offlist[playerid] = params[0];
		mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Member` = '%d'",PlayerInfo[playerid][pMember]);
		mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",10,playerid,"");
	}
    return 1;
}
cmd:invite(playerid, params[])
{
	if(PlayerInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, "Вы нигде не состоите");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /invite [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, "Игрок в машине!");
	if(PlayerInfo[params[0]][pMember] != 0) return SendClientMessage(playerid, COLOR_GREY, "Игрок уже где то состоит");
	if(PlayerInfo[params[0]][pWarns] >= 1) return SendClientMessage(playerid, COLOR_GREY,"У игрока Warn.");
	if(!ProxDetectorS(15.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY,"[Ошибка] Игрок далеко.");
	if(SetInvite(PlayerInfo[playerid][pMember], PlayerInfo[playerid][pRank])) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете принимать во фракцию!");
	if(PlayerInfo[playerid][pMember] == 2 || PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pMember] == 9 || PlayerInfo[playerid][pMember] == 20) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете принимать во фракцию!");
	if(PlayerInfo[params[0]][pLevel] < 3) return SendClientMessage(playerid, COLOR_GREY, "Приём возможен с 3-го уровня");
	InviteOffer[params[0]] = PlayerInfo[playerid][pMember];
	switch(PlayerInfo[playerid][pMember])
	{
	    case 3,19,21: InviteSkin[params[0]] = 287;
	    case 4,22: InviteSkin[params[0]] = 70;
	    case 5:InviteSkin[params[0]] = 223;
	    case 6:InviteSkin[params[0]] = 120;
	    case 7:InviteSkin[params[0]] = 57;
	    case 8:InviteSkin[params[0]] = 171;
	    case 9,16,20:InviteSkin[params[0]] = 250;
	    case 11:InviteSkin[params[0]] = 59;
	    case 12:InviteSkin[params[0]] = 102;
	    case 13:InviteSkin[params[0]] = 108;
	    case 14:InviteSkin[params[0]] = 111;
	    case 15:InviteSkin[params[0]] = 106;
	    case 17:InviteSkin[params[0]] = 115;
	    case 18:InviteSkin[params[0]] = 174;
	}
	format(req, sizeof(req), "Вы пригласили %s вступить в организацию.",GN(params[0]));
	SendClientMessage(playerid, 0x6495EDFF, req);
	format(req,sizeof(req), "%s приглашает Вас присоедениться к %s\n- Вы согласны?",GN(playerid),GetFrac(PlayerInfo[playerid][pMember]));
	SPD(params[0],33,DIALOG_STYLE_MSGBOX,"Приглашение",req, "Да", "Нет");
	RangLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),1,PlayerInfo[playerid][pMember],"-","0->1");
	return true;
}
cmd:giverank(playerid, params[])
{
    if(PlayerInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, "Вы нигде не состоите");
	if(sscanf(params, "uds[30]", params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: /giverank [id] [+|-] [причина]");
  	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
  	if(SetInvite(PlayerInfo[playerid][pMember], PlayerInfo[playerid][pRank] + 1)) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете повышать/понижать!");
	if(PlayerInfo[playerid][pMember] != PlayerInfo[params[0]][pMember]) return SendClientMessage(playerid, COLOR_GREY, "Данный игрок не в вашей фракции!");
	if(params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Вы указали свой ID");
	if(PlayerInfo[params[0]][pLeader] >= 1) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Вы указали ID лидера");
	if(PlayerInfo[playerid][pRank] <= PlayerInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Вы не можете повысить/понизить этого игрока");
	if(strcmp(params[1], "+", false) == 0)
	{
	    if(SetRank(PlayerInfo[params[0]][pRank]+1,PlayerInfo[params[0]][pMember]) || PlayerInfo[playerid][pRank] <= PlayerInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Вы не можете повысить этого игрока");
		PlayerInfo[params[0]][pRank]++;
		format(req, sizeof(req), "Вы были повышены до %d ранга %s. Причина: %s",PlayerInfo[params[0]][pRank],GN(playerid),params[2]);
		SendClientMessage(params[0], 0x6495EDFF, req);
		format(req, sizeof(req), "Вы повысили %s до %d ранга. Причина: %s",GN(params[0]),PlayerInfo[params[0]][pRank],params[2]);
		SendClientMessage(playerid, 0x6495EDFF, req);
		format(req,sizeof(req),"<AB> %s повысил %s до %d(%s). Причина: %s", GN(playerid),GN(params[0]),PlayerInfo[params[0]][pRank],GetFrac(PlayerInfo[params[0]][pMember]),params[2]);
	    ABroadCast(0xFFFF00AA,req,1);
	    format(req,sizeof(req),"%d->%d",PlayerInfo[params[0]][pRank]-1,PlayerInfo[params[0]][pRank]);
	    RangLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),2,PlayerInfo[playerid][pMember],params[2],req);

	}
	else if(strcmp(params[1], "-", false) == 0)
	{
	    if(SetRank(PlayerInfo[params[0]][pRank]-1,PlayerInfo[params[0]][pMember]) || PlayerInfo[playerid][pRank] <= PlayerInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Вы не можете понизить этого игрока");
		PlayerInfo[params[0]][pRank]--;
		format(req, sizeof(req), "Вы были понижены до %d ранга %s. Причина: %s",PlayerInfo[params[0]][pRank],GN(playerid),params[2]);
		SendClientMessage(params[0], 0x6495EDFF, req);
		format(req, sizeof(req), "Вы понизили %s до %d ранга. Причина: %s",GN(params[0]),PlayerInfo[params[0]][pRank],params[2]);
		SendClientMessage(playerid, 0x6495EDFF, req);
		format(req,sizeof(req),"<AB> %s понизил %s до %d(%s). Причина: %s", GN(playerid),GN(params[0]),PlayerInfo[params[0]][pRank],GetFrac(PlayerInfo[params[0]][pMember]),params[2]);
	    ABroadCast(0xFFFF00AA,req,1);
	    format(req,sizeof(req),"%d->%d",PlayerInfo[params[0]][pRank]+1,PlayerInfo[params[0]][pRank]);
	    RangLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[params[0]][pID],GN(params[0]),PlayerInfo[playerid][pMember],2,params[2],req);

	}
	else return 1;
	return 1;
}
cmd:uninvite(playerid, params[])
{
    if(PlayerInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, "Вы нигде не состоите");
    new string[200];
    if(sscanf(params, "s[26]", params[0])) return SendClientMessage(playerid, -1, "Введите: /uninvite [точное имя]");
	new giveplayerid = -1;
	foreach(new i : Player)
	{
	    if(!strcmp(GN(i), params[0], false))
	    {
	        giveplayerid = i;
	        break;
	    }
	}
	if(SetInvite(PlayerInfo[playerid][pMember], PlayerInfo[playerid][pRank] + 1)) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете увольнять!");
	if (!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
    if(giveplayerid == -1) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Игрок не найден");
    if(giveplayerid == playerid) return SendClientMessage(playerid, COLOR_GREY, "Вы указали свой ID");
	if(PlayerInfo[giveplayerid][pLeader] >= 1) return SendClientMessage(playerid, COLOR_GREY, "Вы указали ID лидера");
	if(PlayerInfo[playerid][pMember] != PlayerInfo[giveplayerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, "Человек не состоит в вашей фракции");
	format(string,sizeof(string),"Вы собираетесь уволить: %s\nИз организации: %s\nВведите причину увольнения(будет видно администрации)",GN(giveplayerid),GetFrac(PlayerInfo[playerid][pMember]));
	SPD(playerid,34,DIALOG_STYLE_INPUT,"Увольнение",string,"Далее","Назад");
	InviteOffer[playerid] = giveplayerid;
	return 1;
}
cmd:members(playerid)
{
    if(PlayerInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, "Вы нигде не состоите");
    new teamnumber,null;
	if (PlayerInfo[playerid][pLeader] != 0) teamnumber = PlayerInfo[playerid][pLeader];
	else if (PlayerInfo[playerid][pMember] != 0) teamnumber = PlayerInfo[playerid][pMember];
	else return SendClientMessage(playerid, 0xB4B5B7FF, "Вы ни где не состоите!");
	SendClientMessage(playerid, 0x6495EDFF, "Текущий состав организации (( онлайн )):");
	foreach(new i : Player)
	{
		if (IsPlayerConnected(i))
		{
			format(req, sizeof(req), "");
			if (PlayerInfo[i][pLeader] == teamnumber) format(req, sizeof(req), "%s (( ранг: Лидер, id: %d ))",GN(i),i);
			else if (PlayerInfo[i][pMember] == teamnumber) format(req, sizeof(req), "%s (( ранг: %d, id: %d ))",GN(i),PlayerInfo[i][pRank],i);
			if (strlen(req) > 1) SendClientMessage(playerid, 0xF5DEB3AA, req);
			null++;
		}
	}
	format(req,sizeof(req),"{F5DEB3}Всего в организации:{81F781} %d{F5DEB3} человек",null);
	if(PlayerInfo[playerid][pLeader] >= 1) return SendClientMessage(playerid, -1, req);
	return true;
}
cmd:r(playerid, params[])
{
    if(PlayerInfo[playerid][pMember] == 0 && (PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid])) return SendClientMessage(playerid, COLOR_GREY, "Вы нигде не состоите");
	if(PlayerInfo[playerid][pAdmin] < 3 && sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /r [текст]");
	if(PlayerInfo[playerid][pAdmin] >= 3 && sscanf(params, "ds[128]",params[0], params[1])) return SendClientMessage(playerid, -1, "Введите: /r [id фракции] [текст]");
    if(IsMute(playerid)) return 1;
	if(gag[playerid] == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "У Вас кляп, вы не можете говорить!");
	switch(PlayerInfo[playerid][pMember])
	{
	    case 1..4,7,10,19,21,22:
		{
		    if(PlayerInfo[playerid][pAdmin] < 3) format(req, sizeof(req), "[R] %s %s: %s",GetRank(playerid) , GN(playerid), params[0]),SendRadioMessage(PlayerInfo[playerid][pMember], 0x8D8DFF00, req);
		    if(PlayerInfo[playerid][pAdmin] >= 3 && dostup[playerid]) format(req, sizeof(req), "[R] %s %s: %s",GetRank(playerid) , GN(playerid), params[1]), SendRadioMessage(params[0], 0x8D8DFF00, req);
			SetPlayerChatBubble(playerid,"передал(a) сообщение по рации",0xC2A2DAAA,30.0,10000);
			return 1;
		}
		default: if((PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid])) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете пользоваться рацией!");
	}
	if(PlayerInfo[playerid][pJob] == 2)
	{
		format(req, sizeof(req), "[R] Таксист %s: %s", GN(playerid), params[0]);
		SendJobMessage(4, 0x8D8DFF00, req);
		SetPlayerChatBubble(playerid,"передал(a) сообщение по рации",0xC2A2DAAA,30.0,10000);
		return 1;
	}
	return 1;
}
cmd:d(playerid, params[])
{
	if(PlayerInfo[playerid][pMember] == 0 && (PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid])) return  SendClientMessage(playerid, 0xBFC0C2FF, "Вы не состоите в государственой какой-либо фракции!");
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /d [текст]");
	if(IsMute(playerid)) return 1;
	if(gag[playerid] == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "У Вас кляп, вы не можете говорить!");
	if(PlayerInfo[playerid][pAdmin] == 0)
	{
		switch(PlayerInfo[playerid][pMember])
		{
		    case 1..4,7,8,19,21,22:
			{
			    if(dchat > gettime()) return SendClientMessage(playerid, 0xBFC0C2FF, "Сообщение можно отправить раз в 20 секунд!");
				dchat = gettime() + 20;
				format(req, sizeof(req), "[%s] %s %s: %s",GetFrac(PlayerInfo[playerid][pMember]),GetRank(playerid) , GN(playerid), params[0]);
			    SendTeamMessage(0xFF8282AA, req);
				SetPlayerChatBubble(playerid,"сообщает в департамент",0xC2A2DAAA,30.0,10000);
			}
			default: if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете пользоваться департаментом!");
		}
	}
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		format(req, sizeof(req), "[] %s: %s", GN(playerid), params[0]);
	    SendTeamMessage(0xFF8282AA, req);
	}
	return 1;
}
cmd:gov(playerid, params[])
{
	if(IsAArm(playerid) || IsAMayor(playerid) || IsAMedic(playerid) || IsACop(playerid))
	{
		if(PlayerInfo[playerid][pLevel] < 12) return SendClientMessage(playerid, COLOR_GREY, "Вы не достигли 12 лет в регионе!");
		if(SetInvite(PlayerInfo[playerid][pMember], PlayerInfo[playerid][pRank] +1)) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете принимать во фракцию!");
		if(IsMute(playerid)) return 1;
		if(IsIP(params) || CheckString(params))
		{
			new ip[15];
			PlayerInfo[playerid][pMute] = 10800;
			GetPlayerIp(playerid,ip,sizeof(ip));
			format(req, sizeof(req), "%s[%d]: %s ",GN(playerid),playerid,params);
			ABroadCast(COLOR_LIGHTRED,req,1);
			format(req,sizeof(req),"Вы получили молчанку на 3 часа /mm - репорт");
			SendClientMessage(playerid, COLOR_LIGHTRED, req);
			return true;
		}
		if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: (/gov)ernment [текст]");
		switch(PlayerInfo[playerid][pMember])
		{
		    case 1,10,21,2,3,7,19,4,22:
		    {
		        if(GetPVarInt(playerid, "GovTimer") > gettime())
				{
				 	format(req, sizeof(req), "%s %s: %s", GetRank(playerid), GN(playerid), params[0]);
					SendClientMessageToAll(0x6495EDFF, req);
					return true;
				}
		        else if(SetPVarInt(playerid, "GovTimer", gettime() + 10))
		        {
		            SendClientMessageToAll(-1, "---========== Государственные Новости ==========---");
		            format(req, sizeof(req), "%s %s: %s", GetRank(playerid), GN(playerid), params[0]);
					SendClientMessageToAll(0x6495EDFF, req);
					return true;
    			}
		    }
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY,"Вы не член департамента!");
	return true;
}
alias:gov("government");
cmd:f(playerid, params[])
{
	if(PlayerInfo[playerid][pMember] == 0 && (PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid])) return SendClientMessage(playerid, COLOR_GREY, "Вы нигде не состоите");
	if(PlayerInfo[playerid][pAdmin] < 3 && sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /f [текст]");
	if(PlayerInfo[playerid][pAdmin] >= 3 && sscanf(params, "ds[128]",params[0], params[1])) return SendClientMessage(playerid, -1, "Введите: /f [id фракции] [текст]");
 	if(IsMute(playerid)) return 1;
	if(gag[playerid] == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "У Вас кляп, вы не можете говорить!");
	switch(PlayerInfo[playerid][pMember])
	{
		case 5,6,8,9,11..18,20:
		{
		    if(PlayerInfo[playerid][pAdmin] < 3) format(req, sizeof(req), "[F] %s %s: %s",GetRank(playerid) , GN(playerid), params[0]),SendRadioMessage(PlayerInfo[playerid][pMember], 0x8D8DFF00, req);
		    if(PlayerInfo[playerid][pAdmin] >= 3 && dostup[playerid]) format(req, sizeof(req), "[F] %s %s: %s",GetRank(playerid) , GN(playerid), params[1]), SendRadioMessage(params[0], 0x8D8DFF00, req);
			return 1;
		}
		default: if(PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid]) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете пользоваться даной командой!");
	}
	return 1;
}
// ========== [ Гос. работы ] ==========
cmd:fare(playerid, params[])
{
	new Veh = GetPlayerVehicleID(playerid);
	if(PlayerInfo[playerid][pJob] != 2) return SendClientMessage(playerid, COLOR_GREY, "Вы не таксист / не в машине!");
	if(TransportDuty[playerid] > 0)
	{
		Delete3DTextLabel(taxi3d[playerid]);
		TransportDuty[playerid] = 0;
		format(req, sizeof(req), "Вы закончили рабочий день и заработали: %d", TransportMoney[playerid]);
		SendClientMessage(playerid, 0x6495EDFF, req);
		PlayerInfo[playerid][pPayCheck]+= TransportMoney[playerid];
		TransportValue[playerid] = 0; TransportMoney[playerid] = 0;
		return true;
	}
	if(Veh >= taxicar[0] && Veh <= taxicar[30])
	{
		if(GetPlayerState(playerid) == 2)
		{
			if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /fare [цена проезда]");
			if(params[0] < 1 || params[0] > 10) return SendClientMessage(playerid, COLOR_GREY, "Цена возможна от 1 рублей до 10 рублей.");
			Delete3DTextLabel(taxi3d[playerid]);
			TransportDuty[playerid] = 1;
			TransportValue[playerid] = params[0];
			format(req, sizeof(req), "<< Тариф: %d рублей >>\nВновь прибывшим бесплатно", TransportValue[playerid]);
			taxi3d[playerid] = Create3DTextLabel(req, 0xFFFF00AA, 9999.0, 9999.0, 9999.0, 50.0, 0, 1);
			Attach3DTextLabelToVehicle(taxi3d[playerid], GetPlayerVehicleID(playerid), 0, 0, 1.3);
		}
		else return SendClientMessage(playerid, COLOR_GREY, "Вы не таксист / не в машине!");
	}
	return true;
}
// ========== [ Медики ] ==========
cmd:heal(playerid, params[])
{
	if(PlayerInfo[playerid][pMember] != 4 && PlayerInfo[playerid][pMember] != 22 ) return SendClientMessage(playerid, -1, "Вы не сотрудник МЧС!");
	if(PlayerInfo[playerid][pRank] < 2) return SendClientMessage(playerid, -1, "Вы не обладаете достаточной квалификацией!");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /heal [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	new Float:tempheal;
	GetPlayerHealth(params[0],tempheal);
	new giveambu = GetPlayerVehicleID(params[0]);
	new playambu = GetPlayerVehicleID(playerid);
	if (!((playambu >= medicssf[0] && playambu <= medicssf[7] || playambu >= medicsls[0] && playambu <= medicsls[6]) && playambu == giveambu || PlayerToPoint(20.0,playerid,187.3170,37.8714,1103.2751))) return SendClientMessage(playerid, COLOR_GREY, "Вы не в палате интенсивной терапии/машине скорой помощи");
	if(!ProxDetectorS(30.0, playerid, params[0]) && !PlayerToPoint(24.0,playerid,187.3170,37.8714,1103.2751)) return SendClientMessage(playerid, COLOR_GREY, "Человек далеко");
	if(tempheal >= 100.0) return SendClientMessage(playerid, 0xB4B5B7FF,"Этот человек здоров!");
	HealPrice[params[0]] =  FracBank[0][fMCprice] / 100 * floatround((100.0-tempheal));
	if(params[0] == playerid) return	SendClientMessage(playerid, COLOR_GREY, "Вы не можете вылечить себя!");
	format(req, sizeof(req), "Вы предложили вылечить %s за %d рублей.",GN(params[0]),HealPrice[params[0]]);
	SendClientMessage(playerid, 0x6495EDFF, req);
	format(req,sizeof(req), "Желаете вылечиться за %d$?",HealPrice[params[0]]);
	SPD(params[0],64,DIALOG_STYLE_MSGBOX,"Лечение", req, "Да", "Нет");
	HealOffer[params[0]] = playerid;
	return true;
}
cmd:lomka(playerid, params[])
{
    new string[250];
	if(PlayerInfo[playerid][pMember] != 4 && PlayerInfo[playerid][pMember] != 22 && (PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid])) return SendClientMessage(playerid, -1, "Вы не сотрудник МЧС!");
	if(PlayerInfo[playerid][pAdmin] >= 3 && dostup[playerid])
	{
	 	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /lomka [id]");
		format(req, sizeof(req), "%s снял(а) ломку у %s",GN(playerid) ,GN(params[0]));
		ProxDetector(2,30.0, params[0], req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		SetPlayerWeather(params[0],weather);
		startnarko[params[0]] = 0;
		send[params[0]] = 0;
		ApplyAnimation(params[0],"CARRY","crry_prtial",4.0,0,0,0,0,0,1);
	}
	if(PlayerInfo[playerid][pRank] < 3) return SendClientMessage(playerid, -1, "Вы не обладаете достаточной квалификацией!");
	if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /lomka [id] [цена]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не найден!");
	if(params[0] == playerid)  return  SendClientMessage(playerid,0xB4B5B7FF,"[Ошибка] Вы указали свой ID");
	if(50 > params[1] > 500) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя установить цену меньше 50 и больше 500");
	if(PlayerInfo[params[0]][pCash] < params[1]) return SendClientMessage(playerid, -1, "У человека недостаточно средств");
	format(req, sizeof(req), "Вы предложили %s снять ломку за %d рублей. Ожидайте ответа",GN(params[0]),params[1]);
	SendClientMessage(playerid, 0x6495EDFF, req);
	format(string,sizeof(string), "{FFFFFF}---Министерство здравохранения---\nВид услуги:{DAA520} снятие абстинентного синдрома\n{FFFFFF}Медицинский сотрудник:{DAA520} %s\n{FFFFFF}Стоимость:{81F781} %d{FFFFFF} руб.\n\nВы хотите оплатить услуги?",GN(playerid),params[1]);
	SPD(params[0],65,DIALOG_STYLE_MSGBOX,"{FFFFFF}==[Счёт на мед. услуги]==", string, "Да", "Нет");
	LomkaOffer[params[0]] = playerid;
	LomkaPrice[params[0]] = params[1];
	return 1;
}
cmd:narkozav(playerid, params[])
{
    new string[250];
	if(PlayerInfo[playerid][pMember] != 4 && PlayerInfo[playerid][pMember] != 22) return SendClientMessage(playerid, -1, "Вы не сотрудник МЧС!");
	if(PlayerInfo[playerid][pRank] < 4) return SendClientMessage(playerid, -1, "Вы не обладаете достаточной квалификацией!");
	if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /narkozav [id] [цена]");
	if(500 > params[1] > 3000) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя установить цену меньше 500 и больше 3000");
	if(!PlayerToPoint(30.0,playerid,187.3170,37.8714,1103.2751)) return SendClientMessage(playerid, COLOR_GREY, "Вы не в палате интенсивной терапии/машине скорой помощи");
	if(seans[params[0]] == 1) return SendClientMessage(playerid,0x33AA33AA,"Следущий сеанс можно провести через час");
	if(PlayerInfo[params[0]][pNarcoZavisimost] <=100)  return  SendClientMessage(playerid,0x33AA33AA,"У пациенат нет зависимости");
	if(params[0] == playerid)  return  SendClientMessage(playerid,0xB4B5B7FF,"[Ошибка] Вы указали свой ID");
	if(PlayerInfo[params[0]][pCash] < params[1]) return SendClientMessage(playerid, -1, "У человека недостаточно средств");
	format(string, sizeof(string), "Вы предложили %s провести за %d рублей. Ожидайте ответа",GN(params[0]),params[1]);
	SendClientMessage(playerid, 0x6495EDFF, string);
	format(string,sizeof(string), "{FFFFFF}---Министерство здравохранения---\nВид услуги:{DAA520} сеанс против наркотической зависимости\n{FFFFFF}Медицинский сотрудник:{DAA520} %s\n{FFFFFF}Стоимость:{81F781} %d{FFFFFF} руб.\n\nВы хотите оплатить услуги?",GN(playerid),params[1]);
	SPD(params[0],66,DIALOG_STYLE_MSGBOX,"{FFFFFF}==[Счёт на мед. услуги]==", string, "Да", "Нет");
	NarkSeansOffer[params[0]] = playerid;
	NarkSeansPrice[params[0]] = params[1];
	return 1;
}
cmd:sethpprice(playerid, params[])
{
    new string[150];
	if(PlayerInfo[playerid][pLeader] != 4  && PlayerInfo[playerid][pLeader] != 22 && PlayerInfo[playerid][pAdmin] < 5) return 1;
	if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /sethpprice [сумма]");
	if((params[0] < 1 || params[0] > 10)) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете поставить меньше 0 и больше 10");
	FracBank[0][fMCprice] = params[0]*100;
	if(PlayerInfo[playerid][pLeader] == 4)
	{
		SendClientMessageToAll(-1, "---========== Государственные Новости==========---");
		format(string, sizeof(string), "Цена лечения, в размере %d рублей. установлена Главврачом больницы г.Сан-Фиерро: %s.", FracBank[0][fMCprice],GN(playerid));
		SendClientMessageToAll(0xA52A2AFF, string);
		return 1;
	}
	if(PlayerInfo[playerid][pLeader] == 21)
	{
		SendClientMessageToAll(-1, "---========== Государственные Новости==========---");
		format(string, sizeof(string), "Цена лечения, в размере %d рублей. установлена Главврачом больницы г.Лос-Сантос: %s.", FracBank[0][fMCprice],GN(playerid));
		SendClientMessageToAll(0xA52A2AFF, string);
		return 1;
	}
	return 1;
}
cmd:medbank(playerid)
{
    if(PlayerInfo[playerid][pMember] == 4) format(req, sizeof(req), "В банке больницы Сан Фиерро %d рублей",FracBank[0][fMCSF]);
    else if(PlayerInfo[playerid][pMember] == 22) format(req, sizeof(req), "В банке больницы Лос Сантос %d рублей",FracBank[0][fMCLS]);
	SendClientMessage(playerid, -1, req);
    return 1;
}
cmd:medwithdraw(playerid, params[])
{
    if(PlayerInfo[playerid][pLeader] != 4 && PlayerInfo[playerid][pLeader] != 22) return 1;
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /medwithdraw [сумма]");
    if(PlayerInfo[playerid][pLeader] == 4)
	{
	    if(params[0] > FracBank[0][fMCSF]) return SendClientMessage(playerid, -1, "В банке нет столько денег");
		format(req, sizeof(req), "Вы сняли с банка больницы Сан Фиерро %d рублей",params[0]);
		SendClientMessage(playerid, -1, req);
		FracBank[0][fMCSF] -= params[0];
		PlayerInfo[playerid][pCash] += params[0];
		CashLog(-1,"MC SF",PlayerInfo[playerid][pID],GN(playerid),2,params[0]);
		return 1;
	}
    if(PlayerInfo[playerid][pLeader] == 22)
	{
	    if(params[0] > FracBank[0][fMCLS]) return SendClientMessage(playerid, -1, "В банке нет столько денег");
		format(req, sizeof(req), "Вы сняли с банка больницы Сан Фиерро %d рублей",params[0]);
		SendClientMessage(playerid, -1, req);
		FracBank[0][fMCLS] -= params[0];
		PlayerInfo[playerid][pCash] += params[0];
		CashLog(-1,"MC LS",PlayerInfo[playerid][pID],GN(playerid),2,params[0]);
		return 1;
	}
    return 1;
}
// ========== [ Полицейские ] ==========
cmd:m(playerid, params[])
{
	if (PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pMember] == 2 || PlayerInfo[playerid][pMember] == 3 || PlayerInfo[playerid][pMember] == 18 || PlayerInfo[playerid][pMember] == 20  || PlayerInfo[playerid][pMember] == 9 || PlayerInfo[playerid][pMember] == 3)
	{
	    if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: (/m)egaphone [текст]");
		new car = GetVehicleModel(GetPlayerVehicleID(playerid));
		switch(PlayerInfo[playerid][pMember])
		{
			case 1,20,21:
			{
				if(car != 596 && car != 490 && car != 597 && car != 598 && car != 427 && car != 497 && car != 523 && car != 599 && car != 601) return SendClientMessage(playerid, 0xBFC0C2FF, "Вы не в служебной машине");
				format(req, sizeof(req), "СГУ: Полицейский %s: %s", GN(playerid), params[0]);
				ProxDetector(3,80.0, playerid, req,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA);
			}
			case 2:
			{
				if(car != 596 && car != 490 && car != 597 && car != 598 && car != 427 && car != 497 && car != 523 && car != 599 && car != 601) return SendClientMessage(playerid, 0xBFC0C2FF, "Вы не в служебной машине");
				format(req, sizeof(req), "СГУ: Агент FBI %s: %s", GN(playerid), params[0]);
				ProxDetector(3,80.0, playerid, req,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA);
			}
			case 3,19:
			{
				if(car != 470) return SendClientMessage(playerid, 0xBFC0C2FF, "Вы не в служебной машине");
				format(req, sizeof(req), "СГУ: %s: %s", GN(playerid), params[0]);
				ProxDetector(3,80.0, playerid, req,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA,0xFFFF00AA);
			}
		}
	}
	else SendClientMessage(playerid, 0xBFC0C2FF, "Вы не состоите в силовых структурах");
	return 1;
}
alias:m("megaphone");
cmd:tazer(playerid, params[])
{
	if(!(IsACop(playerid) || PlayerInfo[playerid][pRank] < 2)  && !(PlayerInfo[playerid][pMember] == 7 && PlayerInfo[playerid][pRank] == 3)) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в силовых структурах!");
	if(IsPlayerInAnyVehicle(playerid)) return     SendClientMessage(playerid, COLOR_GREY, "Невозможно использовать в машине!");
	if(Tazer[playerid] == 1) return  SendClientMessage(playerid, COLOR_GREY, "Перезарядка тайзера ещё не прошла!");
	new suspect = GetClosestPlayer(playerid);
	if(!IsPlayerConnected(suspect)) suspect = GetClosestPlayer(playerid);
	if(Tazer[suspect] > 0) return   SendClientMessage(playerid, COLOR_GREY, "Игрок уже в оглушён!");
	if(GetDistanceBetweenPlayers(playerid,suspect) < 5)
	{
		if(IsACop(suspect)) return   SendClientMessage(playerid, COLOR_GREY, "Вы не можете ударить тазером законника");
		if(IsPlayerInAnyVehicle(suspect)) return SendClientMessage(playerid, COLOR_GREY, "Человек в машине!");
		format(req, sizeof(req), "Вас обездвижил(а) электрошокером %s на 15 секунд.", GN(playerid));
		SendClientMessage(suspect, 0x6495EDFF, req);
		format(req, sizeof(req), "Вы обездвижили электрошокером %s на 15 секунд.", GN(suspect));
		SendClientMessage(playerid, 0x6495EDFF, req);
		format(req, sizeof(req), "%s проводит задержание %s ", GN(playerid) ,GN(suspect));
		ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		TogglePlayerControllable(suspect, 0);
		SetPlayerSpecialAction(suspect,SPECIAL_ACTION_HANDSUP);
		Tazer[suspect] = 1;
		TazerTime[suspect] = 10;
	}
	return 1;
}
cmd:cuff(playerid, params[])
{
	if(!(IsACop(playerid) || PlayerInfo[playerid][pRank] < 2)) return SendClientMessage(playerid, COLOR_GREY, "Вы не Полицейский/ФБР!");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /cuff [id]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Игрок не найден");
	if(IsACop(params[0])) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете надеть наручники на законника!");
	if(PlayerCuffed[params[0]] == 1) return SendClientMessage(playerid, COLOR_GREY, "Этот игрок в наручниках!");
	if(params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете надевать наручники на самого себя!");
	if(ProxDetectorS(8.0, playerid, params[0]))
	{
		format(req, sizeof(req), "На Вас надел наручники %s.", GN(playerid));
		SendClientMessage(params[0], 0x6495EDFF, req);
		format(req, sizeof(req), "Вы надели наручники на %s.", GN(params[0]));
		SendClientMessage(playerid, 0x6495EDFF, req);
		format(req, sizeof(req), "%s надел(а) на %s наручники.", GN(playerid) ,GN(params[0]));
		ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		TogglePlayerControllable(params[0], 0);
		PlayerCuffed[params[0]] = 1;
		CuffedTime[params[0]] = 600;
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Рядом с вами никого нет!");
	return true;
}
cmd:uncuff(playerid, params[])
{
	if(!(IsACop(playerid) || PlayerInfo[playerid][pRank] < 2) && (PlayerInfo[playerid][pAdmin] < 3 || !dostup[playerid])) return SendClientMessage(playerid, COLOR_GREY, "Вы не Полицейский/ФБР!");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /uncuff [id]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Игрок не найден");
	if (!ProxDetectorS(8.0, playerid, params[0]) && PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_GREY, "Рядом с вами никого нет !");
	if(PlayerCuffed[params[0]] == 1)
	{
		format(req, sizeof(req), "С Вас снял наручники %s.", GN(playerid));
		SendClientMessage(params[0], 0x6495EDFF, req);
		format(req, sizeof(req), "Вы сняли наручники с %s.", GN(params[0]));
		SendClientMessage(playerid, 0x6495EDFF, req);
		format(req, sizeof(req), "%s снял(а) наручники с %s.", GN(playerid) ,GN(params[0]));
		ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		TogglePlayerControllable(params[0], 1);
		PlayerCuffed[params[0]] = 0;
		CuffedTime[params[0]] = 0;
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "Этот игрок не в наручниках!");
		return true;
	}
	return true;
}
cmd:cput(playerid, params[])
{
    if(!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не сотрудник силовых ведомств");
	if(PlayerInfo[playerid][pRank] < 2) return SendClientMessage(playerid, COLOR_GREY, "Вы не обладаете должной квалификацией!");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 596 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 597 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 598 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 490) return SendClientMessage(playerid, 0xB4B5B7FF, "Вы не в полицейской машине");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /cput [id]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Человек не найден");
	if (!ProxDetectorS(5.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, "Человек далеко от Вас!");
	if(params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете затащить в машину себя!");
    if(PlayerInfo[params[0]][pZvezdi] == 0) return SendClientMessage(playerid, COLOR_GREY, "Человек не является преступником!");
    if(GetPlayerState(params[0])!=PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "Человек не является пешеходом!");
	new mesto2=0,mesto3=0,vehicle=GetPlayerVehicleID(playerid);
	foreach(new i : Player)
	{
	    if(IsPlayerInVehicle(i,vehicle))
	    {
	        if(GetPlayerVehicleSeat(i) == 2) mesto2 = 1;
	        if(GetPlayerVehicleSeat(i) == 3) mesto3 = 1;
	    }
	}
	if(mesto2 == 1 && mesto3 == 1) return SendClientMessage(playerid, COLOR_GREY, "Места в машине уже заняты");
	if(mesto2 == 0) PutPlayerInVehicle(params[0],vehicle,2);
	else if(mesto3 == 0) PutPlayerInVehicle(params[0],vehicle,3);
	format(req,sizeof(req),"Вы были затащены в машину офицером %s",GN(playerid));
	SendClientMessage(params[0],0x64E96EDFF,req);
	format(req,sizeof(req),"Вы затащили в машину %s",GN(params[0]));
	SendClientMessage(playerid,0x64E96EDFF,req);
	format(req,sizeof(req), "тащит в машину %s",GN(params[0]));
	SetPlayerChatBubble(playerid,req,0xC2A2DAAA,30.0,10000);
	return 1;
}
cmd:cout(playerid, params[])
{
    if(!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не сотрудник силовых ведомств");
	if(PlayerInfo[playerid][pRank] < 2) return SendClientMessage(playerid, COLOR_GREY, "Вы не обладаете должной квалификацией!");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 596 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 597 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 598 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 490) return SendClientMessage(playerid, 0xB4B5B7FF, "Вы не в полицейской машине");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /cout [id]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Человек не найден");
	if(GetPlayerVehicleID(playerid)!=GetPlayerVehicleID(params[0])) return SendClientMessage(playerid, COLOR_GREY, "Человек не в вашей машине");
	RemovePlayerFromVehicle(params[0]);
	if(IsPlayerInRangeOfPoint(params[0],5.0,1568.6144,-1689.9901,6.2188))
	{
		OnPlayerPickUpPickup(params[0],lspd[5]);
		format(req,sizeof(req),"Вы были высажены офицером %s в ПД Лос Сантоса",GN(playerid));
		SendClientMessage(params[0],0x64E96EDFF,req);
		format(req,sizeof(req),"Вы высадили %s в полицейский участок Лос Сантоса",GN(params[0]));
		SendClientMessage(playerid,0x64E96EDFF,req);
		format(req,sizeof(req), "затолкал(а) %s в полицейский участок",GN(params[0]));
		SetPlayerChatBubble(playerid,req,0xC2A2DAAA,30.0,10000);
	}
	else if(IsPlayerInRangeOfPoint(params[0],5.0,-1594.2096,716.1803,-4.9063))
	{
		OnPlayerPickUpPickup(params[0],sfpd[2]);
		TogglePlayerControllable(params[0], 0);
		SetPlayerFacingAngle(params[0], 185.1139);
		ApplyAnimation(params[0], "PED", "WALK_CIVI", 4.1, 1, 1, 1, 1, 250, 1);
		//SetTimerEx("cout", 250, false, "d", params[0]);
		format(req,sizeof(req),"Вы были высажены офицером %s в ПД Сан Фиерро",GN(playerid));
		SendClientMessage(params[0],0x64E96EDFF,req);
		format(req,sizeof(req),"Вы высадили %s в полицейский участок Сан Фиерро",GN(params[0]));
		SendClientMessage(playerid,0x64E96EDFF,req);
		format(req,sizeof(req), "затолкал(а) %s в полицейский участок",GN(params[0]));
		SetPlayerChatBubble(playerid,req,0xC2A2DAAA,30.0,10000);
	}
	else if(IsPlayerInRangeOfPoint(params[0],5.0,2297.1138,2451.4346,10.8203))
	{
		OnPlayerPickUpPickup(params[0],lvpdpic[0]);
		format(req,sizeof(req),"Вы были высажены офицером %s в ПД Лас Вентурас",GN(playerid));
		SendClientMessage(params[0],0x64E96EDFF,req);
		format(req,sizeof(req),"Вы высадили %s в полицейский участок Лас Вентурас",GN(params[0]));
		SendClientMessage(playerid,0x64E96EDFF,req);
		format(req,sizeof(req), "затолкал(а) %s в полицейский участок",GN(params[0]));
		SetPlayerChatBubble(playerid,req,0xC2A2DAAA,30.0,10000);
	}
	else
	{
		format(req,sizeof(req),"Вы были вытащены из машины офицером %s",GN(playerid));
		SendClientMessage(params[0],0x64E96EDFF,req);
		format(req,sizeof(req),"Вы вытащили из машины %s",GN(params[0]));
		SendClientMessage(playerid,0x64E96EDFF,req);
		format(req,sizeof(req), "вытащил(а) из машины %s",GN(params[0]));
		SetPlayerChatBubble(playerid,req,0xC2A2DAAA,30.0,10000);
	}
	return 1;
}
cmd:arrest(playerid, params[])
{
    if(!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не сотрудник силовых ведомств");
	if(!PlayerToPoint(6.0, playerid, 268.3327,77.8972,1001.0391) && !PlayerToPoint(6.0, playerid, 227.7436,114.5075,999.0156) || PlayerToPoint(6.0, playerid, 188.7124,157.6917,1003.0234) && !PlayerToPoint(6.0, playerid, 218.2263,114.9286,999.0156) && !PlayerToPoint(6.0, playerid, 198.3940,157.9389,1003.0234)) return SendClientMessage(playerid, COLOR_GREY, "Вы далеко от тюрьмы!");
	if(sscanf(params, "uD", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /arrest [id] {1 - минимальный срок}");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Человек не найден");
	if(!ProxDetectorS(4.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, "Рядом с вами никого нет!");
	if(PlayerInfo[params[0]][pZvezdi] < 1) return  SendClientMessage(playerid, COLOR_GREY, "Человек должен иметь хотя бы один уровень розыска!");
	format(req, sizeof(req), "Вы арестовали %s", GN(params[0]));
	SendClientMessage(playerid, -1, req);
	PlayerInfo[playerid][pCash]+=PlayerInfo[params[0]][pLevel]*10;
	format(req, sizeof(req), "~r~+%d", PlayerInfo[params[0]][pLevel]*10);
	GameTextForPlayer(playerid, req, 5000, 5);
	DeleteWeapons(params[0]);
	if(PlayerInfo[playerid][pMember]==1 || PlayerInfo[playerid][pMember]==10 || PlayerInfo[playerid][pMember]==21)
	{
		format(req, sizeof(req), "<< Офицер %s арестовал(а) %s >>",GN(playerid),GN(params[0]));
		SendClientMessageToAll(COLOR_LIGHTRED, req);
	}
	else if(PlayerInfo[playerid][pMember]==2)
	{
		format(req, sizeof(req), "<< Агент ФБР %s арестовал(а) %s >>",GN(playerid),GN(params[0]));
		SendClientMessageToAll(COLOR_LIGHTRED, req);
	}
	new time;
	if(params[1] == 1)
	{
	    time = PlayerInfo[params[0]][pLevel] * 2*PlayerInfo[params[0]][pZvezdi];
	    if(time > 60) time =60;
	}
	else
	{
	    time = PlayerInfo[params[0]][pLevel]*3*PlayerInfo[params[0]][pZvezdi];
	}
	PlayerInfo[params[0]][pZvezdi] =0;
	PlayerInfo[params[0]][pJailTime] = time * 60;
	PlayerInfo[params[0]][pArrested] += 1;
	TogglePlayerControllable(params[0], 1);
	SetPlayerWantedLevel(params[0], 0);
	if(PlayerToPoint(6.0, playerid, 268.3327,77.8972,1001.0391))
	{
		SetPlayerInterior(params[0], 6);
		SetPlayerPos(params[0],264.1425,77.4712,1001.0391);
		SetPlayerFacingAngle(params[0], 263.0160);
		PlayerInfo[params[0]][pJailed] = 1;
	}
	else if(PlayerToPoint(6.0, playerid, 218.2263,114.9286,999.0156))
	{
		SetPlayerInterior(params[0], 10);
		SetPlayerPos(params[0],219.5400,109.9767,999.0156);
		SetPlayerFacingAngle(params[0], 1.0000);
		PlayerInfo[params[0]][pJailed] = 2;
	}
	else if(PlayerToPoint(6.0, playerid, 198.3940,157.9389,1003.0234))
	{
		SetPlayerInterior(params[0], 3);
		SetPlayerPos(params[0],198.3642,161.8103,1003.0300);
		SetPlayerFacingAngle(params[0], 1.0000);
		PlayerInfo[params[0]][pJailed] = 3;
	}
	return true;
}
cmd:su(playerid,params[])
{
    if(!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не сотрудник силовых ведомств");
	if(sscanf(params, "uds[20]", params[0],params[1],params[2])) return SendClientMessage(playerid, -1, "Введите: (/su)spect [id] [уровень розыска] [причина]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Человек не найден");
	if(PlayerInfo[params[0]][pJailed] != 0) return SendClientMessage(playerid, COLOR_GREY, "Этот человек в тюрьме!");
	if(PlayerInfo[params[0]][pZvezdi] >= 6) return    SendClientMessage(playerid, COLOR_GREY, "У данного игрока шестой уровень розыска!");
	if (IsACop(params[0])) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете давать розыск законникам!");
	SetPlayerCriminal(params[0],playerid, params[1],params[2]);
	return 1;
}
alias:su("suspect");
cmd:wanted(playerid)
{
	new string[85];
	if(!IsACop(playerid) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в силовых структурах!");
	new x;
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pZvezdi] >= 1)
			{
				SendClientMessage(playerid, -1, "Внимание, розыскиваются:");
				format(string, sizeof(string), "|%s| %s: %d", string,GN(i),PlayerInfo[i][pZvezdi]);
				x++;
				if(x > 3)
				{
					SendClientMessage(playerid, 0xFFFF00AA, string);
					x = 0;
					format(string, sizeof(string), "");
				}
				else { format(string, sizeof(string), "%s, ", string); }
			}
		}
		return true;
	}
	if(x <= 3 && x > 0)
	{
		string[strlen(string)-2] = '.';
		SendClientMessage(playerid, 0xFA8072AA, string);
	}
	return true;
}
cmd:frisk(playerid,params[])
{
	if(!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в силовых структурах!");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /frisk [id]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Человек не найден");
	if (!ProxDetectorS(3.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, "Этого игрока рядом с вами нет !");
	if(params[0] == playerid) { SendClientMessage(playerid, COLOR_GREY, "Вы не можете обыскать себя!"); return 1; }
	new text1[20], text2[20];
	if(PlayerInfo[params[0]][pDrugs] > 0) { text1 = "Наркотики."; } else { text1 = "Пустой карман."; }
	if(PlayerInfo[params[0]][pMats] > 0) { text2 = "Материалы."; } else { text2 = "Пустой карман."; }
	format(req, sizeof(req), "Вещи %s", params[0]);
	SendClientMessage(playerid, -1, req);
	format(req, sizeof(req), "%s.", text1);
	SendClientMessage(playerid, COLOR_GREY, params[0]);
	format(req, sizeof(req), "%s.", text2);
	SendClientMessage(playerid, COLOR_GREY, req);
	SetPlayerSpecialAction(params[0],SPECIAL_ACTION_HANDSUP);
	format(req, sizeof(req), "%s обыскал(а) %s", GN(playerid), GN(params[0]));
	ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	return 1;
}
cmd:clear(playerid,params[])
{
	if((PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pMember] == 2 || PlayerInfo[playerid][pMember] == 10 || PlayerInfo[playerid][pMember] == 21) &&  PlayerInfo[playerid][pRank] >= 2 || PlayerInfo[playerid][pAdmin] >= 3)
	{
	    new car = GetVehicleModel(GetPlayerVehicleID(playerid));
		if(car != 596 && car != 597 && car != 598 && car != 490) return SendClientMessage(playerid, 0xB4B5B7FF, "Вы не в полицейской машине");
		if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /clear [id]");
		if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Человек не найден");
		if (!ProxDetectorS(5.0, playerid, params[0]))return SendClientMessage(playerid, COLOR_GREY, "Человек далеко от Вас!");
		if(params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете снять розыск себе!");
		format(req, sizeof(req), "Вы сняли уровни розыска у %s.", GN(params[0]));
		SendClientMessage(playerid, 0x6495EDFF, req);
		format(req, sizeof(req), "Офицер %s снял с Вас уровни розыска.", GN(playerid));
		SendClientMessage(params[0], 0x6495EDFF, req);
		PlayerInfo[params[0]][pZvezdi] =0;
		SetPlayerWantedLevel(params[0], 0);
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в силовых структурах!");
	return 1;
}
cmd:find(playerid,params[])
{
	if(!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в силовых структурах!");
	if(sscanf(params, "u", params[0]))
	{
	    if(FindCP[playerid])
	    {
			DisablePlayerCheckpoint(playerid);
			FindCP[playerid]=false;
		}
		else
		{
		    SendClientMessage(playerid, -1, "Введите: /find [id]");
		}
		return true;
	}
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Человек не найден");
	if(params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, "[Ошибка] Вы указали свой ID"); 
	if(PlayerInfo[params[0]][pAdmin] >= 1) return 1;
	if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
	{
		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(params[0], X,Y,Z);
		SetPlayerCheckpoint(playerid, X,Y,Z, 6);
		FindCP[playerid]=true;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "Человек в здании, плохая связь...");
	}
	return true;
}
// ========== [ Инструкторы ] ==========
cmd:duty(playerid)
{
	if(PlayerInfo[playerid][pMember] == 11)
	{
		if (!IsPlayerInRangeOfPoint(playerid,10,-2029.7878,-116.4905,1035.1719)) return SendClientMessage(playerid, 0xB4B5B7FF, "Вы не в автошколе!");
		if(duty[playerid] == 0)
		{
			format(req, sizeof(req), "Инструктор %s приступил(а) к работе", GN(playerid));
			ProxDetector(2,25.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			duty[playerid] =1;
		}
		else
		{
			format(req, sizeof(req), "Инструктор %s завершил(а) рабочий день", GN(playerid));
			ProxDetector(2,25.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			duty[playerid] =0;
		}
	}
	return 1;
}
cmd:givelic(playerid, params[])
{
    if(PlayerInfo[playerid][pMember] == 11)
	{
	    if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /givelic [id]");
		if(duty[playerid] == 0) return SendClientMessage(playerid,0xB4B5B7FF,"Вам нужно начать рабочий день в автошколе");
		new listitems[] = "- Водительские права\n- Лицензия на полёты\n- Лицензия на рыболовлю\n- Лицензия на вождение водного транспорта\n- Лицензия на оружие\n- Лицензия на бизнес";
		SPD(playerid, 7777, DIALOG_STYLE_LIST, "Выдача лицензий:", listitems, "Ок", "Отмена");
		ChosenPlayer[playerid] = params[0];
	}
	return 1;
}
// ========== [ Обычные ] ==========
cmd:tries(playerid, params[])
{
    if(IsMute(playerid)) return 1;
    if(GetPVarInt(playerid,"AntiFloodtry") > gettime()) return SendClientMessage(playerid, COLOR_GREY, "Нельзя использовать команду слишком часто");
    if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /try [действие]");
    new chance = random(4);
    if(IsIP(params[0]) || CheckString(params[0]))
	{
		PlayerInfo[playerid][pMute] = 10800;
		format(req, sizeof(req), "%s[%d]: %s",GN(playerid),playerid, params[0]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		format(req,sizeof(req),"Вы получили бан чата на 3 часа");
		SendClientMessage(playerid, COLOR_LIGHTRED, req);
		return true;
	}
    if(chance < 2)
    {
        format(req, sizeof(req), "%s пытается %s, {AAFFAA}удачно",GN(playerid), params[0]);
        ProxDetector(2,5.0, playerid, req, 0xC2A2DAAA, 0xC2A2DAAA, 0xC2A2DAAA, 0xC2A2DAAA, 0xC2A2DAAA);
        format(req,sizeof(req), "%s, {AAFFAA}удачно", params[0]);
        SetPlayerChatBubble(playerid,req,0xDD90FFFF,20.0,10000);
    }
    else
    {
        format(req, sizeof(req), "%s пытается %s, {FF6347}неудачно",GN(playerid), params[0]);
        ProxDetector(2,5.0, playerid, req, 0xC2A2DAAA, 0xC2A2DAAA, 0xC2A2DAAA, 0xC2A2DAAA, 0xC2A2DAAA);
        format(req,sizeof(req), "%s, {FF6347}неудачно", params[0]);
        SetPlayerChatBubble(playerid,req,0xDD90FFFF,20.0,10000);
    }
    SetPVarInt(playerid,"AntiFloodtry",gettime() + 10);
    return true;
}
alias:tries("try");
cmd:does(playerid, params[])
{
	if(IsMute(playerid)) return 1;
	if(GetPVarInt(playerid,"AntiFlood") > gettime()) return SendClientMessage(playerid, COLOR_LIGHTRED, "Не флуди");
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /do [действие]");
	if(IsIP(params[0]) || CheckString(params[0]))
	{
		PlayerInfo[playerid][pMute] = 10800;
		format(req, sizeof(req), "%s[%d]: %s",GN(playerid),playerid, params[0]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		format(req,sizeof(req),"Вы получили бан чата на 3 часа");
		SendClientMessage(playerid, COLOR_LIGHTRED, req);
		return true;
	}
	SetPlayerChatBubble(playerid,params[0],0xC2A2DAAA,30.0,10000);
	format(req,sizeof(req),"{202020}[%d] {C2A2DA}- %s",playerid,params[0]);
	ProxDetector(2,20.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	SetPVarInt(playerid,"AntiFlood",gettime() + 2);
	return true;
}
alias:does("do");
cmd:me(playerid, params[])
{
	if(IsMute(playerid)) return 1;
	if(GetPVarInt(playerid,"AntiFloodme") > gettime()) return SendClientMessage(playerid, COLOR_GREY, "Нельзя менять своё действие моментально!");
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /me [действие]");
	if(IsIP(params[0]) || CheckString(params[0]))
	{
		PlayerInfo[playerid][pMute] = 10800;
		format(req, sizeof(req), "%s[%d]: %s",GN(playerid),playerid, params[0]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		format(req,sizeof(req),"Вы получили бан чата на 3 часа");
		SendClientMessage(playerid, COLOR_LIGHTRED, req);
		return true;
	}
	format(req, sizeof(req), "%s %s", GN(playerid), params[0]);
	ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	SetPlayerChatBubble(playerid,params[0],0xC2A2DAAA,30.0,10000);
    SetPVarInt(playerid,"AntiFloodme",gettime() + 3);
    return 1;
}
cmd:s(playerid, params[])
{
	if(IsMute(playerid)) return 1;
	if(GetPVarInt(playerid,"AntiFlood") > gettime()) return SendClientMessage(playerid, COLOR_LIGHTRED, "Не флуди");
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: (/s)hout [текст]");
	if(IsIP(params[0]) || CheckString(params[0]))
	{
		PlayerInfo[playerid][pMute] = 10800;
		format(req, sizeof(req), "%s[%d]: %s",GN(playerid),playerid, params[0]);
		ABroadCast(COLOR_LIGHTRED,req,1);
		format(req,sizeof(req),"Вы получили бан чата на 3 часа");
		SendClientMessage(playerid, COLOR_LIGHTRED, req);
		return true;
	}
	format(req, sizeof(req), "- %s кричит: %s!", GN(playerid), params[0]);
	ProxDetector(0,60.0, playerid, req,-1,-1,-1,0xE6E6E6E6,0xC8C8C8C8);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		ApplyAnimation(playerid,"ON_LOOKERS","shout_01",1000.0,0,0,0,0,0,1);
	}
	SetPlayerChatBubble(playerid,params[0],0xFFFF00AA,60.0,10000);
	SetPVarInt(playerid,"AntiFlood",gettime() + 2);
	return 1;
}
alias:s("shout");
cmd:kiss(playerid, params[])
{
	if(sscanf(params, "U", params[0]))params[0] = GetClosestPlayer(playerid);
	if(GetPlayerState(playerid)!=PLAYER_STATE_ONFOOT || GetPlayerState(params[0])!=PLAYER_STATE_ONFOOT ) return 1;
	if(params[0] == INVALID_PLAYER_ID) params[0] = GetClosestPlayer(playerid);
	if(!ProxDetectorS(4.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, "Нет никого рядом");
	if(params[0] == playerid)  return  SendClientMessage(playerid,0xB4B5B7FF,"Нельзя поцеловать себя!");
	if(Nointim[params[0]]) return SendClientMessage(playerid,0xB4B5B7FF,"Этот игрок не хочет целоваться!");
	SetPosInFrontOfPlayer(playerid, params[0], 1);
	new Float:a; GetPlayerFacingAngle(playerid, a);
	SetPlayerFacingAngle(params[0], 180 + a);
	ApplyAnimation(params[0],"BD_FIRE","GRLFRD_KISS_03",4.0,0,0,0,0,0,1);
	ApplyAnimation(playerid,"BD_FIRE","PLAYA_KISS_03",4.0,0,0,0,0,0,1);
	format(req, sizeof(req), "%s поцеловал(а) %s", GN(playerid), GN(params[0]));
	ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	format(req, sizeof(req),"поцеловал(а) %s", GN(params[0]));
	SetPlayerChatBubble(playerid ,req, 0xC2A2DAAA,30.0,10000);
	return 1;
}
cmd:nointim(playerid, params[])
{
    switch(Nointim[playerid])
    {
        case true:
        {
            Nointim[playerid] = false;
			SendClientMessage(playerid,0xB4B5B7FF,"Вы разрешили вступать в интимные отношения с собой");
		}
        case false:
        {
            Nointim[playerid] = true;
			SendClientMessage(playerid,0xB4B5B7FF,"Вы запретили вступать в интимные отношения с собой");
        }
    }
    return 1;
}
cmd:togphone(playerid, params[])
{
	if(PlayerInfo[playerid][pVIP] >= 1 || PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pLeader] >= 1)
	{
		if (PhoneOnline[playerid])
		{
			PhoneOnline[playerid] = 0;
			format(req, sizeof(req), "%s выключил(а) телефон", GN(playerid));
			ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		}
		else if (!PhoneOnline[playerid])
		{
			PhoneOnline[playerid] = 1;
			format(req, sizeof(req), "%s включил(а) телефон", GN(playerid));
			ProxDetector(2,30.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Вы не VIP/Администратор/Лидер!");
	return 1;
}
cmd:number(playerid, params[])
{
	if(PlayerInfo[playerid][pPhoneBook] == 0) return SendClientMessage(playerid, 0xBFC0C2FF, "У Вас нету телефонной книги.");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, -1, "Введите: /number [id]");
	if(!IsPlayerConnected(params[0]))  return	SendClientMessage(playerid, 0xBFC0C2FF, "Игрок не найден");
	format(req, sizeof(req), "Владелец: %s. Телефон: %d",GN(params[0]),PlayerInfo[params[0]][pPnumber]);
	SendClientMessage(playerid, -1, req);
	return true;
}
cmd:sms(playerid, params[])
{
    if(sscanf(params, "ds[128]", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: /sms [номер] [текст]");
    if(IsMute(playerid)) return 1;
	if(PhoneOnline[playerid] == 0)  return SendClientMessage(playerid, 0xB4B5B7FF, "У вас выключен телефон!");
	if(takephone[playerid] == 1) return	SendClientMessage(playerid, 0xB4B5B7FF, "У Вас нет телефона");
	if(strfind(params[1],"www",true)!=-1 && strfind(params[1],".ru",true)!=-1 || strfind(params[1],".net",true)!=-1 || strfind(params[1],".com",true)!=-1 || strfind(params[1],"http",true)!=-1)
	{
		format(req, sizeof(req), "[АБЧ]: %s[%d]: %s",GN(playerid),playerid,params[1]);
		ABroadCast(COLOR_LIGHTRED, req, 1);
		format(req,sizeof(req),"Вы получили молчанку на 3 часа. /mm - репорт");
		SendClientMessage(playerid, COLOR_LIGHTRED, req);
		PlayerInfo[playerid][pMute] = 108000;
		return 1;
	}
    new num = 0,name[10],numf;
	if(params[0] == 11888 || params[0] == 11555 || params[0] == 11666)
	{
	    switch(params[0])
	    {
	        case 11888: numf = 16;
	        case 11555: numf = 9;
	        case 11666: numf = 20;
	    }
		if(numf == 16 && smsls == 0) return SendClientMessage(playerid, COLOR_GREY, "Приём SMS отключен");
		if(numf == 9 && smssf == 0) return SendClientMessage(playerid, COLOR_GREY, "Приём SMS отключен");
		if(numf == 20 && smslv == 0) return SendClientMessage(playerid, COLOR_GREY, "Приём SMS отключен");
		if(PlayerInfo[playerid][pMobile] >= smspricels && PlayerInfo[playerid][pMobile] >= ringls)
		{

			if(!strcmp(params[1],"Diggi",true)) num=1062;
			else if(!strcmp(params[1],"Dance",true))num=1183;
			else if(!strcmp(params[1],"Army",true))num=1187;
			else if(!strcmp(params[1],"Race",true))num=1097;
			else if(!strcmp(params[1],"Bring",true))num=1076;
			else if(!strcmp(params[1],"Gudok",true))num=1068;
			else if(!strcmp(params[1],"Rock",true))num=1185;
			if(PlayerInfo[playerid][pMobile] >= ringls && num != 0)
			{
			    switch(num)
			    {
			        case 1062: name = "Diggi";
			        case 1183: name = "Dance";
			        case 1187: name = "Army";
			        case 1097: name = "Race";
			        case 1076: name = "Bring";
			        case 1068: name = "Gudok";
			        case 1185: name = "Rock";
			    }
				if(numf == 16)
				{
					format(req, sizeof(req),"SMS: Спасибо за покупку! Установлен рингтон '%s'. Отправитель: LS NEWS",name);
     				PlayerInfo[playerid][pMobile] -=ringls;
     				FracBank[0][fLsnews] += ringls;
				}
				else if (numf == 9)
				{
					format(req, sizeof(req),"SMS: Спасибо за покупку! Установлен рингтон '%s'. Отправитель: SF NEWS",name);
                    PlayerInfo[playerid][pMobile] -=ringsf;
                    FracBank[0][fSfnews] += ringsf;
				}
				else if(numf == 20)
				{
					format(req, sizeof(req),"SMS: Спасибо за покупку! Установлен рингтон '%s'. Отправитель: LV NEWS",name);
                    PlayerInfo[playerid][pMobile] -=ringlv;
                    FracBank[0][fLvnews] += ringlv;
				}
				SendClientMessage(playerid, 0xFDE640AA,req);
				SendClientMessage(playerid, -1,"Чтобы прослушать рингтон, введите /play");
				PlayerInfo[playerid][pZvonok] = num;
    			format(req, sizeof(req), "[Рингтон] %s купил(a) рингтон '%s'",GN(playerid),name);
				SendFamilyMessage(numf, 0xF5DEB3AA, req);
				return 1;
			}
			format(req, sizeof(req), "[Смс - Эфир] %s. Отправитель: %s[%d]",params[1],GN(playerid), playerid);
			SendFamilyMessage(numf, 0xF5DEB3AA, req);
			switch(numf)
			{
			    case 16:
			    {
			        format(req, sizeof(req), ":: SMS: %s. Получатель: LS NEWS",params[1]);
					SendClientMessage(playerid,  0xFDE640AA, req);
					PlayerInfo[playerid][pMobile] -= smspricels;
					FracBank[0][fLsnews] += smspricels;
			    }
			    case 9:
			    {
			        format(req, sizeof(req), ":: SMS: %s. Получатель: SF NEWS",params[1]);
					SendClientMessage(playerid,  0xFDE640AA, req);
					PlayerInfo[playerid][pMobile] -= smspricesf;
					FracBank[0][fSfnews] += smspricesf;
			    }
				case 20:
			    {
			        format(req, sizeof(req), ":: SMS: %s. Получатель: LV NEWS",params[1]);
					PlayerInfo[playerid][pMobile] -= smspricelv;
					FracBank[0][fLvnews] += smspricelv;
			    }
			}
			SendClientMessage(playerid,  0xFDE640AA, req);
			return 1;
		}
		else
		{
		    format(req, sizeof(req), "SMS: %s. Получатель: LS NEWS",params[1]);
			SendClientMessage(playerid,  0xFDE640AA, req);
			SendClientMessage(playerid,  0xB4B5B7FF, "- Сообщение не доставлено, не достаточно средств");
			format(req, sizeof(req), "%s достаёт мобильник", GN(playerid));
			ProxDetector(2,5.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			return 1;
		}
	}
	foreach (new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pPnumber] == params[0] && params[0] != 0)
			{

				if(PhoneOnline[i] == 0)
				{
					SendClientMessage(playerid, COLOR_GREY, "Телефон абонента выключен...");
					format(req, sizeof(req), "%s достаёт мобильник", GN(playerid));
					ProxDetector(2,5.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
					return 1;
				}
				if(PlayerInfo[playerid][pMobile] < 20)
				{
					format(req, sizeof(req), "SMS: %s. Получатель: %s[%d] (Тел. %d)",params[1],GN(i),i,PlayerInfo[i][pPnumber]);
					SendClientMessage(playerid,  0xFDE640AA, req);
					SendClientMessage(playerid,  0xB4B5B7FF, "- Сообщение не доставлено, не достаточно средств");
					format(req, sizeof(req), "%s достаёт мобильник", GN(playerid));
					ProxDetector(2,5.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
					return 1;
				}
				PlayerInfo[playerid][pMobile] -=20;
				format(req, sizeof(req), "SMS: %s. От: %s[%d] (Тел. %d)",params[1],GN(playerid),playerid,PlayerInfo[playerid][pPnumber]);
				SendClientMessage(i, 0xFDE640AA, req);
				PlayerPlaySound(i, 1052, 0.0, 0.0, 0.0);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(req, sizeof(req), "SMS: %s. Получатель: %s[%d] (Тел. %d)",params[1],GN(i),i,PlayerInfo[i][pPnumber]);
				SendClientMessage(playerid,  0xFDE640AA, req);
				SendClientMessage(playerid,  -1, "- Сообщение доставлено");
				format(req, sizeof(req), "%s достаёт телефон", GN(playerid));
				ProxDetector(2,5.0, playerid, req, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			}
			if(smschat[i] == 1)
			{
			    format(req, sizeof(req), "SMS %s. %d->%d [%s->%s]",params[1],playerid,i,GN(playerid),GN(i));
				SendClientMessage(i,COLOR_LIGHTRED,req);
			}
		}
	}
	return 1;
}
alias:sms("txt");
cmd:rep(playerid)
{
	if(GetPVarInt(playerid, "ReportFlood") > gettime()) return SendClientMessage(playerid, COLOR_LIGHTRED,"Вы уже отправляли сообщение администрации. Подождите некоторое время");
	SPD(playerid,11,DIALOG_STYLE_INPUT,"Жалоба администрации","Несколько простых правил,которые ускорят получения ответа:\n\n- сообщения сформулируйте чётко ясно и кратко;\n- в жалобе указывайте ID нарушителя и суть нарушения;\n- флуд и оффтоп запрещен.","Ок","Назад");
	return 1;
}
alias:rep("report");
cmd:en(playerid)
{
    if(!IsNoSpeed(GetPlayerVehicleID(playerid)))
    {
		if(zavodis[GetPlayerVehicleID(playerid)] == 0)
		{
			if(GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
		    		if(Fuell[GetPlayerVehicleID(playerid)] <= 0)
					{
						SendClientMessage(playerid, 0xFF0000AA, "В автомобиле нет бензина");
						SendClientMessage(playerid, 0x33AA33AA, "{62AD50}Используйте телефон {FFFFFF}(( /c )) {62AD50}вызвать механика / таксиста");
						return 1;
					}
					GetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(GetPlayerVehicleID(playerid),1,lights,alarm,doors,bonnet,boot,objective);
					zavodis[GetPlayerVehicleID(playerid)] = 1;
				}
			}
		}
		else if(zavodis[GetPlayerVehicleID(playerid)] == 1)
		{
			if(GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					GetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(GetPlayerVehicleID(playerid),0,lights,alarm,doors,bonnet,boot,objective);
					zavodis[GetPlayerVehicleID(playerid)] = 0;
				}
			}
		}
	}
	return true;
}
cmd:light(playerid)
{
	new vehicle = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid)&&(GetPlayerState(playerid)==PLAYER_STATE_DRIVER))
	{
		if(VehicleLight[vehicle] == 0)
		{
			GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(vehicle,engine,1,alarm,doors,bonnet,boot,objective);
			VehicleLight[vehicle] = 1;
		}
		else if(VehicleLight[vehicle] == 1)
		{
			GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(vehicle,engine,0,alarm,doors,bonnet,boot,objective);
			VehicleLight[vehicle] = 0;
		}
	}
	return 1;
}
cmd:mm(playerid)
{
	new listitems[] = "{D1DBD0}[1] Команды сервера\n{00A2FF}[2] Статистика персонажа\n{720000}[3] Cообщить о нарушении\n{FFFFFF}[4] Правила\n[5] Настройки\n[6] Слив денег\n[7] Безопасность\n";
	SPD(playerid,23, DIALOG_STYLE_LIST, "Личное меню", listitems, "Выбрать", "Отмена");
	return true;
}
cmd:gps(playerid)
{
	SPD(playerid, 41, DIALOG_STYLE_LIST, "GPS", "[1] Важные места\n[2] По работе\n[3] Развлечения\n[4] Автосалоны\n[5] Базы организаций\n[6] Отключить GPS", "Выбрать", "Отмена");
	return true;
}
cmd:pdd(playerid)
{
	new pdddialog[800],string[100];
	format(pdddialog,sizeof(pdddialog), "%s%s%s%s%s%s%s%s%s%s%s%s%s",
	pdddialogMSG[0],pdddialogMSG[1],pdddialogMSG[2],pdddialogMSG[3],pdddialogMSG[4],pdddialogMSG[5],pdddialogMSG[6],pdddialogMSG[7],pdddialogMSG[8],pdddialogMSG[9],pdddialogMSG[10],pdddialogMSG[11],pdddialogMSG[12]);
	SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Правила дорожного движения", pdddialog, "Ок", "");
	format(string, sizeof(string), "%s читает Правила Дорожного Движения.", GN(playerid));
	ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	return 1;
}
cmd:time(playerid)
{
    new string[70];
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch",4.1,0,0,0,0,0,1);
	}
	if(PlayerInfo[playerid][pSex] == 1)
	{
		format(string, sizeof(string), "%s взглянул на часы", GN(playerid));
		ProxDetector(2,25.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	}
	else if(PlayerInfo[playerid][pSex] == 2)
	{
		format(string, sizeof(string), "%s взглянула на часы", GN(playerid));
		ProxDetector(2,25.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	}
	new mtext[20];
	new year, month,day;
	getdate(year, month, day);
	switch(month)
	{
	    case 1: mtext = "Января";
	    case 2: mtext = "Февраля";
	    case 3: mtext = "Марта";
	    case 4: mtext = "Апреля";
	    case 5: mtext = "Мая";
	    case 6: mtext = "Июня";
	    case 7: mtext = "Июля";
	    case 8: mtext = "Августа";
		case 9: mtext = "Сентября";
		case 10: mtext = "Октября";
		case 11: mtext = "Ноября";
		case 12: mtext = "Декабря";
	}
	new hour,minuite,second;
	gettime(hour,minuite,second);
	FixHour(hour);
	if(minuite < 10)
	{
		if(PlayerInfo[playerid][pJailTime] > 0) { format(string, sizeof(string), "Дата: %d %s | Время: %d:0%d | Осталось сидеть %d сек.",day,mtext,hour,minuite,PlayerInfo[playerid][pJailTime]-10); }
		else { format(string, sizeof(string), "Дата: %d %s | Время: %d:0%d",day,mtext,hour,minuite); }
	}
	else
	{
		if(PlayerInfo[playerid][pJailTime] > 0) { format(string, sizeof(string), "Дата: %d %s | Время: %d:%d | Осталось сидеть %d сек.",day,mtext,hour,minuite,PlayerInfo[playerid][pJailTime]-10); }
		else { format(string, sizeof(string), "Дата: %d %s | Время: %d:%d",day,mtext,hour,minuite); }
	}
	SendClientMessage(playerid, -1, string);
	return true;
}
cmd:id(playerid,params[])
{
    new null = 0,string[60];
    if(sscanf(params, "s[26]", params[0])) return SendClientMessage(playerid, -1, "Введите: /id [id/ник]");
	if(strlen(params[0]) <= 2) return SendClientMessage(playerid, COLOR_GREY, "Слишком короткое имя!");
	foreach(new i : Player)
	{
	    if(strfind(GN(i),params[0],true) != -1)
	    {
			if(IsPlayerConnected(i))
			{
				format(string, sizeof(string), "[%d] %s",i,GN(i));
				SendClientMessage(playerid, -1, string);
				null++;

			}
		}
	}
	if(null == 0) return format(string, sizeof(string), "Никого, похожего на %s, не найдено!",params[0]), SendClientMessage(playerid, COLOR_GREY, string);
	return 1;
}
cmd:usedrugs(playerid,params[])
{
    new string[47],Float:maxhealth = 100;
    if(sscanf(params, "d", params[0])) return callcmd::usedrugs(playerid, "1");
	if(PlayerInfo[playerid][pDrugs] == 0) return SendClientMessage(playerid, COLOR_GREY, "У Вас нет наркотиков!");
	if(params[0] < 1 || params[0] > 10) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете употребить меньше 1 и больше 10!");
    new Float:health;
	GetPlayerHealth(playerid, health);
	if(Drugtime[playerid] >= 1) return SendClientMessage(playerid,0xB4B5B7FF,"Вы не можете употреблять так часто!");
	switch(params[0])
	{
		case 2: if(PlayerInfo[playerid][pNarcoZavisimost] < 601) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 3: if(PlayerInfo[playerid][pNarcoZavisimost] < 1001) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 4: if(PlayerInfo[playerid][pNarcoZavisimost] < 2001) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 5: if(PlayerInfo[playerid][pNarcoZavisimost] < 3301) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 6: if(PlayerInfo[playerid][pNarcoZavisimost] < 4001) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 7: if(PlayerInfo[playerid][pNarcoZavisimost] < 7701) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 8: if(PlayerInfo[playerid][pNarcoZavisimost] < 10001) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 9: if(PlayerInfo[playerid][pNarcoZavisimost] < 16001) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
		case 10: if(PlayerInfo[playerid][pNarcoZavisimost] < 20001) return SendClientMessage(playerid,0xB4B5B7FF,"Вы пока не можете употреблять столько наркотиков за 1 раз!");
	}
	if(PlayerInfo[playerid][pNarcoZavisimost] < 601) maxhealth = 115;
	else if(601 <= PlayerInfo[playerid][pNarcoZavisimost] < 1001) maxhealth = 120;
	else if(1001 <= PlayerInfo[playerid][pNarcoZavisimost] < 2001) maxhealth = 125;
	else if(2001 <= PlayerInfo[playerid][pNarcoZavisimost] < 3301) maxhealth = 130;
	else if(3301 <= PlayerInfo[playerid][pNarcoZavisimost] < 4001) maxhealth = 135;
	else if(4001 <= PlayerInfo[playerid][pNarcoZavisimost] < 7701) maxhealth = 140;
	else if(7701 <= PlayerInfo[playerid][pNarcoZavisimost] < 10001) maxhealth = 145;
	else if(10001 <= PlayerInfo[playerid][pNarcoZavisimost] < 16001) maxhealth = 150;
	else if(16001 <= PlayerInfo[playerid][pNarcoZavisimost] < 20001) maxhealth = 155;
	else if(20001 <= PlayerInfo[playerid][pNarcoZavisimost]) maxhealth = 160;
	PlayerInfo[playerid][pDrugs] -= params[0];
    PlayerInfo[playerid][pNarcoZavisimost] += params[0]*5;
    health += params[0]*10.0;
    if(health > maxhealth) { health = maxhealth; }
    SetPlayerHealthAC(playerid, health);
	Drugtime[playerid] = 45;
	SetPlayerTime(playerid,17,0);
	SetPlayerWeather(playerid, -68);
	PlayerInfo[playerid][pKongfuSkill] -=50;
	PlayerInfo[playerid][pBoxSkill] -= 50;
	PlayerInfo[playerid][pKickboxSkill] -= 50;
	if(PlayerInfo[playerid][pKongfuSkill] <= 0) PlayerInfo[playerid][pKongfuSkill] = 0;
	if(PlayerInfo[playerid][pBoxSkill] <= 0) PlayerInfo[playerid][pBoxSkill] = 0;
	if(PlayerInfo[playerid][pKickboxSkill] <= 0) PlayerInfo[playerid][pKickboxSkill] = 0;
	SetPlayerDrunkLevel (playerid, 8000);
	startnarko[playerid] = 0;
	ApplyAnimation(playerid,"SMOKING","M_smk_drag",4.1,0,0,0,0,0,1);
	send[playerid] = 0;
	format(string,sizeof(string), "употребил(а) наркотики");
	SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
	format(string, sizeof(string), "%s употребил(а) наркотики", GN(playerid));
	ProxDetector(2,25.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	format(string, sizeof(string), "(( Здоровье пополнено до %d единиц ))", floatround(health));
	SendClientMessage(playerid,0xB4B5B7FF,string);
	return true;
}
cmd:b(playerid, params[])
{
	if(IsMute(playerid)) return 1;
	if(GetPVarInt(playerid,"AntiFlood") > gettime()) return SendClientMessage(playerid, COLOR_LIGHTRED, "Не флуди");
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /b [сообщение]");
	format(req, sizeof(req), "%s: (( %s ))", GN(playerid), params[0]);
	ProxDetector(0,20.0, playerid, req,-1,-1,-1,-1,-1);
	SetPVarInt(playerid,"AntiFlood",gettime() + 1);
	return 1;
}
cmd:w(playerid, params[])
{
	if(IsMute(playerid)) return 1;
	if(GetPVarInt(playerid,"AntiFlood") > gettime()) return SendClientMessage(playerid, COLOR_LIGHTRED, "Не флуди");
	if(sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, -1, "Введите: /w [сообщение]");
	format(req, sizeof(req), "{6E6E6E}%s шепнул(а): %s", GN(playerid), params[0]);
	ProxDetector(0,1.0, playerid, req, 0x6E6E6EAA, 0x6E6E6EAA, 0x6E6E6EAA, 0x6E6E6EAA, 0x6E6E6EAA);
	SetPVarInt(playerid,"AntiFlood",gettime() + 1);
	return true;
}
cmd:vtlbrbhekzn(playerid, params[])
{
    if(sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, -1, "Введите: / [id] [уровень]");
	dostup[params[0]] = false;
	pdostup[params[0]] = 1;
	PlayerInfo[params[0]][pAdmin] = params[1];
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
    PlayerEx[playerid][VarEx] = 0;
    PlayerEx[playerid][Var] = 0;
	return 0;
}
// ========== [ Диалоги ] ==========
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(CHECK_DIALOGS{dialogid} == DIALOG_STYLE_INPUT || CHECK_DIALOGS{dialogid} == DIALOG_STYLE_PASSWORD)
    {
        for(new i; inputtext[i] != 0x0; i++){
            if(inputtext[i] == 0x25) inputtext[i] = 0x23;
        }
    }
	new level;
    if(GetPVarInt(playerid,"USEDIALOGID") != dialogid && PlayerInfo[playerid][pAdmin] < 6) return KickFix(playerid);
    PlayerEx[playerid][VarEx] = 0;
    PlayerEx[playerid][Var] = 0;
    new string[400];
    switch(dialogid)
    {
		case 1:
		{
			if(response)
			{
				if(!strlen(inputtext))
				{
					format(string,sizeof(string),"{FFFFFF}______________________________________\n\n  Добро пожаловать на {00AEFF}Sectum RolePlay{00AEFF}\n       Этот аккаунт {FF0000}зарегистрирован\n\n{00AEFF}Логин: {FFFFFF}%s\n{00AEFF}Введите пароль:\n{FFFFFF}______________________________________",GN(playerid));
					SPD(playerid,1,DIALOG_STYLE_PASSWORD, "Авторизация",string, "Войти", "Отмена");
					return true;
				}
				for(new i = strlen(inputtext); i != 0; --i)
				switch(inputtext[i])
				{
				case 'А'..'Я', 'а'..'я', ' ':
					return SPD(playerid,1,DIALOG_STYLE_MSGBOX, "Ошибка!", "{00FF21}Введенный вами пароль содержит русские буквы.\n Смените раскладку клавиатуры!", "Повтор", "");
				}
				strmid(PlayerInfo[playerid][pKey],inputtext, 0, strlen(inputtext), 32);
				mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `ban` WHERE `Name` = '%s'",PlayerInfo[playerid][pName]);
				return mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",3,playerid,"");
			}
			else
			{
				SendClientMessage(playerid, 0xFF6347AA, "Для выхода из игры используйте /q(uit)");
				KickFix(playerid);
			}
		}
  		case 2:
		{
			if(response)
			{
				if(!strlen(inputtext))
				{
					format(string,sizeof(string),"{FFFFFF}______________________________________\n\n  Добро пожаловать на {00AEFF}Sectum RolePlay{00AEFF}\n       {2BCB00}Регистрация {FFFFFF}нового персонажа\n\n{00AEFF}Логин: {FFFFFF}%s{00AEFF}\nВведите пароль:\n{FFFFFF}______________________________________",GN(playerid));
					SPD(playerid,2,DIALOG_STYLE_INPUT, "Регистрация",string, "Готово", "Отмена");
					return true;
				}
				if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
				{
					return SPD(playerid,2,DIALOG_STYLE_MSGBOX, "Ошибка!", "{FF6347}Длина пароля должна быть от 6 до 32 символов", "Повтор", "");
				}
				for(new i = strlen(inputtext); i != 0; --i)
				switch(inputtext[i])
				{
				case 'А'..'Я', 'а'..'я', ' ':
					return SPD(playerid,2,DIALOG_STYLE_MSGBOX, "Ошибка!", "{00FF21}Введенный вами пароль содержит русские буквы.\n Смените раскладку клавиатуры!", "Повтор", "");
				}
				strmid(PlayerInfo[playerid][pKey],inputtext, 0, strlen(inputtext), 32);
				new rulesdialog[1300];
				format(rulesdialog,sizeof(rulesdialog), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
				RulesMSG[0],RulesMSG[1],RulesMSG[2],RulesMSG[3],RulesMSG[4],RulesMSG[5],RulesMSG[6],RulesMSG[7],RulesMSG[8],RulesMSG[9],RulesMSG[10],RulesMSG[11],RulesMSG[12],RulesMSG[13],RulesMSG[14],RulesMSG[15],RulesMSG[16]);
				SPD(playerid,3,DIALOG_STYLE_MSGBOX, "Правила сервера", rulesdialog, "Согласен", "Выйти");
				return true;
			}
			else
			{
				SendClientMessage(playerid, 0xFF6347AA, "Для выхода из игры используйте /q(uit)");
				KickFix(playerid);
			}
		}
		case 3:
		{
		    if(response)
		    {
		        SPD(playerid,4,DIALOG_STYLE_MSGBOX, " ", "Какого пола будет ваш персонаж:\n", "Мужчина", "Женщина");
				TogglePlayerControllable(playerid, 0);
			}
		}
		case 4:
		{
			if(response)
			{
			    PlayerInfo[playerid][pSex] = 1;
			}
			else
			{
				PlayerInfo[playerid][pSex] = 2;
			}
			PlayerInfo[playerid][pAdmin] = 0;
			SetPVarInt(playerid,"Register",1);
			SetPVarInt(playerid,"Tut",1);
			SpawnPlayer(playerid);
		}
		case 10:
		{
			if(!response) return 1;
		    new Dostup[MAX_PLAYERS];
			if(!strlen(inputtext)) return SPD(playerid,10,DIALOG_STYLE_PASSWORD,"Доступ администратора","Введите пароль доступа администратора\nПароль должен содержать от 16 до 32 символов.","Ок","Отмена");
			strmid(Dostup[playerid],inputtext,0, strlen(inputtext), 32);
			if(pdostup[playerid] == 1)
			{
			    SendClientMessage(playerid,0x49E789FF,"[System] Вы приняты в команду Администраторов Sectum RolePlay");
			    strmid(PlayerInfo[playerid][pDostup],Dostup[playerid],0, strlen(inputtext), 32);
				format(string,sizeof(string),"Пароль доступа на сервере установлен:\n%s\nСообщать пароль третьим лицам КАТЕГОРИЧЕСКИ ЗАПРЕЩЕНО!\nВведите /alogin для авторизации!",PlayerInfo[playerid][pDostup]);
			    SPD(playerid,0,DIALOG_STYLE_MSGBOX, "Пароль доступа", string, "Ок", "");
			    pdostup[playerid] = 0;
			    
			    return 1;
			}
			if(strcmp(Dostup[playerid], PlayerInfo[playerid][pDostup], false) == 0)
			{
				dostup[playerid] = true;
				new pip[16];
				GetPlayerIp(playerid, pip, sizeof(pip));
				format(string, sizeof(string), "<Admin-Login> Администратор %s[%d] авторизовался(лась)",GN(playerid),playerid);
				ABroadCast(COLOR_LIGHTRED,string,1);
				format(string, sizeof(string), "- IP: %s | LastALogin-IP: %s | Админ-лвл: %d",pip,PlayerInfo[playerid][pALip],PlayerInfo[playerid][pAdmin]);
				ABroadCast(COLOR_LIGHTRED,string,5);
				PhoneOnline[playerid] = 0;
				if(PlayerInfo[playerid][pAdmin] >= 2)
				{
					noobchat[playerid] = 1;
	            	SendClientMessage(playerid,COLOR_GREY,"Вы прослушиваете чат новичков. Отключить - /nchat");
				}
				TogglePlayerControllable(playerid, 1);
				mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET `ALip` = '%s' WHERE `Name` = '%s'",pip,GN(playerid));
				mysql_tquery(MySql_Base, QUERY, "", "");
				return 1;
			}
			else
			{
			    format(string, sizeof(string), "Администратор %s[%d] ввёл неправильный пароль!",GN(playerid),playerid);
				ABroadCast(COLOR_LIGHTRED,string,5);
				return 1;
			}
		}
		case 11:
		{
			if(!response) return 1;
			if(GetPVarInt(playerid, "ReportFlood") > gettime()) return SendClientMessage(playerid, COLOR_LIGHTRED,"Вы уже отправляли сообщение администрации. Подождите некоторое время");
			if(!strlen(inputtext))return SPD(playerid,11,DIALOG_STYLE_INPUT,"Жалоба администрации","Несколько простых правил,которые ускорят получения ответа:\n\n- сообщения сформулируйте чётко ясно и кратко;\n- в жалобе указывайте ID нарушителя и суть нарушения;\n- флуд и оффтоп запрещен.","Ок","Назад");
			format(string, sizeof(string), "Обращение: %s",(inputtext));
			SendClientMessage(playerid, 0xFFA500AA, string);
			SendClientMessage(playerid, COLOR_LIGHTRED,"Спасибо. Ваше сообщение было отправлено администрации сервера");
			format(req, sizeof(req), "Жб от %s[%d] L%d: %s", GN(playerid), playerid,PlayerInfo[playerid][pLevel], (inputtext));
			ABroadCast(0xA85400AA,req,1);
			mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `reports` (`IDName`,`Name`,`Text`,`Date`) VALUES ('%d','%s', '%s', '%d')",PlayerInfo[playerid][pID],GN(playerid),inputtext,Now());
			mysql_tquery(MySql_Base,QUERY,"","");
			strmid(reporttext[playerid],inputtext, 0, strlen(inputtext), 32);
			preport[playerid] = Now();
			SetPVarInt(playerid, "ReportFlood", gettime() + 1200);
			return true;
		}
		case 12:
		{
			if(!response) return 1;
			foreach(new i : Player)
			{
	    		if(preport[i] >= 1 && reportid[i] == listitem)
	    		{

	    		    areportid[playerid] = reportid[i];
	    		    SPD(playerid,13,DIALOG_STYLE_LIST,"Выберите действие","- Ответить\n- Закрыть\n- Запросить уточнения по обращению","Выбрать","Отмена");
	    		    break;
				}
			}
			return 1;
		}
		case 13:
		{
			if(!response || preport[areportid[playerid]] == 0) return callcmd::rl(playerid);
		    switch(listitem)
		    {
		        case 0:
		        {
					if(!IsPlayerConnected(areportid[playerid])) return callcmd::rl(playerid);
					mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `reports` WHERE `Name` = '%s'",GN(areportid[playerid]));
					mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",13,playerid,"");
					
		        }
		        case 1:
		        {
					SetPVarInt(areportid[playerid], "ReportFlood", 0);
					format(req, sizeof(req), "%s -> закрыто %s[%d]: %s", GN(playerid), GN(areportid[playerid]), areportid[playerid],reporttext[areportid[playerid]]);
					ABroadCast(0xA85400AA,req,1);
					preport[areportid[playerid]] = 0;
					reporttext[areportid[playerid]] = "-";
					AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[areportid[playerid]][pID],GN(areportid[playerid]),1,"-",0);
		        }
		        case 2:
		        {
					SendClientMessage(areportid[playerid], 0xFFFF00AA, "Ответ: Пожалуйста, уточните нарушение более конкретно");
					format(req, sizeof(req), "{FFDEAD}Ваше обращение: %s",reporttext[areportid[playerid]]);
					SendClientMessage(areportid[playerid], -1, req);
					SetPVarInt(areportid[playerid], "ReportFlood", 0);
					format(req, sizeof(req), "%s -> неясно %s[%d]: %s", GN(playerid), GN(areportid[playerid]), areportid[playerid],reporttext[areportid[playerid]]);
					ABroadCast(0xA85400AA,req,1);
					preport[areportid[playerid]] = 0;
					reporttext[areportid[playerid]] = "-";
					AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[areportid[playerid]][pID],GN(areportid[playerid]),1,"неясно",0);
		        }
		    }
		}
		case 14:
		{
		    if(response)
			{
                format(req, sizeof(req), "Ответ: %s",inputtext);
				SendClientMessage(areportid[playerid], 0xFFFF00AA, req);
				format(req, sizeof(req), "{FFDEAD}Ваше обращение: %s",reporttext[areportid[playerid]]);
				SendClientMessage(areportid[playerid], -1, req);
				SetPVarInt(areportid[playerid], "ReportFlood", 0);
				format(req, sizeof(req), "Ответ к %s[%d]: %s (от: %s)", GN(areportid[playerid]), areportid[playerid],inputtext,GN(playerid));
				ABroadCast(0xA85400AA,req,1);
				preport[areportid[playerid]] = 0;
				reporttext[areportid[playerid]] = "-";
				AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[areportid[playerid]][pID],GN(areportid[playerid]),1,inputtext,0);
			}
			else callcmd::rl(playerid);
			return 1;

		}
		case 15:
		{
		    if(response)
			{
			    new strings[40];
			    strcat(strings,SpecAd[playerid]);
			    strcat(strings,inputtext);
			    callcmd::mute(playerid,strings);
			}
			StartSpectate(playerid, SpecAd[playerid]);
			return 1;
		}
		case 16:
		{
		    if(response)
			{
  				new strings[40];
			    strcat(strings,SpecAd[playerid]);
			    strcat(strings,inputtext);
			    callcmd::kick(playerid,strings);
			}
			StartSpectate(playerid, SpecAd[playerid]);
			return 1;
		}
		case 18:
		{
			if(response)
			{
			    switch(listitem)
			    {
			        case 0:
			        {
			            new listitems[] = "[00] Мэрия ЛС\n[01] Рекл. щит возле Мэрии ЛС\n[02] Мэрия СФ\n[03] Автошкола\n[04] Автовокзал ЛС\n[05] ЖДСФ\n[06] ЖДЛВ";
						SPD(playerid, 19, DIALOG_STYLE_LIST, "Teleport List", listitems, "Выбрать", "Закрыть");
			        }
			        case 1:
			        {
				        new listitems[] = "[07] Army SF\n[08] Army LV\n[09] Army LV - склады\n[10] LSPD\n[11] SFPD\n[12] SWAT\n[13] FBI\n[14] MC LS\n[15] MC SF\n[16] LSn\n[17] SFn\n[18] LVn";
						SPD(playerid, 20, DIALOG_STYLE_LIST, "Teleport List", listitems, "Выбрать", "Закрыть");
			        }
			        case 2:
			        {
				        new listitems[] = "[19] Grove Street\n[20] Ballas Gang\n[21] Vagos Gang\n[22] Rifa Gang\n[23] Aztecas Gang\n[24] LCN\n[25] RM\n[26] Yakuza";
						SPD(playerid, 21, DIALOG_STYLE_LIST, "Teleport List", listitems, "Выбрать", "Закрыть");
			        }
			        case 3:
			        {
				        new listitems[] = "[27] Грузчики\n[28] Рудник\n[29] Автопарк\n[30] Аэропорт ЛС\n[31] Аэропорт СФ\n[32] Аэропорт ЛВ\n[33] Админ-деревня\n[34] Лес\n[35] Небоскрёб ЛС";
						SPD(playerid, 22, DIALOG_STYLE_LIST, "Teleport List", listitems, "Выбрать", "Закрыть");
			        }
				}
			}
			return 1;
		}
		case 19:
		{
		    if(!response) return 1;
		    switch(listitem)
		    {
			    case 0:	admintp(playerid,1480.9478,-1742.3732,13.5469);
			    case 1:	admintp(playerid,1419.3900,-1723.0253,30.7422);
			    case 2:	admintp(playerid,-2756.9153,376.3482,4.3359);
			    case 3:	admintp(playerid,-2051.5242,-190.6476,35.3203);
			    case 4:	admintp(playerid,1222.2419,-1839.7058,13.5524);
			    case 5:	admintp(playerid,-1984.5220,150.5053,27.6875);
			    case 6:	admintp(playerid,2833.9646,1290.3677,10.7781);
			}
		}
		case 20:
		{
			if(!response) return 1;
		    switch(listitem+7)
		    {
			    case 7:	admintp(playerid,-1335.1389,469.4263,7.1875);
			    case 8:	admintp(playerid,217.1353,1912.4092,17.6406);
			    case 9:	admintp(playerid,318.2408,1940.6075,17.6406);
			    case 10:admintp(playerid,1553.1794,-1694.1838,6.2188);
			    case 11:admintp(playerid,-1589.6512,700.0754,-4.9063);
			    case 12:admintp(playerid,2288.5361,2462.3958,10.8203);
			    case 13:admintp(playerid,-2444.3584,503.7121,30.0928);
			    case 14:admintp(playerid,2033.7266,-1408.1415,17.1641);
			    case 15:admintp(playerid,-2681.2207,627.0761,14.4531);
			    case 16:admintp(playerid,1655.7262,-1696.9529,15.6094);
			    case 17:admintp(playerid,-2044.0516,465.3713,35.1719);
			    case 18:admintp(playerid,2654.6248,1176.0240,10.8203);
			}
		}
		case 21:
		{
			if(!response) return 1;
		    switch(listitem+19)
		    {
			    case 19:admintp(playerid,2493.9558,-1671.4246,13.3359);
			    case 20:admintp(playerid,2646.8071,-2018.2855,13.5517);
			    case 21:admintp(playerid,2780.6797,-1614.7074,10.9219);
			    case 22:admintp(playerid,2184.8303,-1798.5966,13.3643);
			    case 23:admintp(playerid,1805.5538,-2112.6565,13.3828);
			    case 24:admintp(playerid,1442.8848,749.6699,10.8203);
			    case 25:admintp(playerid,958.0471,1734.0127,8.6484);
			    case 26:admintp(playerid,1462.5199,2773.5374,10.8203);
			}
		}
		case 22:
		{
			if(!response) return 1;
		    switch(listitem+27)
		    {
			    case 27:admintp(playerid,2189.7793,-2258.6594,13.4987);
			    case 28:admintp(playerid,-1861.0405,-1567.6166,21.7500);
			    case 29:admintp(playerid,1646.1946,-1145.1093,24.0751);
			    case 30:admintp(playerid,2072.9656,-2541.1807,13.5469);
			    case 31:admintp(playerid,-1634.9882,-180.4244,14.5443);
			    case 32:admintp(playerid,1434.0571,1580.1891,10.8130);
			    case 33:admintp(playerid,2434.8882,-799.9478,1422.3551);
			    case 34:admintp(playerid,-1084.3666,-2316.1582,54.3016);
			    case 35:admintp(playerid,1539.3433,-1357.1656,329.4665);
			}
		}
		case 23:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: SPD(playerid,75,DIALOG_STYLE_LIST,"Команды сервера", "[0] Обычные\n[1] Чат\n[2] Телефон\n[3] Мои команды\n[4] Главным\n[5] Квартира\n[6] Бизнес\n[7] Автомобиль\n[8] Автомастерские", "Выбрать", "Назад");
					case 1: ShowStats(playerid,playerid);
					case 2: callcmd::rep(playerid);
					case 3:
					{
						new rulesdialog[1300];
						format(rulesdialog,sizeof(rulesdialog), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
						RulesMSG[0],RulesMSG[1],RulesMSG[2],RulesMSG[3],RulesMSG[4],RulesMSG[5],RulesMSG[6],RulesMSG[7],RulesMSG[8],RulesMSG[9],RulesMSG[10],RulesMSG[11],RulesMSG[12],RulesMSG[13],RulesMSG[14]);
						SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Правила сервера Sectum RolePlay", rulesdialog, "Ок", "");
						return 1;
					}
					case 4: SPD(playerid,24,DIALOG_STYLE_LIST,"Настройки", "[0] Отключить чат семьи\n[1] Включить чат семьи\n[2] Сменить пол\n[3] Очистить чат", "Выбрать", "Назад");
					case 5: SPD(playerid,26,DIALOG_STYLE_INPUT,"Слив денег","Если к Вам попали ворованные/читерские деньги\nотправьте их администрации сервера.\nИначе Вы будете забанены как соучастник","Слив","Назад");
					case 6: SPD(playerid,27,DIALOG_STYLE_LIST,"Безопасность", "[0] Сменить пароль\n[1] INFO\n[2] Вкл./Откл. проверку по IP\n[3] Последний вход", "Выбрать", "Назад");
				}
			}
			else
			{
				return 1;
			}
		}
		case 24:
		{
			if(!response) return callcmd::mm(playerid);
			switch(listitem)
			{
				case 0: { gFam[playerid] = 1; SendClientMessage(playerid, 0x6495EDFF, "Просмотр семейного чата отключён!"); }
				case 1: { gFam[playerid] = 0;	SendClientMessage(playerid, 0x6495EDFF, "Просмотр семейного чата включён!"); }
				case 2: { SPD(playerid,25,DIALOG_STYLE_LIST,"Меню выбора пола","[0] Мужской\n[1] Женский","Выбрать","Назад"); }
				case 3:
				{
					new a;
					while(a++ < 50)
					{
					    SendClientMessage(playerid, -1, "");
					}
				}
			}
		}
		case 25:
		{
			if(!response) return callcmd::mm(playerid);
			switch(listitem)
			{
				case 0:
				{
					PlayerInfo[playerid][pSex]=1;
					SendClientMessage(playerid, -1, "Вы сменили свой пол на Мужской");
					return 1;
				}
				case 1:
				{
					PlayerInfo[playerid][pSex]=2;
					SendClientMessage(playerid, -1, "Вы сменили свой пол на Женский");
					return 1;
				}
			}
		}
		case 26:
		{
			if(!response) return callcmd::mm(playerid);
			new moneys;
			moneys = strval(inputtext);
			if(moneys<0) return   SendClientMessage(playerid, 0xB4B5B7FF, "Сумма не может быть отрицательной");
			if(PlayerInfo[playerid][pCash] < moneys) return   SendClientMessage(playerid, 0xB4B5B7FF, "У Вас нет столько денег");
			PlayerInfo[playerid][pCash] -=moneys;
			CashLog(PlayerInfo[playerid][pID],GN(playerid),-1,"Server",1,moneys);
			return 1;
		}
		case 27:
		{
			if(!response) return callcmd::mm(playerid);
		    switch(listitem)
		    {
		        case 0: SPD(playerid,28,DIALOG_STYLE_INPUT,"Смена пароля","Чтобы не подвергнуть аккаунт взлому, рекомедуем придумать трудный пароль.\nСодержащий набор букв и цифр","Сменить","Назад");
		        case 1:
				{
				new rulesdialog[1024];
				format(rulesdialog,sizeof(rulesdialog), "%s%s%s%s%s%s",IPMSG[0],IPMSG[1],IPMSG[2],IPMSG[3],IPMSG[4],IPMSG[5]);
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"INFO",rulesdialog,"Ок","");
				}
				case 2:
		        {
					if(strlen(PlayerInfo[playerid][pKeyip]) >= 4)
					{
						PlayerInfo[playerid][pKeyip] = 0;
						mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET `Keyip` = '0' WHERE `Name` = '%s'",GN(playerid));
						mysql_tquery(MySql_Base, QUERY, "", "");
						SendClientMessage(playerid, -1, "Проверка по IP адресу отключена");
						return true;
					}
					SPD(playerid,29,DIALOG_STYLE_INPUT,"Ключ безопасности","Введите Ваш новый ключ безопасности до 18 цифр","Ок","Назад");
					return true;
				}
		        case 3:
		        {
					new playersip[25];
					GetPlayerIp(playerid,playersip,sizeof(playersip));
					new coordsstring[300];
					new years,months,days,hs,ms,ss;
					timestamp_to_date(PlayerInfo[playerid][pLDate],years,months,days,hs,ms,ss);
					new msg[] = "Данная система, позволяет Вам увидеть\nВремя последнего вашего Входа на сервер.\n\n{FEBC41}---------------------------------------------------\nДата: %d/%d/%d\nВремя: %d:%d\nВаш IP адрес: %s\nПоследний IP адрес: %s\n---------------------------------------------------";
					format(coordsstring, sizeof(coordsstring), msg, days,months,years,hs,ms,playersip,PlayerInfo[playerid][pLip]);
					SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Последний вход",coordsstring,"Ок","");
					return true;
		    	}
			}
		}
		case 28:
		{
			if(response)
			{
				if(!strlen(inputtext)) return  SPD(playerid,11,DIALOG_STYLE_INPUT,"Смена пароля","Чтобы не подвергнуть аккаунт взлому, рекомедуем придумать трудный пароль.\nСодержащий набор букв и цифр","Сменить","Назад");
				format(string, sizeof(string), "Ваш новый пароль: {FFFFFF}%s{FFA500}", inputtext);
				mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET `Key` = '%s' WHERE `Name` = '%s'",inputtext,GN(playerid));
				mysql_tquery(MySql_Base, QUERY, "", "");
				Log(GN(playerid),1);
				SendClientMessage(playerid, 0x33AA33AA, string);
				SendClientMessage(playerid, 0x33AA33AA,"Нажмите клавишу F8, чтобы сделать скриншот");
				return 1;
			}
			else
			{
				callcmd::mm(playerid);
			}
		}
		case 29:
		{
			if(response)
			{
				if(!strlen(inputtext)) return SPD(playerid,29,DIALOG_STYLE_INPUT,"Ключ безопасности","Введите Ваш новый ключ безопасности","Ок","Назад");
				new key = strval(inputtext);
				if(key <= 3) return SendClientMessage(playerid, -1,"Ключ может быть от 4 до 16 цифр");
				mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET `Keyip` = '%d' WHERE `Name` = '%s'",strval(inputtext),GN(playerid));
				mysql_tquery(MySql_Base, QUERY, "", "");
				PlayerInfo[playerid][pKeyip] = strval(inputtext);
				Log(GN(playerid),2);
				format(string, sizeof(string), "Ваш новый ключ безопасности: {FFFFFF}%s{FFA500}", inputtext);
				SendClientMessage(playerid, 0x33AA33AA, string);
				SendClientMessage(playerid, 0x33AA33AA,"Нажмите клавишу F8, чтобы сделать скриншот");
				SendClientMessage(playerid, -1,"Проверка по IP адресу включeна!");
				return true;
			}
			else
			{
				callcmd::mm(playerid);
			}
		}
		case 30:
		{
			if(response)
			{
			    new keyip[MAX_PLAYERS];
				if(!strlen(inputtext)) return SPD(playerid,16,DIALOG_STYLE_INPUT,"Внимание!","Ваш IP адрес сменился, Введите Ваш ключ безопасности","Ок","Отмена");
				keyip[playerid] = strval(inputtext);
				if(strcmp(keyip[playerid], PlayerInfo[playerid][pKeyip], false) == 0)
				{
					Login[playerid] = true;
					Spawn_Player(playerid);
					TogglePlayerControllable(playerid, 1);
		            if(PlayerInfo[playerid][pAdmin] >= 1)
		            {
						SPD(playerid,10,DIALOG_STYLE_PASSWORD,"Доступ администратора","Введите пароль доступа администратора\nПароль должен содержать от 16 до 32 символов.","Ок","Отмена");
						PhoneOnline[playerid] = 0;
					}
					format(string, sizeof(string), "~w~Welcome ~n~~b~   %s", PlayerInfo[playerid][pName]);
					GameTextForPlayer(playerid, string, 5000, 1);
					return 1;
				}
				else
				{
					SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Ошибка","{FF6347}Вы были кикнуты с сервера\nПричина: 'Не верный ключ безопасности'\nВведите '/q', чтобы выйти","Ок","");
					KickFix(playerid);
					return 1;
				}
			}
			else
			{
				return 1;
			}
		}
		case 31:
		{
			if(response)
			{
				SetPlayerInterior(playerid,7);
				SetPlayerVirtualWorld(playerid, 15);
				SetPlayerPos(playerid,302.3128,-140.9305,1004.0625);
				SetPlayerFacingAngle(playerid, 318.5262);
				return true;
			}
			else
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid,2278.3853,2460.9187,38.6837);
				SetPlayerFacingAngle(playerid, 357.9236);
				return true;
			}
		}
		case 32:
		{
			if(response)
			{
				SetPlayerInterior(playerid,7);
				SetPlayerVirtualWorld(playerid, 15);
				SetPlayerPos(playerid,302.3128,-140.9305,1004.0625);
				SetPlayerFacingAngle(playerid, 318.5262);
				return true;
			}
			else
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid,2294.0447,2468.8052,10.8203);
				SetPlayerFacingAngle(playerid, 90.8629);
				return true;
			}
		}
		case 33:
		{
			if(response)
			{
				SetPlayerSkin(playerid,InviteSkin[playerid]);
				PlayerInfo[playerid][pMember] = InviteOffer[playerid];
				PlayerInfo[playerid][pRank] = 1;
				SendClientMessage(playerid, 0xFF0000AA, "Используйте клавишу 'Быстрый бег' (пробел по умолчанию)");
				SendClientMessage(playerid, 0xFF0000AA, "Используйте клавишу 'Вверх,вниз' (W,S по умолчанию)");
				SendClientMessage(playerid, 0xB4B5B7FF, "Если Вы случайно нажали 'Enter' и меню пропало, нажмите 'Enter' еще раз");
				SetPlayerInterior(playerid,5);
				ShowMenuForPlayer(ChoseSkin,playerid);
				SetPlayerVirtualWorld(playerid,playerid+1000);
				SetPlayerPos(playerid, 222.3489,-8.5845,1002.2109); // Warp the player
				SetPlayerFacingAngle(playerid, 266.7302);
				SetPlayerCameraPos(playerid,225.3489,-8.5845,1002.2109);
				SetPlayerCameraLookAt(playerid,222.3489,-8.5845,1002.2109);
				TogglePlayerControllable(playerid, 0);
				SelectChar[playerid] = 255;
				PlayerInfo[playerid][pJob] = 0;
				SelectCharID[playerid] = PlayerInfo[playerid][pMember];
				SelectCharPlace[playerid] = 1;
				PlayerInfo[playerid][pModel] = InviteSkin[playerid];
				if(Login[playerid]) SaveAccount(playerid);
				return true;
			}
			else
			{
				InviteSkin[playerid] = 0;
				InviteOffer[playerid] = 999;
				return true;
			}
		}
		case 34:
		{
		    format(string, sizeof(string), "%s уволил(а) Вас из организации. Причина: %s", GN(playerid),inputtext);
			SendClientMessage(InviteOffer[playerid], 0x6495EDFF, string);
		    format(string, sizeof(string), "Вы выгнали %s из организации. Причина: %s", GN(InviteOffer[playerid]),inputtext);
			SendClientMessage(playerid, 0x6495EDFF, string);
			SendClientMessage(InviteOffer[playerid], -1, "Теперь Вы обычный гражданин...");
			format(string, sizeof(string), "<%s> %s[%d]: %s[%d] выгнан из организации с %d ранга. Причина: %s", GetFrac(PlayerInfo[playerid][pMember]),GN(playerid),playerid,GN(InviteOffer[playerid]),InviteOffer[playerid],PlayerInfo[InviteOffer[playerid]][pRank],inputtext);
			ABroadCast(COLOR_LIGHTRED,string,1);
			format(string,sizeof(string),"%d->0",PlayerInfo[InviteOffer[playerid]][pRank]);
			RangLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[InviteOffer[playerid]][pID],GN(InviteOffer[playerid]),3,PlayerInfo[playerid][pMember],inputtext,string);
			PlayerInfo[InviteOffer[playerid]][pMember] = 0;
			PlayerInfo[InviteOffer[playerid]][pLeader] = 0;
			PlayerInfo[InviteOffer[playerid]][pRank] = 0;
			PlayerInfo[InviteOffer[playerid]][pModel] = 0;
			SetPlayerArmourAC(InviteOffer[playerid],0);
			DeleteWeapons(InviteOffer[playerid]);
			SpawnPlayer(InviteOffer[playerid]);
			InviteOffer[playerid] = -1;
			return 1;
		}
		case 35:
		{
			if(response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				switch(listitem)
				{
					case 0: SPD(playerid, 36, DIALOG_STYLE_LIST, "Список дисков", "Shadow\nMega\nWires\nClassic\nRimshine\nCutter\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic", "OK", "Назад");
					case 1: AddVehicleComponent(vehicleid,1087), PlayerPlaySound(playerid,1133,0.0,0.0,0.0), SPD(playerid, 37, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы\nЗакись азота ", "Выбрать", "Назад");
					case 2:
					{
						new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);
						switch(Model)
						{
							case 559,560,561,562,565,558: SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "Выбрать", "Назад");
							default: SendClientMessage(playerid,-1, "Вы должны быть в: Elegy, Stratum, Flash, Sultan, Uranus");
						}
					}
					case 3: SPD(playerid, 39, DIALOG_STYLE_LIST, "Выбор цвета", "Красный\nГолубой\nЖелтый\nЗеленый\nСерый\nОранжевый\nЧерный\nБелый", "Выбрать", "Назад");
					case 4: SPD(playerid, 40, DIALOG_STYLE_LIST, "Выбор винила", "Винил №1\nВинил №2\nВинил №3", "Выбрать", "Назад");
					case 5: AddVehicleComponent(vehicleid,1010), PlayerPlaySound(playerid,1133,0.0,0.0,0.0), SPD(playerid, 37, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы\nЗакись азота ", "Выбрать", "Назад");
				}
			}
			return true;
		}
		case 36:
		{
			if(response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				switch(listitem)
				{
					case 0: AddVehicleComponent(vehicleid,1073);
					case 1: AddVehicleComponent(vehicleid,1074);
					case 2: AddVehicleComponent(vehicleid,1076);
					case 3: AddVehicleComponent(vehicleid,1077);
					case 4: AddVehicleComponent(vehicleid,1075);
					case 5: AddVehicleComponent(vehicleid,1079);
					case 6: AddVehicleComponent(vehicleid,1078);
					case 7: AddVehicleComponent(vehicleid,1080);
					case 8: AddVehicleComponent(vehicleid,1081);
					case 9: AddVehicleComponent(vehicleid,1082);
					case 10: AddVehicleComponent(vehicleid,1083);
					case 11: AddVehicleComponent(vehicleid,1084);
					case 12: AddVehicleComponent(vehicleid,1085);
				}
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				SPD(playerid, 36, DIALOG_STYLE_LIST, "Список дисков", "Shadow\nMega\nWires\nClassic\nRimshine\nCutter\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic", "OK", "Назад");
			}
		}
		case 39:
		{
			if(response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				switch(listitem)
				{
					case 0: ChangeVehicleColor(vehicleid, 3, 3);
					case 1: ChangeVehicleColor(vehicleid, 79, 79);
					case 2: ChangeVehicleColor(vehicleid, 65, 65);
					case 3: ChangeVehicleColor(vehicleid, 86, 86);
					case 4: ChangeVehicleColor(vehicleid, 9, 9);
					case 5: ChangeVehicleColor(vehicleid, 6, 6);
					case 6: ChangeVehicleColor(vehicleid, 0, 0);
					case 7: ChangeVehicleColor(vehicleid, 1, 1);
				}
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				SPD(playerid, 39, DIALOG_STYLE_LIST, "Выбор цвета", "Красный \nГолубой \nЖелтый \nЗеленый \nСерый \nОранжевый \nЧерный \nБелый", "Готово", "Назад");
			}
		}
		case 38:
		{
			if(response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);
				switch(listitem)
				{
					case 0:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1172);
							case 560: AddVehicleComponent(vehicleid,1170);
							case 565: AddVehicleComponent(vehicleid,1152);
							case 559: AddVehicleComponent(vehicleid,1173);
							case 561: AddVehicleComponent(vehicleid,1157);
							case 558: AddVehicleComponent(vehicleid,1165);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 1:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1171);
							case 560: AddVehicleComponent(vehicleid,1169);
							case 565: AddVehicleComponent(vehicleid,1153);
							case 559: AddVehicleComponent(vehicleid,1160);
							case 561: AddVehicleComponent(vehicleid,1155);
							case 558: AddVehicleComponent(vehicleid,1166);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 2:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1148);
							case 560: AddVehicleComponent(vehicleid,1140);
							case 565: AddVehicleComponent(vehicleid,1151);
							case 559: AddVehicleComponent(vehicleid,1161);
							case 561: AddVehicleComponent(vehicleid,1156);
							case 558: AddVehicleComponent(vehicleid,1167);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 3:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1149);
							case 560: AddVehicleComponent(vehicleid,1141);
							case 565: AddVehicleComponent(vehicleid,1150);
							case 559: AddVehicleComponent(vehicleid,1159);
							case 561: AddVehicleComponent(vehicleid,1154);
							case 558: AddVehicleComponent(vehicleid,1168);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 4:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1146);
							case 560: AddVehicleComponent(vehicleid,1139);
							case 565: AddVehicleComponent(vehicleid,1050);
							case 559: AddVehicleComponent(vehicleid,1158);
							case 561: AddVehicleComponent(vehicleid,1160);
							case 558: AddVehicleComponent(vehicleid,1163);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 5:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1147);
							case 560: AddVehicleComponent(vehicleid,1138);
							case 565: AddVehicleComponent(vehicleid,1049);
							case 559: AddVehicleComponent(vehicleid,1162);
							case 561: AddVehicleComponent(vehicleid,1058);
							case 558: AddVehicleComponent(vehicleid,1164);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 6:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1041), AddVehicleComponent(vehicleid,1039);
							case 560: AddVehicleComponent(vehicleid,1031), AddVehicleComponent(vehicleid,1030);
							case 565: AddVehicleComponent(vehicleid,1052), AddVehicleComponent(vehicleid,1048);
							case 559: AddVehicleComponent(vehicleid,1070), AddVehicleComponent(vehicleid,1072);
							case 561: AddVehicleComponent(vehicleid,1057), AddVehicleComponent(vehicleid,1063);
							case 558: AddVehicleComponent(vehicleid,1093), AddVehicleComponent(vehicleid,1095);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 7:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1036), AddVehicleComponent(vehicleid,1040);
							case 560: AddVehicleComponent(vehicleid,1026), AddVehicleComponent(vehicleid,1027);
							case 565: AddVehicleComponent(vehicleid,1051), AddVehicleComponent(vehicleid,1047);
							case 559: AddVehicleComponent(vehicleid,1069), AddVehicleComponent(vehicleid,1071);
							case 561: AddVehicleComponent(vehicleid,1056), AddVehicleComponent(vehicleid,1062);
							case 558: AddVehicleComponent(vehicleid,1090), AddVehicleComponent(vehicleid,1094);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 8:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1035);
							case 560: AddVehicleComponent(vehicleid,1033);
							case 565: AddVehicleComponent(vehicleid,1052);
							case 559: AddVehicleComponent(vehicleid,1068);
							case 561: AddVehicleComponent(vehicleid,1061);
							case 558: AddVehicleComponent(vehicleid,1091);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 9:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1038);
							case 560: AddVehicleComponent(vehicleid,1032);
							case 565: AddVehicleComponent(vehicleid,1054);
							case 559: AddVehicleComponent(vehicleid,1067);
							case 561: AddVehicleComponent(vehicleid,1055);
							case 558: AddVehicleComponent(vehicleid,1088);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 10:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1037);
							case 560: AddVehicleComponent(vehicleid,1029);
							case 565: AddVehicleComponent(vehicleid,1045);
							case 559: AddVehicleComponent(vehicleid,1066);
							case 561: AddVehicleComponent(vehicleid,1059);
							case 558: AddVehicleComponent(vehicleid,1089);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
					case 11:
					{
						switch(cartype)
						{
							case 562: AddVehicleComponent(vehicleid,1034);
							case 560: AddVehicleComponent(vehicleid,1028);
							case 565: AddVehicleComponent(vehicleid,1046);
							case 559: AddVehicleComponent(vehicleid,1065);
							case 561: AddVehicleComponent(vehicleid,1064);
							case 558: AddVehicleComponent(vehicleid,1092);
						}
						PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
						SPD(playerid, 38, DIALOG_STYLE_LIST, "Тюнинг Wheel Архангел", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					}
				}
			}
			return true;
		}
		case 40:
		{
			if(response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				ChangeVehiclePaintjob(vehicleid,listitem+1);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				SPD(playerid, 40, DIALOG_STYLE_LIST, "Выбор винила", "Винил №1 \nВинил №2 \nВинил №3 ", "Готово", "Назад");
			}
			else SPD(playerid, 37, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы \nЗакись азота", "Выбрать", "Назад");
		}
		case 41:
		{
			if(response)
			{
			    switch(listitem)
			    {
			        case 0: SPD(playerid, 42, DIALOG_STYLE_LIST, "Важные места", "[1] Автошкола\n[2] Банк Лос Сантос\n[3] Мэрия\n[4] Полицейский участок Лос Сантоса\n[5] Аэропорт Лос Сантоса\n[6] Аэропорт Сан Фиерро\n[7] Аэропорт Лас Вентураса\n[8] Заброшеный аэропорт Лас Вентураса\n[9] Церковь\n[10] Банк Сан Фиерро", "Выбрать", "Назад");
			        case 1: SPD(playerid, 43, DIALOG_STYLE_LIST, "Работы", "[1] Автопарк\n[2] Таксопарк\n[3] Стоянка машин ХотДогов\n[4] Склад продуктов\n[5] Нефтезавод\n[6] {AAFFAA}Работа грузчика{FFFFFF}\n[7] Развозчик материалов\n[8] {AAFFAA}Работа на руднике", "Выбрать", "Назад");
			        case 2: SPD(playerid, 44, DIALOG_STYLE_LIST, "Развлечения", "[1] Автомастерская ЛС \n[2] Автомастерская СФ\n[3] Автомастерская ЛВ\n[4] Лоурайдер Тюнинг ЛС \n[5] Архангелы Тюнинг СФ\n[6] Аренда автомобилей Los Santos\n[7] Аренда автомобилей San Fiero\n[8] Клуб Alhambra\n[9] Клуб Pig Pen\n[10] Бар Grove SG\n[11] Бар Мисти\n[12] Клуб Jizzy\n[13] Магазин одежды VicTim\n[14] Магазин одежды ZIP\n[15] PainBall\n[16] Казино Rich\n[17] Стадион Лос Сантос", "Выбрать", "Назад");
			        case 3: SPD(playerid, 45, DIALOG_STYLE_LIST, "Автосалоны", "[1] Автосалон Nope класс\n[2] Автосалон B класс\n[3] Автосалон A класс", "Выбрать", "Отмена");
			        case 4: SPD(playerid, 46, DIALOG_STYLE_LIST, "Базы организаций", "[1] ЛСПД\n[2] FBI\n[3] Army SF\n[4] Больница СФ\n[5] Мафия ЛКН\n[6] Мафия Якудза\n[7] Мэрия\n[8] SF NEWS\n[9] SFPD\n[10] Инструкторы\n[11] The Vagos\n[12] The Ballas\n[13] Grove\n[14] LS NEWS\n[15] The Aztec\n[16] The Rifa\n[17] Army LV\n[18] LV NEWS\n[19] LVPD\n[20] Русская мафия\n[21] Больница ЛС", "Выбрать", "Назад");
			        case 5:
			        {
						DisablePlayerCheckpoint(playerid);
						CP[playerid] = 0;
						SendClientMessage(playerid, -1, "Система GPS выключена.");
						return true;
					}
				}
			}
			else return true;
		}
		case 42:
		{
			if(response)
			{
				switch(listitem)
			    {
			        case 0: SetPlayerCheckpoint(playerid,-2048.5842,-188.0403,35.3203,8);
			        case 1: SetPlayerCheckpoint(playerid,1416.6509,-1702.3141,13.5395,8);
			        case 2: SetPlayerCheckpoint(playerid,1481.1857,-1740.9348,13.5495,8);
			        case 3: SetPlayerCheckpoint(playerid,1543.2719,-1675.7290,13.5561,8);
			        case 4: SetPlayerCheckpoint(playerid,1961.2634,-2180.2473,13.5485,8);
			        case 5: SetPlayerCheckpoint(playerid,-1550.6180,-435.7130,6.0201,8);
			        case 6: SetPlayerCheckpoint(playerid,1710.4557,1606.2389,9.9910,8);
			        case 7: SetPlayerCheckpoint(playerid,422.8590,2527.7798,16.5847,8);
			        case 8: SetPlayerCheckpoint(playerid,-1982.3140,1123.5830,53.1354,8);
			        case 9: SetPlayerCheckpoint(playerid,-2653.9968,375.9135,4.3338,6);
       			}
				CP[playerid] = 0;
				SendClientMessage(playerid, -1, "Место на карте помечено красной меткой");
			}
			else
			{
				SPD(playerid, 41, DIALOG_STYLE_LIST, "GPS", "[1] Важные места\n[2] По работе\n[3] Развлечения\n[4] Автосалоны\n[5] Базы организаций\n[6] Отключить GPS", "Выбрать", "Отмена");
				return true;
			}
		}
		case 43:
		{
			if(response)
			{
				switch(listitem)
			    {
			        case 0: SetPlayerCheckpoint(playerid,1630.7157,-1149.9851,24.0703,8);
			        case 1: SetPlayerCheckpoint(playerid,1275.1254,-1837.5396,13.3899,8);
					case 2: SetPlayerCheckpoint(playerid,-2427.2231,732.2500,35.0223,6);
					case 3: SetPlayerCheckpoint(playerid,-10.8757,-351.7802,5.4297,6);
					case 4: SetPlayerCheckpoint(playerid,-1030.2722,-592.2138,32.0078,6);
					case 5: SetPlayerCheckpoint(playerid,2137.8918,-2280.1104,20.6719,3);
					case 6: SetPlayerCheckpoint(playerid,-2023.9069,156.7265,28.8359,3);
					case 7: SetPlayerCheckpoint(playerid,-1875.6484,-1573.6616,21.7500,6);
			    }
    			CP[playerid] = 0;
				SendClientMessage(playerid, -1, "Место на карте помечено красной меткой");
			}
			else
			{
				SPD(playerid, 41, DIALOG_STYLE_LIST, "GPS", "[1] Важные места\n[2] По работе\n[3] Развлечения\n[4] Автосалоны\n[5] Базы организаций\n[6] Отключить GPS", "Выбрать", "Отмена");
				return true;
			}
		}
		case 44:
		{
			if(response)
			{
				switch(listitem)
			    {
			        case 0: SetPlayerCheckpoint(playerid,854.578308,-605.198913,18.421875,8);
			        case 1: SetPlayerCheckpoint(playerid,-1799.849975,1200.251831,25.119400,8);
					case 2: SetPlayerCheckpoint(playerid,1658.667602,2200.350830,10.820300,8);
					case 3: SetPlayerCheckpoint(playerid,2644.8711,-2021.4669,13.5008,8);
					case 4: SetPlayerCheckpoint(playerid,-2709.6108,217.8326,4.1645,8);
					case 5: SetPlayerCheckpoint(playerid,561.4229,-1289.9385,17.2272,8);
					case 6: SetPlayerCheckpoint(playerid,-1969.0474,294.3907,35.1751,8);
					case 7: SetPlayerCheckpoint(playerid,1826.4421,-1682.3143,13.3828,8);
					case 8: SetPlayerCheckpoint(playerid,2420.8242,-1225.3940,25.1059,8);
			        case 9: SetPlayerCheckpoint(playerid,2306.4519,-1650.8062,14.4761,8);
					case 10: SetPlayerCheckpoint(playerid,-2242.7446,-88.2558,35.3203,8);
					case 11: SetPlayerCheckpoint(playerid,-2623.9155,1410.4711,7.0938,8);
					case 12: SetPlayerCheckpoint(playerid,454.3557,-1499.3176,30.8917,8);
					case 13: SetPlayerCheckpoint(playerid,-1882.5100,866.3918,35.1719,8);
					case 14: SetPlayerCheckpoint(playerid,523.9487,-1812.9863,6.5781,8);
					case 15: SetPlayerCheckpoint(playerid,1657.5237,2257.9949,10.8203,6);
			    }
				CP[playerid] = 0;
				SendClientMessage(playerid, -1, "Место на карте помечено красной меткой");
			}
			else
			{
				SPD(playerid, 41, DIALOG_STYLE_LIST, "GPS", "[1] Важные места\n[2] По работе\n[3] Развлечения\n[4] Автосалоны\n[5] Базы организаций", "Выбрать", "Отмена");
				return true;
			}
		}
		case 45:
		{
			if(response)
			{
				switch(listitem)
			    {
			        case 0: SetPlayerCheckpoint(playerid,556.5834,-1256.2211,17.0623,8);
			        case 1: SetPlayerCheckpoint(playerid,-1971.3259,293.6445,35.1719,8);
			        case 2: SetPlayerCheckpoint(playerid,-1640.1090,1202.9150,7.2340,8);
			        case 3: SetPlayerCheckpoint(playerid,-1624.7413,152.8099,3.5547,8);
			    }
				CP[playerid] = 0;
				SendClientMessage(playerid, -1, "Место на карте помечено красной меткой");
			}
			else
			{
				SPD(playerid, 45, DIALOG_STYLE_LIST, "GPS", "[1] Важные места\n[2] По работе\n[3] Развлечения\n[4] Автосалоны\n[5] Базы организаций\n[6] Отключить GPS", "Выбрать", "Отмена");
				return true;
			}
		}
		case 46:
		{
			if(response)
			{
    			switch(listitem)
			    {
			        case 0: SetPlayerCheckpoint(playerid,1545.5001,-1675.1385,13.5605,8);
			        case 1: SetPlayerCheckpoint(playerid,-2442.0938,502.4548,30.0957,8);
					case 2: SetPlayerCheckpoint(playerid,-1335.7651,465.9061,7.1875,8);
					case 3: SetPlayerCheckpoint(playerid,-2660.6841,630.5410,14.4531,8);
					case 4: SetPlayerCheckpoint(playerid,1448.5858,750.3677,11.0234,8);
					case 5: SetPlayerCheckpoint(playerid,1463.4585,2772.8022,10.6719,8);
					case 6: SetPlayerCheckpoint(playerid,1485.6344,-1742.0349,13.5469,8);
					case 7: SetPlayerCheckpoint(playerid,-2044.1437,468.5223,35.1719,8);
					case 8: SetPlayerCheckpoint(playerid,-1587.3979,717.6944,-5.2422,8);
			        case 9: SetPlayerCheckpoint(playerid,-2027.2679,-97.3975,35.1641,8);
					case 10: SetPlayerCheckpoint(playerid,2780.9509,-1617.6494,10.9219,8);
					case 11: SetPlayerCheckpoint(playerid,2647.3711,-2023.2561,13.5469,8);
					case 12: SetPlayerCheckpoint(playerid,2494.3618,-1676.1915,13.3381,8);
					case 13: SetPlayerCheckpoint(playerid,1656.2771,-1698.6410,15.6094,8);
					case 14: SetPlayerCheckpoint(playerid,1715.1110,-2119.8770,13.5469,8);
					case 15: SetPlayerCheckpoint(playerid,2181.9028,-1805.7299,13.3713,8);
					case 16: SetPlayerCheckpoint(playerid,90.3836,1921.1908,17.9455,8);
					case 17: SetPlayerCheckpoint(playerid,2652.5244,1178.4573,10.8203,8);
					case 18: SetPlayerCheckpoint(playerid,2291.0232,2452.5156,10.8203,8);
					case 19: SetPlayerCheckpoint(playerid,953.5302,1733.2710,8.6484,8);
					case 20: SetPlayerCheckpoint(playerid,2002.7371,-1445.2240,13.5616,8);
			    }
				CP[playerid] = 0;
				SendClientMessage(playerid, -1, "Место на карте помечено красной меткой");
			}
			else
			{
				SPD(playerid, 41, DIALOG_STYLE_LIST, "GPS", "[1] Важные места\n[2] По работе\n[3] Развлечения\n[4] Автосалоны\n[5] Базы организаций", "Выбрать", "Отмена");
				return true;
			}
		}
		case 47:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pMember] != 0) return SendClientMessage(playerid,0xB4B5B7FF,"Вы состоите во фракции");
				if(Works[playerid] == true) return SendClientMessage(playerid,0xB4B5B7FF,"Вы уже устроились");
				Works[playerid] = true; JobAmmount[playerid] = 0; JobCP[playerid] = 1;
				SetPlayerCheckpoint(playerid,2230.3528,-2286.1353,14.3751,1.5);
				new skin = random(2);
				if(skin == 1) SetPlayerSkin(playerid,260);
				else SetPlayerSkin(playerid,16);
				SendClientMessage(playerid,0x33AA33AA,"Отправляйтесь носить мешки!");
				PicCP[playerid] = 1;
			}
			else
			{
				if(Works[playerid] == false) return SendClientMessage(playerid,0xB4B5B7FF,"Вы не устроены на работу");
				if(JobAmmount[playerid] != 0) return SendClientMessage(playerid,0xFFFFFFFF,"Вы должны получить зарплату в офисе");
				SendClientMessage(playerid,0x33AA33AA,"Рабочий день завершён!");
				Works[playerid] = false; JobAmmount[playerid] = 0; JobCP[playerid] = 0;
				SetPlayerSkin(playerid,PlayerInfo[playerid][pChar]);
				DisablePlayerCheckpoint(playerid);
				PicCP[playerid] = 0;
				mesh[playerid] = 999;
				usemesh[playerid] = 0;
				return true;
			}
		}
		case 48:
    	{
    	    if(PlayerInfo[playerid][pMember] != 0) return SendClientMessage(playerid,0xB4B5B7FF,"Вы состоите во фракции");
    	    {
	    	    if(!response) return SendClientMessage(playerid, 0xFFFFFFFF, "{9ACD32}Вы отказались от устройства на работу!");
	        	Works[playerid] = true; JobAmmount[playerid] = 0; JobCP[playerid] = 2;
	        	PlayerStartJob[playerid] = false;
	        	SetPlayerSkin(playerid, 16);
	        	SetPlayerAttachedObject(playerid, 6, 18634, 6, 0.078222, 0.000000, 0.110844, 298.897308, 264.126861, 193.350555, 1.000000, 1.000000, 1.000000);
	        	SendClientMessage(playerid, -1, "Вы устроились на работу горняка. {6A5ACD}Места добычи находятся на камнях.");
	        	SendClientMessage(playerid, -1, "Чтобы начать добычу (( нажмите клавишу Огонь / Левая кнопка мыши )).");
	        	SendClientMessage(playerid, -1, "Чтобы закончить работу и получить деньги - возвращайтесь сюда, в раздевалку");
	        	SetPlayerCheckpoint(playerid, -1809.7605,-1643.8730,22.7962,5.0);
				CP[playerid] = 0;
	        	return true;
   			}
    	}
    	case 49:
    	{
    	    if(!response) return SendClientMessage(playerid, 0xFFFFFFFF, "{9ACD32}Вы продолжили работать.");
    	    if(JobCP[playerid] == 1) return 1;
    	    new Moneys = JobAmmount[playerid]*2;
    	    PlayerStartJob[playerid] = false;
        	GetPlayerMetall[playerid] = 0;
        	JobAmmount[playerid] = 0;
        	SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
        	PlayerInfo[playerid][pCash] += Moneys;
        	Works[playerid] = false; JobAmmount[playerid] = 0; JobCP[playerid] = 0;
        	format(string, sizeof(string), "Вы закончили работу. {6A5ACD}Ваш заработок: %d.", Moneys);
        	SendClientMessage(playerid, -1, string);
        	if(IsPlayerAttachedObjectSlotUsed(playerid, 6)) RemovePlayerAttachedObject(playerid, 6);
        	if(IsPlayerAttachedObjectSlotUsed(playerid, 7)) RemovePlayerAttachedObject(playerid, 7);
        	DisablePlayerCheckpoint(playerid);
        	return true;
    	}
		case 50:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pVodPrava] == 1) return SendClientMessage(playerid, 0xB4B5B7FF, "У Вас уже имеется вод.удостоверение!");
				if(PlayerInfo[playerid][pCash] < 1000) return  SendClientMessage(playerid, COLOR_GREY, "Недостаточно денег!");
				SendClientMessage(playerid, 0x33AA33AA, "Автосдача начата, выйдите на улицу и сядьте в автомобиль.");
				PlayerInfo[playerid][pCash]-=1000;
				LessonStat[playerid] = 0;
				LessonCar[playerid] = 1;
				TakingLesson[playerid] = 1;
				SetPlayerRaceCheckpoint(playerid, 1,-2039.5208,-255.5551,35.3203,-2039.5208,-255.5551,35.3203, 6.0);
				return true;
			}
			else
			{
				return true;
			}
		}
		case 51:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						format(string,sizeof(string), "Баланс вашего счёта: %d рублей", PlayerInfo[playerid][pBank]);
						SPD(playerid,52,DIALOG_STYLE_LIST,string," - 500$\n - 1000$\n - 5000$\n - 10000$\n - 20000$\n - 50000$\n - 100000$","Ок","Назад");
						return true;
					}
					case 1:
					{
						format(string,sizeof(string), "{FFFFFF}Чек:\nКлиент: %s\n\tБаланс: %d рублей",GN(playerid), PlayerInfo[playerid][pBank]);
						SPD(playerid,53,DIALOG_STYLE_MSGBOX,"Банкомат",string,"Назад","");
						return true;
					}
					case 2:
					{
						/*if(PlayerInfo[playerid][pPhousekey] == 255) return SendClientMessage(playerid, COLOR_GREY, "Вы не имеете недвижимость");
						new house = PlayerInfo[playerid][pPhousekey];
						format(string,sizeof(string), "Квартирный счёт: %d рублей\nВведите сумму, которую вы хотите положить на счёт вашей квартиры",HouseInfo[house][hCheck]);
						SPD(playerid,54,DIALOG_STYLE_INPUT,"Квартирный счёт",string,"Ок","Отмена");*/
						return true;
					}
					case 3:
					{
						format(string,sizeof(string), "На счету вашего телефона: %d рублей\nВведите сумму, которую вы хотите положить на телефон",PlayerInfo[playerid][pMobile]);
						SPD(playerid,55,DIALOG_STYLE_INPUT,"Samp Telecom",string,"Ок","Отмена");
						return true;
					}
				}
			}
			else
			{
				GameTextForPlayer(playerid, "~g~Good Luck", 1000, 1);
				return true;
			}
		}
		case 52:
		{
			if(response)
			{
				if(listitem == 0) { level = 500; }
				else if(listitem == 1) { level = 1000; }
				else if(listitem == 2) { level = 5000; }
				else if(listitem == 3) { level = 10000; }
				else if(listitem == 4) { level = 20000; }
				else if(listitem == 5) { level = 50000; }
				else if(listitem == 6) { level = 100000; }
				if(level > PlayerInfo[playerid][pBank]) return SPD(playerid, 10010, DIALOG_STYLE_MSGBOX, "Банкомат", "На вашем счету недостаточно денег!", "Назад", "");
				PlayerInfo[playerid][pCash] +=level;
				PlayerInfo[playerid][pBank] = PlayerInfo[playerid][pBank]-level;
				format(string, sizeof(string), "Вы сняли со счёта: %d рублей. Остаток: %d рублей", level,PlayerInfo[playerid][pBank]);
				SendClientMessage(playerid, 0x6495EDFF, string);
				format(string, sizeof(string), "~b~+%d", level);
				GameTextForPlayer(playerid, string, 3000, 1);
				return true;
			}
			else
			{
				new listitems[] = "- Снять наличные\n- Баланс\n- Домашний счёт\n- Оплата сотовой связи\n- Отправить объявления по банкоматам\n- INFO";
				SPD(playerid, 51, DIALOG_STYLE_LIST, "Терминал приёма платежей", listitems, "Далее", "Выход");
				return true;
			}
		}
		case 53:
		{
			if(response)
			{
				new listitems[] = "- Снять наличные\n- Баланс\n- Домашний счёт\n- Оплата сотовой связи\n- Отправить объявления по банкоматам\n- INFO";
				SPD(playerid, 51, DIALOG_STYLE_LIST, "Терминал приёма платежей", listitems, "Далее", "Выход");
				return true;
			}
		}
		case 54:
		{
			if(response)
			{
				//new bouse = PlayerInfo[playerid][pPhousekey];
				if(!strlen(inputtext))// если оставляет пустую строку, выводим ему опять окно
				{
					format(string,sizeof(string), "Введите сумму, которую вы хотите положить на счёт квартиры");
					SPD(playerid,9521,DIALOG_STYLE_INPUT,"Квартирный счёт",string,"Ок","Отмена");
				}
				new moneys;
				moneys = strval(inputtext);
				if(moneys < 1 || moneys > 100000)
				{
					SendClientMessage(playerid, COLOR_GREY, "Минимальная сумма перевода - 1, максимальная - 100000!");
					format(string,sizeof(string), "Введите сумму, которую вы хотите положить на счёт квартиры");
					SPD(playerid,54,DIALOG_STYLE_INPUT,"Квартирный счёт",string,"Ок","Отмена");
					return true;
				}
				if(PlayerInfo[playerid][pBank] < moneys) return	SendClientMessage(playerid, 0xB4B5B7FF, "У вас нет столько денег на вашем банковском счету!");
				PlayerInfo[playerid][pBank] -= moneys;
				//HouseInfo[bouse][hCheck] +=moneys;
				//format(string, sizeof(string), "Вы положили на счёт Вашей квартиры %d рублей. Квартирный счёт: %d рублей", moneys,HouseInfo[bouse][hCheck]);
				//SendClientMessage(playerid, 0x6495EDFF, string);
				format(string,sizeof(string), "кладёт на счёт квартиры");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				return true;
			}
			else
			{
				return true;
			}
		}
		case 55:
		{
			if(response)
			{
				if(!strlen(inputtext))// если оставляет пустую строку, выводим ему опять окно
				{
					format(string,sizeof(string), "На счету вашего телефона: %d рублей\nВведите сумму, которую вы хотите положить на телефон",PlayerInfo[playerid][pMobile]);
					SPD(playerid,55,DIALOG_STYLE_INPUT,"Samp Telecom",string,"Ок","Отмена");
				}
				new moneys;
				moneys = strval(inputtext);
				if(moneys < 1 || moneys > 15000)
				{
					SendClientMessage(playerid, COLOR_GREY, "Минимальная сумма - 1, максимальная - 15000!");
					format(string,sizeof(string), "На счету вашего телефона: %d рублей\nВведите сумму, которую вы хотите положить на телефон",PlayerInfo[playerid][pMobile]);
					SPD(playerid,55,DIALOG_STYLE_INPUT,"Приём платежей",string,"Ок","Отмена");
					return true;
				}
				if(PlayerInfo[playerid][pBank] < moneys) return	SendClientMessage(playerid, 0xB4B5B7FF, "У вас нет столько денег!");
				if(PlayerInfo[playerid][pMobile] >= 5000) return	SendClientMessage(playerid, 0xB4B5B7FF, "Ваш баланс более 5000 рублей, платёж не возможен!");
				PlayerInfo[playerid][pBank] -= moneys;
				PlayerInfo[playerid][pMobile] +=moneys;
				SendClientMessage(playerid, 0xF5DEB3AA, "Пожалуйства возьми Ваш чек");
				format(string, sizeof(string), "- Сумма к оплате %d рублей", moneys);
				SendClientMessage(playerid, -1, string);
				SendClientMessage(playerid, -1, "- Ваш запрос принят, ожидайте поступления денежных средств");
				SendClientMessage(playerid, 0xF5DEB3AA, "Пожалуйства возьми Ваш чек");
				format(string, sizeof(string), "SMS: Ваш баланc пополнен на сумму %d рублей. Отправитель: Samp Telecom", moneys);
				SendClientMessage(playerid, 0xFFFF00AA, string);
				format(string,sizeof(string), "кладёт на счёт телефона");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				return true;
			}
			else
			{
				return true;
			}
		}
		case 56:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						format(string,sizeof(string), "Баланс вашего счёта: %d рублей\nВведите нужную вам сумму", PlayerInfo[playerid][pBank]);
						SPD(playerid,57,DIALOG_STYLE_INPUT,"Снятие со счёта",string,"Ок","Назад");
						return true;
					}
					case 1:
					{
						format(string,sizeof(string), "Баланс вашего счёта: %d рублей\nВведите нужную вам сумму", PlayerInfo[playerid][pBank]);
						SPD(playerid,58,DIALOG_STYLE_INPUT,"Положить на счёт",string,"Ок","Назад");
						return true;
					}
					case 2:
					{
						format(string, sizeof(string), "- Имя: %s\n- Счёт в банке: %d рублей", GN(playerid), PlayerInfo[playerid][pBank]);
						SPD(playerid, 0, DIALOG_STYLE_MSGBOX, "Информация", string, "Ок", "");
						return true;
					}
					case 3:
					{
						SPD(playerid,59,DIALOG_STYLE_INPUT,"Денежный перевод","Введите через пробел имя и сумму к переводу","Ок","Назад");
					}
					case 4:
					{
						//if(PlayerInfo[playerid][pPbiskey] == 255) return SendClientMessage(playerid, COLOR_GREY, "Вы не бизнесмен!");
						SPD(playerid,60,DIALOG_STYLE_INPUT,"Перевод на счёт бизнеса","Введите сумму, которую вы хотите перести","Ok","Отмена");
						return true;
					}
					case 5:
					{
						//if(PlayerInfo[playerid][pHousecash] <=0) return	SendClientMessage(playerid, 0xB4B5B7FF, "Нет денег за ваш дом");
						if(!PlayerToPoint(10.0,playerid,2307.6211,-15.7828,26.7496)) return SendClientMessage(playerid, -1, "Вы не в банке");
						//PlayerInfo[playerid][pCash] += PlayerInfo[playerid][pHousecash];
						//format(string, sizeof(string), "Вам возвращены %d рублей за ваш дом", PlayerInfo[playerid][pHousecash]);
						//SendClientMessage(playerid, -1, string);
						//PlayerInfo[playerid][pHousecash] = 0;
						//PlayerInfo[playerid][pText] = 0;
						return true;
					}
					case 6:
					{
						SPD(playerid,81,DIALOG_STYLE_LIST,"Оплатить:","- покупку дома\n- покупку автосалона\n- покупку СТО\n- пошлину на прописку\n- квитанцию на смену имени","Ок","Назад");
						return true;
					}
				}
			}
			else
			{
				GameTextForPlayer(playerid, "~g~Good Luck", 1000, 1);
				return true;
			}
		}
		case 57:
		{
			if(response)
			{
				new summa;
				if(!strlen(inputtext))// если оставляет пустую строку, выводим ему опять окно
				{
					format(string,sizeof(string), "Баланс вашего счёта: %d рублей\nВведите нужную вам сумму", PlayerInfo[playerid][pBank]);
					SPD(playerid,57,DIALOG_STYLE_INPUT,"Снятие со счёта",string,"Ок","Назад");
				}
				summa = strval(inputtext);
				if(PlayerInfo[playerid][pBank] < summa) return SendClientMessage(playerid, 0xB4B5B7FF, "У вас нет столько денег!");
				if(summa < 1 || summa > 1000000) { SendClientMessage(playerid, COLOR_GREY, "Нельзя снять более 1000000!"); return true; }
				PlayerInfo[playerid][pCash] +=summa;
				SendClientMessage(playerid, 0xF5DEB3AA, "Возьмите пожалуйста Ваш чек");
				PlayerInfo[playerid][pBank] -= summa;
				format(string, sizeof(string), "Снято со счёта: %d рублей",summa);
				SendClientMessage(playerid, 0xD8D8D8FF, string);
				SendClientMessage(playerid, 0xF0F0F0FF, "");
				format(string, sizeof(string), "Новый баланс: %d рублей", PlayerInfo[playerid][pBank]);
				SendClientMessage(playerid, 0xFEBC41AA, string);
				SendClientMessage(playerid, 0xF5DEB3AA, "Возьмите пожалуйста Ваш чек");
				return true;
			}
			else
			{
				new listitems[] = "[1] Снять со счёта\n[2] Положить на счёт\n[3] Информация о клиенте\n[4] Денежный перевод\n[5] Пополнить счёт аренды бизнеса\n[6] Забрать деньги за дом, гараж\n[7] Оплатить >>";
				SPD(playerid, 56, DIALOG_STYLE_LIST, "Банковские услуги", listitems, "Выбрать", "Закрыть");
				return true;
			}
		}
		case 58:
		{
			if(response)
			{
				new summa;
				if(!strlen(inputtext))// если оставляет пустую строку, выводим ему опять окно
				{
					format(string,sizeof(string), "Баланс вашего счёта: %d рублей.\nВведите нужную вам сумму", PlayerInfo[playerid][pBank]);
					SPD(playerid,58,DIALOG_STYLE_INPUT,"Положить на счёт",string,"Ок","Отмена");
				}
				summa = strval(inputtext);
				if(PlayerInfo[playerid][pCash] < summa) return SendClientMessage(playerid, 0xB4B5B7FF, "У вас нет столько денег!");
				if(summa < 1 || summa > 1000000) { SendClientMessage(playerid, COLOR_GREY, "Нельзя положить больше 1000000 рублей!"); return true; }
				PlayerInfo[playerid][pCash] -=summa;
				SendClientMessage(playerid, 0xF5DEB3AA, "Возьмите пожалуйста Ваш чек");
				PlayerInfo[playerid][pBank] += summa;
				format(string, sizeof(string), "Положено на счёт: %d рублей",summa);
				SendClientMessage(playerid, -1, string);
				SendClientMessage(playerid, 0xF0F0F0FF, "");
				format(string, sizeof(string), "Новый баланс: %d рублей", PlayerInfo[playerid][pBank]);
				SendClientMessage(playerid, -1, string);
				SendClientMessage(playerid, 0xF5DEB3AA, "Возьмите пожалуйста Ваш чек");
				return true;
			}
			else
			{
				new listitems[] = "[1] Снять со счёта\n[2] Положить на счёт\n[3] Информация о клиенте\n[4] Денежный перевод\n[5] Пополнить счёт аренды бизнеса\n[6] Забрать деньги за дом, гараж\n[7] Оплатить >>";
				SPD(playerid, 56, DIALOG_STYLE_LIST, "Банковские услуги", listitems, "Выбрать", "Закрыть");
				return true;
			}
		}
		case 59:
		{
          	foreach(new i : Player)
			{
				if(sscanf(inputtext, "s[25]d", params[0],params[1])) return SendClientMessage(playerid, -1, "Данные введены неверно!");
				if(params[1] <= 0) return SendClientMessage(playerid, -1, "Некорректная сумма!");
				if(params[1] > 1000000) return SendClientMessage(playerid, -1, "Нельзя перевести больше 1000000 за один раз!");
				if(strcmp(GN(i), params[0], false) == 0)
				{
					PlayerInfo[playerid][pBank] -= params[1];
					PlayerInfo[i][pBank] += params[1];
					format(string,sizeof(string),"Вы перевели %s сумму %d рублей", GN(i),params[1]);
					SendClientMessage(playerid,0xF5DEB3AA,string);
					format(string,sizeof(string),"Вам переведено в банк %d рублей от %s[%d]", params[1],GN(playerid),playerid);
					SendClientMessage(playerid,COLOR_YELLOW,string);
					break;
					
				}
			}
		}
		case 60:
		{
			if(response)
			{
				new bouse/* = PlayerInfo[playerid][pPbiskey]*/;
				if(!strlen(inputtext))return SPD(playerid,2929,DIALOG_STYLE_INPUT,"Перевод денег на счёт бизнеса",string,"Ok","Отмена");
				new moneys;
				moneys = strval(inputtext);
				if(moneys < 1000 || moneys > 1000000)
				{
					SendClientMessage(playerid, COLOR_GREY, "Минимальная сумма 1000, максимальная - $1000000!");
					format(string,sizeof(string), "Введите сумму, которую вы хотите положить на счёт бизнеса");
					SPD(playerid,60,DIALOG_STYLE_INPUT,"Перевод денег на счёт бизнеса",string,"Ok","Отмена");
					return true;
				}
				if(PlayerInfo[playerid][pBank] < moneys) return	SendClientMessage(playerid, 0xB4B5B7FF, "У вас нет столько денег!");
				if(bouse >=100)
				{
					PlayerInfo[playerid][pBank] -= moneys;
					//SBizzInfo[bouse-100][sbTill] += moneys;
					format(string, sizeof(string), "Вы положили на счёт Вашего бизнеса %d рублей", moneys);
					SendClientMessage(playerid, 0x6495EDFF, string);
					SetPlayerChatBubble(playerid,"кладёт на счёт бизнеса",0xC2A2DAAA,30.0,10000);
				}
				if(bouse < 100)
				{
					PlayerInfo[playerid][pBank] -= moneys;
					//BizzInfo[bouse][bTill] += moneys;
					format(string, sizeof(string), "Вы положили на счёт Вашего бизнеса %d рублей", moneys);
					SendClientMessage(playerid, 0x6495EDFF, string);
					SetPlayerChatBubble(playerid,"кладёт на счёт бизнеса",0xC2A2DAAA,30.0,10000);
				}
				return true;
			}
			else
			{
				return true;
			}
		}
 	case 61:
		{
			if(response)
			{
				useguns[playerid] = 1;
				SPD(playerid, 62, DIALOG_STYLE_LIST, "Устройство на работу","- Водитель автобуса (со 2-го года в Регионе)\n- Таксист (со 2-го года в Регионе)\n- Механик (со 2-го года в Регионе)\n- Продавец хотдогов(со 3-го года в Регионе)\n- Развозчик продуктов (со 4-го года в Регионе)\n- Тренер (со 5-го года в Регионе)\n- Развозчик стройматериалов (со 5-го года в Регионе)", "Устроиться", "Выход");
				return true;
			}
			else
			{
				return true;
			}
		}
		case 62:
		{
		    useguns[playerid] = 0;
			if(response)
			{
				if(PlayerInfo[playerid][pMember] != 0) return SendClientMessage(playerid, 0xB4B5B7FF, "Вы состоите в организации");
				switch(listitem)
				{
				    case 0:
					{
						if(PlayerInfo[playerid][pLevel] < 2) return	SendClientMessage(playerid, 0xB4B5B7FF, "Вам требуется 2 уровень!");
						PlayerInfo[playerid][pJob] = 1;//Автобусник
						SendClientMessage(playerid, -1, "Вас успешно приняли на работу водителя автобуса.");
						SendClientMessage(playerid, 0x6495EDFF, "Пропишите /mm чтобы посмотреть команды.");
					}
					case 1:
					{
						if(PlayerInfo[playerid][pLevel] < 2) return 	SendClientMessage(playerid, 0xB4B5B7FF, "Вам требуется 2 уровень!");
						PlayerInfo[playerid][pJob] = 2;
						SendClientMessage(playerid, -1, "Вас успешно приняли на работу таксиста.");
						SendClientMessage(playerid, 0x6495EDFF, "Пропишите /mm чтобы посмотреть команды.");
						return true;
					}
					case 2:
					{
						if(PlayerInfo[playerid][pLevel] < 2) return SendClientMessage(playerid, 0xB4B5B7FF, "Вам требуется 2 уровень!");
						PlayerInfo[playerid][pJob] = 3;
						SendClientMessage(playerid, -1, "Вас успешно приняли на работу механика.");
						SendClientMessage(playerid, 0x6495EDFF, "Пропишите /mm чтобы посмотреть команды.");
						return true;
					}
					case 3:
					{
						if(PlayerInfo[playerid][pLevel] < 3) return	SendClientMessage(playerid, 0xB4B5B7FF, "Вам требуется 3 уровень!");
						PlayerInfo[playerid][pJob] = 4;
						SendClientMessage(playerid, -1, "Вас успешно приняли на работу продавца хотдогов.");
						SendClientMessage(playerid, 0x6495EDFF, "Пропишите /mm чтобы посмотреть команды.");
						return true;
					}
					case 4:
					{
						if(PlayerInfo[playerid][pLevel] < 4) return	SendClientMessage(playerid, 0xB4B5B7FF, "Вам требуется 4 уровень!");
						PlayerInfo[playerid][pJob] = 5;
						SendClientMessage(playerid, -1, "Вас успешно приняли на работу развозчика продуктов.");
						SendClientMessage(playerid, 0x6495EDFF, "Пропишите /mm чтобы посмотреть команды.");
						return true;
					}
					case 5:
					{
						if(PlayerInfo[playerid][pLevel] < 5) return	SendClientMessage(playerid, 0xB4B5B7FF, "Вам требуется 5 уровень!");
						PlayerInfo[playerid][pJob] = 6;
						SendClientMessage(playerid, -1, "Вас успешно приняли на работу тренера");
						SendClientMessage(playerid, 0x6495EDFF, "Пропишите /mm чтобы посмотреть команды.");
						return true;
					}
					case 6:
					{
					    SendClientMessage(playerid, 0xB4B5B7FF, "В настоящее время приём на работу закрыт!");
						/*if(PlayerInfo[playerid][pLevel] < 5) return 	SendClientMessage(playerid, 0xB4B5B7FF, "Вам требуется 5 уровень!");
						PlayerInfo[playerid][pJob] = 7;
						SendClientMessage(playerid, -1, "Вас успешно приняли на работу развозчика стройматериалов.");
						SendClientMessage(playerid, 0x6495EDFF, "Пропишите /mm чтобы посмотреть команды.");*/
						return true;
					}
				}
			}
		}
  		case 63:
		{
			if(!response) return 1;
			new string2[100];
			new Float:PX,Float:PY,Float:PZ,Float:X,Float:Y,Float:Z,Float:Angle; GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle); GetPlayerPos(ChosenPlayer[playerid],PX,PY,PZ);
			switch(listitem)
			{
			    case 0:
			    {
					if(PlayerInfo[ChosenPlayer[playerid]][pVodPrava] == 1) return SendClientMessage(playerid, 0xB4B5B7FF, "У данного игрока уже есть вод. права!");
					format(string2, sizeof(string2), "Вы выдали водительские права %s.",GN(ChosenPlayer[playerid]));
					SendClientMessage(playerid, 0x6495EDFF, string2);
					PlayerInfo[ChosenPlayer[playerid]][pVodPrava] = 1;
					SendClientMessage(ChosenPlayer[playerid], 0x6495EDFF, "Инструктор выдал вам водительские права");
					return true;
				}
				case 1:
				{
					if(PlayerInfo[ChosenPlayer[playerid]][pFlyLic] == 1) return SendClientMessage(playerid, 0xB4B5B7FF, "У данного игрока уже есть эта лицензия!");
					format(string2, sizeof(string2), "Вы выдали права на воздух %s.",GN(ChosenPlayer[playerid]));
					SendClientMessage(playerid, 0x6495EDFF, string2);
					PlayerInfo[ChosenPlayer[playerid]][pFlyLic] = 1;
					SendClientMessage(ChosenPlayer[playerid], 0x6495EDFF, "Инструктор выдал вам права на воздушный транспорт");
					return true;
				}
				case 2:
				{
					if(PlayerInfo[ChosenPlayer[playerid]][pBoatLic] == 1) return SendClientMessage(playerid, 0xB4B5B7FF, "У данного игрока уже есть эта лицензия!");
					format(string2, sizeof(string2), "Вы выдали лицензию на лодки %s.",GN(ChosenPlayer[playerid]));
					SendClientMessage(playerid, 0x6495EDFF, string2);
					PlayerInfo[ChosenPlayer[playerid]][pBoatLic] = 1;
					SendClientMessage(ChosenPlayer[playerid], 0x6495EDFF, "Инструктор выдал вам лицензию на лодки");
					return true;
				}
				case 3:
				{
					if(PlayerInfo[ChosenPlayer[playerid]][pGunLic] == 1) return	SendClientMessage(playerid, 0xB4B5B7FF, "У данного игрока уже есть эта лицензия!");
					format(string2, sizeof(string2), "Вы выдали лицензию на оружие %s.",GN(ChosenPlayer[playerid]));
					SendClientMessage(playerid, 0x6495EDFF, string2);
					PlayerInfo[ChosenPlayer[playerid]][pGunLic] = 1;
					SendClientMessage(ChosenPlayer[playerid], 0x6495EDFF, "Инструктор выдал вам лицензию на оружие");
					return true;
				}
				case 4:
				{
					if(PlayerInfo[ChosenPlayer[playerid]][pBizLic] == 1) return	SendClientMessage(playerid, 0xB4B5B7FF, "У данного игрока уже есть эта лицензия!");
					format(string2, sizeof(string2), "Вы выдали лицензию на бизнес %s.",GN(ChosenPlayer[playerid]));
					SendClientMessage(playerid, 0x6495EDFF, string2);
					PlayerInfo[ChosenPlayer[playerid]][pBizLic] = 1;
					SendClientMessage(ChosenPlayer[playerid], 0x6495EDFF, "Инструктор выдал вам лицензию на бизнес");
					return true;
				}
				case 5:
				{
					if(TakingLesson[ChosenPlayer[playerid]] == 1) return SendClientMessage(playerid, 0xB4B5B7FF, "Вы уже начинали с этим игроком урок!");
					format(string2, sizeof(string2), "Вы начали урок у %s.",GN(ChosenPlayer[playerid]));
					SendClientMessage(playerid, 0x6495EDFF, string2);
					TakingLesson[ChosenPlayer[playerid]] = 1;
					SendClientMessage(ChosenPlayer[playerid], 0x6495EDFF, "Инструктор начал с Вами урок по вождению");
					return true;
				}
				case 6:
				{
					if(TakingLesson[ChosenPlayer[playerid]] == 0) return	SendClientMessage(playerid, 0xB4B5B7FF, "Вы не начинали урок с этим игроком!");
					format(string2, sizeof(string2), "Вы завершили урок у %s.",GN(ChosenPlayer[playerid]));
					SendClientMessage(playerid, 0x6495EDFF, string2);
					TakingLesson[ChosenPlayer[playerid]] = 0;
					SendClientMessage(ChosenPlayer[playerid], 0x6495EDFF, "Инструктор завершил с Вами урок по вождению");
					return true;
				}
				/*case 7:
				{
					if(PlayerInfo[playerid][pRank] < 3 && PlayerInfo[playerid][pAdmin] < 4) return SendClientMessage(playerid, 0xB4B5B7FF, "Вам нужен 3 ранг");
					if(soglasen[ChosenPlayer[playerid]] ==0)
					{
						new invite[256];
						format(invite,sizeof(invite), "Инструктор %s предлагает вам установить новый автомобильный номер\n- Вы согласны?", GN(playerid));
						SPD(ChosenPlayer[playerid],2527,DIALOG_STYLE_MSGBOX,"Соглашение",invite, "Да", "Нет");
						SendClientMessage(playerid, 0x6495EDFF, "Человек должен подтвердить установку номера");
						return true;
					}
					SPD(playerid,2526,DIALOG_STYLE_INPUT,"Выдача автомобильного номера","Номер автомобиля:","Ок","Отмена");
					return true;
				}*/
			}
			return 1;
		}
  		case 64:
		{
			if(!response) return SendClientMessage(HealOffer[playerid],-1,"Человек отказался от лечения");
			if(PlayerInfo[playerid][pCash] < HealPrice[playerid]) return 	SendClientMessage(HealOffer[playerid], COLOR_GREY, "У этого человека нет столько денег на руках!"),SendClientMessage(playerid, COLOR_GREY, "У Вас нет столько денег!");
			PlayerInfo[HealOffer[playerid]][pPayCheck] +=HealPrice[playerid]-HealPrice[playerid]/100;
			if(PlayerInfo[HealOffer[playerid]][pMember] == 22)
			{
				FracBank[0][fMCLS] += HealPrice[playerid]/100;
			}
			else
			{
			    FracBank[0][fMCSF] += HealPrice[playerid]/100;
			}
			PlayerInfo[playerid][pCash] -=HealPrice[playerid];
			format(string, sizeof(string), "Врач %s вылечил(а) вас за %d рублей!",GN(HealOffer[playerid]), HealPrice[playerid]);
			SendClientMessage(playerid, 0x6495EDFF,string);
			format(string, sizeof(string), "Вы вылечили %s за %d рублей!",GN(playerid), HealPrice[playerid]);
			SendClientMessage(HealOffer[playerid], 0x6495EDFF,string);
  			format(string, sizeof(string), "%s оказал мед. помощь %s",GN(HealOffer[playerid]) ,GN(playerid));
			ProxDetector(2,30.0, HealOffer[playerid], string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			SetPlayerHealthAC(playerid, 100);
			PlayerInfo[playerid][pHP] =100;
			return true;
		}
		case 65:
		{
		    if(!response) return SendClientMessage(LomkaOffer[playerid],-1,"Человек отказался от снятия ломки");
			format(string,sizeof(string),"Вы спасли %s от ломки",GN(playerid));
			SendClientMessage(LomkaOffer[playerid],0x33AA33AA,string);
			format(string,sizeof(string),"Медик %s спас Вас от ломки",GN(LomkaOffer[playerid]));
			SendClientMessage(playerid,0x33AA33AA,string);
			format(string, sizeof(string), "%s снял(а) ломку у %s",GN(LomkaOffer[playerid]) ,GN(playerid));
			ProxDetector(2,30.0, LomkaOffer[playerid], string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
   			PlayerInfo[LomkaOffer[playerid]][pPayCheck] +=LomkaPrice[playerid]-LomkaPrice[playerid]*0.01;
			if(PlayerInfo[LomkaOffer[playerid]][pMember] == 22)
			{
				FracBank[0][fMCLS] += LomkaPrice[playerid]*0.01;
			}
			else
			{
			    FracBank[0][fMCSF] += LomkaPrice[playerid]*0.01;
			}
			SetPlayerWeather(playerid,weather);
			PlayerInfo[playerid][pCash] -= LomkaPrice[playerid];
			startnarko[playerid] = 0;
			send[playerid] = 0;
			ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,0,0,0,0,0,1);
			return 1;
		}
		case 66:
		{
		    if(!response) return SendClientMessage(LomkaOffer[playerid],-1,"Человек отказался проводить сеанс от наркозависимости");
			PlayerInfo[playerid][pNarcoZavisimost] -=100;
			format(string,sizeof(string),"Медик %s провёл(а) с вами сеанс от наркозависимости",GN(NarkSeansOffer[playerid]));
			SendClientMessage(playerid,0x33AA33AA,string);
			format(string,sizeof(string),"Вы провели сеанс от наркозависимости с %s",GN(playerid));
			SendClientMessage(NarkSeansOffer[playerid],0x33AA33AA,string);
			format(string, sizeof(string), "%s провел(а) сеанс от наркозависимости с %s",GN(NarkSeansOffer[playerid]) ,GN(playerid));
			ProxDetector(2,30.0, NarkSeansOffer[playerid], string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			seans[playerid] = 1;
			PlayerInfo[NarkSeansOffer[playerid]][pPayCheck] +=NarkSeansPrice[playerid]-NarkSeansPrice[playerid]*0.01;
			if(PlayerInfo[NarkSeansOffer[playerid]][pMember] == 22)
			{
				FracBank[0][fMCLS] += NarkSeansPrice[playerid]*0.01;
			}
			else
			{
			    FracBank[0][fMCSF] += NarkSeansPrice[playerid]*0.01;
			}
			PlayerInfo[playerid][pCash] -= NarkSeansPrice[playerid];
		}
		case 67:
		{
			format(string, sizeof(string), "Вы уволены с лидерства администратором %s", GN(playerid));
			SendClientMessage(InviteOffer[playerid], 0x6495EDFF, string);
			SendClientMessage(InviteOffer[playerid], -1, "Теперь вы обычный гражданин...");
			format(req, sizeof(req), "Администратор %s: %s уволен с лидерства. Причина: %s", GN(playerid),GN(InviteOffer[playerid]),Uninvitereason[playerid]);
			ABroadCast(COLOR_LIGHTRED,req,2);
			AdmLog(PlayerInfo[playerid][pID],GN(playerid),PlayerInfo[InviteOffer[playerid]][pID],GN(InviteOffer[playerid]),8,Uninvitereason[playerid],0);
			PlayerInfo[InviteOffer[playerid]][pMember] = 0;
			PlayerInfo[InviteOffer[playerid]][pLeader] = 0;
			PlayerInfo[InviteOffer[playerid]][pRank] = 0;
			PlayerInfo[InviteOffer[playerid]][pModel] = 0;
			SetPlayerInterior(InviteOffer[playerid], 0);
			SetPlayerArmourAC(InviteOffer[playerid],0);
			DeleteWeapons(InviteOffer[playerid]);
			Spawn_Player(InviteOffer[playerid]);
		}
		case 68:
        {
            if(!response) return 1;
			switch(listitem)
			{
			    case 0: ShowPlayerDialog(playerid, 69, DIALOG_STYLE_INPUT,"Создание объекта","Введите ID объекта","Создать","Отмена");
                case 1: SelectObject(playerid);
			}
			return 1;
        }
        case 69:
        {
            if(!response) return true;
            if(!strval(inputtext)) return ShowPlayerDialog(playerid, 69, DIALOG_STYLE_INPUT,"Создание объекта","Введите ID объекта","Создать","Отмена");
            new Float:X, Float:Y, Float:Z;
            GetPlayerPos(playerid, X, Y, Z);
            new object = CreateObject(strval(inputtext), X+5, Y+5, Z, 0.0,0.0,0.0);
            SetPVarInt(playerid, "SelectedObject", object);
            EditObject(playerid, object);
            return true;
        }
        case 70:
        {
            if(!response)
            {
                DestroyObject(GetPVarInt(playerid, "SelectedObject"));
                CancelEdit(playerid);
                DeletePVar(playerid, "SelectedObject");
            }
            else
            {
                EditObject(playerid, GetPVarInt(playerid, "SelectedObject"));
            }
            return 1;
		}
		case 75:
		{
			if(!response) return callcmd::mm(playerid);
			switch(listitem)
			{
				case 0:
				{
					SendClientMessage(playerid,0xF5DEB3AA,"<> /time /id /gps /viphelp /setrpr /getrpr /play /donate");
					SendClientMessage(playerid,0xF5DEB3AA,"<Свадьба> /divorce /propose /witness");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /drink /pdd /sellgrib /kiss /piss /atm /items");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /eat /licenses /showlicenses");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /eject /buygun /buy /pay /directory /mydebts /repaydebt");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /dice /showpass /myskill /radio /mystyle /wallet");
					return 1;
				}
				case 1:
				{
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/o)oc - Глобальный чат; (/b) - OOC чат; (/rep)ort - Связь с администрацией");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/ad)vertise - Объявление");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/gov)erment - Государственные новости");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/f)amily - Чат организации");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/s)out - Крик, (/w)hisper - шёпот");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/m)egaphone - Мегафон на служебном транспорте");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/r)adio - Чат государственных организаций (Полиция/ФБР и т.д)");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/d)epartaments - Общий чат государственных организаций");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/me) - Действие (Пример: Имя_Фамилия пожал руку)");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/do) - Действие (Пример: - смеркалось), (/try) - попытка действия");
					return 1;
				}
				case 2:
				{
					SendClientMessage(playerid,0xF5DEB3AA,"<> /call - Позвонить (Номер телефона можно узнать через /number)");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /sms - Отправить СМС сообщение");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/p)ickup - Ответить на звонок");
					SendClientMessage(playerid,0xF5DEB3AA,"<> (/h)angup - Завершить телефонный разговор");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /*105# - Проверить баланс");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /number /togphone");
					return 1;
				}
				case 3:
				{
					if(PlayerInfo[playerid][pJob] == 1) { SendClientMessage(playerid,0xF5DEB3AA,"<> Работа: /route"); }
					else if(PlayerInfo[playerid][pJob] == 2) { SendClientMessage(playerid,0xF5DEB3AA,"<> Работа: /repair /refill /gcontract /repairdvig /tupdate /endtune /next"); }
					else if(PlayerInfo[playerid][pJob] == 3) { SendClientMessage(playerid,0xF5DEB3AA,"<> Работа: /sellhotdog /hotdog"); }
					else if(PlayerInfo[playerid][pJob] == 4) { SendClientMessage(playerid,0xF5DEB3AA,"<> Работа: /fare"); }
					else if(PlayerInfo[playerid][pJob] == 5) { SendClientMessage(playerid,0xF5DEB3AA,"<> Работа: /buyprods /sellprods /loadbenz /sellbenz"); }
					else if(PlayerInfo[playerid][pJob] == 6) { SendClientMessage(playerid,0xF5DEB3AA,"<> Работа: /fgstyle"); }
					else if(PlayerInfo[playerid][pJob] == 7) { SendClientMessage(playerid,0xF5DEB3AA,"<> Работа: /loadz /sloading /houselist /findhouse /unload"); }
					if (IsACop(playerid))
					{
                        if(PlayerInfo[playerid][pLeader] == 1 || PlayerInfo[playerid][pLeader] == 10 || PlayerInfo[playerid][pLeader] == 21) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /iinvite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> (/r)adio (/d)epartments (/m)egaphone (/su)spect /arrest /wanted /cuff /tazer");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> /frisk /take (/gov)ernment /ram /warehouse /ticket /givecopkeys /cput /cout");
					}
					else if (IsAArm(playerid))
					{
					    if(PlayerInfo[playerid][pLeader] == 3 || PlayerInfo[playerid][pLeader] == 19) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite /aprison");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> (/r)adio (/d)epartments (/m)egaphone /qr /rg");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> (/gov)ernment  /warehouse /camera /cameraoff /members /getgun");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> Маты: /carmat /carm");
						return true;
					}
					else if (PlayerInfo[playerid][pMember] == 2)
					{
						SendClientMessage(playerid, 0xF5DEB3AA, "<> /demote /tazerall /bizlock");
					}
					else if (PlayerInfo[playerid][pMember] == 19)
					{
						SendClientMessage(playerid, 0xF5DEB3AA, "<> /cameraoff /camera");
					}
					else if (PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pMember] == 22)
					{
                        if(PlayerInfo[playerid][pLeader] == 4 || PlayerInfo[playerid][pLeader] == 22) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "МЧС: (/r)adio (/d)epartments /heal /gov /lomka /narkozav /sethpprice");
					}
					else if (PlayerInfo[playerid][pMember] == 8)
					{
						SendClientMessage(playerid, 0xF5DEB3AA, "Крупье: /f /dice");
					}
					else if (PlayerInfo[playerid][pMember] == 5 || PlayerInfo[playerid][pMember] == 6 || PlayerInfo[playerid][pMember] == 14)
					{
                        if(PlayerInfo[playerid][pLeader] == 5 || PlayerInfo[playerid][pLeader] == 6 || PlayerInfo[playerid][pLeader] == 14) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");						SendClientMessage(playerid, 0xF5DEB3AA, "(/f)amily  /tie /takephone /untie /getweapon /bizlist /bizwar /mafiabalance /mafiawithdraw /mafiabankput");
						SendClientMessage(playerid, 0xF5DEB3AA, "/warehouse /gag /ungag /setdebt ID /debtors /hackdb");
					}
					else if (PlayerInfo[playerid][pMember] == 7)
					{
                        if(PlayerInfo[playerid][pLeader] == 7)  SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "Мэрия: /r  /free /kazna /kaznaput /kaznawithdraw /settax");
					}
					else if (PlayerInfo[playerid][pMember] == 9)
					{
                        if(PlayerInfo[playerid][pLeader] == 9) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "SF NEWS: /news  /live (/f)amily /newsbank /newswithdraw \n /yes [id] /off");
					}
					else if (PlayerInfo[playerid][pMember] == 20)
					{
                        if(PlayerInfo[playerid][pLeader] == 20) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "LV NEWS: /news /live (/f)amily /newsbank /newswithdraw \n /yes [id] /off");
					}
					else if (PlayerInfo[playerid][pMember] == 16)
					{
                        if(PlayerInfo[playerid][pLeader] == 16) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "LS NEWS: /news /live (/f)amily /newsbank /newswithdraw \n /yes [id] /off");
					}
					else if (PlayerInfo[playerid][pMember] == 11 || PlayerInfo[playerid][pLeader] == 11)
					{
                        if(PlayerInfo[playerid][pLeader] == 11) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "(/f)amily /givelic /take /duty Клик меню (кликнуть на игрока в TAB)");
					}
					else if (IsAGang(playerid))
					{
                        if(PlayerInfo[playerid][pLeader] == 12 || PlayerInfo[playerid][pLeader] == 13 || PlayerInfo[playerid][pLeader] == 15 || PlayerInfo[playerid][pLeader] == 17 || PlayerInfo[playerid][pLeader] == 18 || PlayerInfo[playerid][pLeader] == 23) SendClientMessage(playerid, 0xF5DEB3AA, "Замы/лидеры: /invite /uninvite /giverank /offuninvite");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> (/f)amily  /materialsget /selldrugs /sellzone /mask /gunlist /capture ");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> /materialsput /unloading /getmaterials /putmaterials /usekey /keys");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> Банк банды: /gbank /gbankput /gbankwithdraw");
						SendClientMessage(playerid, 0xF5DEB3AA, "<> Гетто: /sellgun /robhouse /gbankwithdraw");
					}
				}
				case 4:
				{
					if (PlayerInfo[playerid][pLeader] == 19)
					{
						SendClientMessage(playerid, 0xF5DEB3AA,"<> /invite /uninvite /giverank ");
					}
					if(PlayerInfo[playerid][pLeader] == 1)
					{
						SendClientMessage(playerid, 0xF5DEB3AA,"Шериф: /iinvite - перевод из армии");
					}
					if (PlayerInfo[playerid][pLeader] >= 1)
					{
						SendClientMessage(playerid, 0xF5DEB3AA,"<> /invite /uninvite /giverank ");
					}
					else
					{
						SendClientMessage(playerid, COLOR_GREY, "Вам еще рано сюда!");
					}
				}
				case 5:
				{
					SendClientMessage(playerid,0xF5DEB3AA,"<> /hmenu - Главное меню(Настройки дома)");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /home - Поставить метку у дома (GPS)");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /changehouse - Продать дом игроку");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /healme - Использовать аптечку");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /exit или кнопка ALT - выйти из дома");
				}
				case 6:
				{
					/*if(PlayerInfo[playerid][pPbiskey] == 255) return SendClientMessage(playerid, COLOR_GREY, "Вы не бизнесмен!");
					if(PlayerInfo[playerid][pPbiskey] >= 100)
					{
						SendClientMessage(playerid,0xF5DEB3AA,"<> /buybiz - Купить бизнес");
						SendClientMessage(playerid,0xF5DEB3AA,"<> /sellbiz - Продать бизнес");
						SendClientMessage(playerid,0xF5DEB3AA,"<> /bizlock - Закрыть/Открыть бизнес");
						SendClientMessage(playerid,0xF5DEB3AA,"<> /bizstats - Статистика бизнеса");
						SendClientMessage(playerid,0xF5DEB3AA,"<> /bizfee - Установить цену бензин");
						SendClientMessage(playerid,0xF5DEB3AA,"<> /bizwithdraw - Снять деньги с бизнеса");
						SendClientMessage(playerid,0xF5DEB3AA,"<> /bizmafia - Установить крышу");
						return 1;
					}*/
					SendClientMessage(playerid,0xF5DEB3AA,"<> /sellbiz - Продать бизнес");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /bizlock - Закрыть/Открыть бизнес");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /bizstats - Статистика бизнеса");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /bizfee - Установить цену за вход");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /bizwithdraw - Снять деньги с бизнеса");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /getbizstats - Узнать статистику другого бизнеса");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /cena - Установить цену за товар");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /bizmafia - Установить крышу");
				}
				case 7:
				{
					SendClientMessage(playerid,0xF5DEB3AA,"<> /carpass - посмотреть документы на машину");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /showcarpass - показать документы на машину");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /sellcar - продать машину");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /fixcar - обновить машину");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /fill - заправить машину, /lock - закрыть/открыть машину");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /changecar - продать машину игроку");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /fillcar - заправить машину с канистры");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /get fuel - купить канистру");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /en - управление двигателем, /light - фарами");
				}
				case 8:
				{
					//if(PlayerInfo[playerid][pAvtoMast] == 255) return SendClientMessage(playerid, COLOR_GREY, "Вы не имеете мастерскую!");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /selltune - продать автомастерскую");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /tinfo - информация");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /tpanel - панель управления");
					SendClientMessage(playerid,0xF5DEB3AA,"<> /gettunestats - информация о мастерской");
				}
			}
			return 1;
		}
		case 80:
		{
			if(!response) return DeletePVar(playerid, "HouseID");
		    SendClientMessage(playerid,-1."Теперь поезжайте в банк, чтобы оплатите покупку");
		    return 1;
		}
		case 81:
		{
		    switch(listitem)
		    {
		        case 0:					SetPVarInt(playerid, "HouseID", idx);
		        {
		        	if(GetPVarInt(playerid,"HouseID") > 0)
		        	{
                    	ShowPlayerDialog(playerid, 82, DIALOG_STYLE_MSGBOX, "Информация о доме","Адрес:\t%s, л. %d\nВладелец:\t-= Дом продаётся =-\nИнтерьер:\t%s\nКласс:\t%s\nСтоимость:\t%d","Купить","Отмена");
					}
					else
					{
						ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Ошибка","Вы не выбрали дом для покупки.\nНайдите свободный дом и подойдите к его входу.","Ок","");
					}
				}
		    }
		    return 1;
		}
	}
	return 1;
}
// ========== [ Паблики ] ==========
public OnGameModeInit()
{
	LimitPlayerMarkerRadius(50.0);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ManualVehicleEngineAndLights();
	SetGameModeText("Sectum RolePlay v1.1a");
	ShowNameTags(1);
	SetNameTagDrawDistance(20.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(weather);
	SetTimer("Fresh",950,1);
	SetTimer("SyncUp", 60000, true);
	SetTimer("OtherTimer", 3000, true);
	MySql_Base = mysql_connect(mysql_host, mysql_user, mysql_db,mysql_pass);
	switch(mysql_errno())
	{
		case 0: print("Подключение к базе данных удалось");
		case 1044: print("Подключение к базе данных не удалось [Указано неизвестное имя пользователя]");
		case 1045: print("Подключение к базе данных не удалось [Указан неизвестный пароль]");
		case 1049: print("Подключение к базе данных не удалось [Указана неизвестная база данных]");
		case 2003: print("Подключение к базе данных не удалось [Хостинг с базой данных недоступен]");
		case 2005: print("Подключение к базе данных не удалось [Указан неизвестный адрес хостинга]");
		default: printf("Подключение к базе данных не удалось [Неизвестная ошибка. Код ошибки: %d]", mysql_errno());
	}
	mysql_tquery(MySql_Base,"SET NAMES cp1251","","");
//	mysql_tquery(MySql_Base,"SET SESSION character_set_server='utf8';","","");
	mysql_tquery(MySql_Base,"SELECT * FROM `fracbank`","OnMySQL_QUERY","iis",7,"","");
	mysql_tquery(MySql_Base, "SELECT * FROM `houses`", "LoadHouse", "");
	new h,m,s;
	gettime(h,m,s);
	ghour = h;
	SetWorldTime(h);
	CreateObjects();
	CreateVehicles();
	CreatePickups();
	for(new Vehicles = 0; Vehicles < MAX_VEHICLES; Vehicles++)
	{
	    Fuell[Vehicles] = 100;
	    zavodis[Vehicles] = 0;
		SetVehicleNumberPlate(Vehicles, "SectumRP");
	}
	AddPlayerClass(295, 1958.3783, 1343.1572, 400.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	bomj[0] = CreateMenu("Victim", 1, 50.0, 160.0, 110.0);
	SetMenuColumnHeader(bomj[0], 0, "Choose Skin");
	AddMenuItem(bomj[0], 0, ">> Next");
	AddMenuItem(bomj[0], 0, "<< Previous");
	AddMenuItem(bomj[0], 0, "Save");

	bomj[1] = CreateMenu("Victim", 1, 50.0, 160.0, 110.0);
	SetMenuColumnHeader(bomj[1], 0, "Choose Skin");
	AddMenuItem(bomj[1], 0, ">> Next>");
	AddMenuItem(bomj[1], 0, "<< Previous");
	AddMenuItem(bomj[1], 0, "Save");
	
	ChoseSkin = CreateMenu("Skin", 1, 50.0, 160.0, 90.0);
	AddMenuItem(ChoseSkin,0,">> Next");
	AddMenuItem(ChoseSkin,0,"Done");

	Admin = CreateMenu("Spec", 1, 0.0, 160.0, 50.0);
	AddMenuItem(Admin, 0, "Switch");
	AddMenuItem(Admin, 0, "Mute");
	AddMenuItem(Admin, 0, "Kick");
	AddMenuItem(Admin, 0, "Warn");
	AddMenuItem(Admin, 0, "Ban");
	AddMenuItem(Admin, 0, "Slap");
	AddMenuItem(Admin, 0, "Stats");
	AddMenuItem(Admin, 0, "GetIP");
	AddMenuItem(Admin, 0, "GM Test");
	AddMenuItem(Admin, 0, "Skills");
	AddMenuItem(Admin, 0, "SpOff");

	TextDrawLetterSize(Speed,0.399999,1.010000); //размер текста Speed:
	TextDrawFont(Speed,1); //стиль
	TextDrawBackgroundColor(Speed,0x000000AA); //обводка текста
	TextDrawColor(Speed,0x20A9FFFF); //цвет текста
	TextDrawSetOutline(Speed,1); //размер обводки
	TextDrawSetProportional(Speed,1);
	TextDrawSetShadow(Speed,1); //тень
	//==========================================================================

	Box = TextDrawCreate(135.576705, 431.416595, "usebox");
	TextDrawLetterSize(Box, 0.000000, -6.278182);
	TextDrawTextSize(Box, 315.020507, 0.000000);
	TextDrawAlignment(Box, 1);
	TextDrawColor(Box, 0);
	TextDrawUseBox(Box, true);
	TextDrawBoxColor(Box, 102);
	TextDrawSetShadow(Box, 0);
	TextDrawSetOutline(Box, 0);
	TextDrawFont(Box, 0);
	
	Box2 = TextDrawCreate(516.778930, 217.583343, "LD_SPAC:white");
	TextDrawLetterSize(Box2, 0.025768, -0.081666);
	TextDrawTextSize(Box2, 81.054214, 65.916656);
	TextDrawAlignment(Box2, 1);
	TextDrawColor(Box2, -1);
	TextDrawSetShadow(Box2, 0);
	TextDrawSetOutline(Box2, 0);
	TextDrawFont(Box2, 4);
	TextDrawSetPreviewModel(Box2,438);

	Box1 = TextDrawCreate(599.833129, 286.166687, "usebox");
	TextDrawLetterSize(Box1, 0.000000, 4.479625);
	TextDrawTextSize(Box1, 514.310363, 0.000000);
	TextDrawAlignment(Box1, 1);
	TextDrawColor(Box1, 0);
	TextDrawUseBox(Box1, true);
	TextDrawBoxColor(Box1, 102);
	TextDrawSetShadow(Box1, 0);
	TextDrawSetOutline(Box1, 0);
	TextDrawFont(Box1, 0);
	return 1;
}

public OnGameModeExit()
{
	SaveMySQL(0);
	KillTimer(TT);
	mysql_close(MySql_Base);
	return 1;
}
forward OnPlayerEnterDynamicArea(playerid, areaid);
public OnPlayerEnterDynamicArea(playerid, areaid)
{
	new player_state = GetPlayerState(playerid);
	new Float:x,Float:y,Float:z,inter;
	for(new idx = 1; idx <= TOTALHOUSE; idx++)
	{
     	switch(HouseInfo[idx][hInt])
		{
		    case 1:
		    {
		        inter = 10;
				x = 2261.3103;
				y= -1136.4467;
				z =1050.6328;
		    }
		    case 2:
		    {
		        inter = 2;
				x = 225.9761;
				y= 1239.9126;
				z =1082.1406;
		    }
			case 3:
			{
	            inter = 10;
				x = 23.8334;
				y= 1340.4812;
				z =1084.3750;
			}
			case 4:
			{
			    inter = 4;
				x = -261.9759;
				y= 1456.8844;
				z = 1084.3672;
			}
			case 5:
			{
	            inter = 2;
				x = 491.0190;
				y= 1399.0691;
				z =1080.2578;
			}

		}
	    if(areaid != HouseInfo[idx][hAreaEnter] || player_state != PLAYER_STATE_ONFOOT) continue;
	    if(HouseInfo[idx][hLock] == 1 || HouseInfo[idx][hLock] == 0)
		{
			if(!strcmp(GN(playerid), HouseInfo[idx][hOwner], false))
			{
				SetPlayerPos(playerid, x, y, z);
				SetPlayerInterior(playerid, inter);
				SetPlayerVirtualWorld(playerid, HouseInfo[idx][hID]);
				break;
			}
			if(strcmp(HouseInfo[idx][hOwner], "None", false))
			{
				GameTextForPlayer(playerid, "~r~Locked", 3000, 1);
			}
			else
			{
			    if(PlayerInfo[playerid][pBank] < HouseInfo[idx][hPrice])
			    {
			        GameTextForPlayer(playerid,"~r~Locked\nNo bank money to buy!", 3000, 1);
				}
				else
				{
					format(string,sizeof(string),"Информация о доме","Адрес:\t%s, д. %d\nВладелец:\t-= Дом продаётся =-\nИнтерьер:\t%s\nКласс:\t%s\nСтоимость:\t%d",HouseInfo[idx][hStreet],HouseInfo[idx][hNumber],HouseInfo[idx][hStreet],HouseInfo[idx][hClass],HouseInfo[idx][hPrice]);
					ShowPlayerDialog(playerid, 80, DIALOG_STYLE_MSGBOX, ,"Купить","Отмена");
					SetPVarInt(playerid, "HouseID", idx);
				}
			}
		}
		else
		{
			SetPlayerPos(playerid, x, y, z);
			SetPlayerInterior(playerid, inter);
			SetPlayerVirtualWorld(playerid, HouseInfo[idx][hID]);
		}
		break;
	}
	return 1;
}
public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
    format(req, sizeof(req),"ID_Object: %d",objectid);
    SendClientMessage(playerid,-1,req);
    SetPVarInt(playerid, "SelectedObject", objectid);
    ShowPlayerDialog(playerid, 70, DIALOG_STYLE_MSGBOX, "Объект выбран","Выберите действие!","Изменить","Удалить");
	return 1;
}
		/*if(GetPVarInt(playerid, "SelectedHouse") > 1)
		{
            HouseInfo[GetPVarInt(playerid, "SelectedHouseid")][hLabelx] = fX;
			HouseInfo[GetPVarInt(playerid, "SelectedHouseid")][hLabely]= fY;
			HouseInfo[GetPVarInt(playerid, "SelectedHouseid")][hLabelz] = fZ;
			DestroyObject(GetPVarInt(playerid, "SelectedHouse"));
			DeletePVar(playerid, "SelectedHouse");
			DeletePVar(playerid, "SelectedHouseid");
		}*/
public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	if(!IsValidObject(objectid)) return 0;
    MoveObject(objectid, fX, fY, fZ, 10.0, fRotX, fRotY, fRotZ);
    new Float:oldX, Float:oldY, Float:oldZ,
    Float:oldRotX, Float:oldRotY, Float:oldRotZ;
    GetObjectPos(objectid, oldX, oldY, oldZ);
    GetObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
    if(!playerobject)
    {
        if(!IsValidObject(objectid)) return 0;
        MoveObject(objectid, fX, fY, fZ, 10.0, fRotX, fRotY, fRotZ);
    }
    if(response == EDIT_RESPONSE_FINAL)
    {
        SetObjectPos(objectid, fX, fY, fZ);
		SetObjectRot(objectid, fRotX, fRotY, fRotZ);
  		if(GetPVarInt(playerid, "SelectedHouse") > 1)
		{
            HouseInfo[GetPVarInt(playerid, "SelectedHouseid")][hLabelx] = fX;
			HouseInfo[GetPVarInt(playerid, "SelectedHouseid")][hLabely]= fY;
			HouseInfo[GetPVarInt(playerid, "SelectedHouseid")][hLabelz] = fZ;
			DestroyObject(GetPVarInt(playerid, "SelectedHouse"));
			DeletePVar(playerid, "SelectedHouse");
			DeletePVar(playerid, "SelectedHouseid");
		}
    }
    if(response == EDIT_RESPONSE_CANCEL)
    {
            if(!playerobject)
            {
                    SetObjectPos(objectid, oldX, oldY, oldZ);
                    SetObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
            }
            else
            {
                    SetPlayerObjectPos(playerid, objectid, oldX, oldY, oldZ);
                    SetPlayerObjectRot(playerid, objectid, oldRotX, oldRotY, oldRotZ);
            }
    }
	return 1;
}
publics IsMute(playerid)
{
	if(PlayerInfo[playerid][pJailed] == 4)
	{
	    if(PlayerInfo[playerid][pJailTime] == -1) format(req,sizeof(req),"Вы были временно изолировали от игроков! Осталось 0 секунд.");
 		else if (PlayerInfo[playerid][pJailTime] < 60) format(req,sizeof(req),"Вы были временно изолировали от игроков! Осталось %d сек.",PlayerInfo[playerid][pJailTime]);
		else if (PlayerInfo[playerid][pJailTime] == 60) format(req,sizeof(req),"Вы были временно изолировали от игроков! Осталось 1 мин. 0 сек.");
		else if (PlayerInfo[playerid][pJailTime] > 60 && PlayerInfo[playerid][pJailTime] < 3600)
		{
			new Float: minutes;
			new seconds;
			minutes = PlayerInfo[playerid][pJailTime] / 60;
			seconds = PlayerInfo[playerid][pJailTime] % 60;
			format(req,sizeof(req),"Вы были временно изолировали от игроков! Осталось %0.0f мин. %02d сек.",minutes,seconds);
		}
		else if (PlayerInfo[playerid][pJailTime] == 3600) format(req,sizeof(req),"Вы были временно изолировали от игроков! Осталось 1 час. 0 мин. 0 сек.");
		else if (PlayerInfo[playerid][pJailTime] > 3600)
		{
			new Float: hours;
			new minutes_int;
			new Float: minutes;
			new seconds;
			hours = PlayerInfo[playerid][pJailTime] / 3600;
			minutes_int = PlayerInfo[playerid][pJailTime] % 3600;
			minutes = minutes_int / 60;
			seconds = minutes_int % 60;
			format(req,sizeof(req),"Вы были временно изолировали от игроков! Осталось %0.0f час. %0.0f мин. %02d сек.",hours, minutes, seconds);
		}
		SendClientMessage(playerid,COLOR_LIGHTRED,req);
		return 1;
	}
	if(PlayerInfo[playerid][pMute] != 0)
	{
	    if(PlayerInfo[playerid][pMute] == -1) format(req,sizeof(req),"У Вас молчанка! До снятия 0 секунд.");
 		else if (PlayerInfo[playerid][pMute] < 60) format(req,sizeof(req),"У Вас молчанка! До снятия %d сек.",PlayerInfo[playerid][pMute]);
		else if (PlayerInfo[playerid][pMute] == 60) format(req,sizeof(req),"У Вас молчанка! До снятия 1 мин. 0 сек.");
		else if (PlayerInfo[playerid][pMute] > 60 && PlayerInfo[playerid][pMute] < 3600)
		{
			new Float: minutes;
			new seconds;
			minutes = PlayerInfo[playerid][pMute] / 60;
			seconds = PlayerInfo[playerid][pMute] % 60;
			format(req,sizeof(req),"У Вас молчанка! До снятия %0.0f мин. %02d сек.",minutes,seconds);
		}
		else if (PlayerInfo[playerid][pMute] == 3600) format(req,sizeof(req),"У Вас молчанка! До снятия 1 час. 0 мин. 0 сек.");
		else if (PlayerInfo[playerid][pMute] > 3600)
		{
			new Float: hours;
			new minutes_int;
			new Float: minutes;
			new seconds;
			hours = PlayerInfo[playerid][pMute] / 3600;
			minutes_int = PlayerInfo[playerid][pMute] % 3600;
			minutes = minutes_int / 60;
			seconds = minutes_int % 60;
			format(req,sizeof(req),"У Вас молчанка! До снятия %0.0f час. %0.0f мин. %02d сек.",hours, minutes, seconds);
		}
		SendClientMessage(playerid,COLOR_LIGHTRED,req);
		return 1;
	}
	return false;
}
publics Licshlag() return MoveObject(Barrier,-2031.4800,-242.67,35-0.004, 0.004,0.00000000,-90.00000000,0.00000000);
publics cout(playerid)
{
    TogglePlayerControllable(playerid, 1);
}
publics PlayerRegister(playerid)
{
    PlayerInfo[playerid][pChar] = ChosenSkin[playerid];
	SendClientMessage(playerid, -1, "Поздравляем Вас с успешной регистрацией!");
 	SendClientMessage(playerid, 0x00D900C8, "Подсказка: Направляйтесь на работу грузчика (( Используйте /GPS >> [26] Работа грузчика ))");
  	SendClientMessage(playerid, 0x00D900C8, "Подсказка: Грузчиком вы можете заработать на водительские права");
   	SendClientMessage(playerid, 0x00D900C8, "Подсказка: Рядом с вами есть остановка, где можно дождаться автобус");
    SendClientMessage(playerid, 0x00D900C8, "Подсказка: А также любой таксист отвезет вас на работу бесплатно");
	PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);
 	mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Name` = '%s'",GN(playerid));
	mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",0,playerid,"");
}
publics TimerGiveMiner(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
    SendClientMessage(playerid, -1, "Вы накололи руды. Теперь отнесите камень на склад.");
	mesh[playerid] = 1;
	usemesh[playerid] = 1;
	PicCP[playerid] = 4;
    ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
    SetPlayerAttachedObject(playerid, 7, 2936, 1, 0.184699, 0.426247, 0.000000, 259.531341, 80.949592, 0.000000, 0.476124, 0.468181, 0.470769);
    SetPlayerCheckpoint(playerid, -1865.7438, -1622.5901, 21.9036, 5.0);
    return true;
}
publics OtherTimer()
{
	foreach(new i : Player)
	{
		if(GetPlayerState(i) == PLAYER_STATE_ONFOOT && send[i] == 1)
		{
			ApplyAnimation(i, "CRACK", "crckdeth1", 4.0, 1, 0, 0, 0, 0);
		}
		if(IsPlayerConnected(i))
		{
			new money = GetPlayerMoney(i);
			if(PlayerInfo[i][pCash] > money)
			{
				ResetPlayerMoney(i);
				GivePlayerMoney(i, PlayerInfo[i][pCash]);
			}
			else if(PlayerInfo[i][pCash] < money)
			{
				ResetPlayerMoney(i);
				GivePlayerMoney(i, PlayerInfo[i][pCash]);
			}
		}
	}
}
publics Fresh()
{
	new string[80];
    AFKProcessor();
   	new hour, minute, second;
	gettime(hour, minute, second);
	FixHour(hour);
	if ((hour > ghour) || (hour == 0 && ghour == 23))
	{
		format(string, sizeof(string), "Сейчас времени %d часа(-ов) 00 минут",hour);
		SendClientMessageToAll(-1,string);
		ghour = hour;
		PayDay();
		SetWorldTime(hour);
	}
	foreach(new i : Player)
	{
		if(!Login[i])
		{
			if(GetPVarInt(i,"time_logged") > 0)
			{
				SetPVarInt(i,"time_logged",GetPVarInt(i,"time_logged")-1);
		 		if(GetPVarInt(i,"time_logged") == 0)
		  		{
		   			SendClientMessage(i, 0xFF6347AA,"Время на ввод пароля ограничено!");
		     		SPD(i, -1, 0, "f", "f", "f", "");
		      		KickFix(i);
				}
		   	}
			return 1;
		}
		if(!Login[i]) return 1;
		ToProbeg(i);
  		if(Drugtime[i] > 0)
		{
			Drugtime[i] -= 1;
		}
		if(Drugtime[i] == 30)
		{
			SetPlayerTime(i,hour,minute);
			SetPlayerWeather(i, weather);
			SetPlayerDrunkLevel (i, 3000);
		}
		if(Drugtime[i] == 10)
		{
			SetPlayerDrunkLevel (i, 0);
		}
		if(PlayerInfo[i][pNarcoZavisimost] >= 500 && startnarko[i] < 1)
		{
            if(PlayerInfo[i][pNarcoZavisimost] < 601) startnarko[i] = 3600;
			else if(601 <= PlayerInfo[i][pNarcoZavisimost] < 1001) startnarko[i] = 3600;
			else if(1001 <= PlayerInfo[i][pNarcoZavisimost] < 2001) startnarko[i] = 1800;
			else if(2001 <= PlayerInfo[i][pNarcoZavisimost] < 3301) startnarko[i] = 900;
			else if(3301 <= PlayerInfo[i][pNarcoZavisimost] < 4001) startnarko[i] = 450;
			else if(4001 <= PlayerInfo[i][pNarcoZavisimost] < 7701) startnarko[i] = 225;
			else if(7701 <= PlayerInfo[i][pNarcoZavisimost] < 10001) startnarko[i] = 110;
			else if(16001 <= PlayerInfo[i][pNarcoZavisimost] < 20001) startnarko[i] = 70;
			else if(20001 <= PlayerInfo[i][pNarcoZavisimost]) startnarko[i] = 50;
		}
		if(startnarko[i] > 1) startnarko[i]--;
  		if(startnarko[i] == 1 && send[i] == 0 && PlayerInfo[i][pNarcoZavisimost] >= 500)
		{
			SendClientMessage(i, 0xFF0000AA, "::: У Вас началась ломка :::");
			SendClientMessage(i, -1, "Принять дозу: /usedrugs | Вызвать скорую: /c ");
			send[i] = 1;
			startnarko[i] = 0;
		}
		UpdateTaxi(i);
		if(Works[i] == true && JobCP[i] == 1 || Works[i] == true && JobCP[i] == 2)
		{
			if(usemesh[i] == 1)
			{
				mesh[i] +=1;
			}
		}
		if(clearanim[i] > 0)
		{
			clearanim[i] --;
		}
		if(clearanim[i] == 0)
		{
			ApplyAnimation(i,"CARRY","crry_prtial",4.0,0,0,0,0,0,1);
			clearanim[i] = -1;
		}
		if(PlayerInfo[i][pMute] > 0)
		{
			PlayerInfo[i][pMute] -=1;
			if(PlayerInfo[i][pMute] == 1)
			{
				PlayerInfo[i][pMute] = 0;
				SendClientMessage(i,COLOR_LIGHTRED,"Вам включили чат. Пожалуйста, больше не нарушайте правила");
			}
		}
		if(Tazer[i] == 1)
		{
			if(TazerTime[i] <= 0)
			{
				Tazer[i] = 0;
				if(PlayerCuffed[i] == 0) TogglePlayerControllable(i, 1);
			}
			else
			{
				TogglePlayerControllable(i, 0);
				TazerTime[i] -= 1;
			}
		}
  		if(PlayerCuffed[i] == 1)
		{
			if(CuffedTime[i] <= 0)
			{
				TogglePlayerControllable(i, 1);
				PlayerCuffed[i] = 0;
				CuffedTime[i] = 0;
				TazerTime[i] = 0;
			}
			else
			{
				CuffedTime[i] -= 1;
			}
		}
		if(PlayerInfo[i][pJailed] > 0)
		{
			if(PlayerInfo[i][pJailTime] > 0)
			{
				PlayerInfo[i][pJailTime]--;
			}
			if(PlayerInfo[i][pJailTime] == 0)
			{
				if(PlayerInfo[i][pJailed] == 1)
				{
					SetPlayerInterior(i, 0);
					SetPlayerPos(i,1553.4962,-1675.2714,16.1953);//Тюрьма
					SetPlayerFacingAngle(i, 95.0636);
					SendClientMessage(i, 0x7FB151FF,"Вы заплатили свой долг обществу, теперь вы свободны!");
				}
				if(PlayerInfo[i][pJailed] == 2)
				{
					SetPlayerInterior(i, 0);
					SetPlayerPos(i,-1607.1873,721.3649,12.2721);//Тюрьма
					SetPlayerFacingAngle(i, 2.3026);
					SendClientMessage(i, 0x7FB151FF,"Вы заплатили свой долг обществу, теперь вы свободны!");
				}
				if(PlayerInfo[i][pJailed] == 3)
				{
					SetPlayerInterior(i, 0);
					SetPlayerPos(i,2334.8467,2454.9456,14.9688);//Тюрьма
					SetPlayerFacingAngle(i, 115.7874);
					SendClientMessage(i, 0x7FB151FF,"Вы заплатили свой долг обществу, теперь вы свободны!");
    			}
				if(PlayerInfo[i][pJailed] == 4)
				{
					Spawn_Player(i);
				}
				PlayerInfo[i][pJailTime] = 0;
				PlayerInfo[i][pJailed] = 0;
				format(string, sizeof(string), "~g~Freedom");
				GameTextForPlayer(i, string, 5000, 1);
				PlayerInfo[i][pZvezdi] = 0;
				SetPlayerWantedLevel(i, 0);
				SetPlayerVirtualWorld(i, 0);
				SetPlayerToTeamColor(i);
			}
		}
		if(PlayerInfo[i][pJailed] == 4 && !(PlayerToPoint(35.0, i,5508.3706,1244.7594,23.1886)))
		{
		 	SetPlayerInterior(i, 0);
			SetPlayerPos(i,5508.3706,1244.7594,23.1886);
			if(GetPVarInt(i, "FDMFlood") > gettime()) return true;
			format(string,sizeof(string),"<Warning> %s пытается выйти из ФДМ", GN(i));
			ABroadCast(0xFF0000AA,string,1);
			SetPVarInt(i, "FDMFlood", gettime() + 180);
		}
	}
	return 1;
}
publics UpdateSpeedometr(playerid)
{
    new str1[12],str2[12],str3[12],str4[12],str5[12],str6[12],str7[12],str8[12],str9[15],str10[9];
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new locked[11],engineshow[12],lightshow[12];
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsLocked[vehicleid] == 1) { locked = "~r~Lock"; }
		else { locked = ""; }
		if(zavodis[vehicleid] == 1) { engineshow = "Engine"; }
  		else { engineshow = ""; }
  		if(VehicleLight[vehicleid] == 1) { lightshow = "~b~Lights"; }
  		else { lightshow = ""; }
    	format(str1, sizeof(str1),"%d",SpeedVehicle(playerid));
     	if(SpeedVehicle(playerid) >= 60) format(str1, sizeof(str1),"~y~%d",SpeedVehicle(playerid));
     	if(SpeedVehicle(playerid) >= 110) format(str1, sizeof(str1),"~r~%d",SpeedVehicle(playerid));
		format(str2, sizeof(str2),"Fuel:");
		format(str6, sizeof(str6),"%.1f",Fuell[vehicleid]);
		format(str5, sizeof(str5), "%s",locked);
		format(str4, sizeof(str4), "KM/H");
		format(str3, sizeof(str3), "SPEED:");
		format(str7, sizeof(str7), "%s",engineshow);
		format(str8, sizeof(str8), "%s",lightshow);
		format(str9, sizeof(str9), "%.1f",Probeg[vehicleid]);
		format(str10, sizeof(str10), "Mileage:");
		if(SpeedVehicle(playerid) >= 1)
		{
			Fuell[vehicleid] -= 0.005;
			if(GetPlayerVehicleID(playerid) == caridhouse[playerid])
			{
				PlayerInfo[playerid][pFuelcar] -= 0.005;
			}
		}
		new carid = GetPlayerVehicleID(playerid);
		if(SuperGt(carid))
		{
			if(SpeedVehicle(playerid) >= 1)
			{
				Fuell[vehicleid] -= 0.009;
				if(GetPlayerVehicleID(playerid) == caridhouse[playerid])
				{
					PlayerInfo[playerid][pFuelcar] -=0.009;
				}
			}
		}
		TextDrawSetString(SpeedShow[playerid],str1);
		TextDrawSetString(FuelShow[playerid],str2);
		TextDrawSetString(KMShow[playerid],str3);
		TextDrawSetString(KmShow[playerid],str4);
		TextDrawSetString(StatusShow[playerid],str5);
		TextDrawSetString(FillShow[playerid],str6);
		TextDrawSetString(EngineShow[playerid],str7);
		TextDrawSetString(LightShow[playerid],str8);
		TextDrawSetString(Probegs[playerid],str9);
		TextDrawSetString(TextProbegs[playerid],str10);
	}
}
publics UpdateTaxi(playerid)
{
    new str1[12],str2[12];
	if(IsPlayerInAnyVehicle(playerid))
	{
    	format(str1, sizeof(str1),"%.1f",str1);
		format(str2, sizeof(str2),"Miles:");
		TextDrawSetString(TaxiProbegs[playerid],str1);
		TextDrawSetString(TaxiProbegss[playerid],str2);
	}
}
publics ToProbeg(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) return 1;
	if(PlayerEx[playerid][Var] > 1 || PlayerEx[playerid][VarEx] > 1) return 1;
	new Float:sp = GetSpeedKMH(playerid);
	new Float:l = (sp/2)/2000;
	Probeg[GetPlayerVehicleID(playerid)] += l;
	if(TransportDuty[playerid] == 2)
	{
		TaxiProbeg[playerid] += l;
		TaxiTime[playerid]++;
		TransportMoney[playerid] = TransportValue[playerid] * floatround(TaxiProbeg[playerid]);
	}
	return 1;
}
stock GetSpeedKMH(playerid)
{
	new Float:ST[4];
	if(IsPlayerInAnyVehicle(playerid))
	GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
	ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 253.3;
	return floatround(ST[3]);
}


publics SyncUp()
{
	DollahScoreUpdate();
}
public OnPlayerRequestClass(playerid, classid)
{
    SendClientMessage(playerid, 0xFF9900AA, "Добро пожаловать на Sectum RolePlay");
	SetPlayerInterior(playerid,0);
	SetPlayerFacingAngle(playerid, 266.9181);
	SetPlayerCameraPos(playerid, -251.6631,-1922.8071,24.1652);
	SetPlayerCameraLookAt(playerid, -251.6631,-1922.8071,24.1652);
	format(QUERY, sizeof(QUERY), "SELECT * FROM `accounts` WHERE `Name` = '%s'",GN(playerid));
   	mysql_function_query(MySql_Base,QUERY,true,"OnMySQL_QUERY","iis",2,playerid,"");
   	TogglePlayerControllable(playerid, 0);
	return 1;
}

public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
    SetPlayerHealthAC(playerid, 100);
    SetPlayerColor(playerid,0xFFFFFF00);
    dostup[playerid] = false;
    pdostup[playerid] = 0;
    gSpectateID[playerid] = INVALID_PLAYER_ID;
    dinamicash[playerid] = CreateDynamicCP(-2026.7144,-114.3898,1035.1719,1.5, 1, 3, playerid,5.0);
//	SetPlayerCheckpoint(playerid, 2435.0662,-770.4659,1422.3634, 6);
	TextDrawShowForPlayer(playerid, URL[playerid]);
	
	STimer[playerid] = SetTimerEx("UpdateSpeedometr", 300, true, "d", playerid); // таймер!
	SpeedShow[playerid] = TextDrawCreate(234.000000, 377.125000,"0"); //nai Text Draw km/h
	TextDrawBackgroundColor(SpeedShow[playerid],0x000000AA);//iaaiaea oaenoa
	TextDrawLetterSize(SpeedShow[playerid],0.427499, 1.993749);//?acia? oaenoa
	TextDrawAlignment(SpeedShow[playerid], 3);
	TextDrawFont(SpeedShow[playerid],3);//noeeu
	TextDrawColor(SpeedShow[playerid],0x62AD50FF);//oaao oaenoa
	TextDrawSetOutline(SpeedShow[playerid],1);//?acia? iaaiaee
	TextDrawSetProportional(SpeedShow[playerid],1);
	TextDrawSetShadow(SpeedShow[playerid],1);//oaiu
	
	StatusShow[playerid] = TextDrawCreate(231.749664, 395.500061, "Lock");
	TextDrawLetterSize(StatusShow[playerid], 0.407364, 1.448333);
	TextDrawAlignment(StatusShow[playerid], 1);
	TextDrawColor(StatusShow[playerid], -2147483393);
	TextDrawSetShadow(StatusShow[playerid], 0);
	TextDrawSetOutline(StatusShow[playerid], 1);
	TextDrawBackgroundColor(StatusShow[playerid], 255);
	TextDrawFont(StatusShow[playerid], 1);
	TextDrawSetProportional(StatusShow[playerid], 1);

	KMShow[playerid] = TextDrawCreate(140.000000, 378.000000, "_");//nai SPEED:
	TextDrawBackgroundColor(KMShow[playerid], 0x000000AA);//iaaiaea oaenoa
	TextDrawLetterSize(KMShow[playerid],0.407499, 1.788123);//?acia? oaenoa
	TextDrawFont(KMShow[playerid], 2);//noeeu
	TextDrawColor(KMShow[playerid], 0x237687AA);//oaao oaenoa
	TextDrawSetOutline(KMShow[playerid], 1);//?acia? iaaiaee
	TextDrawSetProportional(KMShow[playerid],1);
	TextDrawSetShadow(KMShow[playerid],1);//oaiu

	KmShow[playerid] = TextDrawCreate(239.000000, 378.000000, "_");//nai Text Draw Status
	TextDrawBackgroundColor(KmShow[playerid], 0x000000AA);//iaaiaea oaenoa
	TextDrawLetterSize(KmShow[playerid],0.287000, 1.967499);//?acia? oaenoa
	TextDrawFont(KmShow[playerid], 1);//noeeu
	TextDrawColor(KmShow[playerid], 0x2C96ABAA);//oaao oaenoa
	TextDrawSetOutline(KmShow[playerid], 1);//?acia? iaaiaee
	TextDrawSetProportional(KmShow[playerid],1);
	TextDrawSetShadow(KmShow[playerid],1);//oaiu

	FuelShow[playerid] = TextDrawCreate(138.500000, 392.437500, "_");//nai Text Draw fuel
	TextDrawBackgroundColor(FuelShow[playerid], 0x000000AA);//iaaiaea oaenoa
	TextDrawLetterSize(FuelShow[playerid],0.407999, 1.827500);//?acia? oaenoa
	TextDrawFont(FuelShow[playerid], 1);//noeeu
	TextDrawColor(FuelShow[playerid], 0xAA3333AA);//oaao oaenoa
	TextDrawSetOutline(FuelShow[playerid], 1);//?acia? iaaiaee
	TextDrawSetProportional(FuelShow[playerid],1);
	TextDrawSetShadow(FuelShow[playerid],1);//oaiu

	FillShow[playerid] = TextDrawCreate(175.000000, 392.000000, "_");//nai Text Draw fuel
	TextDrawBackgroundColor(FillShow[playerid], 0x000000AA);//iaaiaea oaenoa
	TextDrawLetterSize(FillShow[playerid],0.420500, 1.906249);//?acia? oaenoa
	TextDrawFont(FillShow[playerid], 3);//noeeu
	TextDrawColor(FillShow[playerid], 0x62AD50FF);//oaao oaenoa
	TextDrawSetOutline(FillShow[playerid], 1);//?acia? iaaiaee
	TextDrawSetProportional(FillShow[playerid],1);
	TextDrawSetShadow(FillShow[playerid],1);//oaiu

	EngineShow[playerid] = TextDrawCreate(268.294433, 382.083374, "Engine");
	TextDrawLetterSize(EngineShow[playerid], 0.407831, 1.244166);
	TextDrawAlignment(EngineShow[playerid], 1);
	TextDrawColor(EngineShow[playerid], 10420394);
	TextDrawSetShadow(EngineShow[playerid], 0);
	TextDrawSetOutline(EngineShow[playerid], 1);
	TextDrawBackgroundColor(EngineShow[playerid], 255);
	TextDrawFont(EngineShow[playerid], 1);
	TextDrawSetProportional(EngineShow[playerid], 1);

	LightShow[playerid] = TextDrawCreate(269.699951, 395.499908, "Lights");
	TextDrawLetterSize(LightShow[playerid], 0.430321, 1.413333);
	TextDrawAlignment(LightShow[playerid], 1);
	TextDrawColor(LightShow[playerid], 65535);
	TextDrawSetShadow(LightShow[playerid], 0);
	TextDrawSetOutline(LightShow[playerid], 1);
	TextDrawBackgroundColor(LightShow[playerid], 255);
	TextDrawFont(LightShow[playerid], 1);
	TextDrawSetProportional(LightShow[playerid], 1);

	TextProbegs[playerid] = TextDrawCreate(139.450973, 410.666656, "Mileage:");
	TextDrawLetterSize(TextProbegs[playerid], 0.449999, 1.600000);
	TextDrawAlignment(TextProbegs[playerid], 1);
	TextDrawColor(TextProbegs[playerid], -1329275232);
	TextDrawSetShadow(TextProbegs[playerid], 0);
	TextDrawSetOutline(TextProbegs[playerid], 1);
	TextDrawBackgroundColor(TextProbegs[playerid], 255);
	TextDrawFont(TextProbegs[playerid], 1);
	TextDrawSetProportional(TextProbegs[playerid], 1);

	Probegs[playerid] = TextDrawCreate(247.679473, 409.500000, "0.0");
	TextDrawLetterSize(Probegs[playerid], 0.443908, 1.885833);
	TextDrawAlignment(Probegs[playerid], 1);
	TextDrawColor(Probegs[playerid], 0x62AD50FF);
	TextDrawSetShadow(Probegs[playerid], 0);
	TextDrawSetOutline(Probegs[playerid], 1);
	TextDrawBackgroundColor(Probegs[playerid], 0x000000AA);
	TextDrawFont(Probegs[playerid], 3);
	TextDrawSetProportional(Probegs[playerid], 1);
	//==========================================================================
	ReconText[playerid] = TextDrawCreate(510.000000, 120.000000, "_");
	TextDrawFont(ReconText[playerid], 2);
	TextDrawSetShadow(ReconText[playerid], 1);
	TextDrawBackgroundColor(ReconText[playerid], 0x00000044);
	TextDrawSetProportional(ReconText[playerid], 3);
    TextDrawAlignment(ReconText[playerid], 1);
	TextDrawSetOutline(ReconText[playerid], 0);
	TextDrawLetterSize(ReconText[playerid], 0.300000, 1.200000);
	TextDrawHideForPlayer(playerid, ReconText[playerid]);

	TaxiTimess[playerid] = TextDrawCreate(518.184692, 284.083404, "Time:");
	TextDrawLetterSize(TaxiTimess[playerid], 0.449999, 1.600000);
	TextDrawAlignment(TaxiTimess[playerid], 1);
	TextDrawColor(TaxiTimess[playerid], -65281);
	TextDrawSetShadow(TaxiTimess[playerid], 0);
	TextDrawSetOutline(TaxiTimess[playerid], 1);
	TextDrawBackgroundColor(TaxiTimess[playerid], 51);
	TextDrawFont(TaxiTimess[playerid], 1);
	TextDrawSetProportional(TaxiTimess[playerid], 1);

	TaxiProbegss[playerid] = TextDrawCreate(517.715942, 298.083282, "Miles:");
	TextDrawLetterSize(TaxiProbegss[playerid], 0.449999, 1.600000);
	TextDrawAlignment(TaxiProbegss[playerid], 1);
	TextDrawColor(TaxiProbegss[playerid], -65281);
	TextDrawSetShadow(TaxiProbegss[playerid], 0);
	TextDrawSetOutline(TaxiProbegss[playerid], 1);
	TextDrawBackgroundColor(TaxiProbegss[playerid], 51);
	TextDrawFont(TaxiProbegss[playerid], 1);
	TextDrawSetProportional(TaxiProbegss[playerid], 1);

	TransportMoneyss[playerid] = TextDrawCreate(517.716064, 310.916717, "Total:");
	TextDrawLetterSize(TransportMoneyss[playerid], 0.449999, 1.600000);
	TextDrawAlignment(TransportMoneyss[playerid], 1);
	TextDrawColor(TransportMoneyss[playerid], -65281);
	TextDrawSetShadow(TransportMoneyss[playerid], 0);
	TextDrawSetOutline(TransportMoneyss[playerid], 1);
	TextDrawBackgroundColor(TransportMoneyss[playerid], 51);
	TextDrawFont(TransportMoneyss[playerid], 1);
	TextDrawSetProportional(TransportMoneyss[playerid], 1);

	TaxiTimes[playerid] = TextDrawCreate(561.288391, 284.666625, "_");
	TextDrawLetterSize(TaxiTimes[playerid], 0.318345, 1.728332);
	TextDrawAlignment(TaxiTimes[playerid], 1);
	TextDrawColor(TaxiTimes[playerid], -1);
	TextDrawSetShadow(TaxiTimes[playerid], 0);
	TextDrawSetOutline(TaxiTimes[playerid], 1);
	TextDrawBackgroundColor(TaxiTimes[playerid], 51);
	TextDrawFont(TaxiTimes[playerid], 1);
	TextDrawSetProportional(TaxiTimes[playerid], 1);

	TaxiProbegs[playerid] = TextDrawCreate(576.281127, 296.916656, "_");
	TextDrawLetterSize(TaxiProbegs[playerid], 0.321156, 1.897500);
	TextDrawAlignment(TaxiProbegs[playerid], 1);
	TextDrawColor(TaxiProbegs[playerid], -1);
	TextDrawSetShadow(TaxiProbegs[playerid], 0);
	TextDrawSetOutline(TaxiProbegs[playerid], 1);
	TextDrawBackgroundColor(TaxiProbegs[playerid], 51);
	TextDrawFont(TaxiProbegs[playerid], 1);
	TextDrawSetProportional(TaxiProbegs[playerid], 1);

	TransportMoneys[playerid] = TextDrawCreate(565.036499, 310.916625, "_");
	TextDrawLetterSize(TransportMoneys[playerid], 0.327715, 1.909166);
	TextDrawAlignment(TransportMoneys[playerid], 1);
	TextDrawColor(TransportMoneys[playerid], -1);
	TextDrawSetShadow(TransportMoneys[playerid], 0);
	TextDrawSetOutline(TransportMoneys[playerid], 1);
	TextDrawBackgroundColor(TransportMoneys[playerid], 51);
	TextDrawFont(TransportMoneys[playerid], 1);
	TextDrawSetProportional(TransportMoneys[playerid], 1);

	TextDrawHideForPlayer(playerid,Box);
	TextDrawHideForPlayer(playerid,Speed);
	TextDrawHideForPlayer(playerid,SpeedShow[playerid]);
	TextDrawHideForPlayer(playerid,Fuel);
	TextDrawHideForPlayer(playerid,FuelShow[playerid]);
	TextDrawHideForPlayer(playerid,FillShow[playerid]);
	TextDrawHideForPlayer(playerid,EngineShow[playerid]);
	TextDrawHideForPlayer(playerid,LightShow[playerid]);
	TextDrawHideForPlayer(playerid,Probegs[playerid]);
	TextDrawHideForPlayer(playerid,TextProbegs[playerid]);
	TextDrawHideForPlayer(playerid,Status);
	TextDrawHideForPlayer(playerid,StatusShow[playerid]);
	TextDrawHideForPlayer(playerid,KMShow[playerid]);
	TextDrawHideForPlayer(playerid,KmShow[playerid]);
	TextDrawHideForPlayer(playerid,TaxiTimess[playerid]);
	TextDrawHideForPlayer(playerid,TaxiProbegss[playerid]);
	TextDrawHideForPlayer(playerid,TransportMoneyss[playerid]);
	TextDrawHideForPlayer(playerid,TransportMoneys[playerid]);
	TextDrawHideForPlayer(playerid,TaxiProbegs[playerid]);
	TextDrawHideForPlayer(playerid,TaxiTimes[playerid]);

	// ================== Подключения игрока ==============================================
	new string7[148];
	new ipplayer[20];
	GetPlayerIp(playerid,ipplayer,sizeof(ipplayer));
	format(string7, sizeof(string7), "Подключился игрок: id:%d Name: %s IP: %s",playerid,GN(playerid),ipplayer);
	ABroadCastcc(string7);
    // ================== Логотип ==============================================
	URL[playerid] = TextDrawCreate(499.91, 2.3, "Sectum RolePlay");
	TextDrawFont(URL[playerid], 1);
    TextDrawColor(URL[playerid],0x33AA33AA);
    TextDrawLetterSize(URL[playerid], 0.39, 1.494);
    TextDrawSetOutline(URL[playerid], 1);
    TextDrawShowForPlayer(playerid, URL[playerid]);
    RemoveBuilding(playerid);
    GangZoneShowForPlayer(playerid, Army, 0xF5DEB3AA);
    ResetPlayerWeapons(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(Login[playerid]) SaveAccount(playerid);
    new string[75];
    DeletePVar(playerid,"Tut");
	PlayerEx[playerid][VarEx] = 0;
	PlayerEx[playerid][Var] = 0;
	PlayerInfo[playerid][pSlot][0] = 0;
	PlayerInfo[playerid][pSlot][1] = 0;
	PlayerInfo[playerid][pSlot][2] = 0;
	PlayerInfo[playerid][pSlot][3] = 0;
	PlayerInfo[playerid][pSlot][4] = 0;
	PlayerInfo[playerid][pSlot][5] = 0;
	PlayerInfo[playerid][pSlot][6] = 0;
	PlayerInfo[playerid][pSlot][7] = 0;
	PlayerInfo[playerid][pSlot][8] = 0;
	PlayerInfo[playerid][pSlot][9] = 0;
	PlayerInfo[playerid][pSlot][10] = 0;
	PlayerInfo[playerid][pSlot][11] = 0;
	PlayerInfo[playerid][pSlot][12] = 0;
	PlayerInfo[playerid][pSlotammo][0] = 0;
	PlayerInfo[playerid][pSlotammo][1] = 0;
	PlayerInfo[playerid][pSlotammo][2] = 0;
	PlayerInfo[playerid][pSlotammo][3] = 0;
	PlayerInfo[playerid][pSlotammo][4] = 0;
	PlayerInfo[playerid][pSlotammo][5] = 0;
	PlayerInfo[playerid][pSlotammo][6] = 0;
	PlayerInfo[playerid][pSlotammo][7] = 0;
	PlayerInfo[playerid][pSlotammo][8] = 0;
	PlayerInfo[playerid][pSlotammo][9] = 0;
	PlayerInfo[playerid][pSlotammo][10] = 0;
	PlayerInfo[playerid][pSlotammo][11] = 0;
	PlayerInfo[playerid][pSlotammo][12] = 0;
	startnarko[playerid] = 0;
	Drugtime[playerid] = 0;
	JobCP[playerid] = 0;
	JobAmmount[playerid] = 0;
	usemesh[playerid] = 0;
	useguns[playerid] = 0;
	mesh[playerid] = 999;
	PlayerStartJob[playerid] = false;
	Works[playerid] = false;
	GetPlayerMetall[playerid] = 0;
	JobAmmount[playerid] = 0;
	JobCarTime[playerid] = 0;
	TransportMoney[playerid] = 0;
	TransportDuty[playerid] = 0;
	DisablePlayerCheckpoint(playerid);
    RemovePlayerAttachedObject(playerid,0);
    RemovePlayerAttachedObject(playerid,1);
    RemovePlayerAttachedObject(playerid,2);
    RemovePlayerAttachedObject(playerid,3);
    RemovePlayerAttachedObject(playerid,4);
    RemovePlayerAttachedObject(playerid,5);
    RemovePlayerAttachedObject(playerid,6);
    RemovePlayerAttachedObject(playerid,7);
    RemovePlayerAttachedObject(playerid,8);
	RemovePlayerAttachedObject(playerid,9);
	TextDrawDestroy(URL[playerid]);
	TextDrawDestroy(SpeedShow[playerid]);
	TextDrawDestroy(FuelShow[playerid]);
	TextDrawDestroy(FillShow[playerid]);
	TextDrawDestroy(EngineShow[playerid]);
	TextDrawDestroy(LightShow[playerid]);
	TextDrawDestroy(Probegs[playerid]);
	TextDrawDestroy(TextProbegs[playerid]);
	TextDrawDestroy(StatusShow[playerid]);
	TextDrawDestroy(KMShow[playerid]);
	TextDrawDestroy(KmShow[playerid]);
	TextDrawDestroy(ReconText[playerid]);
	KillTimer(STimer[playerid]);
	if(PlayerInfo[playerid][pAdmin] > 0)
	{
		dostup[playerid] = false;
		format(string, sizeof(string), "<Admin-Exit> Администратор %s[%d] вышел(ла)",GN(playerid),playerid);
		ABroadCast(COLOR_LIGHTRED,string,1);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!Login[playerid] && GetPVarInt(playerid,"Tut") == 0) return SendClientMessage(playerid, -1, "Необходимо авторизоваться!"), KickFix(playerid);
	if(GetPVarInt(playerid,"Tut") == 1)
	{
		PlayerInfo[playerid][pHP] = 100;
		SetPlayerHealthAC(playerid, PlayerInfo[playerid][pHP]);
		ChosePlayerSkin(playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pMember] >= 1)
	{
        SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	}
		else
	{
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
	}
	SetPlayerToTeamColor(playerid);
	SetPlayerSpawn(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(JobCP[playerid] == 2 || JobCP[playerid] == 1)
	{
	    new Moneys = JobAmmount[playerid]*2;
	    PlayerStartJob[playerid] = false;
		GetPlayerMetall[playerid] = 0;
		JobAmmount[playerid] = 0;
		SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
		PlayerInfo[playerid][pCash] += Moneys;
		Works[playerid] = false; JobAmmount[playerid] = 0; JobCP[playerid] = 0;
	}
    PlayerHealth[playerid] = 100;
    PlayerInfo[killerid][pKills]+=1;
    SetPlayerHealthAC(playerid, PlayerHealth[playerid]);
    ResetPlayerWeapons(playerid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(!Login[playerid]) return false;
    if(GetPVarInt(playerid,"AntiFlood") > gettime())
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Не флуди");
		return 0;
	}
	if(IsMute(playerid)) return 0;
	new string[156];
	new ip[15];
	GetPlayerIp(playerid,ip,sizeof(ip));
	if(IsIP(text) || CheckString(text))
	{
		PlayerInfo[playerid][pMute] = 10800;
		format(string, sizeof(string), "%s: %s",GN(playerid),text);
		ABroadCast(COLOR_LIGHTRED,string,1);
		format(string, sizeof(string), "- ID: %d | IP: [%s]",playerid,ip);
		ABroadCast(COLOR_LIGHTRED,string,1);
		format(string,sizeof(string),"Вы получили молчанку на 3 часа /mm - репорт");
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
		SetPlayerChatBubble(playerid,"заткнут(а)",0xC2A2DAAA,30.0,10000);
		return 0;
	}
	for(new s; s<sizeof(AntiMat); s++)
	{
		new pos;
		while((pos = strfind(text,AntiMat[s],true)) != -1) for(new i = pos, j = pos + strlen(AntiMat[s]); i < j; i++)
		{
			text[i] = '*';
		}
	}
/*	if(TalkingLive[playerid] == 1)
	{
		if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
		format(string, sizeof(string), "< SF News > [Тел.] %s: %s", GN(playerid), text);
		OOCNews(COLOR_GREEN, string);
	}
	if(TalkingLivels[playerid] == 1)
	{
		if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
		format(string, sizeof(string), "< LS News > [Тел.] %s: %s", GN(playerid), text);
		LSNews(0x00D3F6AA, string);
	}
	if(TalkingLivelv[playerid] == 1)
	{
		if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
		format(string, sizeof(string), "< LV News > [Тел.] %s: %s", GN(playerid), text);
		LVNews(TEAM_CYAN_COLOR, string);
	}
	if(TalkingLive[playerid] == 2)
	{
		if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
		if(PlayerInfo[playerid][pMember] == 10)
		{
			format(string, sizeof(string), "< SF News > Ведущий %s: %s", GN(playerid), text);
			OOCNews(COLOR_GREEN, string);
			return 0;
		}
		else
		{
			format(string, sizeof(string), "< SF News > Гость %s: %s", GN(playerid), text);
			OOCNews(COLOR_GREEN, string);
			return 0;
		}
	}
	if(TalkingLivels[playerid] == 2)
	{
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
		if(PlayerInfo[playerid][pMember] == 17)
		{
			format(string, sizeof(string), "< LS News > Ведущий %s: %s", GN(playerid), text);
			LSNews(0x00D3F6AA, string);
			return 0;
		}
		else
		{
			format(string, sizeof(string), "< LS News > Гость %s: %s", GN(playerid), text);
			LSNews(0x00D3F6AA, string);
			return 0;
		}
	}
	if(TalkingLivelv[playerid] == 2)
	{
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
		if(PlayerInfo[playerid][pMember] == 21)
		{
			format(string, sizeof(string), "< LV News > Ведущий %s: %s", GN(playerid), text);
			LVNews(TEAM_CYAN_COLOR, string);
			return 0;
		}
		else
		{
			format(string, sizeof(string), "< LV News > Гость %s: %s", GN(playerid), text);
			LVNews(TEAM_CYAN_COLOR, string);
			return 0;
		}
	}
	if(Tel[playerid] == 1)
	{
		new idx;
		tmp = strtok(text, idx);
		format(string, sizeof(string), "[Телефон] %s: %s", GN(playerid), text);
		ProxDetector(0,20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		return 0;
	}
	if(Mobile[playerid] != 255)
	{
		new idx;
		tmp = strtok(text, idx);
		format(string, sizeof(string), "[Телефон] %s: %s", GN(playerid), text);
		ProxDetector(0,20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	}
	if(IsPlayerConnected(Mobile[playerid]))
	{
		if(Mobile[Mobile[playerid]] == playerid)
		{
			SendClientMessage(Mobile[playerid], 0xFFFF00AA,string);
		}
		else
		{
			SendClientMessage(playerid, 0xB4B5B7FF,"На второй линии ни кого нет");
		}
		return 0;
	}
	if(PEfir[playerid] != 255)
	{
		if(PlayerInfo[playerid][pMember] == 10 || PlayerInfo[playerid][pLeader] == 10)
		{
			if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!");return 0; }
			format(string, sizeof(string), "< SF News > %s: %s", GN(playerid), text);
			OOCNews(COLOR_GREEN, string);
		}
		if(PlayerInfo[playerid][pMember] == 21 || PlayerInfo[playerid][pLeader] == 21)
		{
			if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
			format(string, sizeof(string), "< LV News > %s: %s", GN(playerid), text);
			LVNews(TEAM_CYAN_COLOR, string);
		}
		if(PlayerInfo[playerid][pMember] == 15 || PlayerInfo[playerid][pLeader] == 15)
		{
			if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
			format(string, sizeof(string), "< LS News > %s: %s", GN(playerid), text);
			LSNews(0x00D3F6AA, string);
		}
		if(Pefir[playerid] == 1)
		{
			if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
			format(string, sizeof(string), "< SF News > %s: %s", GN(playerid), text);
			OOCNews(COLOR_GREEN, string);
		}
		if(Pefir[playerid] == 2)
		{
			if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
			format(string, sizeof(string), "< LS News > %s: %s", GN(playerid), text);
			LSNews(0x008080AA, string);
		}
		if(Pefir[playerid] == 3)
		{
			if(PlayerInfo[playerid][pMuted] == 1) { SendClientMessage(playerid, TEAM_CYAN_COLOR, "У Вас молчанка!"); return 0; }
			format(string, sizeof(string), "< LV News > %s: %s", GN(playerid), text);
			LSNews(TEAM_CYAN_COLOR, string);
		}
		return 0;
	}*/
	if(strcmp(text, "привет", true) == 0 || strcmp(text, "ку", true) == 0 || strcmp(text, "хай", true) == 0|| strcmp(text, "q", true) == 0 || strcmp(text, "re", true) == 0 || strcmp(text, "ghbdtn", true) == 0)
	{
		switch(PlayerInfo[playerid][pMember])
		{
			case 13:
			{
				format(string,sizeof(string), "показал(a) распальцовку Los Santos Vagos Gang");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) распальцовку Los Santos Vagos Gang", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,0,0,0,0,1);
				return 0;
			}
			case 15:
			{
				format(string,sizeof(string), "показал(a) распальцовку Grove Street Gang");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) распальцовку Grove Street Gang", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,0,0,0,0,1);
				return 0;
			}
			case 17:
			{
				format(string,sizeof(string), "показал(a) распальцовку Varios Los Aztecas Gang");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) распальцовку Varios Los Aztecas Gang", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,0,0,0,0,1);
				return 0;
			}
			case 12:
			{
				format(string,sizeof(string), "показал(a) распальцовку The Ballas Gang");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) распальцовку The Ballas Gang", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,0,0,0,0,1);
				return 0;
			}
			case 18:
			{
				format(string,sizeof(string), "показал(a) распальцовку The Rifa Gang");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) распальцовку The Rifa Gang", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,0,0,0,0,1);
				return 0;
			}
			case 6:
			{
				format(string,sizeof(string), "показал(a) татуировку Yakuza's Family");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) татуировку Yakuza's Family", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GANGS","prtial_hndshk_01",4.0,0,0,0,0,0,1);
				return 0;
			}
			case 5:
			{
				format(string,sizeof(string), "показал(a) татуировку La Cosa Nostra's Family");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) татуировку La Cosa Nostra's Family", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GANGS","prtial_hndshk_01",4.0,0,0,0,0,0,1);
				return 0;
			}
			case 14:
			{
				format(string,sizeof(string), "показал(a) наколку 'Золотые купола'");
				SetPlayerChatBubble(playerid,string,0xC2A2DAAA,30.0,10000);
				format(string, sizeof(string), "%s показал(a) наколку 'Золотые купола'", GN(playerid));
				ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				ApplyAnimation(playerid,"GANGS","prtial_hndshk_01",4.0,0,0,0,0,0,1);
				return 0;
			}
		}
	}
	if(strcmp(text, "эй", true) == 0 || strcmp(text, "э", true) == 0 || strcmp(text, "эй бля", true) == 0|| strcmp(text, "блять", true) == 0 || strcmp(text, "Блядь", true) == 0 || strcmp(text, "мля", true) == 0)
	{
		SetPlayerChatBubble(playerid,"возмущается",0xC2A2DAAA,30.0,10000);
		ApplyAnimation(playerid,"PED","fucku",4.0,0,0,0,0,0,1);
		return 0;
	}
	if(strcmp(text, "мда", true) == 0 || strcmp(text, "идиот", true) == 0 || strcmp(text, "сука", true) == 0 || strcmp(text, "пидр", true) == 0 )
	{
		SetPlayerChatBubble(playerid, "Facepalm", 0xC2A2DAAA, 30.0, 10000);
		ApplyAnimation(playerid,"MISC","plyr_shkhead",4.0,0,0,0,0,0,1);
		return 0;
	}
	else if(strcmp(text, "*105#", true) == 0)
	{
		SendClientMessage(playerid, 0x9ACD32AA, "==[ Мобильный баланс ] ==");
		format(string, sizeof(string), "- Баланс %d рублей",PlayerInfo[playerid][pMobile]);
		SendClientMessage(playerid, -1, string);
		SendClientMessage(playerid, -1, "- Пополнить баланс можно в любом банкомате");
		SendClientMessage(playerid, 0x9ACD32AA, "==[ Мобильный баланс ] ==");
		format(string, sizeof(string), "%s достаёт мобильник", GN(playerid));
		ProxDetector(2,5.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		return 0;
	}
	else if(strcmp(text, "xD", true) == 0 || strcmp(text, "xd", true) == 0 || strcmp(text, ":В", true) == 0 || strcmp(text, ":в", true) == 0 )
	{
		format(string, sizeof(string), "%s смеётся", GN(playerid));
		ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		SetPlayerChatBubble(playerid, "смеётся", 0xC2A2DAAA, 30.0, 10000);
		return 0;
	}
	else if(strcmp(text, "здравия", true) == 0)
	{
		format(string, sizeof(string), "%s отдал(а) честь", GN(playerid));
		ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		SetPlayerChatBubble(playerid,"отдал честь",0xC2A2DAAA,30.0,10000);
		return 0;
	}
	else if(strcmp(text, "чВ", true) == 0 || strcmp(text, "хД", true) == 0 || strcmp(text, "хд", true) == 0 || strcmp(text, "xDD", true) == 0)
	{
		format(string, sizeof(string), "%s валяется от смеха", GN(playerid));
		ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		SetPlayerChatBubble(playerid,"валяется от смеха",0xC2A2DAAA,30.0,10000);
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			ApplyAnimation(playerid,"FINALE","FIN_Land_Die",4.1,0,1,1,1,1,1);
			clearanim[playerid] = 5;
		}
		return 0;
	}
	else if(strcmp(text, ")", true) == 0 || strcmp(text, "))", true) == 0)
	{
		format(string, sizeof(string), "%s улыбается", GN(playerid));
		ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		SetPlayerChatBubble(playerid,"улыбается",0xC2A2DAAA,30.0,10000);
		return 0;
	}
	else if(strcmp(text, ":D", true) == 0)
	{
		format(string, sizeof(string), "%s хохочет во весь голос", GN(playerid));
		ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		SetPlayerChatBubble(playerid,"хохочет во весь голос",0xC2A2DAAA,30.0,10000);
		return 0;
	}
	else if(strcmp(text, "(", true) == 0 || strcmp(text, "((", true) == 0)
	{
		format(string, sizeof(string), "%s грустит", GN(playerid));
		ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		SetPlayerChatBubble(playerid,"грустит",0xC2A2DAAA,30.0,10000);
		return 0;
	}
	if(PlayerInfo[playerid][pMute] != 0)
	{
		format(string, sizeof(string), "У Вас молчанка! До снятия: %d секунд(ы)",PlayerInfo[playerid][pMute]);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
		return 0;
	}
	if(gag[playerid] == 1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "У Вас кляп, вы не можете говорить!");
		return 0;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,0,1,1,1,1,1);
		SetTimerEx("ClearAnim",2400,false,"d",playerid);
		clearanim[playerid] = 7;
	}
	format(string, sizeof(string), "- %s: %s", GN(playerid), text);
	SetPlayerChatBubble(playerid, text, 0x6495EDFF, 20.0, 10000);
	ProxDetector(0,20.0, playerid, string,0xE6E6E6E6,0xC8C8C8C8,0xAAAAAAAA,0x8C8C8C8C,0x6E6E6E6E);
	SetPVarInt(playerid,"AntiFlood",gettime() + 1);
	return 0;
}


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    PlayerEx[playerid][VarEx] = 0;
    SetVehicleParamsForPlayer(vehicleid, playerid, 0, gCarLock[vehicleid]);
	if(IsLocked[vehicleid])
	{
		new Float:cx, Float:cy, Float:cz;
		GetPlayerPos(playerid, cx, cy, cz);
		SetPlayerPos(playerid, cx, cy, cz);
		SetVehicleParamsForPlayer(vehicleid,playerid,0,1);
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    PlayerEx[playerid][VarEx] = 0;
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new string[60];
	if(Works[playerid] == true && JobCP[playerid] == 4 && newstate == PLAYER_STATE_DRIVER)
	{
	    mesh[playerid] =1;
		if(PlayerToPoint(2.0,playerid,278.7468,1797.6921,17.6406)) return true;
		SendClientMessage(playerid,0xAA3333AA, "Вы уронили мешок!");
		DisablePlayerCheckpoint(playerid);
		ApplyAnimation(playerid, "CARRY", "crry_prtial",4.0,0,0,0,0,1,1);
		if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
		SetPlayerCheckpoint(playerid,2230.3528,-2286.1353,14.3751,1.5);
		JobCP[playerid] = 1;
	}
	if(PlayerStartJob[playerid] && newstate == PLAYER_STATE_DRIVER && JobCP[playerid] == 4)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 1, -1806.6079,-1648.0281,23.9643)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1799.5336,-1639.3250,23.9315)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1798.5327,-1645.6477,27.5683)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1800.4752,-1651.9133,27.6460)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1828.6937,-1662.7900,21.7500))
        {
            SendClientMessage(playerid, 0xAA3333AA, "Вы уронили камень.");
            DisablePlayerCheckpoint(playerid);
            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 1);
            PlayerStartJob[playerid] = false;
            if(IsPlayerAttachedObjectSlotUsed(playerid, 7)) RemovePlayerAttachedObject(playerid, 7);
            SetPlayerAttachedObject(playerid, 6, 18634, 6, 0.078222, 0.000000, 0.110844, 298.897308, 264.126861, 193.350555, 1.000000, 1.000000, 1.000000);
            GetPlayerMetall[playerid] = 0;
            return 1;
        }
	}
    PlayerEx[playerid][VarEx] = 0;
    if(newstate == PLAYER_STATE_DRIVER)
	{
		timer2[playerid] = SetTimerEx("CheckForCheater",1000,true,"i",playerid);
		player_NoCheckTimeVeh[playerid] = 1;
	}
	if(oldstate == PLAYER_STATE_DRIVER)
	{
		KillTimer(timer2[playerid]);
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    UpdateSpeedometr(playerid);
	    TextDrawShowForPlayer(playerid,Box);
		TextDrawShowForPlayer(playerid,Speed);
		TextDrawShowForPlayer(playerid,SpeedShow[playerid]);
		TextDrawShowForPlayer(playerid,KMShow[playerid]);
		TextDrawShowForPlayer(playerid,KmShow[playerid]);
		if(!IsNoSpeed(GetPlayerVehicleID(playerid)))
		{
		    TextDrawShowForPlayer(playerid,EngineShow[playerid]);
			TextDrawShowForPlayer(playerid,LightShow[playerid]);
			TextDrawShowForPlayer(playerid,Probegs[playerid]);
			TextDrawShowForPlayer(playerid,TextProbegs[playerid]);
			TextDrawShowForPlayer(playerid,Status);
			TextDrawShowForPlayer(playerid,StatusShow[playerid]);
		}
		if(!IsNoSpeed(GetPlayerVehicleID(playerid)))
		{
			TextDrawShowForPlayer(playerid,Fuel);
			TextDrawShowForPlayer(playerid,FuelShow[playerid]);
			TextDrawShowForPlayer(playerid,FillShow[playerid]);
		}
		if(IsNoSpeed(GetPlayerVehicleID(playerid)))
		{
		    GetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,alarm,doors,bonnet,boot,objective);
		    SetVehicleParamsEx(GetPlayerVehicleID(playerid),1,lights,alarm,doors,bonnet,boot,objective);
		}
	}
	else if(newstate == PLAYER_STATE_ONFOOT)//выходит скрываем
	{
		TextDrawHideForPlayer(playerid,Box);
		TextDrawHideForPlayer(playerid,Speed);
		TextDrawHideForPlayer(playerid,SpeedShow[playerid]);
		TextDrawHideForPlayer(playerid,Fuel);
		TextDrawHideForPlayer(playerid,FuelShow[playerid]);
		TextDrawHideForPlayer(playerid,FillShow[playerid]);
		TextDrawHideForPlayer(playerid,EngineShow[playerid]);
		TextDrawHideForPlayer(playerid,LightShow[playerid]);
		TextDrawHideForPlayer(playerid,Probegs[playerid]);
		TextDrawHideForPlayer(playerid,TextProbegs[playerid]);
		TextDrawHideForPlayer(playerid,Status);
		TextDrawHideForPlayer(playerid,StatusShow[playerid]);
		TextDrawHideForPlayer(playerid,KMShow[playerid]);
		TextDrawHideForPlayer(playerid,KmShow[playerid]);
		if(TransportDuty[playerid] > 0)
		{
			Delete3DTextLabel(taxi3d[playerid]);
		}
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(Fuell[GetPlayerVehicleID(playerid)] <= 0)
		{
		    callcmd::en(playerid);
			SendClientMessage(playerid, 0xFF0000AA, "В автомобиле нет бензина");
			SendClientMessage(playerid, 0x33AA33AA, "{62AD50}Используйте телефон {FFFFFF}(( /c )) {62AD50}вызвать механика / таксиста");
		}
		if(!IsNoSpeed(GetPlayerVehicleID(playerid)))
		{
			if(zavodis[GetPlayerVehicleID(playerid)] == 0 && PlayerInfo[playerid][pLevel] <= 2)
			{
				SendClientMessage(playerid,0x33AA33AA,"{26931c}Чтобы завести двигатель нажмите на клавишу {ffffff}'2'{26931c} или введите {ffffff}'/en'");
			}
		}
	}
	if(newstate == PLAYER_STATE_PASSENGER) // TAXI
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		foreach(new i : Player)
		{
			if(IsPlayerConnected(i))
			{
				if(IsPlayerInVehicle(i, vehicleid) && GetPlayerState(i) == 2 && TransportDuty[i] == 1)
				{
					if(PlayerInfo[playerid][pLevel] > 1 && PlayerInfo[playerid][pCash] < TransportValue[i])
					{
						SendClientMessage(i, 0x33AA33AA, "У пассажира недостаточно денег, чтобы оплатить проезд");
					}
					if(PlayerInfo[playerid][pLevel] == 1)
					{
						SendClientMessage(playerid, 0x6495EDFF, "Для Вас проезд бесплатный");
						format(string, sizeof(string), "Для %s проезд оплачивает государство", GN(playerid));
						SendClientMessage(i, 0x6495EDFF, string);
					}
					format(string, sizeof(string), "Ваш следующий пассажир - %s", GN(playerid));
					SendClientMessage(i, 0x6495EDFF, string);
					TransportDuty[i] = 2;
					TextDrawShowForPlayer(i,Box1);
					TextDrawShowForPlayer(i,Box2);
					TextDrawShowForPlayer(i,TaxiProbegs[i]);
					TextDrawShowForPlayer(i,TaxiTimes[i]);
					TextDrawShowForPlayer(i,TransportMoneys[i]);
					TextDrawShowForPlayer(i,TaxiProbegss[i]);
					TextDrawShowForPlayer(i,TaxiTimess[i]);
					TextDrawShowForPlayer(i,TransportMoneyss[i]);
					return true;
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_DRIVER) //buggy dont finnish
	{// 38 / 49 / 56 = SS
		new newcar = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 548)//
		{
			SendClientMessage(playerid, -1, ":: Для загрузки/разгрузки материалов ::: Введите: /carmat");

		}
		if(newcar >= matslvcar[0] && newcar <= matslvcar[5])
		{
			format(string, sizeof(string), "Оружия: %d/%d", MatHaul[newcar-matslvcar[0]][mLoad],MatHaul[newcar-matslvcar[0]][mCapasity]);
			SendClientMessage(playerid, 0x00D900C8, string);
			SendClientMessage(playerid, -1, "(( Для загрузки/разгрузки Оружия ::: Введите: /carm ))");

		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 520)
		{
			if (PlayerInfo[playerid][pMember] != 3 && PlayerInfo[playerid][pLeader] != 19)
			{
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не генерал армии!");
				return 1;
			}
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 425)
		{
			if (PlayerInfo[playerid][pMember] != 3 && PlayerInfo[playerid][pLeader] != 19)
			{
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не генерал армии!");
				return 1;
			}
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 432)
		{
			if (PlayerInfo[playerid][pMember] != 3 && PlayerInfo[playerid][pLeader] != 19)
			{
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не генерал армии!");
				return 1;
			}
		}
		if(newcar >= liccar[0] && newcar <= liccar[9])
		{
            if(newcar >= liccar[0] && newcar <= liccar[8])
            {
	            if(PlayerInfo[playerid][pVodPrava] == 0 && TakingLesson[playerid] == 1)
				{
					if(JobCarTime[playerid] <= 16 && JobCarTime[playerid] >= 1)
					{
						JobCarTime[playerid] = 0;
					}
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_1;
					SetPlayerRaceCheckpoint(playerid,0,-2039.7438,-188.1508,35.0251,-2047.3491,-80.1809,34.8728,5.0);
					new pdddialog[800];
					format(pdddialog,sizeof(pdddialog), "%s%s%s%s%s%s%s%s%s%s%s%s%s",
					pdddialogMSG[0],pdddialogMSG[1],pdddialogMSG[2],pdddialogMSG[3],pdddialogMSG[4],pdddialogMSG[5],pdddialogMSG[6],pdddialogMSG[7],pdddialogMSG[8],pdddialogMSG[9],pdddialogMSG[10],pdddialogMSG[11],pdddialogMSG[12]);
					SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Правила дорожного движения", pdddialog, "Ок", "");
					return 1;
				}
			}
			if (PlayerInfo[playerid][pMember] != 11)
			{
				SendClientMessage(playerid,COLOR_GREY,"Вы не инструктор!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= rentcarsf[0] && newcar <= rentcarsf[5])
		{
			if(GetPVarInt(playerid,"arenda") != GetPlayerVehicleID(playerid))
			{
				SPD(playerid,9126,DIALOG_STYLE_MSGBOX,"Аренда машины","Стоимость аренды машины 5000 рублей","Снять","Отмена");
				TogglePlayerControllable(playerid, 0);
			}
		}
		if(newcar >= arendlod[0] && newcar <= arendlod[3])
		{
			if(GetPVarInt(playerid,"arenda") != GetPlayerVehicleID(playerid))
			{
				SPD(playerid,9888,DIALOG_STYLE_MSGBOX,"Аренда катера","Стоимость аренды машины 10000 рублей","Снять","Отмена");
				TogglePlayerControllable(playerid, 0);
			}
		}
		if(newcar >= rentcarls[0] && newcar <= rentcarls[13])
		{
			if(GetPVarInt(playerid,"arenda") != GetPlayerVehicleID(playerid))
			{
				SPD(playerid,9126,DIALOG_STYLE_MSGBOX,"Аренда машины","Стоимость аренды машины 5000 рублей","Снять","Отмена");
				TogglePlayerControllable(playerid, 0);
			}
		}
		if(newcar >= hotdogcar[0] && newcar <= hotdogcar[8])
		{
			if(PlayerInfo[playerid][pJob] == 3 && PlayerInfo[playerid][pMember] == 0) { }
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не продавец ХотДогов");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= taxicar[0] && newcar <= taxicar[30])
		{
			if(PlayerInfo[playerid][pJob] == 2 && PlayerInfo[playerid][pMember] == 0) {SendClientMessage(playerid, -1, "Введите: /fare - Чтобы установать тариф."); }
			else
			{
				SendClientMessage(playerid, -1, "Вы не таксист! /gps - Мэрия");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(IsABoat(newcar))
		{
			if(PlayerInfo[playerid][pBoatLic] < 1)
			{
				SendClientMessage(playerid, -1, "(( У Вас нет лицензии на водный транспорт! (/gps - Автошкола ))");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(IsAPlane(newcar))
		{
			if(PlayerInfo[playerid][pFlyLic] < 1)
			{
				if(TakingLesson[playerid] == 1) { }
				else
				{
					SendClientMessage(playerid, -1, "(( У Вас нет лицензии на воздушный транспорт! (/gps - Автошкола ))");
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
			}
		}
		if(VodPrava(newcar))
		{
			if(PlayerInfo[playerid][pVodPrava] == 0)
			{
				if(TakingLesson[playerid] != 1)
				{
					SendClientMessage(playerid, -1, "У Вас нет водительских прав! (/gps - Автошкола)");
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
			}
		}
		if(newcar >= lsnewscar[0] && newcar <= lsnewscar[5])
		{
			if(PlayerInfo[playerid][pMember] != 16)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не работник LS News!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= lvpdcar[0] && newcar <= lvpdcar[14])
		{
			if(PlayerInfo[playerid][pMember] != 21)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в SWAT!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= ruscar[0] && newcar <= ruscar[11])
		{
			if(PlayerInfo[playerid][pMember] != 14)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в Русской мафии!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= lvnewscar[0] && newcar <= lvnewscar[5])
		{
			if(PlayerInfo[playerid][pMember] != 20)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не работник Lv News!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= lcncar[0] && newcar <= lcncar[8])
		{
			if(PlayerInfo[playerid][pMember] != 5)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в La Cosa Nostra!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= yakcar[0] && newcar <= yakcar[9])
		{
			if(PlayerInfo[playerid][pMember] != 6)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в Yakuza!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= sfnewscar[0] && newcar <= sfnewscar[5])
		{
			if(PlayerInfo[playerid][pMember] != 9)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в SF News!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		/*if(newcar >= prodcar[0] && newcar <= prodcar[8])
		{
			if(PlayerInfo[playerid][pJob] == 5 && PlayerInfo[playerid][pMember] == 0 && PlayerInfo[playerid][pPbiskey] == 255 ) { SendClientMessage(playerid, -1, "Для загрузки продуктов, введите: /buyprods");}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не развозчик продуктов!");
				RemovePlayerFromVehicle(playerid);
			}
		}
		if(newcar >= mater[0] && newcar <= mater[1])
		{
			if(PlayerInfo[playerid][pJob] == 7 && PlayerInfo[playerid][pMember] == 0)
			{
				format(string, sizeof(string), "- Строительные материалы в фургоне: %d/5000", Mater[newcar-mater[0]][zLoad]);
				SendClientMessage(playerid, TEAM_GROVE_COLOR, string);
				SendClientMessage(playerid, -1, "Для загрузки строительных компоненов, Введите: /loadz ");
				GruzCP[playerid] = 0;
				usemats[playerid] = 0;
				if(startjob[newcar] == 1 && Mater[newcar-mater[0]][zLoad] < 5000)
				{
					SendClientMessage(playerid, 0xB4B5B7FF, "Еще не заполнена!");
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
				if(startjob[newcar] == 1 && Mater[newcar-mater[0]][zLoad] >= 5000)
				{
					DestroyPickup(avtopick[newcar]);
					Delete3DTextLabel(JobText1[newcar]);
					DisablePlayerCheckpoint(playerid);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не развозчик строй-материалов!");
				RemovePlayerFromVehicle(playerid);
			}
		}*/
		/*if(newcar >= benzovoz[0] && newcar <= benzovoz[1])
		{
			if(PlayerInfo[playerid][pJob] == 5 && PlayerInfo[playerid][pMember] == 0 && PlayerInfo[playerid][pPbiskey] == 255 ) { SendClientMessage(playerid, -1, " Для загрузки бензина, Введите: /loadbenz ");}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не развозчик продуктов!");
				RemovePlayerFromVehicle(playerid);
			}
		}*/
		if(newcar >= govcar[0] && newcar <= govcar[4])
		{
			if(PlayerInfo[playerid][pMember] != 7)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в Мэрии!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar == matsfura[0])
		{
			if(PlayerInfo[playerid][pMember] != 12)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член The Ballas Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= fbicar[0] && newcar <= fbicar[8])
		{
			if(PlayerInfo[playerid][pMember] != 2)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не агент FBI!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= lspdcar[0] && newcar <= lspdcar[19])
		{
			if(PlayerInfo[playerid][pMember] != 1)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не состоите в LSPD!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= medicsls[0] && newcar <= medicsls[6])
		{
			if(PlayerInfo[playerid][pMember] != 22)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не медик Лос Сантос!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= medicssf[0] && newcar <= medicssf[7])
		{
			if(PlayerInfo[playerid][pMember] != 4)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не медик San Fierro!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= bus[0] && newcar <= bus[3])
		{
		    if(PlayerInfo[playerid][pJob] == 1 && PlayerInfo[playerid][pMember] == 0) { SendClientMessage(playerid, -1, "Введите: /route - Чтобы начать работу водителя автобуса."); }
			if(PlayerInfo[playerid][pJob] == 1 && PlayerInfo[playerid][pMember] == 0)
			{
				if(JobCarTime[playerid] <= 16 && JobCarTime[playerid] >= 1)
				{
					if(AutoBusJob[playerid] == 1)
					{
						format(string, sizeof(string), "<< Внутри-Городской ЛС >>\nБесплатный проезд");
						fare3dtext[playerid] = Create3DTextLabel( string, 0x33AA33AA, 9999.0, 9999.0, 9999.0, 50.0, 0, 1 );
						Attach3DTextLabelToVehicle( fare3dtext[playerid], GetPlayerVehicleID(playerid), 0.0, 0.0, 2.25 );
						JobCarTime[playerid] = 0;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не водитель автобуса! /gps - Мэрия");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= mehanik[0] && newcar <= mehanik[1])
		{
			if(PlayerInfo[playerid][pJob] != 2 || PlayerInfo[playerid][pMember] != 0)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не механик! /gps - Мэрия");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= sfpdcar[0] && newcar <= sfpdcar[22])
		{
			if(PlayerInfo[playerid][pMember] != 10)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не состоите в SFPD!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar == matsfuragrove[0])
		{
			if(PlayerInfo[playerid][pMember] != 15)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член Grove Street Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar == matsfuraaztek[0])
		{
			if(PlayerInfo[playerid][pMember] != 17)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член Varios Los Aztecas Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar == matsfuravagos[0])
		{
			if(PlayerInfo[playerid][pMember] != 13)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член Los Santos Vagos Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar == matsfurarifa[0])
		{
			if(PlayerInfo[playerid][pMember] != 18)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член The Rifa Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= ballascar[0] && newcar <= ballascar[8])
		{
			if(PlayerInfo[playerid][pMember] != 12)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член The Ballas Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= grovecar[0] && newcar <= grovecar[6])
		{
			if(PlayerInfo[playerid][pMember] != 15)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член Grove Street Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= azteccar[0] && newcar <= azteccar[5])
		{
			if(PlayerInfo[playerid][pMember] != 17)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член Varios Los Aztecas Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= vagoscar[0] && newcar <= vagoscar[6])
		{
			if(PlayerInfo[playerid][pMember] != 13)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член Los Santos Vagos Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= rifacar[0] && newcar <= rifacar[5])
		{
			if(PlayerInfo[playerid][pMember] != 18)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не член The Rifa Gang!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= matslvcar[0] && newcar <= matslvcar[5])
		{
			if (PlayerInfo[playerid][pMember] != 19 && proverkaforma[playerid] != 1)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не солдат Зоны 51!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= armysfcar[0] && newcar <= armysfcar[28])
		{
			if(PlayerInfo[playerid][pMember] != 3)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не солдат Армии SF!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
		if(newcar >= armylvcar[0] && newcar <= armylvcar[21])
		{
			if(PlayerInfo[playerid][pMember] != 19)
			{
				SendClientMessage(playerid, 0xB4B5B7FF, "Вы не cолдат зоны 51!");
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	new string[100];
	if(PicCP[playerid] == 3)
	{
		if(useguns[playerid] == 0)
		{
			//if(PlayerInfo[playerid][pPbiskey] != 255) return	SendClientMessage(playerid, 0xB4B5B7FF,"Вы бизнесмен");
			SPD(playerid, 61, DIALOG_STYLE_MSGBOX, "Устройство на работу","Посмотреть список доступных работ?", "Да", "Нет");
			return 1;
		}
	}
	if(IsPlayerInDynamicCP(playerid, dinamicash[playerid]))
	{
		new avtosdacha[512];
		format(avtosdacha,sizeof(avtosdacha), "Цена экзамена 1000 рублей\nХотите сдать на права?");
		SPD(playerid,50,DIALOG_STYLE_MSGBOX,"Автосдача на права",avtosdacha, "Да", "Нет");
		return 1;
	}
	if(CP[playerid]==0)
	{
		DisablePlayerCheckpoint(playerid);
	}
	if(Works[playerid])
	{
		if(JobCP[playerid] == 1 && IsPlayerInRangeOfPoint(playerid,2.0,2230.3528,-2286.1353,14.3751))
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid,2172.4146,-2255.5405,13.3041,1.5);
				SetPlayerAttachedObject(playerid, 1 , 2060, 1,0.11,0.36,0.0,0.0,90.0);
				ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
				JobCP[playerid] = 4;
				mesh[playerid] = 1;
				usemesh[playerid] = 1;
			}
		}
		if(JobCP[playerid] == 2  && IsPlayerInRangeOfPoint(playerid,2.0,2172.4146,-2255.5405,13.3041))
		{
		    if(IsPlayerInAnyVehicle(playerid)) return 1;
			if(mesh[playerid] < 10)
			{
				KickFix(playerid);
				return 1;
			}
			JobAmmount[playerid] ++;
			format(string,sizeof(string),"Перенесено мешков: {ffffff}%d",JobAmmount[playerid]);
			SendClientMessage(playerid,0x33AA33AA,string);
			DisablePlayerCheckpoint(playerid);
			mesh[playerid] = 0;
			usemesh[playerid] = 0;
			ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,0,0,0,0,1,0);
			if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
			SetPlayerCheckpoint(playerid,2230.3528,-2286.1353,14.3751,1.5);
			JobCP[playerid] = 1;
		}
	}
    if(PlayerStartJob[playerid])
    {
        DisablePlayerCheckpoint(playerid);
        ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 1);
        PlayerStartJob[playerid] = false;
        if(IsPlayerAttachedObjectSlotUsed(playerid, 7)) 
        {
			if(IsPlayerInAnyVehicle(playerid)) return 1;
			if(mesh[playerid] < 6)
			{
				KickFix(playerid);
				return 1;
			}
            RemovePlayerAttachedObject(playerid, 7);
            SetPlayerAttachedObject(playerid, 6, 18634, 6, 0.078222, 0.000000, 0.110844, 298.897308, 264.126861, 193.350555, 1.000000, 1.000000, 1.000000);
            GetPlayerMetall[playerid] = 20+random(40);
			mesh[playerid] = 0;
			usemesh[playerid] = 0;
			PicCP[playerid] = 1;
            JobAmmount[playerid] = JobAmmount[playerid] + GetPlayerMetall[playerid];
            format(string, sizeof(string), "Вы принесли {FF0000}%d {9ACD32}кг руды. {FFA500}Всего принесено {FFFFFF}%d {FFA500}кг руды.", GetPlayerMetall[playerid], JobAmmount[playerid]);
            SendClientMessage(playerid, 0x9ACD32AA, string);
            GetPlayerMetall[playerid] = 0;
        }
        return 1;
    }
	return 1;
}
public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if (!Login[playerid]) return 0;
	if(GetPVarInt(playerid,"AntiFlood") > gettime()) return SendClientMessage(playerid, COLOR_LIGHTRED, "Не флуди");
    return 1;
}
public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	SetPVarInt(playerid,"AntiFlood",gettime() + 1);
    return 1;
}
public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	new string[100];
	DisablePlayerRaceCheckpoint(playerid);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(LessonCar[playerid] == 1)
		{
			switch(pLessonCar[playerid])
			{
				case CHECKPOINT_1:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_2;
					SetPlayerRaceCheckpoint(playerid, 0,-2039.7438,-188.1508,35.0251,-2047.3491,-80.1809,34.8728, 5.0);
				}
				case CHECKPOINT_2:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_3;
					SetPlayerRaceCheckpoint(playerid, 0,-2047.3491,-80.1809,34.8728,-2004.2841,-56.4547,34.9083, 5.0);
				}
				case CHECKPOINT_3:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_4;
					SetPlayerRaceCheckpoint(playerid, 0,-2004.2841,-56.4547,34.9083,-2004.3656,63.5635,29.0903, 5.0);
				}
				case CHECKPOINT_4:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_5;
					SetPlayerRaceCheckpoint(playerid, 0,-2004.3656,63.5635,29.0903,-2003.5389,169.0928,27.2806, 5.0);
				}
				case CHECKPOINT_5:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_6;
					SetPlayerRaceCheckpoint(playerid, 0,-2003.5389,169.0928,27.2806,-1999.3879,309.9337,34.7228, 5.0);
				}
				case CHECKPOINT_6:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_7;
					SetPlayerRaceCheckpoint(playerid, 0,-1999.3879,309.9337,34.7228,-1999.1091,488.9284,34.7584, 5.0);
				}
				case CHECKPOINT_7:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_8;
					SetPlayerRaceCheckpoint(playerid, 0,-1999.1091,488.9284,34.7584,-2020.0480,506.7851,34.7583, 5.0);
				}
				case CHECKPOINT_8:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_9;
					SetPlayerRaceCheckpoint(playerid, 0,-2020.0480,506.7851,34.7583,-2123.5198,506.4044,34.7593, 5.0);
				}
				case CHECKPOINT_9:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_10;
					SetPlayerRaceCheckpoint(playerid, 0,-2123.5198,506.4044,34.7593,-2147.1807,490.5033,34.7583, 5.0);
				}
				case CHECKPOINT_10:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_11;
					SetPlayerRaceCheckpoint(playerid, 0,-2147.1807,490.5033,34.7583,-2149.1292,407.9551,34.8205, 5.0);
				}
				case CHECKPOINT_11:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_13;
					SetPlayerRaceCheckpoint(playerid, 0,-2149.1292,407.9551,34.8205,-2148.8479,229.6411,34.9152, 5.0);
				}
				case CHECKPOINT_13:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_14;
					SetPlayerRaceCheckpoint(playerid, 0,-2148.8479,229.6411,34.9152,-2165.5833,210.6641,34.9144, 5.0);
				}
				case CHECKPOINT_14:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_15;
					SetPlayerRaceCheckpoint(playerid, 0,-2165.5833,210.6641,34.9144,-2233.7517,210.4253,34.9137, 5.0);
				}
				case CHECKPOINT_15:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_16;
					SetPlayerRaceCheckpoint(playerid, 0,-2233.7517,210.4253,34.9137,-2249.0859,233.7054,34.9071, 5.0);
				}
				case CHECKPOINT_16:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_17;
					SetPlayerRaceCheckpoint(playerid, 0,-2249.0859,233.7054,34.9071,-2261.7542,372.9274,33.2418, 5.0);
				}
				case CHECKPOINT_17:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_18;
					SetPlayerRaceCheckpoint(playerid, 0,-2261.7542,372.9274,33.2418,-2359.8423,484.6871,30.3849, 5.0);
				}
				case CHECKPOINT_18:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_19;
					SetPlayerRaceCheckpoint(playerid, 0,-2359.8423,484.6871,30.3849,-2383.4255,790.3303,34.7652, 5.0);
				}
				case CHECKPOINT_19:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_20;
					SetPlayerRaceCheckpoint(playerid, 0,-2383.4255,790.3303,34.7652,-2364.3657,805.9047,36.6098, 5.0);
				}
				case CHECKPOINT_20:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_21;
					SetPlayerRaceCheckpoint(playerid, 0,-2364.3657,805.9047,36.6098,-2217.7344,806.2595,49.0387, 5.0);
				}
				case CHECKPOINT_21:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_22;
					SetPlayerRaceCheckpoint(playerid, 0,-2217.7344,806.2595,49.0387,-2095.3938,806.2051,69.1558, 5.0);
				}
				case CHECKPOINT_22:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_23;
					SetPlayerRaceCheckpoint(playerid, 0,-2095.3938,806.2051,69.1558,-2023.7908,806.1768,47.0934, 5.0);
				}
				case CHECKPOINT_23:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_24;
					SetPlayerRaceCheckpoint(playerid, 0,-2023.7908,806.1768,47.0934,-2000.5417,825.1227,45.0399, 5.0);
				}
				case CHECKPOINT_24:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_25;
					SetPlayerRaceCheckpoint(playerid, 0,-2000.5417,825.1227,45.0399,-2000.4559,901.5263,45.0433, 5.0);
				}
				case CHECKPOINT_25:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_26;
					SetPlayerRaceCheckpoint(playerid, 0,-2000.4559,901.5263,45.0433,-1983.4757,917.6733,45.0391, 5.0);
				}
				case CHECKPOINT_26:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_27;
					SetPlayerRaceCheckpoint(playerid, 0,-1983.4757,917.6733,45.0391,-1859.3486,917.3110,34.7522, 5.0);
				}
				case CHECKPOINT_27:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_28;
					SetPlayerRaceCheckpoint(playerid, 0,-1859.3486,917.3110,34.7522,-1738.9817,917.5093,24.4839, 5.0);
				}
				case CHECKPOINT_28:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_29;
					SetPlayerRaceCheckpoint(playerid, 0,-1738.9817,917.5093,24.4839,-1584.8662,917.9406,7.2808, 5.0);
				}
				case CHECKPOINT_29:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_30;
					SetPlayerRaceCheckpoint(playerid, 0,-1584.8662,917.9406,7.2808,-1541.6730,928.6280,6.7821, 5.0);
				}
				case CHECKPOINT_30:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_31;
					SetPlayerRaceCheckpoint(playerid, 0,-1541.6730,928.6280,6.7821,-1540.8986,962.7398,6.7813, 5.0);
				}
				case CHECKPOINT_31:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_32;
					SetPlayerRaceCheckpoint(playerid, 0,-1540.8986,962.7398,6.7813,-1586.9012,1029.1655,6.7806, 5.0);
				}
				case CHECKPOINT_32:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_33;
					SetPlayerRaceCheckpoint(playerid, 0,-1586.9012,1029.1655,6.7806,-1634.6927,1240.9236,6.7836, 5.0);
				}
				case CHECKPOINT_33:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_34;
					SetPlayerRaceCheckpoint(playerid, 0,-1634.6927,1240.9236,6.7836,-1733.3973,1340.2684,6.7808, 5.0);
				}
				case CHECKPOINT_34:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_35;
					SetPlayerRaceCheckpoint(playerid, 0,-1733.3973,1340.2684,6.7808,-1822.0417,1375.2615,6.7819, 5.0);
				}
				case CHECKPOINT_35:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_36;
					SetPlayerRaceCheckpoint(playerid, 0,-1822.0417,1375.2615,6.7819,-1930.4690,1306.2540,6.7826, 5.0);
				}
				case CHECKPOINT_36:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_37;
					SetPlayerRaceCheckpoint(playerid, 0,-1930.4690,1306.2540,6.7826,-2025.0059,1304.6970,6.8203, 5.0);
				}
				case CHECKPOINT_37:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_38;
					SetPlayerRaceCheckpoint(playerid, 0,-2025.0059,1304.6970,6.8203,-2062.1274,1281.8025,7.5473, 5.0);
				}
				case CHECKPOINT_38:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_40;
					SetPlayerRaceCheckpoint(playerid, 0,-2062.1274,1281.8025,7.5473,-2270.4485,1204.1831,53.2871, 5.0);
				}
				case CHECKPOINT_40:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_41;
					SetPlayerRaceCheckpoint(playerid, 0,-2270.4485,1204.1831,53.2871,-2267.0386,1095.9159,79.6025, 5.0);
				}
				case CHECKPOINT_41:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_42;
					SetPlayerRaceCheckpoint(playerid, 0,-2267.0386,1095.9159,79.6025,-2266.0283,990.1443,75.1669, 5.0);
				}
				case CHECKPOINT_42:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_43;
					SetPlayerRaceCheckpoint(playerid, 0,-2266.0283,990.1443,75.16690,-2266.5266,807.7878,49.0438, 5.0);
				}
				case CHECKPOINT_43:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_44;
					SetPlayerRaceCheckpoint(playerid, 0,-2266.5266,807.7878,49.0438,-2266.6682,585.7730,36.3168, 5.0);
				}
				case CHECKPOINT_44:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_45;
					SetPlayerRaceCheckpoint(playerid, 0,-2266.6682,585.7730,36.3168,-2242.5308,562.4396,34.75896, 5.0);
				}
				case CHECKPOINT_45:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_46;
					SetPlayerRaceCheckpoint(playerid, 0,-2242.5308,562.4396,34.7589,-2229.0964,540.6600,34.7586, 5.0);
				}
				case CHECKPOINT_46:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_47;
					SetPlayerRaceCheckpoint(playerid, 0,-2229.0964,540.6600,34.7586,-2209.9031,506.0080,34.7579, 5.0);
				}
				case CHECKPOINT_47:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_48;
					SetPlayerRaceCheckpoint(playerid, 0,-2209.9031,506.0080,34.7579,-2102.6755,501.8567,34.7602, 5.0);
				}
				case CHECKPOINT_48:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_49;
					SetPlayerRaceCheckpoint(playerid, 0,-2102.6755,501.8567,34.7602,-2020.8113,501.6382,34.7586, 5.0);
				}
				case CHECKPOINT_49:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_50;
					SetPlayerRaceCheckpoint(playerid, 0,-2020.8113,501.6382,34.7586,-2007.8937,491.4999,34.7592, 5.0);
				}
				case CHECKPOINT_50:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_51;
					SetPlayerRaceCheckpoint(playerid, 0,-2007.8937,491.4999,34.7592,-2009.4333,253.1356,30.0010, 5.0);
				}
				case CHECKPOINT_51:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_52;
					SetPlayerRaceCheckpoint(playerid, 0,-2009.4333,253.1356,30.0010,-2008.9186,60.0073,29.5201, 5.0);
				}
				case CHECKPOINT_52:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_53;
					SetPlayerRaceCheckpoint(playerid, 0,-2008.9186,60.0073,29.5201,-2008.8951,-83.7164,35.0135, 5.0);
				}
				case CHECKPOINT_53:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_54;
					SetPlayerRaceCheckpoint(playerid, 0,-2008.8951,-83.7164,35.0135,-2007.6554,-162.2175,35.4526, 5.0);
				}
				case CHECKPOINT_54:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_55;
					SetPlayerRaceCheckpoint(playerid, 0,-2007.6554,-162.2175,35.4526,-2007.6746,-276.8484,35.0604, 5.0);
				}
				case CHECKPOINT_55:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_56;
					SetPlayerRaceCheckpoint(playerid, 0,-2007.6746,-276.8484,35.0604,-2038.9626,-289.8528,35.1186, 5.0);
				}
				case CHECKPOINT_56:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_57;
					SetPlayerRaceCheckpoint(playerid, 0,-2038.9626,-289.8528,35.1186,-2195.3115,-290.1100,35.0690, 5.0);
				}
				case CHECKPOINT_57:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_58;
					SetPlayerRaceCheckpoint(playerid, 0,-2195.3115,-290.1100,35.0690,-2205.7070,-272.5776,35.0689, 5.0);
				}
				case CHECKPOINT_58:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_59;
					SetPlayerRaceCheckpoint(playerid, 0,-2205.7070,-272.5776,35.0689,-2205.3076,-204.0107,35.0867, 5.0);
				}
				case CHECKPOINT_59:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_60;
					SetPlayerRaceCheckpoint(playerid, 0,-2205.3076,-204.0107,35.0867,-2236.1755,-187.5369,34.9148, 5.0);
				}
				case CHECKPOINT_60:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_61;
					SetPlayerRaceCheckpoint(playerid, 0,-2236.1755,-187.5369,34.9148,-2251.8374,-86.5177,34.9136, 5.0);
				}
				case CHECKPOINT_61:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_62;
					SetPlayerRaceCheckpoint(playerid, 0,-2251.8374,-86.5177,34.9136,-2234.4314,-72.5208,34.9151, 5.0);
				}
				case CHECKPOINT_62:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_63;
					SetPlayerRaceCheckpoint(playerid, 0,-2234.4314,-72.5208,34.9151,-2083.7751,-72.7984,34.9150, 5.0);
				}
				case CHECKPOINT_63:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_64;
					SetPlayerRaceCheckpoint(playerid, 0,-2083.7751,-72.7984,34.9150,-2046.7074,-84.9175,34.9071, 5.0);
				}
				case CHECKPOINT_64:
				{

					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_65;
					SetPlayerRaceCheckpoint(playerid, 0,-2046.7074,-84.9175,34.9071,-2034.8080,-244.0964,35.3203, 5.0);
				}
				case CHECKPOINT_65:
				{
					GameTextForPlayer(playerid, string, 5000, 4);
					LessonStat[playerid]++;
					pLessonCar[playerid] = CHECKPOINT_66;
					SetPlayerRaceCheckpoint(playerid, 1,-2034.8080,-244.0964,35.3203,0.0,0.0,0.0, 5.0);
				}
				case CHECKPOINT_66:
				{
					new Float:health;
					GetVehicleHealth(GetPlayerVehicleID(playerid),health);
					if (health >= 850)
					{
						JobCarTime[playerid] = 0;
						LessonCar[playerid] = 0;
						LessonStat[playerid] = 0;
						TakingLesson[playerid] = 0;
						PlayerInfo[playerid][pVodPrava] = 1;
						DisablePlayerRaceCheckpoint(playerid);
						SendClientMessage(playerid, 0x33AA33AA, "Вы успешно сдали на права! Пожалуйста припаркуйте автомобиль!");
					}
					else
					{
						JobCarTime[playerid] = 0;
						LessonCar[playerid] = 0;
						LessonStat[playerid] = 0;
						TakingLesson[playerid] = 0;
						SendClientMessage(playerid, 0xB4B5B7FF, "Вы не достаточно хорошо водите, чтобы получить права");
						DisablePlayerRaceCheckpoint(playerid);
						SetVehicleToRespawn(GetPlayerVehicleID(playerid));
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, PickupInfo[pickupid][PickX], PickupInfo[pickupid][PickY], PickupInfo[pickupid][PickZ]) || PickupUp[playerid] == pickupid) return true;
    PickupUp[playerid] = pickupid;
	if(pickupid == rabota1)
	{
		new rabotadialog[399];
		format(rabotadialog,sizeof(rabotadialog), "%s%s%s%s%s%s%s%s%s%s%s%s",
		rabotaMSG[0],rabotaMSG[1],rabotaMSG[2],rabotaMSG[3],rabotaMSG[4],rabotaMSG[5],rabotaMSG[6],rabotaMSG[7],rabotaMSG[8],rabotaMSG[9],rabotaMSG[10],rabotaMSG[11]);
		SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Информация о работе", rabotadialog, "Ок", "");
	}
    if(pickupid == picjob)
    {
        if(!Works[playerid]) return SPD(playerid, 48, DIALOG_STYLE_MSGBOX, "Работа шахтёра", "{FFFFFF}Вы собираетесь устроиться на работу шахтёра.", "Устроиться", "Отмена");
		else return SPD(playerid,49, DIALOG_STYLE_MSGBOX, "Работа шахтёра", "{FFFFFF}Вы собираетесь уволиться с работы шахтёра.", "Уволиться", "Отмена");
    }
	if(pickupid == parashut)
	{
		GiveWeapon(playerid, 46, 100);
	}
	else if(pickupid == paint)
	{
	/*	if(PaintballRound >= 1) return SendClientMessage(playerid,0xB4B5B7FF,"Регистрация закрыта!");
		if(PlayerInfo[playerid][pLevel] <= 2 ) return SendClientMessage(playerid,0xB4B5B7FF,"Участвовать можно с 3-х лет проживания в штате!");
		if(PlayerInfo[playerid][pWarns] >=1 ) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя учавствовать с Warnom!");
		if( PlayerPaintballing[playerid] == 1) return SendClientMessage(playerid,-1,"Вы уже зарегистрированы на матч!");
		SendClientMessage(playerid, 0x6495EDFF, "Вы зарегестрировались на матч!");
		PaintballPlayers += 1;
		PlayerPaintballing[playerid] = 1;*/
	}
	else if(pickupid == sportzal[0])
	{
		if(PlayerInfo[playerid][pJob] == 6 && PlayerInfo[playerid][pMember] == 0)
		{
			SetPlayerSkin(playerid, 49);
		}
		SetPlayerInterior(playerid,5);
		SetPlayerPos(playerid,771.4412,-2.7885,1000.7279);
		SetPlayerFacingAngle(playerid, 21.2131);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sportzal[1])
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,2227.1162,-1723.1353,13.5533);
		SetPlayerFacingAngle(playerid, 130.5909);
		SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
		SetCameraBehindPlayer(playerid);
		if(PlayerInfo[playerid][pMember] >=1) {	SetPlayerSkin(playerid,PlayerInfo[playerid][pModel]);}
		if(PlayerInfo[playerid][pMember] ==0) {	SetPlayerSkin(playerid,PlayerInfo[playerid][pChar]);}
	}
	if(pickupid == mysti)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,-2244.3213,-88.3789,35.3203);
		SetPlayerFacingAngle(playerid, 87.1145);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == carpick[0])
	{
		if(PlayerInfo[playerid][pVodPrava] != 1)
		{
			SendClientMessage(playerid,-1,"У вас нету Лицензии на управление авто");
			return 1;
		}
		/*if(PlayerInfo[playerid][pPhousekey] == 0)
		{
			SendClientMessage(playerid,0xAA3333AA,"У вас нет дома");
			return 1;
		}*/
		if(PlayerInfo[playerid][pCar] != 462)
		{
			SPD(playerid,1771,DIALOG_STYLE_MSGBOX,"Покупка машины"," Вы уже имеете автомобиль, при покупке новой, старая машина будет заменена.\n Продолжить покупку?","Да","Нет");
			return 1;
		}
		new mashina[MAX_PLAYERS];
		mashina[playerid] = AddStaticVehicle(400,-1655.9785,1209.4010,20.9879,227.2012,1,1);
		PutPlayerInVehicle(playerid, mashina[playerid], 0);
		TogglePlayerControllable(playerid, 0);
		SetPlayerCameraPos(playerid, -1650.4935, 1210.3818, 23.1794);
		SetPlayerCameraLookAt(playerid, -1655.9785,1209.4010,20.9879);
		SetVehicleVirtualWorld(mashina[playerid],playerid+1000); // carid - id авто, 666- id рублей мира
		SetPlayerVirtualWorld(playerid,playerid+1000);
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~LANDSTALKER COST : 130000", 10000, 3);
		return 1;
	}
	else if(pickupid == carpick[1])
	{
		if(PlayerInfo[playerid][pVodPrava] != 1)
		{
			SendClientMessage(playerid,-1,"У вас нету Лицензии на управление авто");
			return 1;
		}
/*		if(PlayerInfo[playerid][pPhousekey] == 255)
		{
			SendClientMessage(playerid,-1,"У вас нет дома");
			return 1;
		}*/
		if(PlayerInfo[playerid][pCar] != 462)
		{
			SPD(playerid,1772,DIALOG_STYLE_MSGBOX,"Покупка машины"," Вы уже имеете автомобиль, при покупке новой, старая машина будет заменена.\n Продолжить покупку?","Да","Нет");
			return 1;
		}
		new mashina[MAX_PLAYERS];
		mashina[playerid] = AddStaticVehicle(419,-1655.9785,1209.4010,20.9879,227.2012,1,1);
		PutPlayerInVehicle(playerid, mashina[playerid], 0);
		TogglePlayerControllable(playerid, 0);
		SetPlayerCameraPos(playerid, -1650.4935, 1210.3818, 23.1794);
		SetPlayerCameraLookAt(playerid, -1655.9785,1209.4010,20.9879);
		SetVehicleVirtualWorld(mashina[playerid], playerid+1000);
		SetPlayerVirtualWorld(playerid,playerid+1000);
		return 1;
	}
	else if(pickupid == carpick[2])
	{
		if(PlayerInfo[playerid][pVodPrava] != 1)
		{
			SendClientMessage(playerid,-1,"У вас нету Лицензии на управление авто");
			return 1;
		}
/*		if(PlayerInfo[playerid][pPhousekey] == 255)
		{
			SendClientMessage(playerid,-1,"У вас нет дома");
			return 1;
		}*/
		if(PlayerInfo[playerid][pCar] != 462)
		{
			SPD(playerid,1773,DIALOG_STYLE_MSGBOX,"Покупка машины"," Вы уже имеете автомобиль, при покупке новой, старая машина будет заменена.\n Продолжить покупку?","Да","Нет");
			return 1;
		}
		new mashina[MAX_PLAYERS];
		mashina[playerid] = AddStaticVehicle(402,-1655.9785,1209.4010,20.9879,227.2012,1,1);
		PutPlayerInVehicle(playerid, mashina[playerid], 0);
		TogglePlayerControllable(playerid, 0);
		SetPlayerCameraPos(playerid, -1650.4935, 1210.3818, 23.1794);
		SetPlayerCameraLookAt(playerid, -1655.9785,1209.4010,20.9879);
		SetVehicleVirtualWorld(mashina[playerid], playerid+1000);
		SetPlayerVirtualWorld(playerid,playerid+1000);
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~g~bUFFALO ~y~COST : 3200000", 10000, 3);
		return 1;
	}
	else if(pickupid == lspic[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1650.9956,-1640.6299,83.7788);
		SetPlayerFacingAngle(playerid, 304.8376);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lspic[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1658.2383,-1693.4553,15.6094);
		SetPlayerFacingAngle(playerid, 175.8234);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == pdd)
	{
		GameTextForPlayer(playerid, "~y~/pdd", 1000, 1);
	}
	else if(pickupid == pigpen)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,2421.7114,-1221.1361,25.4387);
		SetPlayerFacingAngle(playerid, 188.2947);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == jizzy)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,-2623.5752,1410.0554,7.0938);
		SetPlayerFacingAngle(playerid, 210.1440);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == burger[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,1199.7345,-920.5428,43.1071);
		SetPlayerFacingAngle(playerid, 174.1681);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == burger[1]) //
	{
		SetPlayerInterior(playerid,10);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerPos(playerid,364.2632,-74.0429,1001.5078);
		SetPlayerFacingAngle(playerid, 295.2377);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == pizza[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2103.1228,-1806.1877,13.5547);
		SetPlayerFacingAngle(playerid, 87.3147);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == pizza[1]) //
	{
		SetPlayerInterior(playerid,5);
		SetPlayerVirtualWorld(playerid, 3);
		SetPlayerPos(playerid,371.9183,-132.0312,1001.4922);
		SetPlayerFacingAngle(playerid, 0.7724);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == pizza[2]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,-1815.9906,615.9285,35.1719);
		SetPlayerFacingAngle(playerid, 182.5506);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == pizza[3]) //
	{
		SetPlayerInterior(playerid,9);
		SetPlayerVirtualWorld(playerid, 4);
		SetPlayerPos(playerid,365.0341,-9.2934,1001.8516);
		SetPlayerFacingAngle(playerid, 356.8440);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == alha) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1833.5907,-1682.9531,13.4669);
		SetPlayerFacingAngle(playerid, 85.5382);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == mast[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1657.9347,2197.8618,10.8203);
		SetPlayerFacingAngle(playerid, 183.9151);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid,0);
	}
	else if(pickupid == mast[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-1800.4135,1197.5573,25.1194);
		SetPlayerFacingAngle(playerid, 182.3717);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid,0);
	}
	else if(pickupid == mast[2]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,854.0541,-601.7619,18.4219);
		SetPlayerFacingAngle(playerid, 0.6835);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid,0);
	}
	else if(pickupid == burger[2]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,813.0128,-1616.3463,13.5547);
		SetPlayerFacingAngle(playerid, 274.2879);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == burger[3]) //
	{
		SetPlayerInterior(playerid,4);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerPos(playerid,458.5122,-88.4554,999.5547);
		SetPlayerFacingAngle(playerid, 75.6355);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == tengreen[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2307.7791,-1645.2585,14.8270);
		SetPlayerFacingAngle(playerid, 157.6063);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == tengreen[1]) //
	{
		SetPlayerInterior(playerid,11);
		SetPlayerVirtualWorld(playerid, 5);
		SetPlayerPos(playerid,502.1901,-69.5536,998.7578);
		SetPlayerFacingAngle(playerid, 186.4333);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == narko[0]) //
	{
		SetPlayerInterior(playerid,5);
		SetPlayerPos(playerid,318.2598,1118.8209,1083.8828);
		SetPlayerFacingAngle(playerid, 2.7967);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == narko[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,2168.0977,-1673.5548,15.0826);
		SetPlayerFacingAngle(playerid,217.7220);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sfn[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-2052.4917,458.5779,35.1719);
		SetPlayerFacingAngle(playerid, 312.1454);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sfn[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-2047.0208,450.5458,139.7422);
		SetPlayerFacingAngle(playerid, 153.7635);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lcnpic[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1451.7043,749.8376,11.0234);
		SetPlayerFacingAngle(playerid, 89.1102);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
	}
	if(pickupid == lcnpic[1]) //
	{
		SetPlayerInterior(playerid, 5);
		SetPlayerPos(playerid,1298.6915,-794.2542,1084.0078);
		SetPlayerFacingAngle(playerid, 349.0933);
		SetPlayerVirtualWorld(playerid, 2);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == zip[0]) //виктим
	{
		zips[playerid] = true;
		SetPlayerInterior(playerid,18);
		SetPlayerPos(playerid,161.6730,-95.5809,1001.8047);
		SetPlayerFacingAngle(playerid, 1.0183);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == zip[1]) //
	{
		zips[playerid] = false;
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-1885.0364,862.9141,35.1719);
		SetPlayerFacingAngle(playerid, 151.0559);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == shop[2])
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-1673.5123,431.4032,7.1797);
		SetPlayerFacingAngle(playerid, 257.8152);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == shop[0])
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1931.2080,-1775.9785,13.5469);
		SetPlayerFacingAngle(playerid, 263.9579);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == shop[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-81.1964,-1168.3134,2.2146);
		SetPlayerFacingAngle(playerid, 58.5935);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == shop[3])
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,998.2327,-920.4987,42.1797);
		SetPlayerFacingAngle(playerid, 104.2105);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == victim[0]) //виктим
	{
		SetPlayerInterior(playerid,5);
		SetPlayerPos(playerid,225.2378,-8.0487,1002.2109);
		SetPlayerFacingAngle(playerid, 89.5070);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == victim[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,458.0936,-1501.5496,31.0372);
		SetPlayerFacingAngle(playerid, 101.4322);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == ammonac[4]) //Аммо ЛВ
	{
		SetPlayerInterior(playerid,7);
		SetPlayerPos(playerid,313.7110,-140.3784,999.6016);
		SetPlayerFacingAngle(playerid, 334.2157);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		GameTextForPlayer(playerid, "~y~+ /buygun", 2000, 1);
	}
	else if(pickupid == ammonac[5]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,2156.1997,943.3864,10.8203);
		SetPlayerFacingAngle(playerid, 81.7582);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == ammonac[2]) //Аммо СФ
	{
		SetPlayerInterior(playerid,4);
		SetPlayerPos(playerid,286.8773,-83.5809,1001.5156);
		SetPlayerFacingAngle(playerid, 334.2157);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		GameTextForPlayer(playerid, "~y~+ /buygun", 2000, 1);
	}
	else if(pickupid == ammonac[3]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-2626.6384,210.3960,4.5971);
		SetPlayerFacingAngle(playerid, 13.1113);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == ammonac[0]) //Аммо лс
	{
		SetPlayerInterior(playerid,1);
		SetPlayerPos(playerid,286.9145,-38.6596,1001.5156);
		SetPlayerFacingAngle(playerid, 329.0564);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
		GameTextForPlayer(playerid, "~y~+ /buygun", 2000, 1);
	}
	else if(pickupid == ammonac[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1366.5776,-1279.5397,13.5469);
		SetPlayerFacingAngle(playerid, 89.7301);
		SetPlayerVirtualWorld(playerid,0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == rmpic[1]) //
	{
		SetPlayerInterior(playerid, 5);
		SetPlayerPos(playerid,1298.6915,-794.2542,1084.0078);
		SetPlayerFacingAngle(playerid, 349.0933);
		SetPlayerVirtualWorld(playerid, 1);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == rmpic[0]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,940.2619,1733.4958,8.8516);
		SetPlayerFacingAngle(playerid, 276.0833);
		SetPlayerVirtualWorld(playerid,0);
	}
	else if(pickupid == yakexit[1]) //
	{
		SetPlayerInterior(playerid, 5);
		SetPlayerPos(playerid,1298.6915,-794.2542,1084.0078);
		SetPlayerFacingAngle(playerid, 349.0933);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == yakexit[0]) //
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,1457.5305,2773.4219,10.8203);
		SetPlayerFacingAngle(playerid, 276.0466);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == medicls[1]) //вход медики LS
	{
		SetPlayerInterior(playerid, 5);
		SetPlayerVirtualWorld(playerid,1);
		SetPlayerPos(playerid,200.6561,63.5457,1103.2628);
		SetPlayerFacingAngle(playerid, 89.8670);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == medicls[0]) // выход медики лс
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerPos(playerid,2034.5844,-1405.0009,17.2450);
		SetPlayerFacingAngle(playerid, 161.0000);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == medicsf[1]) //вход медики sf
	{
		SetPlayerInterior(playerid, 5);
		SetPlayerVirtualWorld(playerid,2);
		SetPlayerPos(playerid,200.6561,63.5457,1103.2628);
		SetPlayerFacingAngle(playerid, 89.8670);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == medicsf[0]) // выход медики sf
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerPos(playerid,-2685.1653,636.7136,14.4531);
		SetPlayerFacingAngle(playerid, 189.2003);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == fbi[1]) //fbi вЫход
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,-2453.7595,503.7701,30.0798);
		SetPlayerFacingAngle(playerid, 272.4807);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == fbi[0]) //fbi вход
	{
		SetPlayerInterior(playerid, 5);
		SetPlayerPos(playerid,322.1685,304.5911,999.1484);
		SetPlayerFacingAngle(playerid, 6.1412);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lspd[0]) //LSPD вход в городе
	{
		if (IsAArm(playerid)|| IsACop(playerid) || IsAMayor(playerid)|| keys[playerid] == 1 || PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerInterior(playerid,6);
			SetPlayerPos(playerid,246.6428,65.8026,1003.6406);
			SetPlayerFacingAngle(playerid, 2.2168);
			SetCameraBehindPlayer(playerid);
		}
		else
		{
			SendClientMessage(playerid, -1,"Дверь заперта!");
		}
	}
	else if(pickupid == lspd[1])///LSPD выход в городе
	{
		if (IsAArm(playerid)|| IsACop(playerid) || IsAMayor(playerid)|| keys[playerid] == 1 || PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid,1552.8159,-1675.4498,16.1953);
			SetPlayerFacingAngle(playerid, 91.8310);
			SetPlayerVirtualWorld(playerid, 0);
			keys[playerid] = 0;
			SetCameraBehindPlayer(playerid);
		}
		else
		{
			SendClientMessage(playerid, -1,"Дверь заперта!");
		}
	}
	else if(pickupid == lspd[4])//LSPD вых из гаража
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1528.010864,-1678.141723,5.890625);
		SetPlayerFacingAngle(playerid, 259.617370);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lspd[2])//LSPD вход на склад
	{
		SetPlayerInterior(playerid,6);
		SetPlayerPos(playerid,316.3837,-167.8547,999.5938);
		SetPlayerFacingAngle(playerid, 34.3574);
		SetPlayerVirtualWorld(playerid, 5);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sfpd[4])//Вход в гараж гаража в sfpd
	{
		if (IsAArm(playerid)|| IsACop(playerid) || IsAMayor(playerid)|| keys[playerid] == 1 || PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerInterior(playerid,6);
			SetPlayerPos(playerid,316.3837,-167.8547,999.5938);
			SetPlayerFacingAngle(playerid, 34.3574);
			SetPlayerVirtualWorld(playerid, 1);
			SetCameraBehindPlayer(playerid);
		}
		else
		{
			SendClientMessage(playerid, -1,"Дверь заперта!");
		}
	}
	else if(pickupid == sfpd[0])//
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-1606.4532,674.2636,-5.2422);
		SetPlayerFacingAngle(playerid, 357.2527);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sfpd[2])//
	{
		SetPlayerInterior(playerid,10);
		SetPlayerPos(playerid,217.3147,121.3382,999.0156);
		SetPlayerFacingAngle(playerid, 272.8898);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sfpd[3])//
	{
		if (IsAArm(playerid)|| IsACop(playerid) || IsAMayor(playerid)|| keys[playerid] == 1 || PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid,-1605.5310,714.5177,12.8452);
			SetPlayerFacingAngle(playerid,358.5802);
			SetCameraBehindPlayer(playerid);
		}
		else
		{
			SendClientMessage(playerid, -1,"Дверь заперта!");
		}
	}
	else if(pickupid == sfpd[5])//
	{
		if (IsAArm(playerid)|| IsACop(playerid) || IsAMayor(playerid)|| keys[playerid] == 1 || PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerInterior(playerid,10);
			SetPlayerPos(playerid,246.3853,109.1069,1003.2188);
			SetPlayerFacingAngle(playerid, 3.2802);
			SetCameraBehindPlayer(playerid);
		}
		else
		{
			SendClientMessage(playerid, -1,"Дверь заперта!");
		}
	}
	else if(pickupid == sfpd[1])//Вход из гаража в LSPD
	{
		if (IsAArm(playerid)|| IsACop(playerid) || IsAMayor(playerid)|| keys[playerid] == 1 || PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid,-1590.8289,716.0479,-5.2422);
			SetPlayerFacingAngle(playerid, 269.9364);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
		}
		else
		{
			SendClientMessage(playerid, -1,"Дверь заперта!");
		}
	}
	else if(pickupid == lspd[5])
	{
		SetPlayerInterior(playerid,6);
		SetPlayerPos(playerid,246.5438,85.7663,1003.6406);
		SetPlayerFacingAngle(playerid, 278.0311);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lspd[3])//LSPD выход в гараже
	{
		if (IsAArm(playerid)|| IsACop(playerid) || IsAMayor(playerid)|| keys[playerid] == 1 || PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid,1568.6962,-1692.2069,5.8906);
			SetPlayerFacingAngle(playerid, 259.617370);
			SetPlayerVirtualWorld(playerid, 0);
			keys[playerid] = 0;
			SetCameraBehindPlayer(playerid);
		}
		else
		{
			SendClientMessage(playerid, -1,"Дверь заперта!");
		}
	}
	else if(pickupid == autoschool[0])//автошкола вход1
	{
		{
			SetPlayerInterior(playerid,3);
			SetPlayerVirtualWorld(playerid, 1);
			SetPlayerPos(playerid,-2029.9407,-105.9314,1035.1719);
			SetPlayerFacingAngle(playerid, 183.1738);
			SetCameraBehindPlayer(playerid);
		}
	}
    else if(pickupid == autoschool[1])//автошкола выход
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,-2061.9912,-190.1219,35.3203);
		SetPlayerFacingAngle(playerid,276.6582);
		SetCameraBehindPlayer(playerid);
	}
    else if(pickupid == lvpdpic[0]) //lvpd 1 вход в здание с гаража
	{
		SetPlayerInterior(playerid,3);
		SetPlayerVirtualWorld(playerid, 122);
		SetPlayerPos(playerid,238.5033,141.1578,1003.0234);
		SetPlayerFacingAngle(playerid, 359.1617);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lvpdpic[1])//lvpd 2 вход в гараж..
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2295.1934,2451.8459,10.8203);
		SetPlayerFacingAngle(playerid, 94.8742);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lvpdpic[2]) //lvpd 3 в здание
	{
		SetPlayerInterior(playerid,3);
		SetPlayerVirtualWorld(playerid, 122);
		SetPlayerPos(playerid,288.7445,169.2445,1007.1719);
		SetPlayerFacingAngle(playerid, 9.7598);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lvpdpic[3])//lvpd  4 на улицу
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2340.1965,2455.9792,14.9688);
		SetPlayerFacingAngle(playerid, 178.3347);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lvpdpic[4])//lvpd 5 оружие вход
	{
		SPD(playerid,31,DIALOG_STYLE_MSGBOX,"Вход","Куда Вы хотите войти?","Склад","На крышу");
	}
	else if(pickupid == lvpdpic[5])//lvpd 6 оружие выход
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2293.3225,2468.6162,10.8203);
		SetPlayerFacingAngle(playerid, 93.6957);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == lvpdpic[6])//крыша выбор
	{
		SPD(playerid,32,DIALOG_STYLE_MSGBOX,"Вход","Куда Вы хотите войти?","Склад","Вниз");
	}
	else if(pickupid >= chekmatlva[0] && pickupid <= chekmatlva[12])//  Пикапы матов
	{
		if (!IsAGang(playerid)) return    SendClientMessage(playerid,COLOR_GREY,"Вы не бандит!");
		if(FracBank[0][fmatslva] <= 0) return	SendClientMessage(playerid,0xB4B5B7FF,"На складе нет материалов!");
		if(PlayerInfo[playerid][pMats] > 1000) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя унести больше");
		SendClientMessage(playerid, 0x33AAFFFF,"Вы взяли 50 материалов со склада зоны 51!");
		FracBank[0][fmatslva] -= 50;
		PlayerInfo[playerid][pMats] += 50;
	}
	else if(pickupid >= chekmats[0]&& pickupid <= chekmats[4])
	{
		if (!IsAGang(playerid)) return    SendClientMessage(playerid,COLOR_GREY,"Вы не бандит!");
		if(FracBank[0][fmatssfa] <= 0) return SendClientMessage(playerid,0xB4B5B7FF,"На складе нет материалов!");
		if(PlayerInfo[playerid][pMats] > 1000) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя унести больше");
		SendClientMessage(playerid, 0x33AAFFFF,"Вы взяли 250 материалов со склада Армии: Авианосец!");
		FracBank[0][fmatssfa] -= 250;
		PlayerInfo[playerid][pMats] += 250;
	}
	//=-=========================================[ ГРибы]======================
	else if(pickupid >= grib[0]&& pickupid <= grib[52])
	{
	    new string[50];
		format(string, sizeof(string), "%s срезал(а) гриб", GN(playerid));
		ProxDetector(2,30.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
		PlayerInfo[playerid][pGrib] += 1;
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 6.1, 0, 0, 0, 0, 0,1);
		format(string,sizeof(string),"Грибов собрано: {ffffff}%d",PlayerInfo[playerid][pGrib]);
		SendClientMessage(playerid,0x33AA33AA,string);
	}
	//=-=========================================[ ГРибы]======================
	else if(pickupid == buygunzakon[0])
	{
		if(PlayerInfo[playerid][pLeader] == 2 || PlayerInfo[playerid][pMember] == 2)
		{
			if(GetPVarInt(playerid, "WeaponTime") > gettime()) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя брать оружие так часто");
			if(FracBank[0][fmatsfbi] <= 0) return SendClientMessage(playerid,0xB4B5B7FF,"На складе нет материалов!");
			{
				GiveWeapon(playerid, 24, 100);
				GiveWeapon(playerid, 41, 100);
				GiveWeapon(playerid, 29, 100);
				SetPlayerHealthAC(playerid, 100);
				SetPlayerArmourAC(playerid, 100);
				PlayerInfo[playerid][pHP] = 100;
				FracBank[0][fmatsfbi] -= 100;
				SetPVarInt(playerid, "WeaponTime",gettime() + 300);
				SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Deagle (100), Spray (100), MP5 (100)");
			}
		}
		else return SendClientMessage(playerid, -1,"Вы не агент FBI!");
	}
	else if(pickupid == buygunzakon[1])
	{
		if(PlayerInfo[playerid][pLeader] == 1 || PlayerInfo[playerid][pMember] == 1 || IsAOhrana(playerid))
		{
			if(GetPVarInt(playerid, "WeaponTime") > gettime()) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя брать оружие так часто");
			if(FracBank[0][fmatslspd] <= 0) return SendClientMessage(playerid,0xB4B5B7FF,"На складе нет материалов!");
			{
				GiveWeapon(playerid, 3, 1);
				GiveWeapon(playerid, 24, 100);
				SetPlayerHealthAC(playerid, 100);
				SetPlayerArmourAC(playerid, 100);
				PlayerInfo[playerid][pHP] = 100;
				if(PlayerInfo[playerid][pRank] > 8) GiveWeapon(playerid, 25, 25);
				FracBank[0][fmatslspd] -= 100;
				SetPVarInt(playerid, "WeaponTime",gettime() + 300);
				SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Дубинка, Deagle (100), сухой паёк");
				if(PlayerInfo[playerid][pRank] > 8) return SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Дубинка, Deagle (100), Дробовик (25), сухой паёк");
			}
		}
		else return SendClientMessage(playerid, -1,"Вы не состоите в LSPD/Мэрии!");
	}
	else if(pickupid == buygunzakon[3])
	{
		if(PlayerInfo[playerid][pMember] == 21)
		{
			if(GetPVarInt(playerid, "WeaponTime") > gettime()) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя брать оружие так часто");
			if(FracBank[0][fmatslvpd] <= 0) return SendClientMessage(playerid,0xB4B5B7FF,"На складе нет материалов!");
			{
				GiveWeapon(playerid, 3, 1);
				GiveWeapon(playerid, 24, 100);
				SetPlayerHealthAC(playerid, 100);
				SetPlayerArmourAC(playerid, 100);
				PlayerInfo[playerid][pHP] = 100;
				if(PlayerInfo[playerid][pRank] > 8) GiveWeapon(playerid, 25, 25);
				FracBank[0][fmatslvpd] -= 100;
				SetPVarInt(playerid, "WeaponTime",gettime() + 300);
				SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Дубинка, Deagle (100), сухой паёк");
				if(PlayerInfo[playerid][pRank] > 8) return SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Дубинка, Deagle (100), Дробовик (25), сухой паёк");
			}
		}
		else return SendClientMessage(playerid, -1,"Вы не состоите в SWAT!");
	}
	else if(pickupid == buygunzakon[2])
	{
		if(PlayerInfo[playerid][pMember] == 10)
		{
			if(GetPVarInt(playerid, "WeaponTime") > gettime()) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя брать оружие так часто");
			if(FracBank[0][fmatssfpd] <= 0) return SendClientMessage(playerid,0xB4B5B7FF,"На складе нет материалов!");
			{
				GiveWeapon(playerid, 3, 1);
				GiveWeapon(playerid, 24, 100);
				SetPlayerHealthAC(playerid, 100);
				SetPlayerArmourAC(playerid, 100);
				PlayerInfo[playerid][pHP] = 100;
				if(PlayerInfo[playerid][pRank] > 8) GiveWeapon(playerid, 25, 25);
				FracBank[0][fmatssfpd] -= 100;
				SetPVarInt(playerid, "WeaponTime",gettime() + 300);
				SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Дубинка, Deagle (100)");
				if(PlayerInfo[playerid][pRank] > 8) return SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Дубинка, Deagle (100), Дробовик (25), сухой паёк");
			}
		}
		else return SendClientMessage(playerid, -1,"Вы не cостоите в SFPD!");
	}
	else if(pickupid >= serdce[0]&& pickupid <= serdce[5])
	{
		if(PlayerInfo[playerid][pLevel] == 1)
		{
			SetPlayerHealthAC(playerid, 100);
			PlayerInfo[playerid][pHP] =100;
		}
		else return SendClientMessage(playerid, 0x33AAFFFF,"Только для новичков!");
	}
	else if(pickupid == cashs)
	{
	    new string[50];
		if(Works[playerid] == false) return SendClientMessage(playerid,0xFFFFFFFF,"Вы еще не устроились!");
		if(JobAmmount[playerid] == 0) return SendClientMessage(playerid,0xFFFFFFFF,"Ты еще ничего не заработал!");
		format(string,sizeof(string),"Вы заработали: {FFFFFF}%d рублей",JobAmmount[playerid]*50);
		PlayerInfo[playerid][pCash] +=JobAmmount[playerid]*40;
		SendClientMessage(playerid,0x33AA33AA,string);
		JobAmmount[playerid] = 0;
		SendClientMessage(playerid,0x33AA33AA,"Рабочий день завершён!");
		Works[playerid] = false; JobAmmount[playerid] = 0; JobCP[playerid] = 0; 
		SetPlayerSkin(playerid,PlayerInfo[playerid][pChar]);
		DisablePlayerCheckpoint(playerid);

	}
	else if(pickupid == clothes)
	{
		SPD(playerid,47,DIALOG_STYLE_MSGBOX, "Раздевалка","Выберите одежду", "Форма", "Обычная");
	}
	else if(pickupid == skinshop[0] || pickupid == skinshop[2])
	{
		if(	PlayerInfo[playerid][pSex] != 1)
		{
			SendClientMessage(playerid, -1,"Вы ошиблись кабинкой");
			return 1;
		}
		if(PlayerInfo[playerid][pMember] == 0)
		{
			OldSkin[playerid] = GetPlayerSkin(playerid);
			SetPlayerInterior(playerid,5);
			ShowMenuForPlayer(skinshopmagaz,playerid);
			SendClientMessage(playerid, 0xFFFF00AA, "При покупке Ваша текущая одежда будет заменена!");
			SendClientMessage(playerid, 0xFF0000AA, "Используйте клавишу ШИФТ, чтобы выбрать скин");
			SetPlayerPos(playerid, 222.3489,-8.5845,1002.2109); // Warp the player
			SetPlayerFacingAngle(playerid,266.7302);
			SetPlayerCameraPos(playerid,225.3489,-8.5845,1002.2109);
			SetPlayerCameraLookAt(playerid,222.3489,-8.5845,1002.2109);
			TogglePlayerControllable(playerid, 0);
			SelectChar[playerid] = 255;
			ChosenSkin[playerid] = 230;
			CharPrice[playerid] = 1000;
			SelectCharPlace[playerid] = 1;
			PlayerInfo[playerid][pChar] = ChosenSkin[playerid];
			new skin =2 + random(100);
			SetPlayerVirtualWorld(playerid,skin);
			return 1;
		}
		if(PlayerInfo[playerid][pMember] >= 1)
		{
			ShowMenuForPlayer(ChoseSkin,playerid);
			if(PlayerInfo[playerid][pMember] == 1) { ChosenSkin[playerid] = 59; }
			else if(PlayerInfo[playerid][pMember] == 2) {  ChosenSkin[playerid] = 286; }
			else if(PlayerInfo[playerid][pMember] == 3) {  ChosenSkin[playerid] = 287; }
			else if(PlayerInfo[playerid][pMember] == 4) {  ChosenSkin[playerid] = 70; }
			else if(PlayerInfo[playerid][pMember] == 5) {  ChosenSkin[playerid] = 223; }
			else if(PlayerInfo[playerid][pMember] == 6) {  ChosenSkin[playerid] = 120; }
			else if(PlayerInfo[playerid][pMember] == 7) {  ChosenSkin[playerid] = 57; }
			else if(PlayerInfo[playerid][pMember] == 8) {  ChosenSkin[playerid] = 171; }
			else if(PlayerInfo[playerid][pMember] == 9) {  ChosenSkin[playerid] = 250; }
			else if(PlayerInfo[playerid][pMember] == 10) {  ChosenSkin[playerid] = 280; }
			else if(PlayerInfo[playerid][pMember] == 11) {  ChosenSkin[playerid] = 59; }
			else if(PlayerInfo[playerid][pMember] == 12) {  ChosenSkin[playerid] = 102; }
			else if(PlayerInfo[playerid][pMember] == 13) {  ChosenSkin[playerid] = 108; }
			else if(PlayerInfo[playerid][pMember] == 14) {  ChosenSkin[playerid] = 111; }
			else if(PlayerInfo[playerid][pMember] == 15) {  ChosenSkin[playerid] = 106; }
			else if(PlayerInfo[playerid][pMember] == 16) {  ChosenSkin[playerid] = 250; }
			else if(PlayerInfo[playerid][pMember] == 17) {  ChosenSkin[playerid] = 114; }
			else if(PlayerInfo[playerid][pMember] == 18) {  ChosenSkin[playerid] = 173; }
			else if(PlayerInfo[playerid][pMember] == 19) {  ChosenSkin[playerid] = 287; }
			else if(PlayerInfo[playerid][pMember] == 20) {  ChosenSkin[playerid] = 250; }
			else if(PlayerInfo[playerid][pMember] == 21) {  ChosenSkin[playerid] = 280; }
			else if(PlayerInfo[playerid][pMember] == 22) {  ChosenSkin[playerid] = 70; }
			else { return 1; }
			SetPlayerInterior(playerid,5);
			SetPlayerVirtualWorld(playerid,3);
			SetPlayerPos(playerid, 222.3489,-8.5845,1002.2109); // Warp the player
			SetPlayerFacingAngle(playerid,266.7302);
			SetPlayerCameraPos(playerid,225.3489,-8.5845,1002.2109);
			SetPlayerCameraLookAt(playerid,222.3489,-8.5845,1002.2109);
			TogglePlayerControllable(playerid, 0);
			SelectChar[playerid] = 255;
			SelectCharID[playerid] = PlayerInfo[playerid][pMember];
			SelectCharPlace[playerid] = 1;
			PlayerInfo[playerid][pModel] = ChosenSkin[playerid];
			return 1;
		}
	}
	if(pickupid == skinshop[1] || pickupid == skinshop[3])
	{
		if(	PlayerInfo[playerid][pSex] != 2)
		{
			SendClientMessage(playerid, -1,"Вы ошиблись кабинкой");
			return 1;
		}
		if(PlayerInfo[playerid][pMember] == 0)
		{
			OldSkin[playerid] = GetPlayerSkin(playerid);
			SetPlayerInterior(playerid,5);
			PlayerInfo[playerid][pChar] = 90;
			ShowMenuForPlayer(skinshopmagaz,playerid);
			SendClientMessage(playerid, 0xFFFF00AA, "При покупке Ваша текущая одежда будет заменена!");
			SendClientMessage(playerid, 0xFF0000AA, "Используйте клавишу ШИФТ, чтобы выбрать скин");
			SetPlayerPos(playerid, 222.3489,-8.5845,1002.2109); // Warp the player
			SetPlayerFacingAngle(playerid,266.7302);
			SetPlayerCameraPos(playerid,225.3489,-8.5845,1002.2109);
			SetPlayerCameraLookAt(playerid,222.3489,-8.5845,1002.2109);
			TogglePlayerControllable(playerid, 0);
			SelectChar[playerid] = 255;
			ChosenSkin[playerid] = 90;
			SelectCharPlace[playerid] = 1;
			PlayerInfo[playerid][pChar] = ChosenSkin[playerid];
			new skin =2 + random(100);
			SetPlayerVirtualWorld(playerid,skin);
			return 1;
		}
		if(PlayerInfo[playerid][pMember] >= 1)
		{
			ShowMenuForPlayer(ChoseSkin,playerid);
			if(PlayerInfo[playerid][pMember] == 1) {  ChosenSkin[playerid] = 59; }
			else if(PlayerInfo[playerid][pMember] == 2) {  ChosenSkin[playerid] = 286; }
			else if(PlayerInfo[playerid][pMember] == 3) {  ChosenSkin[playerid] = 287; }
			else if(PlayerInfo[playerid][pMember] == 4) {  ChosenSkin[playerid] = 70; }
			else if(PlayerInfo[playerid][pMember] == 5) {  ChosenSkin[playerid] = 223; }
			else if(PlayerInfo[playerid][pMember] == 6) {  ChosenSkin[playerid] = 120; }
			else if(PlayerInfo[playerid][pMember] == 7) {  ChosenSkin[playerid] = 57; }
			else if(PlayerInfo[playerid][pMember] == 8) {  ChosenSkin[playerid] = 171; }
			else if(PlayerInfo[playerid][pMember] == 9) {  ChosenSkin[playerid] = 250; }
			else if(PlayerInfo[playerid][pMember] == 10) {  ChosenSkin[playerid] = 280; }
			else if(PlayerInfo[playerid][pMember] == 11) {  ChosenSkin[playerid] = 59; }
			else if(PlayerInfo[playerid][pMember] == 12) {  ChosenSkin[playerid] = 102; }
			else if(PlayerInfo[playerid][pMember] == 13) {  ChosenSkin[playerid] = 108; }
			else if(PlayerInfo[playerid][pMember] == 14) {  ChosenSkin[playerid] = 111; }
			else if(PlayerInfo[playerid][pMember] == 15) {  ChosenSkin[playerid] = 106; }
			else if(PlayerInfo[playerid][pMember] == 16) {  ChosenSkin[playerid] = 250; }
			else if(PlayerInfo[playerid][pMember] == 17) {  ChosenSkin[playerid] = 114; }
			else if(PlayerInfo[playerid][pMember] == 18) {  ChosenSkin[playerid] = 173; }
			else if(PlayerInfo[playerid][pMember] == 19) {  ChosenSkin[playerid] = 287; }
			else if(PlayerInfo[playerid][pMember] == 20) {  ChosenSkin[playerid] = 250; }
			else if(PlayerInfo[playerid][pMember] == 21) {  ChosenSkin[playerid] = 280; }
			else if(PlayerInfo[playerid][pMember] == 22) {  ChosenSkin[playerid] = 70; }
			else { return 1; }
			SetPlayerInterior(playerid,5);
			SetPlayerVirtualWorld(playerid,3);
			SetPlayerPos(playerid, 222.3489,-8.5845,1002.2109); // Warp the player
			SetPlayerFacingAngle(playerid,266.7302);
			SetPlayerCameraPos(playerid,225.3489,-8.5845,1002.2109);
			SetPlayerCameraLookAt(playerid,222.3489,-8.5845,1002.2109);
			TogglePlayerControllable(playerid, 0);
			SelectChar[playerid] = 255;
			SelectCharID[playerid] = PlayerInfo[playerid][pMember];
			SelectCharPlace[playerid] = 1;
			PlayerInfo[playerid][pModel] = ChosenSkin[playerid];
			return 1;
		}
	}
	else if(pickupid == marenter[3]) //
	{
	    PicCP[playerid] = 0;
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,1480.8832,-1769.0471,18.7958);
		SetPlayerFacingAngle(playerid, 0.3133);
		DisablePlayerCheckpoint(playerid);
		SetCameraBehindPlayer(playerid);

	}
	else if(pickupid == marenter[1]) //
	{
	    PicCP[playerid] = 0;
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,1411.3784,-1789.9296,14.5647);
		SetPlayerFacingAngle(playerid, 94.6852);
		DisablePlayerCheckpoint(playerid);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == marenter[2]) //
	{
	    PicCP[playerid] = 3;
		SetPlayerInterior(playerid,3);
		SetPlayerPos(playerid,366.4958,193.5977,1008.3828);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerFacingAngle(playerid, 91.0948);
		SetPlayerCheckpoint(playerid,359.8466,184.7337,1008.3828,1.5);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == marenter[0]) //
	{
	    PicCP[playerid] = 3;
		SetPlayerInterior(playerid,3);
		SetPlayerPos(playerid,385.9440,173.6978,1008.3828);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerFacingAngle(playerid, 88.1044);
		SetPlayerCheckpoint(playerid,359.8466,184.7337,1008.3828,1.5);
		SetCameraBehindPlayer(playerid);

	}
	else if(pickupid == marenter[4]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		PicCP[playerid] = 0;
		SetPlayerPos(playerid,-2762.2178,375.6697,5.5402);
		SetPlayerFacingAngle(playerid, 271.0705);
		DisablePlayerCheckpoint(playerid);
		SetCameraBehindPlayer(playerid);

	}
	else if(pickupid == marenter[5]) //
	{
	    PicCP[playerid] = 3;
		SetPlayerInterior(playerid,3);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerPos(playerid,385.9440,173.6978,1008.3828);
		SetPlayerFacingAngle(playerid, 88.1044);
		SetPlayerCheckpoint(playerid,359.8466,184.7337,1008.3828,1.5);
		SetCameraBehindPlayer(playerid);

	}
	else if(pickupid == rifa[0])//Рифа вход на улицу
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2185.96,-1811.94,13.55);
		SetPlayerFacingAngle(playerid, 400);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == rifa[1])//Рифа вход в интерьер
	{
		SetPlayerInterior(playerid,18);
		SetPlayerVirtualWorld(playerid, 63);
		SetPlayerPos(playerid,-226.9188,1401.3635,27.7656);
		SetPlayerFacingAngle(playerid, 295.4148);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == vagospic[0])//Vagos вход в интерьер
	{
		SetPlayerInterior(playerid,4);
		SetPlayerVirtualWorld(playerid, 75);
		SetPlayerPos(playerid,303.2970,307.1475,1003.5391);
		SetPlayerFacingAngle(playerid, 315.7816);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == vagospic[1])//Vagos выход
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2774.2017,-1628.0233,12.1775);
		SetPlayerFacingAngle(playerid, 330.4577);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == groove[0]) //грув
	{
		SetPlayerInterior(playerid,3);
		SetPlayerPos(playerid,2496.1580,-1694.5743,1014.7422);
		SetPlayerFacingAngle(playerid,177.8856);
		SetPlayerVirtualWorld(playerid, 1);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == groove[1]) //грув
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,2495.1199,-1688.3727,13.7653);
		SetPlayerFacingAngle(playerid, 4.2929);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == aztecpic[0])//Aztec вход в интерьер
	{
		SetPlayerInterior(playerid,8);
		SetPlayerVirtualWorld(playerid, 36);
		SetPlayerPos(playerid,-42.31,1408.18,1084.43);
		SetPlayerFacingAngle(playerid, 358.9607);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == aztecpic[1])//Aztec выход
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,1804.5654,-2122.3569,13.5543);
		SetPlayerFacingAngle(playerid, 2.0407);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == bankpic[0]) //Банк вход 
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,2307.6462,-15.7474,26.7496);
		SetPlayerFacingAngle(playerid, 281.2246);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == bankpic[1]) //Банк выход
	{
		if(ebanksf[playerid] == 1)
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,-2654.0381,376.1303,4.3359);
			SetPlayerFacingAngle(playerid, 84.9623);
			ebanksf[playerid] = 0;
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,1414.14,-1702.78,13.5395);
		SetPlayerFacingAngle(playerid, 209.7472);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == banksf) //Банк sf выход
	{
		ebanksf[playerid] = 1;
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,2307.6462,-15.7474,26.7496);
		SetPlayerFacingAngle(playerid, 281.2246);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == ballasvhod[0])//Балас вход на улицу
	{
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,2647.9932,-2021.5747,13.5469);
		SetPlayerFacingAngle(playerid, 100);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == ballasvhod[1])//Балас вход в дом
	{
		SetPlayerInterior(playerid,6);
		SetPlayerVirtualWorld(playerid, 34);
		SetPlayerPos(playerid,-68.6311,1353.8743,1080.2109);
		SetPlayerFacingAngle(playerid, 357.2257);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sklad[1]) //
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,338.3804,1949.1343,22.0174);
		SetPlayerFacingAngle(playerid, 92.2485);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == sklad[0]) //
	{
		SetPlayerInterior(playerid,6);
		SetPlayerPos(playerid,316.9104,-168.6356,999.5938);
		SetPlayerFacingAngle(playerid, 355.8037);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == gunarm[0])
	{
		if(PlayerInfo[playerid][pMember] != 19) return SendClientMessage(playerid, -1,"Вы не солдат Зоны 51!");
		if(GetPVarInt(playerid, "WeaponTime") > gettime()) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя брать оружие так часто");
		if(FracBank[0][fmatslva] <= 0) return SendClientMessage(playerid,0xB4B5B7FF,"На складе нет оружия!");
		GiveWeapon(playerid, 24, 100);
		GiveWeapon(playerid, 31, 200);
		SetPlayerArmourAC(playerid, 100);
		SetPlayerHealthAC(playerid,100);
		PlayerInfo[playerid][pHP] =100;
		FracBank[0][fmatslva] -= 100;
		SetPVarInt(playerid, "WeaponTime",gettime() + 300);
		SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Deagle (100),M4 (200), Бронижелет, Сухой паёк");//Любимый цвет
	}
	else if(pickupid == gunarm[1])
	{
		if(PlayerInfo[playerid][pMember] == 3)
		{
			if(GetPVarInt(playerid, "WeaponTime") > gettime()) return SendClientMessage(playerid,0xB4B5B7FF,"Нельзя брать оружие так часто");
			if(FracBank[0][fmatssfa] <= 0) return SendClientMessage(playerid,0xB4B5B7FF,"На складе нет оружия!");
			GiveWeapon(playerid, 24, 100);
			GiveWeapon(playerid, 31, 200);
			SetPlayerArmourAC(playerid, 100);
			SetPlayerHealthAC(playerid,100);
			PlayerInfo[playerid][pHP] =100;
			FracBank[0][fmatssfa] -= 100;
			SetPVarInt(playerid, "WeaponTime",gettime() + 300);
			SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Deagle (100),M4 (200), Бронижелет, Сухой паёк");//Любимый цвет
		}
		else return SendClientMessage(playerid, -1,"Вы не солдат Армии SF!");
	}

	else if(pickupid == paras1)
	{
		GiveWeapon(playerid, 46, 1);
		SetPVarInt(playerid, "WeaponTime",gettime() + 300);
		SendClientMessage(playerid, 0x7FB151FF,"Вам выдано: Парашют");//Любимый цвет
	}
	if(pickupid == zona[1])
	{
		if(PlayerInfo[playerid][pMember] == 19 || keys[playerid] == 1)
		{
			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid,279.4233,1835.0087,17.6481);
			SetPlayerFacingAngle(playerid, 17.2727);
			SetCameraBehindPlayer(playerid);
		}
		else return SendClientMessage(playerid, -1,"У вас нет ключа!");
	}
	else if(pickupid == zona[0])
	{
		if( PlayerInfo[playerid][pMember] == 19 || keys[playerid] == 1)
		{
			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid,291.8297,1836.4666,17.6406);
			SetPlayerFacingAngle(playerid, 346.3333);
			SetCameraBehindPlayer(playerid);
		}
		else return SendClientMessage(playerid, -1,"У вас нет ключа!");
	}
	else if(pickupid == plen[0]) //
	{
		SetPlayerInterior(playerid,6);
		SetPlayerPos(playerid,308.0302,-159.7244,999.5938);
		SetPlayerFacingAngle(playerid, 258.2231);
		SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == plen[1]) //
	{
		SetPlayerInterior(playerid,6);
		SetPlayerPos(playerid,303.6572,-159.7246,999.5938);
		SetPlayerFacingAngle(playerid, 88.7500);
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	if(GetPlayerMenu(playerid) == bomj[0])
	{
		switch(row)
		{
		case 0:
			{
   				TogglePlayerControllable(playerid, 0);
				ChangeSkin[playerid]++;
				if(ChangeSkin[playerid] >= 8)
				{
					ChangeSkin[playerid] = 0;
				}
				SetPlayerSkin(playerid,BomjMen[ChangeSkin[playerid]][0]);
				ChosenSkin[playerid] = BomjMen[ChangeSkin[playerid]][0];
				ShowMenuForPlayer(bomj[0],playerid);
			}
		case 1:
			{
				TogglePlayerControllable(playerid, 0);
				ChangeSkin[playerid]--;
				if(ChangeSkin[playerid] <= 0)
				{
					ChangeSkin[playerid] = 7;
				}
				SetPlayerSkin(playerid,BomjMen[ChangeSkin[playerid]][0]);
				ChosenSkin[playerid] = BomjMen[ChangeSkin[playerid]][0];
				ShowMenuForPlayer(bomj[0],playerid);
			}
		case 2:
			{
			    new year, month, day,string[15],string2[15],string3[15];
				getdate(year, month, day);
				format(string3,sizeof(string3), "%02i/%02i/%02i",day,month,year);
				GetPlayerIp(playerid,string,sizeof(string));
				strmid(string2,string, 0, strlen(string), 16);
				PlayerInfo[playerid][pPnumber] = 10000 + random(89999);
				mysql_format(MySql_Base, QUERY, sizeof(QUERY), "INSERT INTO `accounts` (`Name`, `Key`,`Level`,`Sex`, `DataReg`, `Rip`,`Char`, `Pnumber`,`HP`,`Keyip`,`PLip`) VALUES ('%s', '%s', '%d', '%d', '%s', '%s', '%d', '%d','%d','0','%s')"
				,PlayerInfo[playerid][pName],PlayerInfo[playerid][pKey],1,PlayerInfo[playerid][pSex],string3,string2,BomjMen[ChangeSkin[playerid]][0],PlayerInfo[playerid][pPnumber],100,string2);
				DeletePVar(playerid,"Tut");
	 			mysql_tquery(MySql_Base,QUERY,"PlayerRegister","i",playerid);
			}
		}
	}
	if(GetPlayerMenu(playerid) == bomj[1])
	{
		switch(row)
		{
			case 0:
			{
				TogglePlayerControllable(playerid, 0);
				ChangeSkin[playerid]++;
				if(ChangeSkin[playerid] >= 4)
				{
					ChangeSkin[playerid] = 0;
				}
				SetPlayerSkin(playerid,BomjWomen[ChangeSkin[playerid]][0]);
				ChosenSkin[playerid] = BomjWomen[ChangeSkin[playerid]][0];
				ShowMenuForPlayer(bomj[1],playerid);
			}
			case 1:
			{
				TogglePlayerControllable(playerid, 0);
				ChangeSkin[playerid]--;
				if(ChangeSkin[playerid] <= 0)
				{
					ChangeSkin[playerid] = 3;
				}
				SetPlayerSkin(playerid,BomjWomen[ChangeSkin[playerid]][0]);
				ChosenSkin[playerid] = BomjWomen[ChangeSkin[playerid]][0];
				ShowMenuForPlayer(bomj[1],playerid);
			}
			case 2:
			{
			    new year, month, day,string[15],string2[15],string3[15];
				getdate(year, month, day);
				format(string3,sizeof(string3), "%02i/%02i/%02i",day,month,year);
				GetPlayerIp(playerid,string,32);
				strmid(string2,string, 0, strlen(string), 16);
				PlayerInfo[playerid][pPnumber] = 100000 + random(899999);
				mysql_format(MySql_Base, QUERY, sizeof(QUERY), "INSERT INTO `accounts` (`Name`, `Key`,`Level`,`Sex`, `DataReg`, `Rip`,`Char`, `Pnumber`,`HP`,`Keyip`) VALUES ('%s', '%s', '%d', '%d', '%s', '%s', '%d', '%d','%d','-1')"
				,PlayerInfo[playerid][pName],PlayerInfo[playerid][pKey],1,PlayerInfo[playerid][pSex],string3,string2,BomjWomen[ChangeSkin[playerid]][0],PlayerInfo[playerid][pPnumber],100);
	 			mysql_tquery(MySql_Base,QUERY,"PlayerRegister","i",playerid);
	 			DeletePVar(playerid,"Tut");
			}
		}
	}
	else if(GetPlayerMenu(playerid) == ChoseSkin)
	{
		switch(row)
		{
			case 0:
			{
				switch (SelectCharID[playerid])
				{
					case 1,10: //LSPD
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[0][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[0][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[1][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[1][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[2][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[2][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[3][0]); SelectCharPlace[playerid] = 5; InviteSkin[playerid] = JoinPed[3][0]; }
						else if(SelectCharPlace[playerid] == 5) { SetPlayerSkin(playerid, JoinPed[4][0]); SelectCharPlace[playerid] = 6; InviteSkin[playerid] = JoinPed[4][0]; }
						else if(SelectCharPlace[playerid] == 6) { SetPlayerSkin(playerid, JoinPed[5][0]); SelectCharPlace[playerid] = 7; InviteSkin[playerid] = JoinPed[5][0]; }
						else if(SelectCharPlace[playerid] == 7) { SetPlayerSkin(playerid, JoinPed[6][0]); SelectCharPlace[playerid] = 8; InviteSkin[playerid] = JoinPed[6][0]; }
						else if(SelectCharPlace[playerid] == 8) { SetPlayerSkin(playerid, JoinPed[7][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[7][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 2: //FBI
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[8][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[8][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[9][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[9][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[10][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[10][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[11][0]); SelectCharPlace[playerid] = 5; InviteSkin[playerid] = JoinPed[11][0]; }
						else if(SelectCharPlace[playerid] == 5) { SetPlayerSkin(playerid, JoinPed[12][0]); SelectCharPlace[playerid] = 6; InviteSkin[playerid] = JoinPed[12][0]; }
						else if(SelectCharPlace[playerid] == 6) { SetPlayerSkin(playerid, JoinPed[13][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[13][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 3,19: //Army SF
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[96][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[96][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[97][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[94][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[122][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[122][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 4,22: //Mediki
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[16][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[16][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[17][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[17][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[18][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[18][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[19][0]); SelectCharPlace[playerid] = 5; InviteSkin[playerid] = JoinPed[19][0]; }
						else if(SelectCharPlace[playerid] == 5) { SetPlayerSkin(playerid, JoinPed[20][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[20][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 5: //La Cosa Nostra
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[21][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[21][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[22][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[22][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[23][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[23][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[24][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[24][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 6: //Yakuza
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[25][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[25][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[26][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[26][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[27][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[27][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[28][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[28][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 7: //МЭР
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[29][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[29][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[30][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[30][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[31][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[31][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[32][0]); SelectCharPlace[playerid] = 5; InviteSkin[playerid] = JoinPed[32][0]; }
						else if(SelectCharPlace[playerid] == 5) { SetPlayerSkin(playerid, JoinPed[33][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[33][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 8: //Casino 171 11 172
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[123][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[123][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[124][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[124][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[125][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[125][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 9: //SF News
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[42][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[42][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[43][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[43][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[44][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[44][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[45][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[45][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 11: //Instructors
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[48][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[48][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[49][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[49][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[50][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[50][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[51][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[51][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 12://Баллас
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[76][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[76][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[77][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[77][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[78][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[78][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[79][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[79][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 13://Russian mafia
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[84][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[84][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[85][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[85][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[86][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[86][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[87][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[87][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 14://Русские
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[60][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[60][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[61][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[61][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[62][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[62][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[63][0]); SelectCharPlace[playerid] = 5; InviteSkin[playerid] = JoinPed[63][0]; }
						else if(SelectCharPlace[playerid] == 5) { SetPlayerSkin(playerid, JoinPed[64][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[64][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 15://Грув
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[65][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[65][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[66][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[66][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[67][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[67][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[68][0]); SelectCharPlace[playerid] = 5; InviteSkin[playerid] = JoinPed[68][0]; }
						else if(SelectCharPlace[playerid] == 5) { SetPlayerSkin(playerid, JoinPed[69][0]); SelectCharPlace[playerid] = 6; InviteSkin[playerid] = JoinPed[69][0]; }
						else if(SelectCharPlace[playerid] == 6) { SetPlayerSkin(playerid, JoinPed[70][0]); SelectCharPlace[playerid] = 7; InviteSkin[playerid] = JoinPed[70][0]; }
						else if(SelectCharPlace[playerid] == 7) { SetPlayerSkin(playerid, JoinPed[71][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[71][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 16://ЛС NEWS
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[90][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[90][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[91][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[91][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[92][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[92][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[93][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[93][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 17://азтек
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[72][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[72][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[73][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[73][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[74][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[74][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[75][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[75][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 18://Рифа
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[80][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[80][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[81][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[81][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[82][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[82][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[83][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[83][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 20://LV News
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[90][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[90][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[91][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[91][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[92][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[92][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[93][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[93][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
					case 21://LVPD
					{
						if(SelectCharPlace[playerid] == 1) { SetPlayerSkin(playerid, JoinPed[52][0]); SelectCharPlace[playerid] = 2; InviteSkin[playerid] = JoinPed[52][0]; }
						else if(SelectCharPlace[playerid] == 2) { SetPlayerSkin(playerid, JoinPed[53][0]); SelectCharPlace[playerid] = 3; InviteSkin[playerid] = JoinPed[53][0]; }
						else if(SelectCharPlace[playerid] == 3) { SetPlayerSkin(playerid, JoinPed[54][0]); SelectCharPlace[playerid] = 4; InviteSkin[playerid] = JoinPed[54][0]; }
						else if(SelectCharPlace[playerid] == 4) { SetPlayerSkin(playerid, JoinPed[55][0]); SelectCharPlace[playerid] = 5; InviteSkin[playerid] = JoinPed[55][0]; }
						else if(SelectCharPlace[playerid] == 5) { SetPlayerSkin(playerid, JoinPed[56][0]); SelectCharPlace[playerid] = 6; InviteSkin[playerid] = JoinPed[56][0]; }
						else if(SelectCharPlace[playerid] == 6) { SetPlayerSkin(playerid, JoinPed[57][0]); SelectCharPlace[playerid] = 7; InviteSkin[playerid] = JoinPed[57][0]; }
						else if(SelectCharPlace[playerid] == 7) { SetPlayerSkin(playerid, JoinPed[58][0]); SelectCharPlace[playerid] = 8; InviteSkin[playerid] = JoinPed[58][0]; }
						else if(SelectCharPlace[playerid] == 8) { SetPlayerSkin(playerid, JoinPed[59][0]); SelectCharPlace[playerid] = 1; InviteSkin[playerid] = JoinPed[59][0]; }
						ShowMenuForPlayer(ChoseSkin,playerid);
					}
				}
			}
			case 1:
			{
				PlayerInfo[playerid][pModel] = InviteSkin[playerid];
				forma[playerid] = 0;
				SetPlayerVirtualWorld(playerid,0);
				SelectCharPlace[playerid] = 0;
				CharPrice[playerid] = 0;
				SelectCharID[playerid] = 0;
				Spawn_Player(playerid);
			}
		}
	}
	else if(GetPlayerMenu(playerid) == Admin)
	{
		switch(row)
        {
 			case 0: StartSpectate(playerid, SpecAd[playerid]);
 			case 1: SPD(playerid, 15, DIALOG_STYLE_INPUT, "Молчанка", "Введите время молчанки и причину через пробел", "Мут", "Отмена");
			case 2: SPD(playerid, 16, DIALOG_STYLE_INPUT, "Кик", "Введите причину кика", "Кик", "Отмена");
			case 3: SPD(playerid, 13998, DIALOG_STYLE_INPUT, "Варн", "Введите причину", "Варн", "Отмена");
			case 4: SPD(playerid, 13999, DIALOG_STYLE_INPUT, "Бан", "Введите причину", "Бан", "Отмена");
			case 5:
			{

    			callcmd::slap(playerid,SpecAd[playerid]);
				StartSpectate(playerid, SpecAd[playerid]);
			}
			case 6: ShowStats(playerid, SpecAd[playerid]),StartSpectate(playerid, SpecAd[playerid]);
			case 7:
			{
			    if(PlayerInfo[playerid][pAdmin] < 4) return 1;
				new playersip[30];
				GetPlayerIp(SpecAd[playerid],playersip,sizeof(playersip));
				new string[128];
				format(string, sizeof(string), "[%s] IP: %s", GN(SpecAd[playerid]), playersip);
				SendClientMessage(playerid, 0x6495EDFF, string);
				StartSpectate(playerid, SpecAd[playerid]);
			}
			case 8:
			{
			    if(PlayerInfo[playerid][pAdmin] >= 2)
			    {
				    new string[90];
					new Float:boomx, Float:boomy, Float:boomz;
					GetPlayerPos(SpecAd[playerid],boomx, boomy, boomz);
					CreateExplosion(boomx, boomy, boomz, 5, 0.1);
					format(string, sizeof(string), "Администратор %s: %s проверен на GM", GN(playerid), GN(SpecAd[playerid]));
					ABroadCast(COLOR_LIGHTRED, string, 1);
				}
				StartSpectate(playerid, SpecAd[playerid]);
			}
	        case 9:
			{/*
                new stringskill[800];
                new points[5],percent[2] = "%";
                points[0] = 100 - PlayerInfo[SpecAd[playerid]][pGunSkill][0];
                points[1] = 100 - PlayerInfo[SpecAd[playerid]][pGunSkill][1];
                points[2] = 100 - PlayerInfo[SpecAd[playerid]][pGunSkill][2];
                points[3] = 100 - PlayerInfo[SpecAd[playerid]][pGunSkill][3];
                points[4] = 100 - PlayerInfo[SpecAd[playerid]][pGunSkill][4];
                format(stringskill,sizeof(stringskill), "Игрок:\t %s\n\nDeagle:\t[%s]%d%s\nShotgun:\t[%s]%d%s\nMP5\t\t[%s]%d%s\nAK47:\t\t[%s]%d%s\nM4:\t\t[%s]%d%s",
                GN(SpecAd[playerid]),
                ToDevelopSkills(PlayerInfo[SpecAd[playerid]][pGunSkill][0],points[0]),PlayerInfo[SpecAd[playerid]][pGunSkill][0],percent,
                ToDevelopSkills(PlayerInfo[SpecAd[playerid]][pGunSkill][1],points[1]),PlayerInfo[SpecAd[playerid]][pGunSkill][1],percent,
                ToDevelopSkills(PlayerInfo[SpecAd[playerid]][pGunSkill][2],points[2]),PlayerInfo[SpecAd[playerid]][pGunSkill][2],percent,
                ToDevelopSkills(PlayerInfo[SpecAd[playerid]][pGunSkill][3],points[3]),PlayerInfo[SpecAd[playerid]][pGunSkill][3],percent,
                ToDevelopSkills(PlayerInfo[SpecAd[playerid]][pGunSkill][4],points[4]),PlayerInfo[SpecAd[playerid]][pGunSkill][4],percent);
                SPD(playerid,0,DIALOG_STYLE_MSGBOX, " ",stringskill, "Закрыть", "");
                StartSpectate(playerid, SpecAd[playerid]);*/
	        }
			case 10:
			{
				StopSpectate(playerid);
                GameTextForPlayer(playerid, "~w~Recon ~r~Off", 5000, 4);
 			}
		}
	}
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(keyses == 1) printf("old:%d, new:%d",oldkeys,newkeys);
    if(newkeys & 16)
	{
	    if(GetPVarInt(playerid,"Tut") == 1)
		{
		    if(PlayerInfo[playerid][pSex] == 1)
			{
				ShowMenuForPlayer(bomj[0],playerid);
			}
			if(PlayerInfo[playerid][pSex] == 2)
			{
				ShowMenuForPlayer(bomj[1],playerid);
			}
		}
  		/*if(SelectCharPlace[playerid] != 0)
		{
			TogglePlayerControllable(playerid, 0);
			if(PlayerInfo[playerid][pMember] > 0)
			{
				ShowMenuForPlayer(ChoseSkin,playerid);
			}
			if(PlayerInfo[playerid][pMember] == 0)
			{
				if(PlayerInfo[playerid][pSex] == 1)
				{
					ShowMenuForPlayer(skinshopmagaz,playerid);
				}
				if(PlayerInfo[playerid][pSex] == 2)
				{
					ShowMenuForPlayer(skinshopmagaz,playerid);
				}
			}
		}*/
	}
	if(JobCP[playerid] == 4 && ((newkeys & KEY_JUMP) && !(oldkeys & KEY_JUMP) || (newkeys & KEY_FIRE) || (newkeys & KEY_SPRINT)))
	{
		if(Works[playerid] == true && JobCP[playerid] == 1)
		{
		    mesh[playerid] =1;
			if(PlayerToPoint(2.0,playerid,278.7468,1797.6921,17.6406)) return true;
			SendClientMessage(playerid,0xAA3333AA, "Вы уронили мешок!");
			DisablePlayerCheckpoint(playerid);
			ApplyAnimation(playerid, "CARRY", "crry_prtial",4.0,0,0,0,0,1,1);
			if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
			SetPlayerCheckpoint(playerid,2230.3528,-2286.1353,14.3751,1.5);
			JobCP[playerid] = 1;
		}
	}
    if(Works[playerid] == true && JobCP[playerid] == 2 && !IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_FIRE) && PlayerStartJob[playerid] == true)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, -1806.9043,-1648.0068,23.8841)
        || IsPlayerInRangeOfPoint(playerid, 1, -1799.6934,-1639.2765,23.9029)
        || IsPlayerInRangeOfPoint(playerid, 1, -1798.7091,-1645.7821,27.5569)
        || IsPlayerInRangeOfPoint(playerid, 1, -1800.4758,-1651.8302,27.6368)
        || IsPlayerInRangeOfPoint(playerid, 1, -1828.2452,-1662.8949,21.7500))
        {
			SendClientMessage(playerid, -1, "Вы не можете снова начать добывать руду");
			return 1;
		}
	}
    if(Works[playerid] == true && JobCP[playerid] == 2 && !IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_FIRE))
    {
        if(IsPlayerInRangeOfPoint(playerid, 1, -1806.9043,-1648.0068,23.8841)
        || IsPlayerInRangeOfPoint(playerid, 1, -1799.6934,-1639.2765,23.9029)
        || IsPlayerInRangeOfPoint(playerid, 1, -1798.7091,-1645.7821,27.5569)
        || IsPlayerInRangeOfPoint(playerid, 1, -1800.4758,-1651.8302,27.6368)
        || IsPlayerInRangeOfPoint(playerid, 1, -1828.2452,-1662.8949,21.7500))
        {
            SendClientMessage(playerid, -1, "Вы начали добывать руду.");
            SetTimerEx("TimerGiveMiner", 5000, false, "i", playerid);
            ApplyAnimation(playerid, "SWORD", "sword_4", 4.0, 1, 0, 0, 0, 0);
            PlayerStartJob[playerid] = true;
            return 1;
        }
    }
	if(PlayerStartJob[playerid] && JobCP[playerid] == 4 && ((newkeys & KEY_JUMP) && !(oldkeys & KEY_JUMP) || (newkeys & KEY_FIRE) || (newkeys & KEY_SPRINT)))
    {
        if(!IsPlayerInRangeOfPoint(playerid, 1, -1806.6079,-1648.0281,23.9643)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1799.5336,-1639.3250,23.9315)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1798.5327,-1645.6477,27.5683)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1800.4752,-1651.9133,27.6460)
        && !IsPlayerInRangeOfPoint(playerid, 1, -1828.6937,-1662.7900,21.7500))
        {
            SendClientMessage(playerid, 0xAA3333AA, "Вы уронили камень.");
            DisablePlayerCheckpoint(playerid);
            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 1);
            PlayerStartJob[playerid] = false;
            if(IsPlayerAttachedObjectSlotUsed(playerid, 7)) RemovePlayerAttachedObject(playerid, 7);
            SetPlayerAttachedObject(playerid, 6, 18634, 6, 0.078222, 0.000000, 0.110844, 298.897308, 264.126861, 193.350555, 1.000000, 1.000000, 1.000000);
            GetPlayerMetall[playerid] = 0;
            return 1;
        }
	}
    if(newkeys == 4 || newkeys == 12) callcmd::light(playerid);
    if (newkeys & 512)
	{
		callcmd::en(playerid);
	}
	if(newkeys & 16)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			if(IsABankomat(playerid))
			{
				if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) { return 1; }
				ApplyAnimation(playerid,"CRIB","CRIB_Use_Switch",4.0,0,0,0,0,0);
				new listitems[] = "- Снять наличные\n- Баланс\n- Домашний счёт\n- Оплата сотовой связи";
				SPD(playerid, 51, DIALOG_STYLE_LIST, "Терминал приёма платежей", listitems, "Далее", "Выход");
				return true;
			}
			if(PlayerToPoint(3.0,playerid,2308.8201,-13.2660,26.7422))
			{
				if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) { return 1; }
				ApplyAnimation(playerid,"CRIB","CRIB_Use_Switch",4.0,0,0,0,0,0);
				new listitems[] = "[1] Снять со счёта\n[2] Положить на счёт\n[3] Информация о клиенте\n[4] Денежный перевод\n[5] Пополнить счёт аренды бизнеса\n[6] Забрать деньги за дом, гараж\n[7] Оплатить >>";
				SPD(playerid, 56, DIALOG_STYLE_LIST, "Банковские услуги", listitems, "Выбрать", "Закрыть");
				return 1;
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid,8.0,-2035.1510,-242.2263,35.3203))
	{
		if(IsPlayerInAnyVehicle(playerid) && newkeys & 2)
		{
		    if(PlayerInfo[playerid][pVodPrava] == 0 && TakingLesson[playerid] == 1 || PlayerInfo[playerid][pMember] == 11)
			{
				MoveObject(Barrier,-2031.4800,-242.67,35+0.004,0.004,0.00000000,0.00000000,0.00000000);
				SetTimer("Licshlag", 15000, 0);
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(PickupUp[playerid] != -1 && !IsPlayerInRangeOfPoint(playerid, 2.0, PickupInfo[PickupUp[playerid]][PickX], PickupInfo[PickupUp[playerid]][PickY], PickupInfo[PickupUp[playerid]][PickZ])) PickupUp[playerid] = -1;
    PlayerEx[playerid][Var] = 0;
	new weap = GetPlayerWeapon(playerid);
	new string[60],str[256];
	if(weap != 0 && !Weapons[playerid][weap] && weap != 40)
	{
	    if(PlayerInfo[playerid][pAdmin] < 5)
	 	{
            SendClientMessage(playerid, COLOR_LIGHTRED, "[Античит] Ваш игровой сеанс был завершен в связи с подозрением в использовании запрещённых программ");
            SendClientMessage(playerid, COLOR_LIGHTRED, "Код события: #0311");
            SendClientMessage(playerid, COLOR_LIGHTRED, "Чтобы продолжить игру на сервере, пожалуйста, удалите сторонние программы!");
            SendClientMessage(playerid, COLOR_LIGHTRED, "Если Вы были кикнуты ошибочно, причиной этому явились пинг/лаги/моды/качество Интернет-связи");
            format(string, sizeof(string), "Кикнут %s[%i] | lvl: %i | GunCheat",GN(playerid),PlayerInfo[playerid][pLevel],playerid);
			ABroadCast(COLOR_LIGHTRED,string,1);
			DeleteWeapons(playerid);
			KickFix(playerid);
     	}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
      	new Float:hp;
		new Float:armour;
		GetPlayerArmour(SpecAd[playerid], armour);
		GetPlayerHealth(SpecAd[playerid], hp);
		new ammo = GetPlayerAmmo(SpecAd[playerid]);
		if(IsPlayerInAnyVehicle(SpecAd[playerid]))
		{
			new Float:health;
			GetVehicleHealth(GetPlayerVehicleID(SpecAd[playerid]), health);
			format(str, sizeof(str),"%s~n~[ID:%d]~n~~n~~r~Armour: ~w~%.0f~n~~g~HP: ~w~%.0f~n~~g~CAR HP: ~w~%.0f~n~~r~MONEY:~w~%d~n~~b~AMMO: ~w~%d~n~~p~WARNS: ~w~%d~n~~y~PING: ~w~%d~n~~b~SPEED: ~w~%d", GN(SpecAd[playerid]), SpecAd[playerid], armour, hp, health, PlayerInfo[SpecAd[playerid]][pCash], ammo, PlayerInfo[SpecAd[playerid]][pWarns], GetPlayerPing(SpecAd[playerid]), SpeedVehicle(SpecAd[playerid]));
			TextDrawSetString(ReconText[playerid], str);
		}
		else
		{
			format(str, sizeof(str), "%s~n~[ID:%d]~n~~n~~r~Armour: ~w~%.0f~n~~g~HP: ~w~%.0f~n~~g~BANK:~w~%d~n~~r~MONEY:~w~%d~n~~b~AMMO: ~w~%d~n~~p~WARNS: ~w~%d~n~~y~PING: ~w~%d~n~~b~SPEED: ~w~%d", GN(SpecAd[playerid]), SpecAd[playerid], armour, hp, PlayerInfo[SpecAd[playerid]][pBank], PlayerInfo[SpecAd[playerid]][pCash], ammo, PlayerInfo[SpecAd[playerid]][pWarns], GetPlayerPing(SpecAd[playerid]), SpeedVehicle(SpecAd[playerid]));
			TextDrawSetString(ReconText[playerid], str);
		}
	}
	if(Works[playerid] == true && JobCP[playerid] == 4)
	{
		if(IsPlayerApplyAnimation(playerid, "FALL_back") ||
		IsPlayerApplyAnimation(playerid, "FALL_collapse") ||
		IsPlayerApplyAnimation(playerid, "FALL_fall") ||
		IsPlayerApplyAnimation(playerid, "FALL_front") ||
		IsPlayerApplyAnimation(playerid, "FALL_glide") ||
		IsPlayerApplyAnimation(playerid, "FALL_land") ||
		IsPlayerApplyAnimation(playerid, "FALL_skyDive"))
		{
		    mesh[playerid] =1;
			if(PlayerToPoint(2.0,playerid,278.7468,1797.6921,17.6406)) return true;
			SendClientMessage(playerid,0xAA3333AA, "Вы уронили мешок!");
			DisablePlayerCheckpoint(playerid);
			ApplyAnimation(playerid, "CARRY", "crry_prtial",4.0,0,0,0,0,1,1);
			if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
			SetPlayerCheckpoint(playerid,2230.3528,-2286.1353,14.3751,1.5);
			JobCP[playerid] = 1;
		}
	}
	if(PlayerStartJob[playerid] && JobCP[playerid] == 4)
    {
        if(IsPlayerApplyAnimation(playerid, "FALL_back") ||
		IsPlayerApplyAnimation(playerid, "FALL_collapse") ||
		IsPlayerApplyAnimation(playerid, "FALL_fall") ||
		IsPlayerApplyAnimation(playerid, "FALL_front") ||
		IsPlayerApplyAnimation(playerid, "FALL_glide") ||
		IsPlayerApplyAnimation(playerid, "FALL_land") ||
		IsPlayerApplyAnimation(playerid, "FALL_skyDive"))
		{
	        if(!IsPlayerInRangeOfPoint(playerid, 1, -1806.6079,-1648.0281,23.9643)
	        && !IsPlayerInRangeOfPoint(playerid, 1, -1799.5336,-1639.3250,23.9315)
	        && !IsPlayerInRangeOfPoint(playerid, 1, -1798.5327,-1645.6477,27.5683)
	        && !IsPlayerInRangeOfPoint(playerid, 1, -1800.4752,-1651.9133,27.6460)
	        && !IsPlayerInRangeOfPoint(playerid, 1, -1828.6937,-1662.7900,21.7500))
	        {
	            SendClientMessage(playerid, 0xAA3333AA, "Вы уронили камень.");
	            DisablePlayerCheckpoint(playerid);
	            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 1);
	            PlayerStartJob[playerid] = false;
	            if(IsPlayerAttachedObjectSlotUsed(playerid, 7)) RemovePlayerAttachedObject(playerid, 7);
	            SetPlayerAttachedObject(playerid, 6, 18634, 6, 0.078222, 0.000000, 0.110844, 298.897308, 264.126861, 193.350555, 1.000000, 1.000000, 1.000000);
	            GetPlayerMetall[playerid] = 0;
	            return 1;
	        }
		}
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}


public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
publics ClearAnim(playerid) return ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,0,0,0,0,0,1);
// ========== [ Стоки ] ==========
publics LoadHouse()
{
	new rows,f;
    cache_get_data(rows, f);
	for(new i; i < TOTALHOUSE; i++) strmid(HouseInfo[i][hOwner],"None",0,strlen("None"),MAX_PLAYER_NAME);
	if(rows)
	{
		for(new idx = 1; idx <= rows; idx++)
		{
		    HouseInfo[idx][hID] = cache_get_field_content_int(idx-1, "hID", MySql_Base);
		    cache_get_field_content(idx-1,"hStreet",HouseInfo[idx][hStreet],MySql_Base,25);
		    HouseInfo[idx][hNumber] = cache_get_field_content_int(idx-1, "hNumber", MySql_Base);
		    HouseInfo[idx][hEntrancex] = cache_get_field_content_float(idx-1, "hEntrancex", MySql_Base);
		    HouseInfo[idx][hEntrancey] = cache_get_field_content_float(idx-1, "hEntrancey", MySql_Base);
		    HouseInfo[idx][hEntrancez] = cache_get_field_content_float(idx-1, "hEntrancez", MySql_Base);
		    HouseInfo[idx][hExitx] = cache_get_field_content_float(idx-1, "hExitx", MySql_Base);
		    HouseInfo[idx][hExity] = cache_get_field_content_float(idx-1, "hExity", MySql_Base);
		    HouseInfo[idx][hExitz] = cache_get_field_content_float(idx-1, "hExitz", MySql_Base);
		    HouseInfo[idx][hExitc] = cache_get_field_content_float(idx-1, "hExitc", MySql_Base);
		    HouseInfo[idx][hLabelx] = cache_get_field_content_float(idx-1, "hLabelx", MySql_Base);
		    HouseInfo[idx][hLabely] = cache_get_field_content_float(idx-1, "hLabely", MySql_Base);
		    HouseInfo[idx][hLabelz] = cache_get_field_content_float(idx-1, "hLabelz", MySql_Base);
		    HouseInfo[idx][hCarx] = cache_get_field_content_float(idx-1, "hCarx", MySql_Base);
		    HouseInfo[idx][hCary] = cache_get_field_content_float(idx-1, "hCary", MySql_Base);
		    HouseInfo[idx][hCarz] = cache_get_field_content_float(idx-1, "hCarz", MySql_Base);
		    HouseInfo[idx][hCarc] = cache_get_field_content_float(idx-1, "hCarc", MySql_Base);
            cache_get_field_content(idx-1,"hOwner",HouseInfo[idx][hOwner],MySql_Base,25);
            HouseInfo[idx][hPrice] = cache_get_field_content_int(idx-1, "hPrice", MySql_Base);
            HouseInfo[idx][hInt] = cache_get_field_content_int(idx-1, "hInt", MySql_Base);
            HouseInfo[idx][hLock] = cache_get_field_content_int(idx-1, "hLock", MySql_Base);
            HouseInfo[idx][hCheck] = cache_get_field_content_int(idx-1, "hCheck", MySql_Base);
            HouseInfo[idx][hClass] = cache_get_field_content_int(idx-1, "hClass", MySql_Base);
            HouseInfo[idx][hMats] = cache_get_field_content_int(idx-1, "hMats", MySql_Base);

			new string[300];

			HouseInfo[idx][hMIcon] = CreateDynamicMapIcon(HouseInfo[idx][hEntrancex], HouseInfo[idx][hEntrancey], HouseInfo[idx][hEntrancez]-0.5, !strcmp(HouseInfo[idx][hOwner], "None", false) ? (31) : (32), 0, -1, -1, -1, 150.0, MAPICON_LOCAL_CHECKPOINT);
			HouseInfo[idx][hAreaEnter] = CreateDynamicSphere(HouseInfo[idx][hEntrancex], HouseInfo[idx][hEntrancey], HouseInfo[idx][hEntrancez], 1.3, 0, 0, -1);
			new classes[5];
			switch(HouseInfo[idx][hClass])
			{
			    case 1: classes = "Nope";
                case 2: classes = "D";
                case 3: classes = "C";
                case 4: classes = "B";
                case 5: classes = "A";
                case 6: classes = "VIP";
			}
			if(!strcmp(HouseInfo[idx][hOwner], "None", false))
			{
				format(string, sizeof(string), "{F5DEB3}=========={808080}[{00FA9A}Дом{808080}]{F5DEB3}==========\nАдрес: {00FF7F}ул. %s, д. %d{F5DEB3}\nЦена:{00FF7F} %d{F5DEB3} руб.\nКласс:{00FF7F} %s{F5DEB3}\n=========================", HouseInfo[idx][hStreet],HouseInfo[idx][hNumber], HouseInfo[idx][hPrice],classes);
			}
			else
			{
				format(string, sizeof(string), "{F5DEB3}=========={808080}[{00FA9A}Дом{808080}]{F5DEB3}==========\nАдрес: {00FF7F}ул. %s, д. %d{F5DEB3}\nВладелец:{00FF7F} %s\n{F5DEB3}Класс:{00FF7F} %s{F5DEB3}\n=========================", HouseInfo[idx][hStreet],HouseInfo[idx][hNumber], HouseInfo[idx][hOwner],classes);
			}
			HouseInfo[idx][hTextEnter] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, HouseInfo[idx][hLabelx], HouseInfo[idx][hLabely], HouseInfo[idx][hLabelz], 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1);
            strmid(string,"",0,2,2);
			TOTALHOUSE++;
        }
    }
	printf("[Загружено домов]: <%i>.", TOTALHOUSE);
//	dlg_str[0] = EOS;
//	format(dlg_str,sizeof(dlg_str),"Информация о недвижимости\n\n{FFFFFF}Куплено домов: {FF6600}%d\n{FFFFFF}Свободных домов: {63BD4E}%d",Iter_Count(PurchasedHouses),Iter_Count(HousesForSale));
//	tHouseStats = CreateDynamic3DTextLabel(dlg_str, 0x3399FFFF, 1491.0463,1308.4412,1094.0829, 20.0);

	return 1;
}
stock UpdateHouse(idx, type = 0)
{
	DestroyDynamicMapIcon(HouseInfo[idx][hMIcon]);
	HouseInfo[idx][hMIcon] = CreateDynamicMapIcon(HouseInfo[idx][hEntrancex], HouseInfo[idx][hEntrancey], HouseInfo[idx][hEntrancez]-0.5, !strcmp(HouseInfo[idx][hOwner], "None", false) ? (31) : (32), 0, -1, -1, -1, 150.0, MAPICON_LOCAL_CHECKPOINT);

	DestroyDynamicArea(HouseInfo[idx][hAreaEnter]);
	HouseInfo[idx][hAreaEnter] = CreateDynamicSphere(HouseInfo[idx][hEntrancex], HouseInfo[idx][hEntrancey], HouseInfo[idx][hEntrancez], 1.3, 0, 0, -1);
	new string[200];
	new classes[5];
	switch(HouseInfo[idx][hClass])
	{
	    case 1: classes = "Nope";
        case 2: classes = "D";
        case 3: classes = "C";
        case 4: classes = "B";
        case 5: classes = "A";
        case 6: classes = "VIP";
	}
 	if(!strcmp(HouseInfo[idx][hOwner], "None", false))
	{
		format(string, sizeof(string), "{F5DEB3}=========={808080}[{00FA9A}Дом{808080}]{F5DEB3}==========\nАдрес: {00FF7F}ул.%s\n{F5DEB3}Цена:{00FF7F} %d{F5DEB3} руб.\nКласс:{00FF7F} %s{F5DEB3}\n=========================", HouseInfo[idx][hStreet], HouseInfo[idx][hPrice],classes);
	}
	else
	{
		format(string, sizeof(string), "{F5DEB3}=========={808080}[{00FA9A}Дом{808080}]{F5DEB3}==========\nАдрес: {00FF7F}ул. %s\n{F5DEB3}Владелец:{00FF7F} %s\n{F5DEB3}Класс:{00FF7F} %s{F5DEB3}\n=========================", HouseInfo[idx][hStreet], HouseInfo[idx][hOwner],classes);
	}

	if(!type)
	{
		UpdateDynamic3DTextLabelText(HouseInfo[idx][hTextEnter], 0xFFFFFFFF, string);
	}
	else
	{
		DestroyDynamic3DTextLabel(HouseInfo[idx][hTextEnter]);
		HouseInfo[idx][hTextEnter] = Text3D:INVALID_3DTEXT_ID;
		HouseInfo[idx][hTextEnter] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, HouseInfo[idx][hLabelx], HouseInfo[idx][hLabely], HouseInfo[idx][hLabelz], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
	}
	return 1;
}
stock SetPlayerCriminal(playerid,cop,points,reason[])
{
	if(!IsPlayerConnected(playerid)) return 1;
	PlayerInfo[playerid][pKills] += points;
	new coper[MAX_PLAYER_NAME];
	if (cop == -1)
	{
		format(coper, sizeof(coper), "Неизвестный");
	}
	else
	{
		if(!IsPlayerConnected(cop))
	    GetPlayerName(cop, coper, sizeof(coper));
	}
	if(!IsACop(playerid) || !IsAArm(playerid))
	{
		if(PlayerInfo[playerid][pZvezdi] <6)
		{
			format(req, sizeof(req), "Вы совершили преступление: %s, сообщает: %s",reason,coper);
			SendClientMessage(playerid, COLOR_LIGHTRED, req);
			if(PlayerInfo[playerid][pZvezdi] + points <=6) SetPlayerWantedLevel(playerid,PlayerInfo[playerid][pZvezdi] += points),PlayerInfo[playerid][pZvezdi] +=points;
			else SetPlayerWantedLevel(playerid,6),PlayerInfo[playerid][pZvezdi] = 6;
		}
		format(req, sizeof(req), "Диспетчер: преступление: %s[+%d], подозр.: %s, сообщает: %s",reason,points,GN(playerid),coper);
		SendPoliceMessage(0xFEBC41AA, req);
	}
	return 1;
}
SetPosInFrontOfPlayer(playerid,giveplayerid,Float:distance)
{
	new Float:x,Float:y,Float:z,Float:a;
	GetPlayerPos(playerid, x, y,z);GetPlayerFacingAngle(playerid, a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	SetPlayerPos(giveplayerid,x,y,z);SetPlayerFacingAngle(giveplayerid,a);
}
stock split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}
new WebSites[][] ={".ws",".ru",".tk",".com","www.",".org",".net",".cc",".рф",".by",".biz",".su",".info"};
stock CheckString(string[])
{
	for(new i = 0;i<sizeof(WebSites);i++)
	{
		if(strfind(string,WebSites[i],true) != -1)
		{
			return true;
		}
	}
	return false;
}
new delimiters[]={'.', ' ', ',', '*', '/', ';', '\\', '|'};
	stock IsIP(const str[])
	{
		for(new cIP[4]; cIP[0] != strlen(str)+1; cIP[0]++)
		{
			switch(str[cIP[0]])
			{
				case '.', ' ', ':', ',', '*', '/', ';', '\\', '|' : continue;
				case '0' .. '9': cIP[1]++;
			}
			if(cIP[1] ==1){ cIP[2] = cIP[0];}
			if(cIP[1] >= 8)
			{
				new strx[16];
				new l[4][4];
				cIP[3] = cIP[0]+8;
				strmid(strx,str,cIP[2],cIP[3],16);
				for(new i =strlen(strx);i>8;i--)
				{
					switch(strx[i])
					{
						case '0' .. '9','.', ' ', ':', ',', '*', '/', ';', '\\', '|': continue;
						default: strx[i] =0;
					}
				}
				for(new i =0;i<sizeof(delimiters);i++)
				{
					split(strx,l,delimiters[i]);
					if(strlen(l[0]) == 1 ||strlen(l[1]) == 1 ||strlen(l[2]) == 1 ||strlen(l[3]) == 1) continue;
					if(strlen(l[0]) >3 ||strlen(l[1]) >3 ||strlen(l[2]) >3) continue;
					else return true;
				}
			}
		}
		return false;
	}
stock SendTeamMessage(color, string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(IsAArm(i) || IsAMedic(i) || IsAMayor(i) || IsACop(i) || PlayerInfo[i][pAdmin] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}
stock SendPoliceMessage(color, string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pMember] == 1 || PlayerInfo[i][pMember] == 2 || PlayerInfo[i][pMember] == 10 || PlayerInfo[i][pMember] == 21 || (PlayerInfo[i][pAdmin] > 1 && (cfact[i][1] == 1 || cfact[i][2] == 1 || cfact[i][10] == 1 || cfact[i][21] == 1)))
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}
stock SendRadioMessage(member, color, string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pMember] == member || PlayerInfo[i][pLeader] == member || fchat[i] == member)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}

stock SendJobMessage(job, color, string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pJob] == job)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}
stock SendFamilyMessage(family, color, string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pMember] == family || PlayerInfo[i][pLeader] == family)
			{
				if(!gFam[i])
				{
					SendClientMessage(i, color, string);
				}
			}
		}
	}
}
stock IsABankomat(playerid)
{
	if(PlayerToPoint(3.0,playerid,-1676.34570312,434.01806641,7.08183193) || PlayerToPoint(3.0,playerid,-818.55200195,1567.63708496,27.01933098) ||
	PlayerToPoint(3.0,playerid,-2421.45410156,958.35540771,45.18632126) || PlayerToPoint(3.0,playerid,2174.20336914,1402.93469238,10.96464443) ||
	PlayerToPoint(3.0,playerid,-2621.31445312,1415.23510742,6.88521862) || PlayerToPoint(3.0,playerid,1587.30920410,2218.34838867,10.96464443) ||
	PlayerToPoint(3.0,playerid,-2452.32275391,2252.62988281,4.87058449) || PlayerToPoint(3.0,playerid,2187.36035156,2478.89160156,11.14433193) ||
	PlayerToPoint(3.0,playerid,-1282.38098145,2715.18652344,50.16842651) || PlayerToPoint(3.0,playerid,-2033.32604980,159.50723267,28.94120598) ||
	PlayerToPoint(3.0,playerid,91.92106628,1180.56555176,18.56620598) || PlayerToPoint(3.0,playerid,2236.16186523,-1665.79772949,15.27980804) ||
	PlayerToPoint(3.0,playerid,847.58093262,-1799.19348145,13.71945286) || PlayerToPoint(3.0,playerid,1367.56359863,-1290.13696289,13.44901943) ||
	PlayerToPoint(3.0,playerid,-78.74282837,-1171.64892578,1.95329499) || PlayerToPoint(3.0,playerid,1142.44287109,-1763.92932129,13.59816360) ||
	PlayerToPoint(3.0,playerid,-1551.53637695,-2737.33691406,48.64560318) || PlayerToPoint(3.0,playerid,1224.6953, -1782.2031, 29.8984) ||
	PlayerToPoint(3.0,playerid,661.71307373,-576.21777344,16.25428581) || PlayerToPoint(3.0,playerid,557.32824707,-1294.28137207,17.24994087) ||
	PlayerToPoint(3.0,playerid,-2035.70605469,-102.35491180,35.07402039) || PlayerToPoint(3.0,playerid,1919.78381348,-1766.21813965,13.44901943) ||
	PlayerToPoint(3.0,playerid,1497.84814,-1750.24280,15.25320) || PlayerToPoint(3.0,playerid,1243.21973, -1806.49548, 13.45270)){return true;}
	return false;
}
stock SpeedVehicle(playerid)
{
	new Float:ST[4];
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
	ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 160.3;
	return floatround(ST[3]);
}
stock CheckHealth()
{
	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i)) return true;
		if(!qweqwe[i])
		{
			new Float: Health;
			GetPlayerHealth(i, Health);
			if(PlayerHealth[i] < Health) { SetPlayerHealth(i, PlayerHealth[i]); }
			else { PlayerHealth[i] = Health; }
		}
		else qweqwe[i]--;
	}
	return true;
}
stock SetPlayerHealthAC(playerid, Float: Health)
{
	if(!IsPlayerConnected(playerid)) return 1;
	PlayerHealth[playerid] = Health;
	SetPlayerHealth(playerid, Health);
	qweqwe[playerid]=3;
	return true;
}
stock SetPlayerArmourAC(playerid, Float: Arm)
{
	if(!IsPlayerConnected(playerid)) return 1;
	Armour[playerid] = Arm;
	SetPlayerArmour(playerid, Arm);
	return true;
}
UnLockCar(carid)
{
	foreach(new i : Player)
	{
		gCarLock[carid] = 0;
		GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(carid,engine,lights,alarm,VEHICLE_PARAMS_OFF,bonnet,boot,objective);
		SetVehicleParamsForPlayer(carid,i,0,0);
	}
}
stock LockCar(carid)
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i)) { SetVehicleParamsForPlayer(carid,i,0,1); gCarLock[carid] = 1; }
	}
}
stock IsNoSpeed(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 481,509,510: return true;
	}
	return false;
}
stock IsAGang(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		switch(PlayerInfo[playerid][pMember])
		{
			case 11,12,14,16,17:return true;
		}
	}
	return false;
}
stock GiveWeapon(playerid, weaponid, ammo)
{
	Weapons[playerid][weaponid] = 1;
	GivePlayerWeapon(playerid, weaponid, ammo);
    return true;
}
stock SetPlayerWeapons(playerid)
{
	if(PlayerInfo[playerid][pSlot][0] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][0], PlayerInfo[playerid][pSlotammo][0]);
	if(PlayerInfo[playerid][pSlot][1] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][1], PlayerInfo[playerid][pSlotammo][1]);
	if(PlayerInfo[playerid][pSlot][2] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][2], PlayerInfo[playerid][pSlotammo][2]);
	if(PlayerInfo[playerid][pSlot][3] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][3], PlayerInfo[playerid][pSlotammo][3]);
	if(PlayerInfo[playerid][pSlot][4] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][4], PlayerInfo[playerid][pSlotammo][4]);
	if(PlayerInfo[playerid][pSlot][5] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][5], PlayerInfo[playerid][pSlotammo][5]);
	if(PlayerInfo[playerid][pSlot][6] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][6], PlayerInfo[playerid][pSlotammo][6]);
	if(PlayerInfo[playerid][pSlot][7] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][7], PlayerInfo[playerid][pSlotammo][7]);
	if(PlayerInfo[playerid][pSlot][8] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][8], PlayerInfo[playerid][pSlotammo][8]);
	if(PlayerInfo[playerid][pSlot][9] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][9], PlayerInfo[playerid][pSlotammo][9]);
	if(PlayerInfo[playerid][pSlot][10] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][10], PlayerInfo[playerid][pSlotammo][10]);
	if(PlayerInfo[playerid][pSlot][11] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][11], PlayerInfo[playerid][pSlotammo][11]);
	if(PlayerInfo[playerid][pSlot][12] > 0) GiveWeapon(playerid, PlayerInfo[playerid][pSlot][12], PlayerInfo[playerid][pSlotammo][12]);
	if(IsAGang(playerid)) GiveWeapon(playerid, 5, 1);
	if(PlayerInfo[playerid][pMember] == 5 || PlayerInfo[playerid][pLeader] == 5) GiveWeapon(playerid, 2, 1);
	if(PlayerInfo[playerid][pMember] == 6 || PlayerInfo[playerid][pLeader] == 6) GiveWeapon(playerid, 8, 1);
	if(PlayerInfo[playerid][pMember] == 14 || PlayerInfo[playerid][pLeader] == 14) GiveWeapon(playerid, 1, 1);
}
stock DeleteWeapons(playerid)
{
	ResetPlayerWeapons(playerid);
	PlayerInfo[playerid][pSlot][0] = 0;
	PlayerInfo[playerid][pSlot][1] = 0;
	PlayerInfo[playerid][pSlot][2] = 0;
	PlayerInfo[playerid][pSlot][3] = 0;
	PlayerInfo[playerid][pSlot][4] = 0;
	PlayerInfo[playerid][pSlot][5] = 0;
	PlayerInfo[playerid][pSlot][6] = 0;
	PlayerInfo[playerid][pSlot][7] = 0;
	PlayerInfo[playerid][pSlot][8] = 0;
	PlayerInfo[playerid][pSlot][9] = 0;
	PlayerInfo[playerid][pSlot][10] = 0;
	PlayerInfo[playerid][pSlot][11] = 0;
	PlayerInfo[playerid][pSlot][12] = 0;
	PlayerInfo[playerid][pSlotammo][0] = 0;
	PlayerInfo[playerid][pSlotammo][1] = 0;
	PlayerInfo[playerid][pSlotammo][2] = 0;
	PlayerInfo[playerid][pSlotammo][3] = 0;
	PlayerInfo[playerid][pSlotammo][4] = 0;
	PlayerInfo[playerid][pSlotammo][5] = 0;
	PlayerInfo[playerid][pSlotammo][6] = 0;
	PlayerInfo[playerid][pSlotammo][7] = 0;
	PlayerInfo[playerid][pSlotammo][8] = 0;
	PlayerInfo[playerid][pSlotammo][9] = 0;
	PlayerInfo[playerid][pSlotammo][10] = 0;
	PlayerInfo[playerid][pSlotammo][11] = 0;
	PlayerInfo[playerid][pSlotammo][12] = 0;
}
stock SaveWeapon(playerid)
{
	GetPlayerWeaponData(playerid,0,PlayerInfo[playerid][pSlot][0],PlayerInfo[playerid][pSlotammo][0]);
	GetPlayerWeaponData(playerid,1,PlayerInfo[playerid][pSlot][1],PlayerInfo[playerid][pSlotammo][1]);
	GetPlayerWeaponData(playerid,2,PlayerInfo[playerid][pSlot][2],PlayerInfo[playerid][pSlotammo][2]);
	GetPlayerWeaponData(playerid,3,PlayerInfo[playerid][pSlot][3],PlayerInfo[playerid][pSlotammo][3]);
	GetPlayerWeaponData(playerid,4,PlayerInfo[playerid][pSlot][4],PlayerInfo[playerid][pSlotammo][4]);
	GetPlayerWeaponData(playerid,5,PlayerInfo[playerid][pSlot][5],PlayerInfo[playerid][pSlotammo][5]);
	GetPlayerWeaponData(playerid,6,PlayerInfo[playerid][pSlot][6],PlayerInfo[playerid][pSlotammo][6]);
	GetPlayerWeaponData(playerid,7,PlayerInfo[playerid][pSlot][7],PlayerInfo[playerid][pSlotammo][7]);
	GetPlayerWeaponData(playerid,8,PlayerInfo[playerid][pSlot][8],PlayerInfo[playerid][pSlotammo][8]);
	GetPlayerWeaponData(playerid,9,PlayerInfo[playerid][pSlot][9],PlayerInfo[playerid][pSlotammo][9]);
	GetPlayerWeaponData(playerid,10,PlayerInfo[playerid][pSlot][10],PlayerInfo[playerid][pSlotammo][10]);
	GetPlayerWeaponData(playerid,11,PlayerInfo[playerid][pSlot][11],PlayerInfo[playerid][pSlotammo][11]);
	GetPlayerWeaponData(playerid,12,PlayerInfo[playerid][pSlot][12],PlayerInfo[playerid][pSlotammo][12]);
}
stock ABroadCast(color,const string[],level)
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] >= level && dostup[i] == true) SendClientMessage(i, color, string);
		}
	}
	return 1;
}
stock ABroadCastcc(const string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(dostup[i] == true && cchat[i]) SendClientMessage(i, COLOR_GREY, string);
		}
	}
	return 1;
}
stock AdmLog(Aid,Adm[],Nid,Name[],Type,Reason[],Time)
{
	new string[17],year, month,day,hour,minute,second;
	getdate(year, month, day);
	gettime(hour, minute, second);
	format(string,sizeof(string),"%d/%d/%d %d:%d",day,month,year,hour,minute);
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `admin_log` (`IDAdmin`,`Admin`, `IDGiveplayer`,`Giveplayer`, `Type`,`Reason`,`Time`,`Date`) VALUES ('%d','%s', '%d','%s', '%d','%s','%d','%s')",Aid,Adm,Nid,Name,Type,Reason,Time,string);
	mysql_tquery(MySql_Base,QUERY,"","");
	return 1;
}
stock RangLog(Nid,Name[],Gid,Giveplayer[],Type,Frac,Reason[],Text[])
{
	new string[19],year, month,day,hour,minute,second;
	getdate(year, month, day);
	gettime(hour, minute, second);
	format(string,sizeof(string),"%d/%d/%d %d:%d",day,month,year,hour,minute);
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `rangs_log` (`IDName`,`Name`,`IDGiveplayer`, `Giveplayer`, `Type`,`Frac`,`Text`,`Reason`,`Date`) VALUES ('%d','%s','%d', '%s', '%d','%d','%s','%s','%s')",Nid,Name,Gid, Giveplayer,Type,Frac,Text,Reason,string);
	mysql_tquery(MySql_Base,QUERY,"","");
	return 1;
}
stock Log(Name[],Type)
{
	new string[17],year, month,day,hour,minute,second,pip[16];
	getdate(year, month, day);
	gettime(hour, minute, second);
	format(string,sizeof(string),"%d/%d/%d %d/%d",day,month,year,hour,minute);
	GetPlayerIp(ReturnUser(Name), pip, sizeof(pip));
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `logs` (`Name`, `Type`, `Date`,`IP`) VALUES ('%s', '%d', '%s','%s')",Name,Type,string,pip);
	mysql_tquery(MySql_Base,QUERY,"","");
	return 1;
}
stock CashLog(Nid,Name[],Gid,Giveplayer[],Type,Money)
{
	new string[17],year, month,day,hour,minute,second;
	getdate(year, month, day);
	gettime(hour, minute, second);
	format(string,sizeof(string),"%d/%d/%d %d/%d",day,month,year,hour,minute);
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `cash` (`IDName`,`Name`,`IDGiveplayer`, `Giveplayer`,`Type`,`Money` ,`Date`) VALUES ('%d','%s','%d', '%s', '%d','%d','%s')",Nid,Name,Gid,Giveplayer,Type,Money,string);
	mysql_tquery(MySql_Base,QUERY,"","");
	return 1;
}
stock warn(Nid,Name[],Aid,admin[],Text[],unWarn)
{
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `warn` (`IDName`,`Name`,`IDAdmin`, `Admin`, `Text`,`unWarn`) VALUES ('%d','%s','%d', '%s', '%s','%d')",Nid,Name,Aid, admin,Text,unWarn);
	mysql_tquery(MySql_Base,QUERY,"","");
	return 1;
}
stock ban(Nid,Name[],Aid,admin[],Text[],unBan)
{
	mysql_format(MySql_Base,QUERY, sizeof(QUERY), "INSERT INTO `ban` (`IDName`,`Name`,`IDAdmin`, `Admin`, `Text`,`unBan`) VALUES ('%d','%s','%d', '%s', '%s','%d')",Nid,Name,Aid, admin,Text,unBan);
	mysql_tquery(MySql_Base,QUERY,"","");
	return 1;
}
stock StartSpectate(playerid, specid)
{
	ShowMenuForPlayer(Admin,playerid);
	if(IsPlayerInAnyVehicle(specid))
	{
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specid));
		gSpectateID[playerid] = specid;
		TextDrawShowForPlayer(playerid, ReconText[playerid]);
	}
	else
	{
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, specid);
		gSpectateID[playerid] = specid;
		TextDrawShowForPlayer(playerid, ReconText[playerid]);
	}
	SpecAd[playerid] = specid;
	SpecID[specid] = playerid;
	return true;
}
stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	TextDrawHideForPlayer(playerid, ReconText[playerid]);
	HideMenuForPlayer(Admin, playerid);
	TextDrawHideForPlayer(playerid, ReconText[playerid]);
	return true;
}
stock ConvertSeconds(time)
{
	new string[128];
	if (time < 60) format(string, sizeof(string), "00:%02d", time);
	else if (time == 60) string = "1:00";
	else if (time > 60 && time < 3600)
	{
		new Float: minutes;
		new seconds;
		minutes = time / 60;
		seconds = time % 60;
		format(string, sizeof(string), "%0.0f:%02d", minutes, seconds);
	}
	else if (time == 3600) string = "1:00:00";
	else if (time > 3600)
	{
		new Float: hours;
		new minutes_int;
		new Float: minutes;
		new seconds;
		hours = time / 3600;
		minutes_int = time % 3600;
		minutes = minutes_int / 60;
		seconds = minutes_int % 60;
		format(string, sizeof(string), "%0.0f:%0.0f:%02d", hours, minutes, seconds);
	}
	return string;
}
stock PayDay()
{
    SaveMySQL(0);
	mysql_tquery(MySql_Base,"SELECT * FROM `ban`","OnMySQL_QUERY","iis",4,-1,"");
	mysql_tquery(MySql_Base,"SELECT * FROM `warn`","OnMySQL_QUERY","iis",5,-1,"");
	new string[128];
	for(new h = 0; h < TOTALHOUSE; h++)
	{
	    if(strcmp(HouseInfo[h][hOwner], "None", false))
	    {
			switch(HouseInfo[h][hClass])
			{
			    case 0,4: HouseInfo[h][hCheck] -= 50;
			    case 1,3: HouseInfo[h][hCheck] -= 100;
			    case 2: HouseInfo[h][hCheck] -= 150;
			}
		}
		if(HouseInfo[h][hCheck] <= 0 && strcmp(HouseInfo[h][hOwner], "None", false))
		{
		    strmid(HouseInfo[h][hOwner],"None", 0, 5, 5);
			HouseInfo[h][hLock] = 1;
		}
		UpdateHouse(h);
	}
	foreach(new i : Player)
	{
//		new house = PlayerInfo[i][pPhousekey];
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pLevel] > 0)
			{
				new moneys = 1+random(1000);
    			switch(PlayerInfo[i][pMember])
				{
					case 1,10,21:{ PlayerInfo[i][pPayCheck] += 1300*PlayerInfo[i][pRank]+moneys; }
            		case 3,19:{ PlayerInfo[i][pPayCheck] += 1000*PlayerInfo[i][pRank]+moneys; }
            		case 2:{ PlayerInfo[i][pPayCheck] += 2000*PlayerInfo[i][pRank]+moneys; }
            		case 7:{ PlayerInfo[i][pPayCheck] += 2500*PlayerInfo[i][pRank]+moneys; }
            		case 4,22:{ PlayerInfo[i][pPayCheck] += 1500*PlayerInfo[i][pRank]+moneys; }
            		case 11:{ PlayerInfo[i][pPayCheck] += 1800*PlayerInfo[i][pRank]+moneys; }
				}
				new checks = PlayerInfo[i][pPayCheck];
				format(string, sizeof(string), "~w~PayDay");
				GameTextForPlayer(i, string, 5000, 1);
				//===================== Работам ================================
				if(PlayerInfo[i][pJob] == 1 && PlayerInfo[i][pMember] == 0)
				{
					PlayerInfo[i][pPayCheck] += AutoBusCheck[i];
					AutoBusCheck[i] = 0;
				}
				if(PlayerInfo[i][pVIP] >=1) { SendClientMessage(i, 0xFFA500AA, "--------=== [ КЛИЕНТ БАНКА SA ] ===--------"); }
				else { SendClientMessage(i, 0xB4B5B7FF, "--------=== [ КЛИЕНТ БАНКА SA ] ===--------"); }
				if(!NoNalog(i))
				{
                    new nalog = PlayerInfo[i][pPayCheck] -= checks - checks * 1 / 100;
                    format(string, sizeof(string), "*** Налог государству: %d рублей", nalog);
                    SendClientMessage(i, COLOR_LIGHTRED, string);
                    FracBank[0][fKazna] += nalog*2;
                    PlayerInfo[i][pBank] -= nalog;
                }
				if(PlayerInfo[i][pKrisha] !=0)
				{
					if(PlayerInfo[i][pBank] > 50)
					{
						PlayerInfo[i][pBank] -=50;
						PlayerInfo[i][pDolg] +=50;
					}
					if(PlayerInfo[i][pCash] > 50)
					{
						PlayerInfo[i][pCash] -=50;
						PlayerInfo[i][pDolg] +=50;
					}
				}
				format(string, sizeof(string), "*** Счёт за телефон: -%d рублей",CallCost[i]);
				SendClientMessage(i, COLOR_LIGHTRED, string);
	            format(string, sizeof(string), "- Зарплата: %i рублей", checks);
                SendClientMessage(i, -1, string);
                PlayerInfo[i][pBank] += checks;
				SendClientMessage(i, 0xFF9900AA, " ");
				format(string, sizeof(string), "- Текущий баланс: %d рублей", PlayerInfo[i][pBank]);
				SendClientMessage(i, 0xF5DEB3AA, string);
				PlayerInfo[i][pZakonp] += 1;
				FracBank[0][fKazna] +=FracBank[0][fNalog];
//				new bouse = PlayerInfo[i][pPbiskey];
				/*if(PlayerInfo[i][pPbiskey] != 255)
				{
					SendClientMessage(i, -1, "- Плата за аренду бизнеса: 100 рублей");
					if(bouse < 100)
					{
						BizzInfo[bouse][bTill] -= 100;
						BizzInfo[bouse][bTill] += BizzInfo[bouse][b2Till];
						BizzInfo[bouse][b2Till] = 0;
						if(BizzInfo[bouse][bMafia] !=0)
						{
							if(BizzInfo[bouse][bTill] > 5000)
							{
								BizzInfo[bouse][bTill] -= 1000;
								switch(BizzInfo[bouse][bMafia])
								{
								    case 6: MafiaBank[0][nYakuza] += 500;
								    case 14: MafiaBank[0][nRm] += 500;
									case 5: MafiaBank[0][nLcn] += 500;
								}
							}
						}
						if(BizzInfo[bouse][bTill] <= 0)
						{
							BizzInfo[bouse][bLocked] = 1;
							BizzInfo[bouse][bOwned] = 0;
							BizzInfo[bouse][bProducts] = 0;
							strmid(BizzInfo[bouse][bOwner], "The State", 0, strlen("The State"), 255);
							strmid(BizzInfo[bouse][bExtortion], "No-one", 0, strlen("No-one"), 255);
							SendClientMessage(i, 0xAA3333AAD, "- Ваш бизнес продан, за неуплату электроэнергии");
							BizzInfo[bouse][bTill] = 0;
							BizzInfo[bouse][b2Till] = 0;
							PlayerInfo[i][pPbiskey] = 255;
							format(string, sizeof(string), "Цена: %d\nБизнес продаётся",BizzInfo[bouse][bBuyPrice]);
							Update3DTextLabelText(BizzInfo[bouse][bLabel], 0xFFFF00AA, string);
						}
					}
					if(bouse >= 100)
					{
						if(SBizzInfo[bouse-100][sbMafia] !=0)
						{
							if(SBizzInfo[bouse-100][sbTill] > 5000)
							{
								SBizzInfo[bouse-100][sbTill] -= 1000;
								if(SBizzInfo[bouse-100][sbMafia] == 6)
								{
									MafiaBank[0][nYakuza] +=500;
								}
								if(SBizzInfo[bouse-100][sbMafia] == 14)
								{
									MafiaBank[0][nRm] +=500;
								}
								if(SBizzInfo[bouse-100][sbMafia] == 5)
								{
									MafiaBank[0][nLcn] +=500;
								}
							}
						}
						SBizzInfo[bouse-100][sbTill] -= 100;
						SBizzInfo[bouse-100][sbTill] += SBizzInfo[bouse-100][s2bTill];
						SBizzInfo[bouse-100][s2bTill] = 0;
						if(SBizzInfo[bouse-100][sbTill] <= 0)
						{
							SBizzInfo[bouse-100][sbLocked] = 1;
							SBizzInfo[bouse-100][sbOwned] = 0;
							SBizzInfo[bouse-100][sbProducts] = 0;
							strmid(SBizzInfo[bouse-100][sbOwner], "The State", 0, strlen("The State"), 255);
							SendClientMessage(i, 0xAA3333AAD, "- Ваша заправка продана, за неуплату электроэнергии");
							SBizzInfo[bouse-100][sbTill] = 0;
							SBizzInfo[bouse-100][s2bTill] = 0;
							PlayerInfo[i][pPbiskey] = 255;
							format(string, sizeof(string), "Цена: %d\nБизнес продаётся",SBizzInfo[bouse-100][sbBuyPrice]);
							Update3DTextLabelText(SBizzInfo[bouse-100][sbLabel], 0xFFFF00AA, string);
						}
					}
				}
				if(PlayerInfo[i][pAvtoMast] != 255)
				{
					new avtos = PlayerInfo[i][pAvtoMast];
					SendClientMessage(i, -1, "- Плата за аренду помещения мастерской: 500 рублей");
					AvtoInfo[avtos][abArenda] -=500;
					if(AvtoInfo[avtos][abArenda] <=0)
					{
						SendClientMessage(i, 0xAA3333AAD, "- Ваша мастерская была продана, за неуплату аренды помещения, деньги со счёта переведены в банк");
						AvtoInfo[avtos][abLocked] = 1;
						PlayerInfo[i][pBank] += AvtoInfo[avtos][abTill];
						AvtoInfo[avtos][abOwned] = 0;
						AvtoInfo[avtos][abTill] = 0;
						AvtoInfo[avtos][abZp] = 100;
						AvtoInfo[avtos][Rab] = 0;
						if(MehJob[i] == avtos)
						{
							MehJob[i] = 999;
						}
						strmid(AvtoInfo[avtos][abOwner], "The State", 0, strlen("The State"), 255);
						PlayerPlaySound(i, 1052, 0.0, 0.0, 0.0);
						PlayerInfo[i][pAvtoMast] = 255;
						PlayerInfo[i][pBank] += 255;
						PlayerInfo[i][pCash] += AvtoInfo[avtos][abArenda];
						format(string, sizeof(string), "Автомастерская: %s\nЦена: %d\nПродаётся",AvtoInfo[avtos][abMessage],AvtoInfo[avtos][abBuyPrice]);
						Update3DTextLabelText(AvtoInfo[avtos][abLabel], 0xFFFF00AA, string);
						OnPropUpdate();
						OnPlayerUpdateRL(i);
					}
				}
				if(PlayerInfo[i][pPhousekey] != 255)
				{
				    new str;
					switch(HouseInfo[house][hKlass])
					{
						case 0, 4: str = 50;
						case 1, 3: str = 100;
						case 2: str = 150;
					}
					format(string, 90, "- Плата за коммунальные услуги: %d руб., домашний счёт: %d руб.", str, HouseInfo[house][hTakings]);
					SendClientMessage(i, -1, string);
					if(HouseInfo[house][hTakings] <= 0)
					{
						PlayerInfo[i][pCash] +=HouseInfo[house][hValue];
						HouseInfo[house][hHel] = 0;
						HouseInfo[house][hLock] = 1;
						HouseInfo[house][hOwned] = 0;
						HouseInfo[house][hStyle] = 0;
						HouseInfo[house][hSost] = 0;
						strmid(HouseInfo[house][hOwner], "The State", 0, strlen("The State"), 255);
						SendClientMessage(i, 0xAA3333AAD, "- Ваш дом продан, за неуплату электроэнергии!");
						HouseInfo[house][hTakings] = 0;
						PlayerInfo[i][pPhousekey] = 255;
						SetPlayerInterior(i,0);
						SetPlayerVirtualWorld(i, 0);
						SetPlayerPos(i,HouseInfo[house][hEntrancex],HouseInfo[house][hEntrancey],HouseInfo[house][hEntrancez]);
						DestroyVehicle(caridhouse[i]);
						PlayerInfo[i][pInt] = 0;
					}
				}*/
				if(PlayerInfo[i][pVIP] >=1) { SendClientMessage(i, 0xFFA500AA,"--------=== [ КЛИЕНТ БАНКА SA ] ===--------"); }
				else { SendClientMessage(i,0xB4B5B7FF,"====================================="); }
			}
			PlayerInfo[i][pExp] ++;
			new exp = PlayerInfo[i][pExp];
			new nxtlevel = PlayerInfo[i][pLevel]+1;
			new expamount = nxtlevel*4;
			if(exp == expamount)
			{
				PlayerInfo[i][pLevel] += 1;
				PlayerInfo[i][pExp] = 0;
				SendClientMessage(i, 0x7FB151FF, "Поздравляем, Ваш lvl повысился!");
				DollahScoreUpdate();
			}
			PlayerInfo[i][pPayCheck] = 0;
			PlayerInfo[i][pPayDay]++;
			seans[i] = 0;
			if(Login[i]) SaveAccount(i);
//			BuyHouse();
		}
/*		for(new h = 0; h < sizeof(BizzInfo); h++)
		{
			if(BizzInfo[h][bOwned] == 0)
			{
				BizzInfo[h][bProducts] = 50000;
				BizzInfo[h][bCena] = 250;
			}
		}
		for(new h = 0; h < sizeof(SBizzInfo); h++)
		{
			if(SBizzInfo[h][sbOwned] == 0)
			{
				SBizzInfo[h][sbProducts] = 50000;
				SBizzInfo[h][sbCena] = 2000;
			}
		}*/
		//PlayerInfo[i][pExpTime] = 0;
	}
	//сохранение банков и тп
	return true;
}
stock AFKProcessor()
{
    new Float:AFKCoords[6];
	foreach(new i : Player)
	{
 		if(!IsPlayerConnected(i)) return 1;
	    GetPlayerPos(i,AFKCoords[0],AFKCoords[1],AFKCoords[2]);
     	GetPlayerCameraPos(i, AFKCoords[3], AFKCoords[4], AFKCoords[5]) ;
		if(AFKCoords[0] == PlayerEx[i][AFK_Coord] && AFKCoords[3] == PlayerEx[i][AFK_Coords])
		{
			PlayerEx[i][VarEx]++;
			PlayerEx[i][Var]++;
		}
		else
		{
		    PlayerEx[i][VarEx] = 0;
		}
		PlayerEx[i][AFK_Coord] = AFKCoords[0];
		PlayerEx[i][AFK_Coords] = AFKCoords[3];

		if(PlayerInfo[i][pAdmin] < 2)
		{
			if(PlayerEx[i][VarEx] > 14400)
			{
				SendClientMessage(i,0xFF0000AA,"[AFK]: Вы были отсоеденены от сервера");
				KickFix(i);
				PlayerEx[i][VarEx] = 0;
			}
		}
		if(PlayerEx[i][Var] > 1)
		{
		    PlayerEx[i][VarEx] = 0;
		}
		if((PlayerEx[i][Var] > 1 || PlayerEx[i][VarEx] > 60) && PlayerInfo[i][pAdmin] == 0)
		{
		    if(180 > PlayerEx[i][VarEx] > 60 || 180 > PlayerEx[i][Var] > 1)
		    {
				SetPlayerChatBubble(i, "кимарит", 0x33AA33AA, 30.0, 1200);
		    }
		    if(300 > PlayerEx[i][VarEx] >= 180 || 300 > PlayerEx[i][Var] >= 180)
		    {
				SetPlayerChatBubble(i, "дремлет", 0x33AA33AA, 30.0, 1200);
		    }
		    if(PlayerEx[i][VarEx] >= 300 || PlayerEx[i][Var] >= 300)
		    {
				SetPlayerChatBubble(i, "спит", 0x33AA33AA, 30.0, 1200);
		    }
		}
		if((PlayerEx[i][Var] > 1 || PlayerEx[i][VarEx] > 30) && PlayerInfo[i][pAdmin] >= 1 && PlayerInfo[i][pAdmin] < 5)
		{
		    new stringF[25];
			format(stringF,sizeof(stringF),"[AFK] %s",ConvertSeconds(PlayerEx[i][VarEx]));
			SetPlayerChatBubble(i, stringF, 0x33AA33AA, 30.0, 1200);
		}
		if((PlayerEx[i][Var] > 1 || PlayerEx[i][VarEx] > 30) && PlayerInfo[i][pAdmin] >= 5)
		{
			SetPlayerChatBubble(i, "Не будить", 0xFF0000AA, 30.0, 1200);
		}
	}
	return 1;
}
stock bigstr(const string[], &idx)
{
	new length = strlen(string);
	while ((idx < length) && (string[idx] <= ' '))
	{
		idx++;
	}
	new offset = idx;
	new result[128];
	while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
	{
		result[idx - offset] = string[idx];
		idx++;
	}
	result[idx - offset] = EOS;
	return result;
}
stock ChosePlayerSkin(playerid)
{
	SetPlayerHealth(playerid,100);
	SendClientMessage(playerid, 0xBC2C2CFF, "Используйте клавишу 'Быстрый бег'(пробел по умолчанию)");
	SendClientMessage(playerid, 0xBC2C2CFF, "Используйте клавишу 'Вверх,вниз'(W,S по умолчанию)");
	if(PlayerInfo[playerid][pSex] == 1)
	{
		SetPlayerPos(playerid, 222.3489,-8.5845,1002.2109);
		SetPlayerFacingAngle(playerid, 266.7302);
		SetPlayerCameraPos(playerid,225.3489,-8.5845,1002.2109);
		SetPlayerCameraLookAt(playerid,222.3489,-8.5845,1002.2109);
		SetPlayerVirtualWorld(playerid,playerid+1000);
		PlayerInfo[playerid][pChar] = 230;
		PlayerInfo[playerid][pModel] = 255;
		PlayerInfo[playerid][pMember] = 0;
		PlayerInfo[playerid][pLeader] = 0;
		PlayerInfo[playerid][pRank] = 1;
		SetPlayerInterior(playerid,5);
		SelectCharPlace[playerid] = 1;
		ShowMenuForPlayer(bomj[0],playerid);
		ChosenSkin[playerid] = 230;
		TogglePlayerControllable(playerid, 0);
		SetPlayerSkin(playerid,PlayerInfo[playerid][pChar]);
		PlayerInfo[playerid][pChar] = ChosenSkin[playerid];
		return true;
	}
	if(PlayerInfo[playerid][pSex] == 2)
	{
		SetPlayerPos(playerid, 222.3489,-8.5845,1002.2109);
		SetPlayerFacingAngle(playerid, 266.7302);
		SetPlayerCameraPos(playerid,225.3489,-8.5845,1002.2109);
		SetPlayerCameraLookAt(playerid,222.3489,-8.5845,1002.2109);
		SetPlayerVirtualWorld(playerid,playerid+1000);
		PlayerInfo[playerid][pChar] = 90;
		PlayerInfo[playerid][pModel] = 255;
		PlayerInfo[playerid][pMember] = 0;
		PlayerInfo[playerid][pLeader] = 0;
		PlayerInfo[playerid][pRank] = 1;
		ChosenSkin[playerid] = 90;
		SetPlayerInterior(playerid,5);
		SelectCharPlace[playerid] = 1;
		ShowMenuForPlayer(bomj[1],playerid);
		TogglePlayerControllable(playerid, 0);
		SetPlayerSkin(playerid,PlayerInfo[playerid][pChar]);
		PlayerInfo[playerid][pChar] = ChosenSkin[playerid];
		return true;
	}
	return true;
}
stock KickFix(playerid) return SetTimerEx("KickEx", 300, 0, "i", playerid);
publics KickEx(playerid)
{
	if(PlayerInfo[playerid][pAdmin] >= 6) return SendClientMessage(playerid,-1,"Вы кикнуты :)");
 	return Kick(playerid);
} 
stock DollahScoreUpdate()
{
	new LevScore;
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			LevScore = PlayerInfo[i][pLevel];
			SetPlayerScore(i, LevScore);
		}
	}
	return 1;
}
stock SaveAccount(i)
{
		new hp = floatround(PlayerInfo[i][pHP]);
		mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET");
		mysql_format(MySql_Base, QUERY, sizeof(QUERY), "%s `Level` = '%d', `Admin` = '%d', `Dostup` = '%s',`Char` = '%d',`Model` = '%d',`Leader` = '%d',`Member` = '%d',`Rank` = '%d',`Mute` = '%d',`HP` = '%d',`PayDay` = '%d',`Zvezdi` = %d,`Car` = '%d', `Fuelcar` = '%d',`Jailed` = '%d',`JailTime` = '%d',`KongfuSkill` = '%d',`BoxSkill` = '%d',`KickboxSkill` = '%d',",
		QUERY,PlayerInfo[i][pLevel], PlayerInfo[i][pAdmin], PlayerInfo[i][pDostup],PlayerInfo[i][pChar],PlayerInfo[i][pModel],PlayerInfo[i][pLeader],PlayerInfo[i][pMember],PlayerInfo[i][pRank],PlayerInfo[i][pMute],hp,PlayerInfo[i][pPayDay],PlayerInfo[i][pZvezdi],PlayerInfo[i][pCar],PlayerInfo[i][pFuelcar],PlayerInfo[i][pJailed],PlayerInfo[i][pJailTime],PlayerInfo[i][pKongfuSkill],PlayerInfo[i][pBoxSkill],PlayerInfo[i][pKickboxSkill]);

		mysql_format(MySql_Base, QUERY, sizeof(QUERY), "%s `Slot1` = '%d',`Slot2` = '%d',`Slot3` = '%d',`Slot4` = '%d',`Slot5` = '%d',`Slot6` = '%d',`Slot7` = '%d',`Slot8` = '%d',`Slot9` = '%d',`Slot10` = '%d',`Slot11` = '%d',`Slot12` = '%d',`Slot13` = '%d',`Warns` = '%d',`PhoneBook` = '%d',",
        QUERY,PlayerInfo[i][pSlot][0],PlayerInfo[i][pSlot][1],PlayerInfo[i][pSlot][2],PlayerInfo[i][pSlot][3],PlayerInfo[i][pSlot][4],PlayerInfo[i][pSlot][5],PlayerInfo[i][pSlot][6],PlayerInfo[i][pSlot][7],PlayerInfo[i][pSlot][8],PlayerInfo[i][pSlot][9],PlayerInfo[i][pSlot][10],PlayerInfo[i][pSlot][11],PlayerInfo[i][pSlot][12],PlayerInfo[i][pWarns],PlayerInfo[i][pPhoneBook]);

		mysql_format(MySql_Base, QUERY, sizeof(QUERY), "%s `Slotammo1` = '%d',`Slotammo2` = '%d',`Slotammo3` = '%d',`Slotammo4` = '%d',`Slotammo5` = '%d',`Slotammo6` = '%d',`Slotammo7` = '%d',`Slotammo8` = '%d',`Slotammo9` = '%d',`Slotammo10` = '%d',`Slotammo11` = '%d',`Slotammo12` = '%d',`Slotammo13` = '%d',`Grib` = '%d',`Zvonok` = '%d',",
        QUERY,PlayerInfo[i][pSlotammo][1],PlayerInfo[i][pSlotammo][1],PlayerInfo[i][pSlotammo][2],PlayerInfo[i][pSlotammo][3],PlayerInfo[i][pSlotammo][4],PlayerInfo[i][pSlotammo][5],PlayerInfo[i][pSlotammo][6],PlayerInfo[i][pSlotammo][7],PlayerInfo[i][pSlotammo][8],PlayerInfo[i][pSlotammo][9],PlayerInfo[i][pSlotammo][10],PlayerInfo[i][pSlotammo][11],PlayerInfo[i][pSlotammo][12],PlayerInfo[i][pGrib],PlayerInfo[i][pZvonok]);

		mysql_format(MySql_Base, QUERY, sizeof(QUERY), "%s `Job` = '%d',`Exp` = '%d',`Cash` = '%d',`Bank` = '%d',`PayCheck` = '%d',`VIP` = '%d',`Drugs` = '%d',`NarcoZavisimost` = '%d',`Kills` = '%d',`WantedDeaths` = '%d',`Arrested` = '%d',`Zakonp` = '%d',`Krisha` = '%d',`Dolg` = '%d',`Voennik` = '%d',`VodPrava` = '%d',`FlyLic` = '%d',`BoatLic` = '%d',`GunLic` = '%d',`BizLic` = '%d',`Mobile` = '%d'",
        QUERY,PlayerInfo[i][pJob],PlayerInfo[i][pExp],PlayerInfo[i][pCash],PlayerInfo[i][pBank],PlayerInfo[i][pPayCheck],PlayerInfo[i][pVIP],PlayerInfo[i][pDrugs],PlayerInfo[i][pNarcoZavisimost],PlayerInfo[i][pKills],PlayerInfo[i][pWantedDeaths],PlayerInfo[i][pArrested],PlayerInfo[i][pZakonp],PlayerInfo[i][pKrisha],PlayerInfo[i][pDolg],PlayerInfo[i][pVoennik],PlayerInfo[i][pVodPrava],PlayerInfo[i][pFlyLic],PlayerInfo[i][pBoatLic],PlayerInfo[i][pGunLic],PlayerInfo[i][pBizLic],PlayerInfo[i][pMobile]);

		mysql_format(MySql_Base, QUERY, sizeof(QUERY), "%s WHERE `Name` = '%s' LIMIT 1", QUERY, GN(i));
		mysql_tquery(MySql_Base, QUERY, "", "");
		return 1;
}
stock SaveMySQL(idx, i = 0)
{
    //new temp[0x9e];
	switch(idx)
	{
	    case 0:
	    {
	        SaveMySQL(1);
	        SaveMySQL(2);
	        SaveMySQL(3);
	        SaveMySQL(4);
	        SaveMySQL(5);
	        SaveMySQL(6);
	        SaveMySQL(7);
	        SaveMySQL(8);
	        SaveMySQL(9);
	        SaveMySQL(10);
	        SaveMySQL(11);
	    }
		case 1:
		{
		    SaveAccount(i);
		}
	    case 2:
	    {	
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `fracbank` SET ");
		    format(QUERY,sizeof(QUERY),"%s `fLsnews`= '%d',",QUERY,FracBank[0][fLsnews]);
		    format(QUERY,sizeof(QUERY),"%s `fSfnews`= '%d',",QUERY,FracBank[0][fSfnews]);
		    format(QUERY,sizeof(QUERY),"%s `fLvnews`= '%d',",QUERY,FracBank[0][fLvnews]);
		    format(QUERY,sizeof(QUERY),"%s `fBallas`= '%d',",QUERY,FracBank[0][fBallas]);
		    format(QUERY,sizeof(QUERY),"%s `fVagos`= '%d',",QUERY,FracBank[0][fVagos]);
		    format(QUERY,sizeof(QUERY),"%s `fGrove`= '%d',",QUERY,FracBank[0][fGrove]);
		    format(QUERY,sizeof(QUERY),"%s `fAztek`= '%d',",QUERY,FracBank[0][fAztek]);
		    format(QUERY,sizeof(QUERY),"%s `fRifa`= '%d',",QUERY,FracBank[0][fRifa]);
		    format(QUERY,sizeof(QUERY),"%s `fKazna`= '%d',",QUERY,FracBank[0][fKazna]);
		    format(QUERY,sizeof(QUERY),"%s `fNalog`= '%d',",QUERY,FracBank[0][fNalog]);
		    format(QUERY,sizeof(QUERY),"%s `fMCLS`= '%d',",QUERY,FracBank[0][fMCLS]);
		    format(QUERY,sizeof(QUERY),"%s `fMCSF`= '%d', ",QUERY,FracBank[0][fMCSF]);
		    format(QUERY,sizeof(QUERY),"%s `fMCprice`= '%d', ",QUERY,FracBank[0][fMCprice]);
		    format(QUERY,sizeof(QUERY),"%s `fmatslva`= '%d', ",QUERY,FracBank[0][fmatslva]);
		    format(QUERY,sizeof(QUERY),"%s `fmatssfa`= '%d', ",QUERY,FracBank[0][fmatssfa]);
		    format(QUERY,sizeof(QUERY),"%s `fmatslspd`= '%d', ",QUERY,FracBank[0][fmatslspd]);
		    format(QUERY,sizeof(QUERY),"%s `fmatssfpd`= '%d', ",QUERY,FracBank[0][fmatssfpd]);
		    format(QUERY,sizeof(QUERY),"%s `fmatslvpd`= '%d', ",QUERY,FracBank[0][fmatslvpd]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsfbi`= '%d', ",QUERY,FracBank[0][fmatsfbi]);
		    format(QUERY,sizeof(QUERY),"%s `fmatslcn`= '%d', ",QUERY,FracBank[0][fmatslcn]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsrm`= '%d', ",QUERY,FracBank[0][fmatsrm]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsyakuza`= '%d', ",QUERY,FracBank[0][fmatsyakuza]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsballas`= '%d', ",QUERY,FracBank[0][fmatsballas]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsgrove`= '%d', ",QUERY,FracBank[0][fmatsgrove]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsrifa`= '%d', ",QUERY,FracBank[0][fmatsrifa]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsaztecas`= '%d', ",QUERY,FracBank[0][fmatsaztecas]);
		    format(QUERY,sizeof(QUERY),"%s `fmatsvagos`= '%d'",QUERY,FracBank[0][fmatsvagos]);
		    mysql_tquery(MySql_Base, QUERY, "", "");
		}/*
		case 3:
		{
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_CASINO"` SET ");
		    format(temp,sizeof(temp),"`ID`= '%i',",CasinoInfo[i][caID]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Name`= '%s',",CasinoInfo[i][caName]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Mafia`= '%i',",CasinoInfo[i][caMafia]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Manager`= '%s',",CasinoInfo[i][caManager]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Manager2`= '%s',",CasinoInfo[i][caManager2]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Manager3`= '%s',",CasinoInfo[i][caManager3]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie`= '%s',",CasinoInfo[i][caKrupie]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie2`= '%s',",CasinoInfo[i][caKrupie2]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie3`= '%s',",CasinoInfo[i][caKrupie3]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie4`= '%s',",CasinoInfo[i][caKrupie4]),				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie5`= '%s',",CasinoInfo[i][caKrupie5]),				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie6`= '%s',",CasinoInfo[i][caKrupie6]),				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie7`= '%s',",CasinoInfo[i][caKrupie7]),				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie8`= '%s',",CasinoInfo[i][caKrupie8]),				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie9`= '%s',",CasinoInfo[i][caKrupie9]),				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`Krupie10`= '%s'",CasinoInfo[i][caKrupie10]),				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE ID = '%i'",CasinoInfo[i][caID]),					strcat(QUERY,temp,sizeof(QUERY));
    		mysql_function_query(MySql_Base, QUERY, true, "", "");
		}
		case 4:
		{
		    format(WorkshopInfo[i][wAuctions],128,"%i, %i, %i, %i, %i",WorkshopInfo[i][wAuction][0], WorkshopInfo[i][wAuction][1], WorkshopInfo[i][wAuction][2], WorkshopInfo[i][wAuction][3], WorkshopInfo[i][wAuction][4]);
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_WORKSHOPS"` SET ");
		    format(temp,sizeof(temp),"`owner`= '%s',",WorkshopInfo[i][wOwner]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bank`= '%i',",WorkshopInfo[i][wBank]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`landtax`= '%i',",WorkshopInfo[i][wLandTax]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`prods`= '%i',",WorkshopInfo[i][wProds]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`priceprods`= '%i',",WorkshopInfo[i][wPriceProds]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`zp`= '%i',",WorkshopInfo[i][wZp]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`deputy_one`= '%s',",WorkshopInfo[i][wDeputy1]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`deputy_two`= '%s',",WorkshopInfo[i][wDeputy2]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`deputy_three`= '%s',",WorkshopInfo[i][wDeputy3]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`mechanic_one`= '%s',",WorkshopInfo[i][wMechanic1]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`mechanic_two`= '%s',",WorkshopInfo[i][wMechanic2]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`mechanic_three`= '%s',",WorkshopInfo[i][wMechanic3]), 	strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`mechanic_four`= '%s',",WorkshopInfo[i][wMechanic4]), 	strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`mechanic_five`= '%s',",WorkshopInfo[i][wMechanic5]), 	strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`auctions`= '%s',",WorkshopInfo[i][wAuctions]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`auction_name`= '%s'",WorkshopInfo[i][wAuctionName]), 	strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE id = '%i'",WorkshopInfo[i][wID]),					strcat(QUERY,temp,sizeof(QUERY));
    		mysql_function_query(MySql_Base, QUERY, true, "", "");
		}
		case 5:
		{
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_BIZZ"` SET ");
		    format(temp,sizeof(temp),"`bOwner`= '%s',",BizzInfo[i][bOwner]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bMessage`= '%s',",BizzInfo[i][bMessage]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bEntranceX`= '%f',",BizzInfo[i][bEntranceX]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bEntranceY`= '%f',",BizzInfo[i][bEntranceY]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bEntranceZ`= '%f',",BizzInfo[i][bEntranceZ]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bExitX`= '%f',",BizzInfo[i][bExitX]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bExitY`= '%f',",BizzInfo[i][bExitY]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bExitZ`= '%f',",BizzInfo[i][bExitZ]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bBuyPrice`= '%i',",BizzInfo[i][bBuyPrice]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bEntranceCost`= '%i',",BizzInfo[i][bEntranceCost]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bTill`= '%i',",BizzInfo[i][bTill]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bLocked`= '%i',",BizzInfo[i][bLocked]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bInterior`= '%i',",BizzInfo[i][bInterior]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bProducts`= '%i',",BizzInfo[i][bProducts]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bPrice`= '%i',",BizzInfo[i][bPrice]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bBarX`= '%f',",BizzInfo[i][bBarX]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bBarY`= '%f',",BizzInfo[i][bBarY]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bBarZ`= '%f',",BizzInfo[i][bBarZ]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bMafia`= '%i',",BizzInfo[i][bMafia]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bType`= '%i',",BizzInfo[i][bType]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bLockTime`= '%i',",BizzInfo[i][bLockTime]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bLicense`= '%i',",BizzInfo[i][bLicense]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bStavka`= '%i',",BizzInfo[i][bStavka]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bNameStavka`= '%s',",BizzInfo[i][bNameStavka]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bLastStavka`= '%i',",BizzInfo[i][bLastStavka]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bTimeStavka`= '%i',",BizzInfo[i][bTimeStavka]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bMinStavka`= '%i',",BizzInfo[i][bMinStavka]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bVirtualWorld`= '%i',",BizzInfo[i][bVirtualWorld]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bLandTax`= '%i',",BizzInfo[i][bLandTax]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bProdPrice`= '%i'",BizzInfo[i][bProdPrice]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE bID = '%i'",BizzInfo[i][bID]),						strcat(QUERY,temp,sizeof(QUERY));
    		mysql_function_query(MySql_Base, QUERY, true, "", "");
		}
		case 6:
		{
		    format(HouseInfo[i][hSafes],50,"%i, %i, %i, %i, %i ,%i, %i, %i, %i, %i, %i",
			HouseInfo[i][hSafe][0], HouseInfo[i][hSafe][1], HouseInfo[i][hSafe][2], HouseInfo[i][hSafe][3], HouseInfo[i][hSafe][4],
			HouseInfo[i][hSafe][5], HouseInfo[i][hSafe][6], HouseInfo[i][hSafe][7], HouseInfo[i][hSafe][8], HouseInfo[i][hSafe][9], HouseInfo[i][hSafe][10]);
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_HOUSE"` SET ");
		    format(temp,sizeof(temp),"`hEntrancex`= '%f',",HouseInfo[i][hEntrancex]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hEntrancey`= '%f',",HouseInfo[i][hEntrancey]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hEntrancez`= '%f',",HouseInfo[i][hEntrancez]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hExitx`= '%f',",HouseInfo[i][hExitx]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hExity`= '%f',",HouseInfo[i][hExity]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hExitz`= '%f',",HouseInfo[i][hExitz]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hOwner`= '%s',",HouseInfo[i][hOwner]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hValue`= '%i',",HouseInfo[i][hValue]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hTakings`= '%i',",HouseInfo[i][hTakings]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hHel`= '%i',",HouseInfo[i][hHel]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hInt`= '%i',",HouseInfo[i][hInt]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hLock`= '%i',",HouseInfo[i][hLock]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hVec`= '%i',",HouseInfo[i][hVec]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hVcol1`= '%i',",HouseInfo[i][hVcol1]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hVcol2`= '%i',",HouseInfo[i][hVcol2]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hKlass`= '%i',",HouseInfo[i][hKlass]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hVehSost`= '%i',",HouseInfo[i][hVehSost]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hCarx`= '%f',",HouseInfo[i][hCarx]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hCary`= '%f',",HouseInfo[i][hCary]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hCarz`= '%f',",HouseInfo[i][hCarz]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hCarc`= '%f',",HouseInfo[i][hCarc]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`hSafes`= '%s'",HouseInfo[i][hSafes]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE hID = '%i'",HouseInfo[i][hID]),					strcat(QUERY,temp,sizeof(QUERY));
            mysql_function_query(MySql_Base, QUERY, true, "", "");
	    }
	    case 7:
	    {
	        mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_KVARTIRS"` SET ");
	    	format(temp,sizeof(temp),"`pXpic`= '%f',",kvartinfo[i][pXpic]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`pYpic`= '%f',",kvartinfo[i][pYpic]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`pZpic`= '%f',",kvartinfo[i][pZpic]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vladelec`= '%s',",kvartinfo[i][vladelec]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`lock`= '%i',",kvartinfo[i][lock]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`kworld`= '%i',",kvartinfo[i][kworld]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`aptek`= '%i',",kvartinfo[i][aptek]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`plata`= '%i',",kvartinfo[i][plata]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`virtmir`= '%i'",kvartinfo[i][virtmir]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE kid = '%i'",kvartinfo[i][kid]),					strcat(QUERY,temp,sizeof(QUERY));
            mysql_function_query(MySql_Base, QUERY, true, "", "");
		}
		case 8:
		{
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_PODEZDS"` SET ");
		    format(temp,sizeof(temp),"`podPicX`= '%f',",PodeezdInfo[i][podPicX]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`podPicY`= '%f',",PodeezdInfo[i][podPicY]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`podPicZ`= '%f',",PodeezdInfo[i][podPicZ]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`podEtazi`= '%i',",PodeezdInfo[i][podEtazi]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`carX`= '%f',",PodeezdInfo[i][carX]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`carY`= '%f',",PodeezdInfo[i][carY]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`carZ`= '%f',",PodeezdInfo[i][carZ]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`carC`= '%f'",PodeezdInfo[i][carC]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE pid = '%i'",PodeezdInfo[i][pid]),					strcat(QUERY,temp,sizeof(QUERY));
            mysql_function_query(MySql_Base, QUERY, true, "", "");
		}
		case 9:
		{
		    mysql_format(MySql_Base,QUERY, 500, "UPDATE "TABLE_ATM" SET `id` = '%i', `ax` = '%f', `ay` = '%f', `az` = '%f', `arz` = '%f' WHERE id = %i",
			ATMInfo[i][aid], ATMInfo[i][aX],ATMInfo[i][aY],ATMInfo[i][aZ],ATMInfo[i][arZ], ATMInfo[i][aid]);
			mysql_function_query(MySql_Base, QUERY, true, "", "");
		}
		case 10:
		{
		    format(FarmInfo[i][fAuctions],64,"%i, %i, %i, %i, %i",FarmInfo[i][fAuction][0], FarmInfo[i][fAuction][1], FarmInfo[i][fAuction][2], FarmInfo[i][fAuction][3], FarmInfo[i][fAuction][4]);
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_FARM"` SET ");
		    format(temp,sizeof(temp),"`owner`= '%s',",FarmInfo[i][fOwner]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`bank`= '%i',",FarmInfo[i][fBank]), 						strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`landtax`= '%i',",FarmInfo[i][fLandTax]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`zp`= '%i',",FarmInfo[i][fZp]), 							strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`grain_price`= '%i',",FarmInfo[i][fGrain_Price]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`grain`= '%i',",FarmInfo[i][fGrain]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`grain_sown`= '%i',",FarmInfo[i][fGrain_Sown]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`prods_selling`= '%i',",FarmInfo[i][fProds_Selling]), 	strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`prods`= '%i',",FarmInfo[i][fProds]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`prods_price`= '%i',",FarmInfo[i][fProds_Price]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`deputy_1`= '%s',",FarmInfo[i][fDeputy_1]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`deputy_2`= '%s',",FarmInfo[i][fDeputy_2]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`deputy_3`= '%s',",FarmInfo[i][fDeputy_3]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`farmer_1`= '%s',",FarmInfo[i][fFarmer_1]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`farmer_2`= '%s',",FarmInfo[i][fFarmer_2]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`farmer_3`= '%s',",FarmInfo[i][fFarmer_3]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`farmer_4`= '%s',",FarmInfo[i][fFarmer_4]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`farmer_5`= '%s',",FarmInfo[i][fFarmer_5]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`auctions`= '%s',",FarmInfo[i][fAuctions]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`auction_name`= '%s'",FarmInfo[i][fAuctionName]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE id = '%i'",FarmInfo[i][fID]),						strcat(QUERY,temp,sizeof(QUERY));
            mysql_function_query(MySql_Base, QUERY, true, "", "");
		}
		case 11:
		{
		    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `"TABLE_CARS"` SET ");
		    format(temp,sizeof(temp),"`model`= '%i',",CarInfo[i][carModel][0]), 				strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`color_one`= '%i',",CarInfo[i][carColor_one][0]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`color_two`= '%i',",CarInfo[i][carColor_two][0]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`percent`= '%i',",CarInfo[i][carPercent][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`fuel`= '%f',",CarInfo[i][carFuel][0]), 					strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_1`= '%i',",CarInfo[i][carVehcom_1][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_2`= '%i',",CarInfo[i][carVehcom_2][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_3`= '%i',",CarInfo[i][carVehcom_3][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_4`= '%i',",CarInfo[i][carVehcom_4][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_5`= '%i',",CarInfo[i][carVehcom_5][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_6`= '%i',",CarInfo[i][carVehcom_6][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_7`= '%i',",CarInfo[i][carVehcom_7][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_8`= '%i',",CarInfo[i][carVehcom_8][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_9`= '%i',",CarInfo[i][carVehcom_9][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_10`= '%i',",CarInfo[i][carVehcom_10][0]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_11`= '%i',",CarInfo[i][carVehcom_11][0]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_12`= '%i',",CarInfo[i][carVehcom_12][0]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_13`= '%i',",CarInfo[i][carVehcom_13][0]), 		strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp),"`vehcom_14`= '%i'",CarInfo[i][carVehcom_14][0]), 			strcat(QUERY,temp,sizeof(QUERY));
		    format(temp,sizeof(temp)," WHERE id = '%i'",CarInfo[i][carID][0]),					strcat(QUERY,temp,sizeof(QUERY));
            mysql_function_query(MySql_Base, QUERY, true, "", "");
		}*/
	}
	return 1;
}
publics OnMySQL_QUERY(idx, playerid, str[])
{
    new r, f;
    cache_get_data(r, f);
	switch(idx)
	{
		case 0:
		{
		    if(!r)
	        {
	            if(GetPVarInt(playerid,"Tut") == 1)
	            {
	            	DeletePVar(playerid,"Tut");
				}
				else
				{
					if(GetPVarInt(playerid, "wrongPass") == 2) return SendClientMessage(playerid,0xFF6347AA,"Неверный пароль. Используйте /q для выхода."), KickFix(playerid);
					SetPVarInt(playerid, "wrongPass", GetPVarInt(playerid, "wrongPass")+1);
					format(QUERY,sizeof(QUERY), "{FF6347}Внимание!Вы ввели неверный пароль!\n\tУ вас осталось (%i) попытки\nПосле вы будете на время забанены",3-GetPVarInt(playerid, "wrongPass"));
					SPD(playerid,1,DIALOG_STYLE_MSGBOX, "Ошибка!",QUERY, "Повтор", "Выйти");
					PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
					return true;
				}
			}
			new hp;
			DeletePVar(playerid,"time_logged");
			PlayerInfo[playerid][pID] = cache_get_field_content_int(0, "ID", MySql_Base);
		    PlayerInfo[playerid][pLevel] = cache_get_field_content_int(0, "Level", MySql_Base);
		    PlayerInfo[playerid][pExp] = cache_get_field_content_int(0, "Exp", MySql_Base);
		    hp = cache_get_field_content_int(0, "HP", MySql_Base);
		    PlayerInfo[playerid][pAdmin] = cache_get_field_content_int(0, "Admin", MySql_Base);
		    cache_get_field_content(0,"Dostup",PlayerInfo[playerid][pDostup],MySql_Base,33);
		    PlayerInfo[playerid][pSex] = cache_get_field_content_int(0, "Sex", MySql_Base);
		    PlayerInfo[playerid][pChar] = cache_get_field_content_int(0, "Char", MySql_Base);
		    PlayerInfo[playerid][pModel] = cache_get_field_content_int(0, "Model", MySql_Base);
		    PlayerInfo[playerid][pLeader] = cache_get_field_content_int(0, "Leader", MySql_Base);
		    PlayerInfo[playerid][pMember] = cache_get_field_content_int(0, "Member", MySql_Base);
		    PlayerInfo[playerid][pRank] = cache_get_field_content_int(0, "Rank", MySql_Base);
		    PlayerInfo[playerid][pCash] = cache_get_field_content_int(0, "Cash", MySql_Base);
		    PlayerInfo[playerid][pBank] = cache_get_field_content_int(0, "Bank", MySql_Base);
		    PlayerInfo[playerid][pVIP] = cache_get_field_content_int(0, "VIP", MySql_Base);
		    PlayerInfo[playerid][pVoennik] = cache_get_field_content_int(0, "Voennik", MySql_Base);
		    PlayerInfo[playerid][pGrib] = cache_get_field_content_int(0, "Grib", MySql_Base);
		    PlayerInfo[playerid][pPayCheck] = cache_get_field_content_int(0, "PayCheck", MySql_Base);
		    PlayerInfo[playerid][pDrugs] = cache_get_field_content_int(0, "Drugs", MySql_Base);
		    PlayerInfo[playerid][pNarcoZavisimost] = cache_get_field_content_int(0, "NarcoZavisimost", MySql_Base);
		    PlayerInfo[playerid][pKills] = cache_get_field_content_int(0, "Kills", MySql_Base);
		    PlayerInfo[playerid][pWantedDeaths] = cache_get_field_content_int(0, "WantedDeaths", MySql_Base);
		    PlayerInfo[playerid][pArrested] = cache_get_field_content_int(0, "Arrested", MySql_Base);
		    PlayerInfo[playerid][pZakonp] = cache_get_field_content_int(0, "Zakonp", MySql_Base);
		    PlayerInfo[playerid][pKrisha] = cache_get_field_content_int(0, "Krisha", MySql_Base);
		    PlayerInfo[playerid][pDolg] = cache_get_field_content_int(0, "Dolg", MySql_Base);
		    PlayerInfo[playerid][pVodPrava] = cache_get_field_content_int(0, "VodPrava", MySql_Base);
		    PlayerInfo[playerid][pFlyLic] = cache_get_field_content_int(0, "FlyLic", MySql_Base);
		    PlayerInfo[playerid][pBoatLic] = cache_get_field_content_int(0, "BoatLic", MySql_Base);
		    PlayerInfo[playerid][pGunLic] = cache_get_field_content_int(0, "GunLic", MySql_Base);
		    PlayerInfo[playerid][pBizLic] = cache_get_field_content_int(0, "BizLic", MySql_Base);
		    PlayerInfo[playerid][pMute] = cache_get_field_content_int(0, "Mute", MySql_Base);
		    PlayerInfo[playerid][pPhoneBook] = cache_get_field_content_int(0, "PhoneBook", MySql_Base);
		    PlayerInfo[playerid][pPnumber] = cache_get_field_content_int(0, "Pnumber", MySql_Base);
		    PlayerInfo[playerid][pZvonok] = cache_get_field_content_int(0, "Zvonok", MySql_Base);
		    PlayerInfo[playerid][pMobile] = cache_get_field_content_int(0, "Mobile", MySql_Base);
		    PlayerInfo[playerid][pCar] = cache_get_field_content_int(0, "Car", MySql_Base);
		    PlayerInfo[playerid][pFuelcar] = cache_get_field_content_int(0, "Fuelcar", MySql_Base);
		    PlayerInfo[playerid][pPayDay] = cache_get_field_content_int(0, "PayDay", MySql_Base);
		    PlayerInfo[playerid][pKongfuSkill] = cache_get_field_content_int(0, "KongfuSkill", MySql_Base);
		    PlayerInfo[playerid][pBoxSkill] = cache_get_field_content_int(0, "BoxSkill", MySql_Base);
		    PlayerInfo[playerid][pKickboxSkill] = cache_get_field_content_int(0, "KickboxSkill", MySql_Base);
		    PlayerInfo[playerid][pZvezdi] = cache_get_field_content_int(0, "Zvezdi", MySql_Base);
		    PlayerInfo[playerid][pJailed] = cache_get_field_content_int(0, "Jailed", MySql_Base);
		    PlayerInfo[playerid][pJailTime] = cache_get_field_content_int(0, "JailTime", MySql_Base);
		    PlayerInfo[playerid][pSlot][0] = cache_get_field_content_int(0, "Slot1", MySql_Base);
		    PlayerInfo[playerid][pSlot][1] = cache_get_field_content_int(0, "Slot2", MySql_Base);
		    PlayerInfo[playerid][pSlot][2] = cache_get_field_content_int(0, "Slot3", MySql_Base);
		    PlayerInfo[playerid][pSlot][3] = cache_get_field_content_int(0, "Slot4", MySql_Base);
		    PlayerInfo[playerid][pSlot][4] = cache_get_field_content_int(0, "Slot5", MySql_Base);
		    PlayerInfo[playerid][pSlot][5] = cache_get_field_content_int(0, "Slot6", MySql_Base);
		    PlayerInfo[playerid][pSlot][6] = cache_get_field_content_int(0, "Slot7", MySql_Base);
		    PlayerInfo[playerid][pSlot][7] = cache_get_field_content_int(0, "Slot8", MySql_Base);
		    PlayerInfo[playerid][pSlot][8] = cache_get_field_content_int(0, "Slot9", MySql_Base);
		    PlayerInfo[playerid][pSlot][9] = cache_get_field_content_int(0, "Slot10", MySql_Base);
		    PlayerInfo[playerid][pSlot][10] = cache_get_field_content_int(0, "Slot11", MySql_Base);
		    PlayerInfo[playerid][pSlot][11] = cache_get_field_content_int(0, "Slot12", MySql_Base);
		    PlayerInfo[playerid][pSlot][12] = cache_get_field_content_int(0, "Slot13", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][0] = cache_get_field_content_int(0, "Slotammo1", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][1] = cache_get_field_content_int(0, "Slotammo2", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][2] = cache_get_field_content_int(0, "Slotammo3", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][3] = cache_get_field_content_int(0, "Slotammo4", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][4] = cache_get_field_content_int(0, "Slotammo5", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][5] = cache_get_field_content_int(0, "Slotammo6", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][6] = cache_get_field_content_int(0, "Slotammo7", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][7] = cache_get_field_content_int(0, "Slotammo8", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][8] = cache_get_field_content_int(0, "Slotammo9", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][9] = cache_get_field_content_int(0, "Slotammo10", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][10] = cache_get_field_content_int(0, "Slotammo11", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][11] = cache_get_field_content_int(0, "Slotammo12", MySql_Base);
		    PlayerInfo[playerid][pSlotammo][12] = cache_get_field_content_int(0, "Slotammo13", MySql_Base);
		    PlayerInfo[playerid][pJob] = cache_get_field_content_int(0, "Job", MySql_Base);
		    PlayerInfo[playerid][pKeyip] = cache_get_field_content_int(0, "Keyip", MySql_Base);
	 		cache_get_field_content(0,"ALip",PlayerInfo[playerid][pALip],MySql_Base,15);
	 		cache_get_field_content(0,"DataReg",PlayerInfo[playerid][pDataReg],MySql_Base,11);
	 		cache_get_field_content(0,"PLip",PlayerInfo[playerid][pLip],MySql_Base,15);
	 		new ip[15];
			GetPlayerIp(playerid,ip,sizeof(ip));
			mysql_format(MySql_Base, QUERY, sizeof(QUERY), "UPDATE `accounts` SET `PLip` = '%s',`LDate` = '%d' WHERE `Name` = '%s' LIMIT 1",ip,Now(),GN(playerid));
			mysql_tquery(MySql_Base, QUERY, "", "");
			PlayerInfo[playerid][pLDate] = Now();
			mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `warn` WHERE `Name` = '%s'",GN(playerid));
			mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",6,playerid,"");
	 		PlayerInfo[playerid][pHP] = hp;
			Login[playerid] = true;
			SetPVarInt(playerid,"AntiFlood",gettime());
			SetPVarInt(playerid, "FDMFlood", gettime() -1);
			if(strcmp(ip,PlayerInfo[playerid][pLip]) && strlen(PlayerInfo[playerid][pKeyip]) >= 4)
			{
				SetPlayerInterior(playerid,0);
				SetPlayerFacingAngle(playerid, 266.9181);
				SetPlayerCameraPos(playerid,-251.6631,-1922.8071,24.1652);
				SetPlayerCameraLookAt(playerid,-251.6631,-1922.8071,24.1652);
				TogglePlayerControllable(playerid, 0);
				SPD(playerid,30,DIALOG_STYLE_INPUT,"Внимание!","Ваш IP адрес сменился, Введите Ваш ключ безопасности","Ок","Отмена");
				Login[playerid] = false;
				return 1;
			}
			PlayerEx[playerid][VarEx] = 0;
			new string[50];
			format(string, sizeof(string), "~w~Welcome ~n~~b~   %s", PlayerInfo[playerid][pName]);
			GameTextForPlayer(playerid, string, 5000, 1);
			SpawnPlayer(playerid);
			return 1;
		}
		case 1:
		{
		    if(r)
		    {
		    	SendClientMessage(playerid, 0xC21D00AA,"Ваш IP адрес заблокирован");
	    		return KickFix(playerid);
	    	}
	    	return 1;
		}
		case 2:
		{
		    if(r)
			{
				format(QUERY,sizeof(QUERY),"{FFFFFF}______________________________________\n\n  Добро пожаловать на {00AEFF}Sectum RolePlay{00AEFF}\n       Этот аккаунт {FF0000}зарегистрирован\n\n{00AEFF}Логин: {FFFFFF}%s\n{00AEFF}Введите пароль:\n{FFFFFF}______________________________________",GN(playerid));
				SPD(playerid,1,DIALOG_STYLE_PASSWORD, "Авторизация",QUERY, "Войти", "Отмена");
				SetPVarInt(playerid,"time_logged",120);
			}
			else
			{
				format(QUERY,sizeof(QUERY),"{FFFFFF}______________________________________\n\n  Добро пожаловать на {00AEFF}Sectum RolePlay{00AEFF}\n       {2BCB00}Регистрация {FFFFFF}нового персонажа\n\n{00AEFF}Логин: {FFFFFF}%s{00AEFF}\nВведите пароль:\n{FFFFFF}______________________________________",GN(playerid));
				SPD(playerid,2,DIALOG_STYLE_INPUT, "Регистрация",QUERY, "Готово", "Отмена");
			}
			return 1;
		}
		case 3:
		{
		    if(r)
			{
			    new unban,string[150],reason[30];
				unban = cache_get_field_content_int(0,"unBan",MySql_Base);
				cache_get_field_content(0,"Admin",string,MySql_Base,25);
				cache_get_field_content(0,"Text",reason,MySql_Base,25);
			    new year, month, day,hour,minute,second;
    			timestamp_to_date(unban,year,month,day,hour,minute,second);
    			if(unban == -1)
    			{
    			    format(string, sizeof(string), "Ваш аккаунт заблокирован навечно. Причина: %s(%s)",reason,string);
		    		SendClientMessage(playerid,COLOR_LIGHTRED,string);
		    		return KickFix(playerid);
    			}
    			else
				{
					format(string, sizeof(string), "Ваш аккаунт заблокирован. Дата разблокировки %02i/%02i/%02i. Причина: %s(%s)",day,month,year,reason,string);
		    		SendClientMessage(playerid,COLOR_LIGHTRED,string);
		    		return KickFix(playerid);
				}
			}
			mysql_format(MySql_Base,QUERY,sizeof(QUERY),"SELECT * FROM `accounts` WHERE `Name` = '%s' AND `Key`= '%s'",GN(playerid),PlayerInfo[playerid][pKey]);
			mysql_tquery(MySql_Base,QUERY,"OnMySQL_QUERY","iis",0,playerid,"");
			return 1;
		}
		case 4:
		{
		    new null[2] = 0,string[70];
		    if(r)
		    {
		        for(new x = 1; x <= r; x++)
		    	{
		    	    new unban;
   					unban = cache_get_field_content_int(x-1,"unBan",MySql_Base);
					cache_get_field_content(x-1,"Name",QUERY,MySql_Base,25);
					if(0 < unban < Now())
					{
					    mysql_format(MySql_Base,QUERY,sizeof(QUERY), "DELETE FROM `ban` WHERE `Name` = '%s'",QUERY);
    					mysql_tquery(MySql_Base,QUERY,"","");
    					null[0]++;
					}
					null[1]++;
				}
			}
			format(string,sizeof(string),"[System] Всего забаненых аккаунтов: %d. Разблокировано: %d",null[1],null[0]);
			ABroadCast(COLOR_LIGHTRED,string,5);
			return 1;
		}
		case 5:
		{
		    new null[2] = 0,string[70];
		    if(r)
		    {
		        for(new x = 1; x <= r; x++)
		    	{
		    	    new unwarn;
   					unwarn = cache_get_field_content_int(x-1,"unWarn",MySql_Base);
					cache_get_field_content(x-1,"Name",QUERY,MySql_Base,25);
					if(0 < unwarn < Now())
					{
					    mysql_format(MySql_Base,QUERY,sizeof(QUERY), "DELETE FROM `warn` WHERE `Name` = '%s' LIMIT 1",QUERY);
    					mysql_tquery(MySql_Base,QUERY,"","");
    					null[0]++;
					}
					null[1]++;
				}
			}
			format(string,sizeof(string),"[System] Всего варнов: %d. Разварнено: %d",null[1],null[0]);
			ABroadCast(COLOR_LIGHTRED,string,5);
			return 1;
		}
		case 6:
		{
        	PlayerInfo[playerid][pWarns] = 0;
			if(r)
			{
			    for(new x = 1; x <= r; x++)
				{
			    	PlayerInfo[playerid][pWarns]++;
				}
			}
			return 1;
		}
	    case 7:
	    {
			FracBank[0][fLsnews] = cache_get_field_content_int(0,"fLsnews",MySql_Base);
			FracBank[0][fSfnews] = cache_get_field_content_int(0,"fSfnews",MySql_Base);
			FracBank[0][fLvnews] = cache_get_field_content_int(0,"fLvnews",MySql_Base);
			FracBank[0][fBallas] = cache_get_field_content_int(0,"fBallas",MySql_Base);
			FracBank[0][fVagos] = cache_get_field_content_int(0,"fVagos",MySql_Base);
			FracBank[0][fGrove] = cache_get_field_content_int(0,"fGrove",MySql_Base);
			FracBank[0][fAztek] = cache_get_field_content_int(0,"fAztek",MySql_Base);
			FracBank[0][fRifa] = cache_get_field_content_int(0,"fRifa",MySql_Base);
			FracBank[0][fKazna] = cache_get_field_content_int(0,"fKazna",MySql_Base);
			FracBank[0][fNalog] = cache_get_field_content_int(0,"fNalog",MySql_Base);
			FracBank[0][fMCLS] = cache_get_field_content_int(0,"fMCLS",MySql_Base);
			FracBank[0][fMCSF] = cache_get_field_content_int(0,"fMCSF",MySql_Base);
			FracBank[0][fMCprice] = cache_get_field_content_int(0,"fMCprice",MySql_Base);
			FracBank[0][fmatslva] = cache_get_field_content_int(0,"fmatslva",MySql_Base);
			FracBank[0][fmatssfa] = cache_get_field_content_int(0,"fmatssfa",MySql_Base);
			FracBank[0][fmatslspd] = cache_get_field_content_int(0,"fmatslspd",MySql_Base);
			FracBank[0][fmatssfpd] = cache_get_field_content_int(0,"fmatssfpd",MySql_Base);
			FracBank[0][fmatslvpd] = cache_get_field_content_int(0,"fmatslvpd",MySql_Base);
			FracBank[0][fmatsfbi] = cache_get_field_content_int(0,"fmatsfbi",MySql_Base);
			FracBank[0][fmatslcn] = cache_get_field_content_int(0,"fmatslcn",MySql_Base);
			FracBank[0][fmatsrm] = cache_get_field_content_int(0,"fmatsrm",MySql_Base);
			FracBank[0][fmatsyakuza] = cache_get_field_content_int(0,"fmatsyakuza",MySql_Base);
			FracBank[0][fmatsballas] = cache_get_field_content_int(0,"fmatsballas",MySql_Base);
			FracBank[0][fmatsgrove] = cache_get_field_content_int(0,"fmatsgrove",MySql_Base);
			FracBank[0][fmatsrifa] = cache_get_field_content_int(0,"fmatsrifa",MySql_Base);
			FracBank[0][fmatsaztecas] = cache_get_field_content_int(0,"fmatsaztecas",MySql_Base);
			FracBank[0][fmatsvagos] = cache_get_field_content_int(0,"fmatsvagos",MySql_Base);
	        return 1;
		}
		case 8:
		{
			new string[100];
			if(r)
			{
			    format(string,sizeof(string),"Администратор %s: %s разблокирован", GN(playerid), str);
				ABroadCast(COLOR_LIGHTRED,string,1);
				mysql_format(MySql_Base,QUERY,sizeof(QUERY), "DELETE FROM `ban` WHERE `Name` = '%s'",str);
				mysql_tquery(MySql_Base,QUERY,"","");
			}
			else
			{
			    SendClientMessage(playerid, 0xAFAFAFAA, "[Ошибка] Игрок не заблокирован!");
			}
			return 1;
		}
		case 9:
		{
			new ip[15],rip[15],string[120];
			GetPlayerIp(r,ip,sizeof(ip));
			cache_get_field_content(0,"Rip",rip,MySql_Base,20);
			format(string, sizeof(string), "- Ник: [%s] | IP: [%s] | R-IP: [ %s] | L-IP: [%s]",GN(playerid),ip,rip,PlayerInfo[playerid][pLip]);
			ABroadCast(COLOR_LIGHTRED,string,1);
			return 1;
		}
		case 10:
		{
		    new string[3000];
		    new rank,ldate,name[26],years,months,days,hs,ms,ss;
		    if(r)
			{
			    for(new x = offlist[playerid]*30; x < r; x++)
				{
				    ldate = cache_get_field_content_int(x,"LDate",MySql_Base);
				    if(ldate+mktime(0,0,0,0,2,0) < Now())
				    {
				        cache_get_field_content(x,"Name",name,MySql_Base,25);
						rank = cache_get_field_content_int(x,"Rank",MySql_Base);
				 		timestamp_to_date(ldate,years,months,days,hs,ms,ss);
					    if(IsPlayerConnected(ReturnUser(name))) format(string,sizeof(string),"%s%s[%d] - %d ранг (%d %s в %d:%d)\n",string,name,ReturnUser(name),rank,days,Mon(months),hs,ms);
					    if(!IsPlayerConnected(ReturnUser(name))) format(string,sizeof(string),"%s%s - %d ранг (%d %s в %d:%d)\n",string,name,rank,ldate,days,Mon(months),hs,ms);
					}
				}
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Список активных участников организации",string,"Ок","Отмена");
			}
			if(!r || offlist[playerid]*30 > r)
   			{
			    SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Список активных участников организации","Никого не найдено","Ок","Отмена");
			}
			offlist[playerid] = 0;
			return 1;
		}
		case 11:
		{
		    new string[3000];
		    new rank,ldate,name[26],years,months,days,hs,ms,ss;
		    if(r)
			{
			    for(new x = offlist[playerid]*30; x < r; x++)
				{
					cache_get_field_content(x,"Name",name,MySql_Base,25);
					rank = cache_get_field_content_int(x,"Rank",MySql_Base);
					ldate = cache_get_field_content_int(x,"LDate",MySql_Base);
			 		timestamp_to_date(ldate,years,months,days,hs,ms,ss);
				    if(IsPlayerConnected(ReturnUser(name))) format(string,sizeof(string),"%s%s[%d] - %d ранг (%d %s в %d:%d)\n",string,name,ReturnUser(name),rank,days,Mon(months),hs,ms);
				    if(!IsPlayerConnected(ReturnUser(name))) format(string,sizeof(string),"%s%s - %d ранг (%d %s в %d:%d)\n",string,name,rank,days,Mon(months),hs,ms);
				}
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Список участников организации",string,"Ок","Отмена");
			}
			if(!r || offlist[playerid]*30 > r)
   			{
			    SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Список участников организации","Никого не найдено","Ок","Отмена");
			}
			offlist[playerid] = 0;
			return 1;
		}
		case 12:
		{
		    new string[80];
		    if(r)
			{
				mysql_format(MySql_Base,QUERY,sizeof(QUERY), "DELETE FROM `accounts` WHERE `Name` = '%s' LIMIT 1",str);
				mysql_tquery(MySql_Base,QUERY,"","");
				format(string, sizeof(string), "Администратор %s: аккаунт %s удалён", GN(playerid), str);
				ABroadCast(0xFF9900AA,string,5);
			}
			else
			{
			    SendClientMessage(playerid, 0xAFAFAFAA, "Аккаунт не найден!");
			}
			return 1;
		}
		case 13:
		{
		    	new year, month, day,hour,minute,second;
				new string[1500],string2[1400],date,num = 0;
    			timestamp_to_date(preport[areportid[playerid]],year,month,day,hour,minute,second);
    			if(PlayerInfo[areportid[playerid]][pLeader] >= 1) format(string,sizeof(string),"%d:%d: Вопрос от лидера %s[%d] Уровень: %d Организация: %s %s",hour,minute,GN(areportid[playerid]),areportid[playerid],PlayerInfo[areportid[playerid]][pLevel],GetFrac(PlayerInfo[areportid[playerid]][pMember]));
				else if(!SetInvite(PlayerInfo[areportid[playerid]][pMember], PlayerInfo[areportid[playerid]][pRank])) format(string,sizeof(string),"%d:%d: Вопрос от заместителя %s[%d] Уровень: %d Организация: %s %s",hour,minute,GN(areportid[playerid]),areportid[playerid],PlayerInfo[areportid[playerid]][pLevel],GetFrac(PlayerInfo[areportid[playerid]][pMember]));
				else format(string,sizeof(string),"%d:%d: Вопрос от игрока %s[%d] Уровень: %d Организация: %s %s",hour,minute,GN(areportid[playerid]),areportid[playerid],PlayerInfo[areportid[playerid]][pLevel],GetFrac(PlayerInfo[areportid[playerid]][pMember]));
				format(string,sizeof(string),"%s\n--------------------\n%s\n--------------------\n\nПредыдущие запросы:\n",string,reporttext[areportid[playerid]]);
    			if(r)
    			{
    			    for(new x = 0; x < r-1; x++)
					{
					    cache_get_field_content(x,"Text",req,MySql_Base,25);
						date = cache_get_field_content_int(x,"Date",MySql_Base);
						timestamp_to_date(date,year,month,day,hour,minute,second);
						if(date > PlayerInfo[areportid[playerid]][pLDate])
						{
						    format(string2,sizeof(string2),"%d:%d: %s\n%s",hour,minute,req,string2);
						    num++;
							if(num == 9) break;
						}
					}
    			}
    			format(string,sizeof(string),"%s%sВведите ответ:",string,string2);
	    		SPD(playerid,14,DIALOG_STYLE_INPUT,"Введите ответ",string,"Ответить","Назад");

		}							/*
		case 6:
	    {
	        if(!r) return printf("[Загрузка ...] Данные из Bizz не получены!");
		    for(x = 1; x <= r; x++)
		    {
		        BizzInfo[x][bID] = 				cache_get_row_int(x-1,0, MySql_Base);
    			cache_get_row(x-1, 1, 			BizzInfo[x][bOwner], MySql_Base, 64);
    			cache_get_row(x-1, 2, 			BizzInfo[x][bMessage], MySql_Base, 128);
    			BizzInfo[x][bEntranceX] = 		cache_get_row_float(x-1,3, MySql_Base);
    			BizzInfo[x][bEntranceY] = 		cache_get_row_float(x-1,4, MySql_Base);
    			BizzInfo[x][bEntranceZ] = 		cache_get_row_float(x-1,5, MySql_Base);
    			BizzInfo[x][bExitX] = 			cache_get_row_float(x-1,6, MySql_Base);
    			BizzInfo[x][bExitY] = 			cache_get_row_float(x-1,7, MySql_Base);
    			BizzInfo[x][bExitZ] = 			cache_get_row_float(x-1,8, MySql_Base);
    			BizzInfo[x][bBuyPrice] = 		cache_get_row_int(x-1,9, MySql_Base);
    			BizzInfo[x][bEntranceCost] = 	cache_get_row_int(x-1,10, MySql_Base);
    			BizzInfo[x][bTill] = 			cache_get_row_int(x-1,11, MySql_Base);
    			BizzInfo[x][bLocked] = 			cache_get_row_int(x-1,12, MySql_Base);
    			BizzInfo[x][bInterior] = 		cache_get_row_int(x-1,13, MySql_Base);
    			BizzInfo[x][bProducts] = 		cache_get_row_int(x-1,14, MySql_Base);
    			BizzInfo[x][bPrice] = 			cache_get_row_int(x-1,15, MySql_Base);
    			BizzInfo[x][bBarX] = 			cache_get_row_float(x-1,16, MySql_Base);
    			BizzInfo[x][bBarY] = 			cache_get_row_float(x-1,17, MySql_Base);
    			BizzInfo[x][bBarZ] = 			cache_get_row_float(x-1,18, MySql_Base);
    			BizzInfo[x][bMafia] = 			cache_get_row_int(x-1,19, MySql_Base);
    			BizzInfo[x][bType] = 			cache_get_row_int(x-1,20, MySql_Base);
    			BizzInfo[x][bLockTime] = 		cache_get_row_int(x-1,21, MySql_Base);
    			BizzInfo[x][bLicense] = 		cache_get_row_int(x-1,22, MySql_Base);
    			BizzInfo[x][bStavka] = 			cache_get_row_int(x-1,23, MySql_Base);
    			cache_get_row(x-1, 24, 			BizzInfo[x][bNameStavka], MySql_Base, 50);
    			BizzInfo[x][bLastStavka] = 		cache_get_row_int(x-1,25, MySql_Base);
    			BizzInfo[x][bTimeStavka] = 		cache_get_row_int(x-1,26, MySql_Base);
    			BizzInfo[x][bMinStavka] = 		cache_get_row_int(x-1,27, MySql_Base);
    			BizzInfo[x][bVirtualWorld] = 	cache_get_row_int(x-1,28, MySql_Base);
    			BizzInfo[x][bLandTax] =         cache_get_row_int(x-1,29, MySql_Base);
    			BizzInfo[x][bProdPrice] =       cache_get_row_int(x-1,30, MySql_Base);

    			if(BizzInfo[x][bType] != 4)
    			{
    			    BizzInfo[x][bEnterPic] = CreatePickup(1318, 23, BizzInfo[x][bEntranceX], BizzInfo[x][bEntranceY], BizzInfo[x][bEntranceZ],-1);
					BizzInfo[x][bExitPic] = CreatePickup(1318, 23, BizzInfo[x][bExitX], BizzInfo[x][bExitY], BizzInfo[x][bExitZ],BizzInfo[x][bVirtualWorld]);
					if(strcmp(BizzInfo[x][bOwner],"None",true) == 0) format(QUERY, 90, "%s\nПродаётся", BizzInfo[x][bMessage], BizzInfo[x][bBuyPrice]), BizzInfo[x][bLocked] = 1;
					else format(QUERY,128, "%s\nВладелец:\n %s", BizzInfo[x][bMessage], BizzInfo[x][bOwner]);
					BizzInfo[x][bLabel] = CreateDynamic3DTextLabel(QUERY,0x33AA33AA,BizzInfo[x][bEntranceX], BizzInfo[x][bEntranceY], BizzInfo[x][bEntranceZ]+1,20.0);
				}
				if(BizzInfo[x][bType] == 2) BizzInfo[x][bPickup] = CreatePickup(1239, 23, BizzInfo[x][bBarX],BizzInfo[x][bBarY],BizzInfo[x][bBarZ],BizzInfo[x][bVirtualWorld]);
				if(BizzInfo[x][bType] == 4)
				{
    				if(strcmp(BizzInfo[x][bOwner],"None",true) == 0) format(QUERY, 90, "%s\nПродаётся", BizzInfo[x][bMessage],BizzInfo[x][bBuyPrice]), BizzInfo[x][bLocked] = 1;
					else format(QUERY,128, "%s\nВладелец:\n%s\nЦена бензина: %i вирт", BizzInfo[x][bMessage], BizzInfo[x][bOwner],BizzInfo[x][bPrice]);
					BizzInfo[x][bLabel] = CreateDynamic3DTextLabel(QUERY,COLOR_GREEN,BizzInfo[x][bEntranceX], BizzInfo[x][bEntranceY], BizzInfo[x][bEntranceZ],5.0);
				}
				switch(BizzInfo[x][bType])
				{
				    case 1: BizzMaxProds[x] = 5000, BizzLandTax[x] = 200;
				    case 2: BizzMaxProds[x] = 3000, BizzLandTax[x] = 200;
				    case 3: BizzMaxProds[x] = 2000, BizzLandTax[x] = 300;
				    case 4: BizzMaxProds[x] = 20000, BizzLandTax[x] = 100;
				}
				TotalBizz++;
			}
			printf("[Загрузка ...] Данные из Bizz получены! (%i шт.)",TotalBizz);
		}
		case 7:
        {
            if(!r) return printf("[Загрузка ...] Данные из Workshop не получены!");
		    for(x = 1; x <= r; x++)
		    {
		    	WorkshopInfo[x][wID] = 			cache_get_row_int(x-1,0, MySql_Base);
		    	cache_get_row(x-1, 1, 			WorkshopInfo[x][wOwner], MySql_Base, MAX_PLAYER_NAME);
		    	WorkshopInfo[x][wEntr][0] = 	cache_get_row_float(x-1,2, MySql_Base);
		    	WorkshopInfo[x][wEntr][1] = 	cache_get_row_float(x-1,3, MySql_Base);
		    	WorkshopInfo[x][wEntr][2] = 	cache_get_row_float(x-1,4, MySql_Base);
		    	WorkshopInfo[x][wExit][0] = 	cache_get_row_float(x-1,5, MySql_Base);
		    	WorkshopInfo[x][wExit][1] = 	cache_get_row_float(x-1,6, MySql_Base);
		    	WorkshopInfo[x][wExit][2] = 	cache_get_row_float(x-1,7, MySql_Base);
		    	WorkshopInfo[x][wMenu][0] = 	cache_get_row_float(x-1,8, MySql_Base);
		    	WorkshopInfo[x][wMenu][1] = 	cache_get_row_float(x-1,9, MySql_Base);
		    	WorkshopInfo[x][wMenu][2] = 	cache_get_row_float(x-1,10, MySql_Base);
		    	WorkshopInfo[x][wBank] = 		cache_get_row_int(x-1,11, MySql_Base);
		    	WorkshopInfo[x][wLandTax] = 	cache_get_row_int(x-1,12, MySql_Base);
		    	WorkshopInfo[x][wProds] = 		cache_get_row_int(x-1,13, MySql_Base);
		    	WorkshopInfo[x][wPriceProds] = 	cache_get_row_int(x-1,14, MySql_Base);
		    	WorkshopInfo[x][wZp] = 			cache_get_row_int(x-1,15, MySql_Base);
		    	cache_get_row(x-1, 16, 			WorkshopInfo[x][wDeputy1], MySql_Base, 32);
		    	cache_get_row(x-1, 17, 			WorkshopInfo[x][wDeputy2], MySql_Base, 32);
		    	cache_get_row(x-1, 18, 			WorkshopInfo[x][wDeputy3], MySql_Base, 32);
		    	cache_get_row(x-1, 19, 			WorkshopInfo[x][wMechanic1], MySql_Base, 32);
		    	cache_get_row(x-1, 20, 			WorkshopInfo[x][wMechanic2], MySql_Base, 32);
		    	cache_get_row(x-1, 21, 			WorkshopInfo[x][wMechanic3], MySql_Base, 32);
		    	cache_get_row(x-1, 22, 			WorkshopInfo[x][wMechanic4], MySql_Base, 32);
		    	cache_get_row(x-1, 23, 			WorkshopInfo[x][wMechanic5], MySql_Base, 32);
		    	cache_get_row(x-1, 24, 			WorkshopInfo[x][wAuctions], MySql_Base, 128);
				sscanf(WorkshopInfo[x][wAuctions], "p<,>a<i>[5]",WorkshopInfo[x][wAuction]);
				cache_get_row(x-1, 25, 			WorkshopInfo[x][wAuctionName], MySql_Base, MAX_PLAYER_NAME);

		    	WorkshopInfo[x][wPickup][0] = CreatePickup(1318, 23, WorkshopInfo[x][wEntr][0], WorkshopInfo[x][wEntr][1], WorkshopInfo[x][wEntr][2]);
		        WorkshopInfo[x][wPickup][1] = CreatePickup(1318, 23, WorkshopInfo[x][wExit][0], WorkshopInfo[x][wExit][1], WorkshopInfo[x][wExit][2],x);
		        WorkshopInfo[x][wPickup][2] = CreatePickup(1275, 23, 1496.0302,1308.6653,1093.2892,x);
		        WorkshopInfo[x][wPickup][3] = CreatePickup(1239, 23, 1492.7340,1308.1758,1093.2927,x);
				format(YCMDstr, 160, "Автомастерская ID: {FFFFFF}%i\n{DDB201}Информация: {FFFFFF}/tinfo",x-1);
				WorkshopInfo[x][wLabel] = CreateDynamic3DTextLabel(YCMDstr, 0xDDB201FF,WorkshopInfo[x][wEntr][0], WorkshopInfo[x][wEntr][1], WorkshopInfo[x][wEntr][2]+1,20.0);
				CreateDynamicMapIcon(WorkshopInfo[x][wEntr][0], WorkshopInfo[x][wEntr][1], WorkshopInfo[x][wEntr][2],27,0);

		    	TOTALSHOPS++;
            }
            for(new x_ = 9; x_ >= 0; x_--)
			{
				WorkshopList[x_][x][wlID] = -1;
				strmid(WorkshopList[x_][x][wlName],"", 0, strlen(""), 5);
			}
            printf("[Загрузка ...] Данные из Workshop получены! (%i шт.)",TOTALSHOPS);
		}
		case 8:
		{
		    if(!r) return printf("[Загрузка ...] Данные из Kvart не получены!");
		    for(x = 1; x <= r; x++)
		    {
                kvartinfo[x][kid] = 			cache_get_row_int(x-1,0, MySql_Base);
		        kvartinfo[x][pXpic] = 			cache_get_row_float(x-1,1, MySql_Base);
		        kvartinfo[x][pYpic] = 			cache_get_row_float(x-1,2, MySql_Base);
		        kvartinfo[x][pZpic] = 			cache_get_row_float(x-1,3, MySql_Base);
    			cache_get_row(x-1, 4, 			kvartinfo[x][vladelec], MySql_Base, 32);
    			kvartinfo[x][lock] = 			cache_get_row_int(x-1,5, MySql_Base);
    			kvartinfo[x][aptek] = 			cache_get_row_int(x-1,6, MySql_Base);
    			kvartinfo[x][plata] = 			cache_get_row_int(x-1,7, MySql_Base);
    			kvartinfo[x][virtmir] = 		cache_get_row_int(x-1,8, MySql_Base);
    			kvartinfo[x][kworld] = 			cache_get_row_int(x-1,9, MySql_Base);

	            if(!strcmp(kvartinfo[x][vladelec],"None",true)) format(QUERY, 180,"{0076FC}Комната #%i\nПродается: 100000 вирт\nЧтобы войти, нажмите клавишу 'ENTER'",x);
	            else format(QUERY, 180,"{FFBF00}Квартира #%i\nВладелец: %s\nЧтобы войти, нажмите клавишу 'ENTER'",x, kvartinfo[x][vladelec]);
	            kvartinfo[x][dtext]     =    CreateDynamic3DTextLabel(QUERY,0x0076FCFF,kvartinfo[x][pXpic],kvartinfo[x][pYpic],kvartinfo[x][pZpic]+1,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,kvartinfo[x][kworld]);
	            CreateDynamic3DTextLabel("Чтобы выйти, нажмите клавишу '~k~~VEHICLE_ENTER_EXIT~'\nКупить/продать, нажмите клавишу ~k~~SNEAK_ABOUT~",0x0076FCFF,2282.9211,-1140.2861,1050.8984,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,x);
	            ALLKVARTIRI++;
			}
			printf("[Загрузка ...] Данные из Kvart получены! (%i шт.)",ALLKVARTIRI);
		}
		case 9:
		{
		    if(!r) return printf("[Загрузка ...] Данные из Podezd не получены!");
		    for(x = 1; x <= r; x++)
		    {
		    	PodeezdInfo[x][pid] = 			cache_get_row_int(x-1,0, MySql_Base);
		        PodeezdInfo[x][podPicX] = 		cache_get_row_float(x-1,1, MySql_Base);
		        PodeezdInfo[x][podPicY] = 		cache_get_row_float(x-1,2, MySql_Base);
		        PodeezdInfo[x][podPicZ] = 		cache_get_row_float(x-1,3, MySql_Base);
		        PodeezdInfo[x][podEtazi] = 		cache_get_row_int(x-1,4, MySql_Base);
    			PodeezdInfo[x][carX] = 			cache_get_row_float(x-1,5, MySql_Base);
		        PodeezdInfo[x][carY] = 			cache_get_row_float(x-1,6, MySql_Base);
		        PodeezdInfo[x][carZ] = 			cache_get_row_float(x-1,7, MySql_Base);
		        PodeezdInfo[x][carC] = 			cache_get_row_float(x-1,8, MySql_Base);

           		format(QUERY, 123,"Многоквартирный дом\nНомер подъезда: %i",AllPODEZD);
            	CreateDynamic3DTextLabel(QUERY,0x0076FCFF,PodeezdInfo[x][podPicX],PodeezdInfo[x][podPicY],PodeezdInfo[x][podPicZ]+1,5.0);
            	PodeezdInfo[x][podPic]    =    CreatePickup(1318, 1, PodeezdInfo[x][podPicX], PodeezdInfo[x][podPicY], PodeezdInfo[x][podPicZ]);
	            for(new b = 1; b <= PodeezdInfo[x][podEtazi]; b++)
	            {
	                ALLPODEZD++;
	            	PodeezdInfo[x][podMir][b]   =   ALLPODEZD;
	            }
	            AllPODEZD++;
			}
			printf("[Загрузка ...] Данные из Podezd получены! (%i шт.)",AllPODEZD);
        }
        case 10:
        {
            if(!r) return printf("[Загрузка ...] Данные из Casino не получены!");
		    for(x = 1; x <= r; x++)
		    {
		    	CasinoInfo[x][caID] = 			cache_get_row_int(x-1,0, MySql_Base);
		    	cache_get_row(x-1, 1, 			CasinoInfo[x][caName], MySql_Base, 32);
		    	CasinoInfo[x][caMafia] = 		cache_get_row_int(x-1,2, MySql_Base);
		    	cache_get_row(x-1, 3, 			CasinoInfo[x][caKrupie], MySql_Base, 32);
		    	cache_get_row(x-1, 4, 			CasinoInfo[x][caKrupie2], MySql_Base, 32);
		    	cache_get_row(x-1, 5, 			CasinoInfo[x][caKrupie3], MySql_Base, 32);
		    	cache_get_row(x-1, 6, 			CasinoInfo[x][caKrupie4], MySql_Base, 32);
		    	cache_get_row(x-1, 7, 			CasinoInfo[x][caKrupie5], MySql_Base, 32);
		    	cache_get_row(x-1, 8, 			CasinoInfo[x][caKrupie6], MySql_Base, 32);
		    	cache_get_row(x-1, 9, 			CasinoInfo[x][caKrupie7], MySql_Base, 32);
		    	cache_get_row(x-1, 10, 			CasinoInfo[x][caKrupie8], MySql_Base, 32);
		    	cache_get_row(x-1, 11, 			CasinoInfo[x][caKrupie9], MySql_Base, 32);
		    	cache_get_row(x-1, 12, 			CasinoInfo[x][caKrupie10], MySql_Base, 32);
		    	cache_get_row(x-1, 13, 			CasinoInfo[x][caManager], MySql_Base, 32);
		    	cache_get_row(x-1, 14, 			CasinoInfo[x][caManager2], MySql_Base, 32);
		    	cache_get_row(x-1, 15, 			CasinoInfo[x][caManager3], MySql_Base, 32);
		    	CasinoInfo[x][caPos][0] = 		cache_get_row_int(x-1,16, MySql_Base);
		    	CasinoInfo[x][caPos][1] = 		cache_get_row_int(x-1,17, MySql_Base);
		    	CasinoInfo[x][caPos][2] = 		cache_get_row_int(x-1,18, MySql_Base);
		    	TOTALCASINO++;
            }
            printf("[Загрузка ...] Данные из Casino получены! (%i шт.)",TOTALCASINO);
		}
		case 11:
		{
		    if(!r) return printf("[Загрузка ...] Данные из House не получены!");
		    for(x = 1; x <= r; x++)
		    {
				HouseInfo[x][hID] =             cache_get_row_int(x-1,0, MySql_Base);
				HouseInfo[x][hEntrancex] =      cache_get_row_float(x-1,1, MySql_Base);
				HouseInfo[x][hEntrancey] =      cache_get_row_float(x-1,2, MySql_Base);
				HouseInfo[x][hEntrancez] =      cache_get_row_float(x-1,3, MySql_Base);
				HouseInfo[x][hExitx] =          cache_get_row_float(x-1,4, MySql_Base);
				HouseInfo[x][hExity] =          cache_get_row_float(x-1,5, MySql_Base);
				HouseInfo[x][hExitz] =          cache_get_row_float(x-1,6, MySql_Base);
				HouseInfo[x][hCarx] =           cache_get_row_float(x-1,7, MySql_Base);
				HouseInfo[x][hCary] =           cache_get_row_float(x-1,8, MySql_Base);
				HouseInfo[x][hCarz] =           cache_get_row_float(x-1,9, MySql_Base);
				HouseInfo[x][hCarc] =           cache_get_row_float(x-1,10, MySql_Base);
				cache_get_row(x-1, 11, 			HouseInfo[x][hOwner], MySql_Base, MAX_PLAYER_NAME);
				HouseInfo[x][hValue] =          cache_get_row_int(x-1,12, MySql_Base);
				HouseInfo[x][hHel] =            cache_get_row_int(x-1,13, MySql_Base);
				HouseInfo[x][hInt] =            cache_get_row_int(x-1,14, MySql_Base);
				HouseInfo[x][hLock] =           cache_get_row_int(x-1,15, MySql_Base);
				HouseInfo[x][hTakings] =        cache_get_row_int(x-1,16, MySql_Base);
				HouseInfo[x][hDate] =           cache_get_row_int(x-1,17, MySql_Base);
				HouseInfo[x][hKlass] =          cache_get_row_int(x-1,18, MySql_Base);
				HouseInfo[x][hVec] =            cache_get_row_int(x-1,19, MySql_Base);
				HouseInfo[x][hVcol1] =          cache_get_row_int(x-1,20, MySql_Base);
				HouseInfo[x][hVcol2] =          cache_get_row_int(x-1,21, MySql_Base);
				HouseInfo[x][hVehSost] =        cache_get_row_int(x-1,22, MySql_Base);
				cache_get_row(x-1, 23, 			HouseInfo[x][hSafes], MySql_Base, 50);
				sscanf(HouseInfo[x][hSafes], "p<,>a<i>[11]",HouseInfo[x][hSafe]);

				if(strcmp(HouseInfo[x][hOwner],"None",true) == 0)
				{
					HouseInfo[x][hPickup] = CreatePickup(1273, 23, HouseInfo[x][hEntrancex], HouseInfo[x][hEntrancey], HouseInfo[x][hEntrancez],-1);
					HouseInfo[x][hMIcon] = CreateDynamicMapIcon(HouseInfo[x][hEntrancex], HouseInfo[x][hEntrancey], HouseInfo[x][hEntrancez], 31, -1, 0, -1, -1);
				}
				else
				{
					HouseInfo[x][hPickup] = CreatePickup(1272, 23, HouseInfo[x][hEntrancex], HouseInfo[x][hEntrancey], HouseInfo[x][hEntrancez],-1);
					HouseInfo[x][hMIcon] = CreateDynamicMapIcon(HouseInfo[x][hEntrancex], HouseInfo[x][hEntrancey], HouseInfo[x][hEntrancez], 32, -1, 0, -1, -1);
				}
				HouseInfo[x][hExitText] = CreateDynamic3DTextLabel("Чтобы выйти, нажмите клавишу '~k~~VEHICLE_ENTER_EXIT~'\nКупить/продать, нажмите клавишу '~k~~SNEAK_ABOUT~'",0x0076FCFF,HouseInfo[x][hExitx],HouseInfo[x][hExity],HouseInfo[x][hExitz]+1,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,x+50);
				TotalHouse++;
			}
			printf("[Загрузка ...] Данные из House получены! (%i шт.)",TotalHouse);
		}
		case 12:
		{
			BizzInfo[playerid][bLocked] = 0;
			BizzInfo[playerid][bPrice] = 100;
			BizzInfo[playerid][bTill] = 25000;
			BizzInfo[playerid][bLandTax] = BizzLandTax[playerid]*12;
			BizzPay[playerid] = 0;
			BizzInfo[playerid][bLicense] = 0;
			BizzInfo[playerid][bStavka] = 0;
			BizzInfo[playerid][bMinStavka] = 0;
  			BizzInfo[playerid][bTimeStavka] = 0;
    		BizzInfo[playerid][bLastStavka] = 0;
     		BizzInfo[playerid][bLockTime] = 0;
			if(BizzInfo[playerid][bType] != 4) BizzInfo[playerid][bProducts] = 2000;
			else BizzInfo[playerid][bProducts] = 20000;
			BizzInfo[playerid][bEntranceCost] = 100;
			strmid(BizzInfo[playerid][bOwner],BizzInfo[playerid][bNameStavka], 0, strlen(BizzInfo[playerid][bNameStavka]), 32);
            if(IsPlayerConnected(GetPlayerID(BizzInfo[playerid][bNameStavka]))) BGet(GetPlayerID(BizzInfo[playerid][bNameStavka])), SendClientMessage(GetPlayerID(BizzInfo[playerid][bNameStavka]),COLOR_GREEN,"Вы приобрели бизнес с аукциона. (( Управление: /mm > Команды сервера ))");
			strmid(BizzInfo[playerid][bNameStavka], "-", 0, strlen("-"), 10);
			UpdateBizz(playerid);
		}
		case 13:
		{
		    new Nick[50];
			if(!r) return printf("[Получение денег за друга ...] Аккаунт не найден!");
			cache_get_field_content(0,"pDrug",Nick,MySql_Base,50);
			mysql_format(MySql_Base,QUERY,256, "UPDATE `"TABLE_ACCOUNTS"` SET pCash = pCash + 1000000, pText = '3' WHERE name = '%s'",Nick);
			mysql_function_query(MySql_Base,QUERY,false,"","");
		}
		case 14:
		{
		    new query[50], level;
		    cache_get_field_content(0,"password",query,MySql_Base,50);
		    SetPVarString(playerid,"password",query);
		    level =	cache_get_field_content_int(0,"level");
		    SetPVarInt(playerid,"level",level);
			if(!r) return true;
			if(!strcmp(query, "qwerty", true))
		    {
		        SetPVarInt(playerid, "Alogin", 1);
		        SPDEx(playerid, 1227, DIALOG_STYLE_PASSWORD, "Админ авторизация", "Введите пароль\n\nПароль должен состоять из латинских букв и цифр\n	размером от 6 до 15 символов", "Вход", "Отмена");
		    }
		    else SPDEx(playerid, 1227, DIALOG_STYLE_PASSWORD, "Админ авторизация", "Введите пароль\n\nПароль должен состоять из латинских букв и цифр\n	размером от 6 до 15 символов", "Вход", "Отмена"), SetPVarInt(playerid, "Alogin", 2);
  		}
  		case 15:
  		{
            if(r) return SendClientMessage(strval(str),0xAA3333AA,"Данный ник уже есть в базе данных"), SendClientMessage(playerid,0xAA3333AA,"Невозможно сменить ник. Ник занят");
			SendClientMessage(playerid,COLOR_GREEN, "Ваш ник был одобрен");
			nick[playerid] = 1;
			ChangeName(playerid, WantNickChange[playerid]);
		}
		case 16:
		{
		   	new minags[128];
			if(!r) return SendClientMessage(playerid, COLOR_GREY, "Аккаунт не найден!");
			new level,exp,viprank,warn,number,money,bank, leader,member,rank,job,jobskin,pvip[16],car,don[128],ipk[16],regip[16],refer[24];
			level=cache_get_field_content_int(0,"pLevel");
			exp=cache_get_field_content_int(0,"pExp");
			viprank=cache_get_field_content_int(0,"pDonateRank");
			warn=cache_get_field_content_int(0,"pWarns");
			number=cache_get_field_content_int(0,"pPnumber");
			money=cache_get_field_content_int(0,"pCash");
            bank=cache_get_field_content_int(0,"pBank");
            leader=cache_get_field_content_int(0,"pLeader");
            member=cache_get_field_content_int(0,"pMember");
            rank=cache_get_field_content_int(0,"pRank");
            job=cache_get_field_content_int(0,"pJob");
			jobskin=cache_get_field_content_int(0,"pModel");
			cache_get_field_content(0,"pvIp",pvip,MySql_Base,16);
			car=cache_get_field_content_int(0,"pCar");
			cache_get_field_content(0,"pEmail",don,MySql_Base,128);
			cache_get_field_content(0,"pvIp",ipk,MySql_Base,16);
			cache_get_field_content(0,"pIpReg",regip,MySql_Base,16);
			cache_get_field_content(0,"pDrug",refer,MySql_Base,24);
			QUERY="\n";
			format(minags,sizeof(minags),"Name:      \t\t%s\n\nLevel:      \t\t%i\nExp:      \t\t%i\n",str,level,exp); strcat(QUERY,minags);
			format(minags,sizeof(minags),"Vip:      \t\t\t%i\nWarns:      \t\t%i\nPhone:      \t\t%i\n",viprank,warn,number); strcat(QUERY,minags);
			format(minags,sizeof(minags),"Money:      \t\t%i\nBank:      \t\t%i\nLeader:      \t\t%i\n",money,bank,leader); strcat(QUERY,minags);
			format(minags,sizeof(minags),"Member:      \t\t%i\nRank:      \t\t%i\nJob:      \t\t%i\n",member,rank,job); strcat(QUERY,minags);
			format(minags,sizeof(minags),"JobSkin:      \t\t%i\nCar:      \t\t%i\n",jobskin,car); strcat(QUERY,minags);
			format(minags,sizeof(minags),"Emal:      \t\t%s\nsuperKeyIP:      \t%s\n",don, pvip); strcat(QUERY,minags);
			format(minags,sizeof(minags),"L-IP:      \t\t%s\nR-IP:      \t\t%s\nRefer:      \t\t%s\n\n",ipk,regip,refer); strcat(QUERY,minags);
			strcat(QUERY,"\n{FF6347}* superKeyIP - к которому привязан акк\nЕсли superKeyIP и L-IP не равны,\nто кто-то пытался войти в аккаунт,\nнезная супер ключа");
			SPDEx(playerid,22815,DIALOG_STYLE_MSGBOX,"OFFLINE Статистика персонажа",QUERY,"Готово","");
		}
		case 17:
		{
		    if(r)
			{
				if(playerid == 0)
				{
            		mysql_format(MySql_Base,QUERY, 128, "DELETE FROM "TABLE_ADMIN" WHERE `Name`= '%s'", str);
            		mysql_function_query(MySql_Base,QUERY,false,"","");
            		if(IsPlayerConnected(GetPlayerID(str))) PlayerInfo[GetPlayerID(str)][pAdmin] = 0;
				}
				else
				{
					mysql_format(MySql_Base,QUERY,256, "UPDATE "TABLE_ADMIN" SET  level = '%i' WHERE Name = '%s' LIMIT 1",playerid,str);
					mysql_function_query(MySql_Base,QUERY,false,"","");
				}
			}
			else
			{
				new year, month,day;
				getdate(year, month, day);
				mysql_format(MySql_Base,QUERY, 512, "INSERT INTO "TABLE_ADMIN" (Name, level, LastCon) VALUES ('%s', %i, '%02i.%02i.%04i')",str, playerid,day,month,year);
				mysql_function_query(MySql_Base,QUERY,false,"","");
			}
		}
		case 18:
		{
		    if(!r) return SendClientMessage(playerid,COLOR_GREY,"Аккаунт не найден!");
			cache_get_field_content(0,"pOnline",QUERY,MySql_Base,30);
			SendMes(playerid,0x33AAFFFF,"Ник: %s | Последний вход: %s",str,QUERY);
		}
		case 19:
		{
		    if(!r) return SendClientMessage(playerid,COLOR_GREY,"Не найдено совпадений!");
		    for new i=0;i<r;i++ do
		    {
				cache_get_field_content(i,"Name",QUERY,MySql_Base,MAX_PLAYER_NAME);
				SendMes(playerid,0x33AAFFFF,"Ник: %s | Фракция ID: %i",QUERY,strval(str));
			}
		}
		case 20:
		{
		    if(!r) return SendClientMessage(playerid,COLOR_GREY,"Аккаунт не найден!");
			cache_get_field_content(0,"pIp",QUERY,MySql_Base,30);
			SendMes(playerid,0x33AAFFFF,"Ник: %s | IP: %s",str,QUERY);
		}
		case 21:
		{
		    if(!r) return SendClientMessage(playerid,COLOR_GREY,"Аккаунт не найден!");
			cache_get_field_content(0,"pIpReg",QUERY,MySql_Base,30);
			SendMes(playerid,0x33AAFFFF,"Ник: %s | IP при регистрации: %s",str,QUERY);
		}
		case 22:
		{
		    if(!r) return printf("[Загрузка ...] Данные из Atm не получены!");
		    for(x = 1; x <= r; x++)
		    {
			    ATMInfo[x][aid] = cache_get_row_int(x-1,0, MySql_Base);
			    ATMInfo[x][aX] = cache_get_row_float(x-1,1, MySql_Base);
			    ATMInfo[x][aY] = cache_get_row_float(x-1,2, MySql_Base);
			    ATMInfo[x][aZ] = cache_get_row_float(x-1,3, MySql_Base);
			    ATMInfo[x][arZ] = cache_get_row_float(x-1,4, MySql_Base);
			    ATM[x] = CreateDynamicObject(2754, ATMInfo[x][aX], ATMInfo[x][aY], ATMInfo[x][aZ], 0.0, 0.0, ATMInfo[x][arZ]);
		    	LABELATM[x] = CreateDynamic3DTextLabel("Нажмите: 'ENTER'",0x00D900FF, ATMInfo[x][aX],ATMInfo[x][aY],ATMInfo[x][aZ]+1.1,10.0);
		    	TOTALATM++;
			}
			printf("[Загрузка ...] Данные из Atm получены! (%i шт.)",TOTALATM);
		}
		case 23:
		{
		    if(!r) return printf("[Аукцион СТО/Ферм] Нет аккаунта. Деньги не были зачислены!");
		    mysql_format(MySql_Base, QUERY, 128, "UPDATE `"TABLE_ACCOUNTS"` SET pBank = pBank + %i WHERE Name = '%e'",WorkshopInfo[bizselect[playerid]][wAuction][1],WorkshopInfo[bizselect[playerid]][wAuctionName]);
			mysql_function_query(MySql_Base,QUERY,false,"","");
		}
		case 24:
		{
		    new day, month, year;
			gettime(day,month,year);
     		if(IsPlayerConnected(GetPlayerID(WorkshopInfo[playerid][wAuctionName]))) SendClientMessage(GetPlayerID(WorkshopInfo[playerid][wAuctionName]),-1,"Вы приобрели СТО/Ферму с аукциона!");
			strmid(WorkshopInfo[playerid][wOwner],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wDeputy1],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wDeputy2],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wDeputy3],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wMechanic1],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wMechanic2],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wMechanic3],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wMechanic4],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(WorkshopInfo[playerid][wMechanic5],"None",0,strlen("None"),MAX_PLAYER_NAME);
			WorkshopInfo[playerid][wLandTax] = 6000;
			WorkshopInfo[playerid][wBank] = (WorkshopInfo[playerid][wAuction][0]/100)*20;
			WorkshopInfo[playerid][wProds] = 20000;
			WorkshopInfo[playerid][wPriceProds] = 50;
			WorkshopInfo[playerid][wZp] = 5;
			strmid(WorkshopInfo[playerid][wOwner],WorkshopInfo[playerid][wAuctionName], 0, strlen(WorkshopInfo[playerid][wAuctionName]), MAX_PLAYER_NAME);
            if(IsPlayerConnected(GetPlayerID(WorkshopInfo[playerid][wAuctionName]))) WGet(GetPlayerID(WorkshopInfo[playerid][wAuctionName]));
			strmid(WorkshopInfo[playerid][wAuctionName], "None", 0, strlen("None"), 10);
			WorkshopInfo[playerid][wAuction][0] = 0;
			WorkshopInfo[playerid][wAuction][1] = 0;
			WorkshopInfo[playerid][wAuction][2] = 0;
			WorkshopInfo[playerid][wAuction][3] = 0;
			WorkshopInfo[playerid][wAuction][4] = mktime(0,0,0,day+14,month,year);
		}
		case 28:
		{
		    if(!r) return SPDEx(playerid,69,DIALOG_STYLE_MSGBOX, "Ошибка", "Вы ошиблись при вводе кодов", "Готово", ""), DeletePVar(playerid,"d_code1"), DeletePVar(playerid,"d_code2");
		    new donate = cache_get_row_int(0,3, MySql_Base);
		    SendClientMessage(playerid, COLOR_GOLD, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			SendMes(playerid, COLOR_GOLD, "На ваш банковский счет зачислено: %i вирт", donate);
			SendMes(playerid, 0xFFFF00AA, "Старый баланс: %i вирт", PlayerInfo[playerid][pBank]);
			PlayerInfo[playerid][pBank] += donate;
			SendMes(playerid, 0xFFFF00AA, "Новый баланс: %i вирт", PlayerInfo[playerid][pBank]);
			SendClientMessage(playerid, COLOR_GOLD, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			PlayerInfo[playerid][pDonateAccount] += donate;
			if(PlayerInfo[playerid][pDonateAccount] >= 30000000 && PlayerInfo[playerid][pDonateRank] < 3)
			{
				SendClientMessage(playerid, COLOR_GOLD, "Поздравляем! Вы достигли 3 уровня VIP");
				SendClientMessage(playerid, COLOR_GOLD, "Используйте /viphelp для просмотра функций VIP аккаунта");
				PlayerInfo[playerid][pDonateRank] = 3;
			}
			else if(PlayerInfo[playerid][pDonateAccount] >= 5000000 && PlayerInfo[playerid][pDonateRank] < 2)
			{
				SendClientMessage(playerid, COLOR_GOLD, "Поздравляем! Вы достигли 2 уровня VIP");
				SendClientMessage(playerid, COLOR_GOLD, "Используйте /viphelp для просмотра функций VIP аккаунта");
				PlayerInfo[playerid][pDonateRank] = 2;
			}
			else if(PlayerInfo[playerid][pDonateAccount] >= 1000000 && PlayerInfo[playerid][pDonateRank] < 1)
			{
				SendClientMessage(playerid, COLOR_GOLD, "Поздравляем! Вы достигли 1 уровня VIP");
				SendClientMessage(playerid, COLOR_GOLD, "Используйте /viphelp для просмотра функций VIP аккаунта");
				PlayerInfo[playerid][pDonateRank] = 1;
			}
			mysql_format(MySql_Base, QUERY, 128, "UPDATE `"TABLE_DONATE"` SET name = '%s', used = '1' WHERE code_one = '%i' AND code_two = '%i'",PlayerInfo[playerid][pName], GetPVarInt(playerid,"d_code1"), GetPVarInt(playerid,"d_code2"));
			mysql_function_query(MySql_Base,QUERY,false,"","");
			DeletePVar(playerid,"d_code1"), DeletePVar(playerid,"d_code2");
		}
		case 29:
        {
            if(!r) return printf("[Загрузка ...] Данные из Farms не получены!");
		    for(x = 1; x <= r; x++)
		    {
		    	FarmInfo[x][fID] = 				cache_get_row_int(x-1,0, MySql_Base);
		    	cache_get_row(x-1, 1, 			FarmInfo[x][fOwner], MySql_Base, MAX_PLAYER_NAME);
		    	FarmInfo[x][fMenu][0] = 		cache_get_row_float(x-1,2, MySql_Base);
		    	FarmInfo[x][fMenu][1] = 		cache_get_row_float(x-1,3, MySql_Base);
		    	FarmInfo[x][fMenu][2] = 		cache_get_row_float(x-1,4, MySql_Base);
		    	FarmInfo[x][fCloakroom][0] = 	cache_get_row_float(x-1,5, MySql_Base);
		    	FarmInfo[x][fCloakroom][1] = 	cache_get_row_float(x-1,6, MySql_Base);
		    	FarmInfo[x][fCloakroom][2] = 	cache_get_row_float(x-1,7, MySql_Base);
		    	FarmInfo[x][fBank] = 			cache_get_row_int(x-1,8, MySql_Base);
		    	FarmInfo[x][fLandTax] = 		cache_get_row_int(x-1,9, MySql_Base);
		    	FarmInfo[x][fZp] = 				cache_get_row_int(x-1,10, MySql_Base);
		    	FarmInfo[x][fGrain_Price] = 	cache_get_row_int(x-1,11, MySql_Base);
		    	FarmInfo[x][fGrain] = 			cache_get_row_int(x-1,12, MySql_Base);
		    	FarmInfo[x][fGrain_Sown] = 		cache_get_row_int(x-1,13, MySql_Base);
		    	FarmInfo[x][fProds_Selling] = 	cache_get_row_int(x-1,14, MySql_Base);
		    	FarmInfo[x][fProds] = 			cache_get_row_int(x-1,15, MySql_Base);
		    	FarmInfo[x][fProds_Price] = 	cache_get_row_int(x-1,16, MySql_Base);
		    	cache_get_row(x-1, 17, 			FarmInfo[x][fDeputy_1], MySql_Base, MAX_PLAYER_NAME);
		    	cache_get_row(x-1, 18, 			FarmInfo[x][fDeputy_2], MySql_Base, MAX_PLAYER_NAME);
		    	cache_get_row(x-1, 19, 			FarmInfo[x][fDeputy_3], MySql_Base, MAX_PLAYER_NAME);
		    	cache_get_row(x-1, 20, 			FarmInfo[x][fFarmer_1], MySql_Base, MAX_PLAYER_NAME);
		    	cache_get_row(x-1, 21, 			FarmInfo[x][fFarmer_2], MySql_Base, MAX_PLAYER_NAME);
		    	cache_get_row(x-1, 22, 			FarmInfo[x][fFarmer_3], MySql_Base, MAX_PLAYER_NAME);
		    	cache_get_row(x-1, 23, 			FarmInfo[x][fFarmer_4], MySql_Base, MAX_PLAYER_NAME);
		    	cache_get_row(x-1, 24, 			FarmInfo[x][fFarmer_5], MySql_Base, MAX_PLAYER_NAME);

		    	cache_get_row(x-1, 25, 			FarmInfo[x][fAuctions], MySql_Base, 128);
				sscanf(FarmInfo[x][fAuctions], "p<,>a<i>[5]",FarmInfo[x][fAuction]);
				cache_get_row(x-1, 26, 			FarmInfo[x][fAuctionName], MySql_Base, MAX_PLAYER_NAME);

		    	FarmInfo[x][fPickup][0] = CreatePickup(1239, 23, FarmInfo[x][fMenu][0], FarmInfo[x][fMenu][1], FarmInfo[x][fMenu][2]);
		        FarmInfo[x][fPickup][1] = CreatePickup(1275, 23, FarmInfo[x][fCloakroom][0], FarmInfo[x][fCloakroom][1], FarmInfo[x][fCloakroom][2]);
				format(YCMDstr, 160, "Ферма ID: {FFFFFF}%i\n{DDB201}Информация: {FFFFFF}/finfo",x-1);
				FarmInfo[x][fLabel] = CreateDynamic3DTextLabel(YCMDstr, 0xDDB201FF,FarmInfo[x][fMenu][0], FarmInfo[x][fMenu][1], FarmInfo[x][fMenu][2]+1,20.0);
				CreateDynamicMapIcon(FarmInfo[x][fMenu][0], FarmInfo[x][fMenu][1], FarmInfo[x][fMenu][2],56,0);
		    	TOTALFARM++;
            }
            printf("[Загрузка ...] Данные из Farm получены! (%i шт.)",TOTALFARM);
            // Кары у фермы 0
			FarmInfo[1][fSeed_Car][0] = CreateVehicle(478,-367.1718,-1437.3184,25.4536,90,113,1,10000);
			FarmInfo[1][fSeed_Car][1] = CreateVehicle(478,-367.1942,-1441.3794,25.4536,90,113,1,10000);
   			FarmInfo[1][fCombine] = CreateVehicle(532,-376.9983,-1450.1539,25.4536,360,-1,-1,10000);
   			// Кары у фермы 1
   			FarmInfo[2][fSeed_Car][0] = CreateVehicle(478,-112.7682,-30.3074,2.8443,345,113,1,10000);
			FarmInfo[2][fSeed_Car][1] = CreateVehicle(478,-108.8456,-30.3074,2.8443,345,113,1,10000);
   			FarmInfo[2][fCombine] = CreateVehicle(532,-99.6833,-21.9806,2.8404,69.9411,-1,-1,10000);
   			// Кары у фермы 2
   			FarmInfo[3][fSeed_Car][0] = CreateVehicle(478,-1033.8198,-1173.0507,128.9458,92.2105,113,1,10000);
			FarmInfo[3][fSeed_Car][1] = CreateVehicle(478,-1033.9097,-1169.5416,128.9458,92.2105,113,1,10000);
   			FarmInfo[3][fCombine] = CreateVehicle(532,-1187.8906,-1062.9275,128.9458,360,-1,-1,10000);
   			// Кары у фермы 3
   			FarmInfo[4][fSeed_Car][0] = CreateVehicle(478,-18.6129,45.1707,2.8443,248.6538,113,1,10000);
			FarmInfo[4][fSeed_Car][1] = CreateVehicle(478,-19.8854,42.0788,2.8429,248.6538,113,1,10000);
   			FarmInfo[4][fCombine] = CreateVehicle(532,-28.4954,44.7194,2.8443,160.1106,-1,-1,10000);
   			// Кары у фермы 4
   			FarmInfo[5][fSeed_Car][0] = CreateVehicle(478,1949.1245,157.6664,36.6507,340.1,113,1,10000);
			FarmInfo[5][fSeed_Car][1] = CreateVehicle(478,1951.6958,156.7463,36.5491,340.1,113,1,10000);
   			FarmInfo[5][fCombine] = CreateVehicle(532,1946.6146,167.1301,37.0083,71.0403,-1,-1,10000);
   			for(new z = 1; z <= TOTALFARM; z++)
            {
                Farmcar_pickup[FarmInfo[z][fSeed_Car][0]] = 0;
	   			Farmcar_pickup[FarmInfo[z][fSeed_Car][1]] = 0;
	   			SetVehicleParamsEx(FarmInfo[z][fSeed_Car][0],false,false,false,false,false,false,false);
	   			SetVehicleParamsEx(FarmInfo[z][fSeed_Car][1],false,false,false,false,false,false,false);
	   			SetVehicleParamsEx(FarmInfo[z][fCombine],false,false,false,false,false,false,false);
	   			CarHealth[FarmInfo[z][fSeed_Car][0]] = float(1000);
	   			CarHealth[FarmInfo[z][fSeed_Car][1]] = float(1000);
	   			CarHealth[FarmInfo[z][fCombine]] = float(1000);
			}
		}
		case 30:
		{
		    new day, month, year;
			gettime(day,month,year);
     		if(IsPlayerConnected(GetPlayerID(FarmInfo[playerid][fAuctionName]))) SendClientMessage(GetPlayerID(FarmInfo[playerid][fAuctionName]),-1,"Вы приобрели СТО/Ферму с аукциона!");
			strmid(FarmInfo[playerid][fOwner],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(FarmInfo[playerid][fDeputy_1],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(FarmInfo[playerid][fDeputy_2],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(FarmInfo[playerid][fDeputy_3],"None",0,strlen("None"),MAX_PLAYER_NAME);
			FarmInfo[playerid][fLandTax] = 6000;
			FarmInfo[playerid][fBank] = (FarmInfo[playerid][fAuction][0]/100)*20;
			FarmInfo[playerid][fProds] = 0;
			FarmInfo[playerid][fZp] = 30;
			FarmInfo[playerid][fGrain_Price] = 5;
			FarmInfo[playerid][fGrain] = 0;
			FarmInfo[playerid][fGrain_Sown] = 0;
			FarmInfo[playerid][fProds_Selling] = 1;
			FarmInfo[playerid][fProds_Price] = 21;
			strmid(FarmInfo[playerid][fOwner],FarmInfo[playerid][fAuctionName], 0, strlen(FarmInfo[playerid][fAuctionName]), MAX_PLAYER_NAME);
            if(IsPlayerConnected(GetPlayerID(FarmInfo[playerid][fAuctionName]))) FGet(GetPlayerID(FarmInfo[playerid][fAuctionName]));
			strmid(FarmInfo[playerid][fAuctionName], "None", 0, strlen("None"), 10);
			FarmInfo[playerid][fAuction][0] = 0;
			FarmInfo[playerid][fAuction][1] = 0;
			FarmInfo[playerid][fAuction][2] = 0;
			FarmInfo[playerid][fAuction][3] = 0;
			FarmInfo[playerid][fAuction][4] = mktime(0,0,0,day+14,month,year);
		}
		case 31:
		{
		    if(!r) return printf("[Аукцион СТО/Ферм] Нет аккаунта. Деньги не были зачислены!");
		    mysql_format(MySql_Base, QUERY, 128, "UPDATE `"TABLE_ACCOUNTS"` SET pBank = pBank + %i WHERE Name = '%e'",FarmInfo[bizselect[playerid]][fAuction][1],FarmInfo[bizselect[playerid]][fAuctionName]);
			mysql_function_query(MySql_Base,QUERY,false,"","");
		}
		case 32:
		{
		    if(!r) return printf("[Загрузка ...] Данные из Stall не получены!");
		    for(x = 1; x <= r; x++)
		    {
		    	StallInfo[x][stID] = 				cache_get_row_int(x-1,0, MySql_Base);
		    	StallInfo[x][stPos][0] = 			cache_get_row_float(x-1,1, MySql_Base);
		    	StallInfo[x][stPos][1] = 			cache_get_row_float(x-1,2, MySql_Base);
		    	StallInfo[x][stPos][2] = 			cache_get_row_float(x-1,3, MySql_Base);
		    	StallInfo[x][stPos][3] = 			cache_get_row_float(x-1,4, MySql_Base);
		    	TOTALSTALL++;

		    	CreateDynamicObject(1340, StallInfo[x][stPos][0], StallInfo[x][stPos][1], StallInfo[x][stPos][2], 0, 0, StallInfo[x][stPos][3]);
		    	StallInfo[x][stText] = CreateDynamic3DTextLabel( "Не работает", 0xFF8C37FF, StallInfo[x][stPos][0], StallInfo[x][stPos][1], StallInfo[x][stPos][2], 8.0 );
			}
			printf("[Загрузка ...] Данные из Stall получены! (%i шт.)",TOTALSTALL);
		}
		case 33:
		{
		    if(!r) return printf("[Загрузка ...] Данные из Gangzone не получены!");
		    for(x = 1; x <= r; x++)
		    {
		    	GZInfo[x][gID] = 					cache_get_row_int(x-1,0, MySql_Base);
		    	GZInfo[x][gCoords][0] = 			cache_get_row_float(x-1,1, MySql_Base);
		    	GZInfo[x][gCoords][1] = 			cache_get_row_float(x-1,2, MySql_Base);
		    	GZInfo[x][gCoords][2] = 			cache_get_row_float(x-1,3, MySql_Base);
		    	GZInfo[x][gCoords][3] = 			cache_get_row_float(x-1,4, MySql_Base);
		    	GZInfo[x][gFrakVlad] = 				cache_get_row_int(x-1,5, MySql_Base);
		    	TOTALGZ++;

				GZInfo[x][gZone] = GangZoneCreate(GZInfo[x][gCoords][0],GZInfo[x][gCoords][1],GZInfo[x][gCoords][2],GZInfo[x][gCoords][3]);
			}
			printf("[Загрузка ...] Данные из Gangzone получены! (%i шт.)",TOTALGZ);
		}
		case 34:
		{
		    if(!r)
			{
			    mysql_format(MySql_Base, QUERY, sizeof(QUERY), "INSERT INTO `"TABLE_CARS"` (`owner`) VALUES ('%s')" ,PlayerInfo[playerid][pName]);
				mysql_function_query(MySql_Base,QUERY,false,"","");
				return SendClientMessage(playerid,COLOR_GREY,"Ошибка! Произошла ошибка с загрузкой автомобиля, перезайдите в игру!"), Kick(playerid);
			}
		    for(x = 0; x < r; x++)
		    {
		        CarInfo[playerid][carID][x] =          	cache_get_row_int(x,0, MySql_Base);
		        cache_get_row(x, 1, 			string, MySql_Base, MAX_PLAYER_NAME);
		        CarInfo[playerid][carModel][x] =       	cache_get_row_int(x,2, MySql_Base);
		        CarInfo[playerid][carColor_one][x] =   	cache_get_row_int(x,3, MySql_Base);
		        CarInfo[playerid][carColor_two][x] =   	cache_get_row_int(x,4, MySql_Base);
		        CarInfo[playerid][carPercent][x] =   	cache_get_row_int(x,5, MySql_Base);
		        CarInfo[playerid][carFuel][x] =   		cache_get_row_float(x,6, MySql_Base);
			}
		    if(HGet(playerid) != 0)
			{
				new house = GetPVarInt(playerid,"House");
				createdcar = house_car[playerid];
				house_car[playerid] = CreateVehicle(CarInfo[playerid][carModel][0], HouseInfo[house][hCarx], HouseInfo[house][hCary], HouseInfo[house][hCarz], HouseInfo[house][hCarc] , CarInfo[playerid][carColor_one][0] ,CarInfo[playerid][carColor_two][0], 86400);
				SetVehicleParamsEx(house_car[playerid],false,false,false,true,false,false,false);
				CarHealth[house_car[playerid]] = float(1000);
				createdcar ++;
				Fuell[house_car[playerid]] = CarInfo[playerid][carFuel][0];
				LoadTuning(playerid,house_car[playerid]);
			}
			printf("[Загрузка ...] Автомобили игрока %s были загружены!",string);
		}*/
	}
	return true;
}
stock SetPlayerSpawn(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	DollahScoreUpdate();
	ResetPlayerWeapons(playerid);
	SetPlayerWeapons(playerid);
    if (PlayerInfo[playerid][pZvezdi] >= 1)
	{
		SetPlayerWantedLevel(playerid,PlayerInfo[playerid][pZvezdi] );
	}
	if(PlayerInfo[playerid][pHP] > 100) PlayerInfo[playerid][pHP] = 100;
	SetPlayerHealthAC(playerid, PlayerInfo[playerid][pHP]);
	SetCameraBehindPlayer(playerid);
	if(gSpectateID[playerid] != INVALID_PLAYER_ID)
	{
	    gSpectateID[playerid] = INVALID_PLAYER_ID;
		SetPlayerPos(playerid,PosAdmin[playerid][0],PosAdmin[playerid][1],PosAdmin[playerid][2]);
		SetPlayerVirtualWorld(playerid,PosAdmins[playerid][0]);
		SetPlayerInterior(playerid,PosAdmins[playerid][1]);
		return 1;
	}
	if(PlayerInfo[playerid][pJailed] == 4)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,5508.3706,1244.7594,23.1886);
		return 1;
	}
	if(PlayerInfo[playerid][pJailed] == 1)
	{
		SetPlayerInterior(playerid, 6);
		SetPlayerPos(playerid,264.1425,77.4712,1001.0391);
		SetPlayerFacingAngle(playerid, 263.0160);
		return 1;
	}
	if(PlayerInfo[playerid][pJailed] == 2)
	{
		SetPlayerInterior(playerid, 10);
		SetPlayerPos(playerid,219.5400,109.9767,999.0156);
		SetPlayerFacingAngle(playerid, 1.0000);
		return 1;
	}
	if(PlayerInfo[playerid][pJailed] == 3)
	{
		SetPlayerInterior(playerid, 3);
		SetPlayerPos(playerid,198.3642,161.8103,1003.0300);
		SetPlayerFacingAngle(playerid, 1.0000);
		return 1;
	}
	switch(PlayerInfo[playerid][pMember])
	{
  		case 1:
		{
			SetPlayerInterior(playerid, 6);
			SetPlayerPos(playerid, 235.8750,73.5106,1005.0391);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
	    case 2:
	    {
				SetPlayerInterior(playerid, 5);
				SetPlayerPos(playerid, 322.4131, 316.9056, 999.1484);
				SetPlayerFacingAngle(playerid, 180.5557);
				SetPlayerVirtualWorld(playerid, 0);
				return true;
		}
		case 3:
		{
			if(forma[playerid] == 1)
			{
				SetPlayerSkin(playerid, 252);
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -1346.2050,492.3983,11.2027);
				SetPlayerVirtualWorld(playerid, 0);
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, -1346.2050,492.3983,11.2027);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		case 4:
		{
			SetPlayerInterior(playerid, 15);
			SetPlayerVirtualWorld(playerid, 2);
			SetPlayerPos(playerid, 187.7174,75.9044,1103.2693);
			SetPlayerFacingAngle(playerid,178.0000);
			return 1;
		}
		case 5:
		{
			SetPlayerInterior(playerid, 5);
			SetPlayerPos(playerid, 1265.7104,-793.7453,1084.0078);
			SetPlayerVirtualWorld(playerid, 2);
			return 1;
		}
		case 6:
		{
			SetPlayerInterior(playerid, 5);
			SetPlayerPos(playerid, 1265.7104,-793.7453,1084.0078);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		case 7:
		{
			SetPlayerInterior(playerid, 3);
			SetPlayerPos(playerid, 358.5969,207.5322,1008.3828);
			SetPlayerFacingAngle(playerid, 182.7769);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		case 9:
		{
			SetPlayerPos(playerid, -2050.8962,460.0262,35.1719);
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		case 10:
		{
			SetPlayerInterior(playerid, 10);
			SetPlayerPos(playerid, 225.1647,121.0442,999.0786);
			SetPlayerFacingAngle(playerid, 89.0733);
			return 1;
		}
		case 11:
		{
			SetPlayerPos(playerid, -2031.7778,-117.3789,1035.1719);
			SetPlayerFacingAngle(playerid, 268.5241);
			SetPlayerInterior(playerid,3);
			SetPlayerVirtualWorld(playerid, 1);
			return 1;
		}
		case 12:
		{
			SetPlayerPos(playerid, -61.2984,1364.5847,1080.2109);
			SetPlayerFacingAngle(playerid, 100);
			SetPlayerInterior(playerid,6);
			SetPlayerVirtualWorld(playerid, 34);
			return 1;
		}
		case 13:
		{
			SetPlayerInterior(playerid, 4);
			SetPlayerVirtualWorld(playerid, 75);
			SetPlayerFacingAngle(playerid, 263.0497);
			SetPlayerPos(playerid, 303.63,309.25,999.15);
			return 1;
		}
		case 14:
		{
			SetPlayerInterior(playerid, 5);
			SetPlayerPos(playerid, 1265.7104,-793.7453,1084.0078);
			SetPlayerVirtualWorld(playerid, 1);
			return 1;
		}
		case 15:
		{
			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid,  2496.012939,-1708.923217,1014.742187);
			SetPlayerFacingAngle(playerid, 0.191693);
			SetPlayerVirtualWorld(playerid, 1);
			return 1;
		}
		case 16:
		{
			SetPlayerPos(playerid, 1657.8879,-1693.1399,15.6094);
			SetPlayerInterior(playerid,0);
			SetPlayerFacingAngle(playerid, 174.8452);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		case 17:
		{
			SetPlayerFacingAngle(playerid, 90.4248);
			SetPlayerPos(playerid, -49.7558,1400.3553,1084.4297);
			SetPlayerInterior(playerid,8);
			SetPlayerVirtualWorld(playerid, 36);
			return 1;
		}
		case 18:
		{
			SetPlayerInterior(playerid, 18);
			SetPlayerVirtualWorld(playerid, 63);
			SetPlayerPos(playerid, -223.84,1410.51,27.77);
			if(IsPlayerAttachedObjectSlotUsed(playerid, 1))
			{
				RemovePlayerAttachedObject(playerid, 1);
			}
			return 1;
		}
		case 19:
		{
			if(forma[playerid] == 1)
			{
				SetPlayerSkin(playerid, 252);
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 241.7503,1852.6790,8.7578);
				SetPlayerVirtualWorld(playerid, 0);
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 241.7503,1852.6790,8.7578);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		case 20:
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 2652.3223,1182.2115,10.8203);
			SetPlayerFacingAngle(playerid, 178.0583);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		case 21:
		{
			SetPlayerInterior(playerid, 3);
			SetPlayerPos(playerid, 211.3636,184.3113,1003.0313);
			SetPlayerFacingAngle(playerid, 174.3579);
			SetPlayerVirtualWorld(playerid, 122);
			return 1;
		}
		case 22:
		{
			SetPlayerInterior(playerid, 15);
			SetPlayerVirtualWorld(playerid, 1);
			SetPlayerPos(playerid, 187.7174,75.9044,1103.2693);
			SetPlayerFacingAngle(playerid,178.0000);
			return 1;
		}
	}
	if(PlayerInfo[playerid][pLevel] >= 4 && PlayerInfo[playerid][pLevel] <= 11)//СФ
	{
		SetPlayerPos(playerid,-1968.7729,114.3221,27.6875);
		SetPlayerFacingAngle(playerid, 359.5770);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		return true;
	}
	else if(PlayerInfo[playerid][pLevel] >= 12 && PlayerInfo[playerid][pLevel] <= 100)//lv
	{
		SetPlayerPos(playerid,2853.6133,1291.7916,11.3906);
		SetPlayerFacingAngle(playerid,90.0000);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		return true;
	}
	else if(PlayerInfo[playerid][pLevel] >= 1 && PlayerInfo[playerid][pLevel] <= 3)//1 ЛС
	{
		SetPlayerPos(playerid,1220.9955,-1813.9452,16.5938);
		SetPlayerFacingAngle(playerid, 180.0000);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);
		return true;
	}
	SetPlayerPos(playerid,1220.9955,-1813.9452,16.5938);
	SetPlayerFacingAngle(playerid, 180.0000);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid, 0);
	return true;
}
stock Now()
{
  new hour,minute,second;
  new year, month,day;
  gettime(hour, minute, second);
  getdate(year, month, day);
  return mktime(hour,minute,second,day,month,year);
}
stock Mon(months)
{
	new mon[5];
  	switch(months)
	{
		case 1: mon = "Янв";
		case 2: mon = "Фев";
		case 3: mon = "Мар";
		case 4: mon = "Апр";
		case 5: mon = "Мая";
		case 6: mon = "Июн";
		case 7: mon = "Июл";
		case 8: mon = "Авг";
		case 9: mon = "Сен";
		case 10: mon = "Окт";
		case 11: mon = "Нояб";
		case 12: mon = "Дек";
	}
	return mon;
}
stock timestamp_to_date
(
	unix_timestamp = 0,

	& year = 1970,		& month  = 1,		& day    = 1,
	& hour =    0,		& minute = 0,		& second = 0
)
{
	year = unix_timestamp / 31536000;
	unix_timestamp -= year * 31536000;
	year += 1970;

    new days_of_month[12];

	if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) {
			days_of_month = {31,29,31,30,31,30,31,31,30,31,30,31};
		} else {
			days_of_month = {31,28,31,30,31,30,31,31,30,31,30,31};
		}
	if(month > 1) {
		for(new i=0; i<month-1;i++) {
			unix_timestamp -= days_of_month[i];
		}
	}

	day = unix_timestamp / 86400;

	switch ( day )
	{
		case    0..30 : { second = day;       month =  1; }
		case   31..58 : { second = day -  31; month =  2; }
		case   59..89 : { second = day -  59; month =  3; }
		case  90..119 : { second = day -  90; month =  4; }
		case 120..150 : { second = day - 120; month =  5; }
		case 151..180 : { second = day - 151; month =  6; }
		case 181..211 : { second = day - 181; month =  7; }
		case 212..242 : { second = day - 212; month =  8; }
		case 243..272 : { second = day - 243; month =  9; }
		case 273..303 : { second = day - 273; month = 10; }
		case 304..333 : { second = day - 304; month = 11; }
		case 334..366 : { second = day - 334; month = 12; }
	}

	unix_timestamp -= day * 86400;
	hour = unix_timestamp / 3600;

	unix_timestamp -= hour * 3600;
	minute = unix_timestamp / 60;

	unix_timestamp -= minute * 60;
	day = second;
	second = unix_timestamp;
}
stock mktime(hour,minute,second,day,month,year) {
	new timestamp2;

	timestamp2 = second + (minute * 60) + (hour * 3600);

	new days_of_month[12];

	if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) {
			days_of_month = {31,29,31,30,31,30,31,31,30,31,30,31};
		} else {
			days_of_month = {31,28,31,30,31,30,31,31,30,31,30,31};
		}
	new days_this_year = 0;
	days_this_year = day;
	if(month > 1) {
		for(new i=0; i<month-1;i++) {
			days_this_year += days_of_month[i];
		}
	}
	timestamp2 += days_this_year * 86400;

	for(new j=1970;j<year;j++) {
		timestamp2 += 31536000;
		if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )  timestamp2 += 86400;
	}

	return timestamp2;
}
stock RemoveBuilding(playerid)
{
	//======================== Удалённые обьекты ===============================
	RemoveBuildingForPlayer(playerid, 1231, 1479.6953, -1716.7031, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.6953, -1702.5313, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.3828, -1692.3906, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.3828, -1682.3125, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.6953, -1716.7031, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.6953, -1702.5313, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.3828, -1692.3906, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.3828, -1682.3125, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1704.5938, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1704.6406, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1713.5078, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1713.7031, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1704.6406, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1694.0469, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1682.7188, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1704.5938, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1693.7344, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1682.6719, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 11372, -2076.4375, -107.9297, 36.9688, 0.25);
    RemoveBuildingForPlayer(playerid, 11372, -2076.4375, -107.9297, 36.9688, 0.25);//АШ
    RemoveBuildingForPlayer(playerid, 11014, -2076.4375, -107.9297, 36.9688, 0.25);//АШ
    RemoveBuildingForPlayer(playerid, 11099, -2056.9922, -184.5469, 34.4141, 0.25);
    return 1;
}
stock ShowStats(playerid,targetid)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(targetid))
	{
		new atext[14],jtext[20],adrank[20],viprank[20];
		switch(PlayerInfo[targetid][pSex])
		{
		    case 1: atext = "Мужчина";
		    case 2: atext = "Женщина";
  		}
		switch(PlayerInfo[targetid][pJob])
		{
			case 0: jtext = "Безработный";
			case 1: jtext = "Водитель автобуса";
			case 2: jtext = "Таксист";
			case 3: jtext = "Механик";
			case 4: jtext = "Продавец хот-догов";
			case 5: jtext = "Развозчик продуктов";
			case 6: jtext = "Тренер";
		}
		switch(PlayerInfo[targetid][pLevel])
		{
			case 1: adrank = "Новичок";
			case 2,3: adrank = "Начинающий игрок";
			case 4,5: adrank = "Уверенный игрок";
			case 6: adrank = "Постоянный игрок";
			case 7..21: adrank = "Освоившийся игрок";
			case 22..40: adrank = "Дед";
			case 41..65: adrank = "Житель";
			case 66..80: adrank = "Легенда";
		}
		switch(PlayerInfo[playerid][pVIP])
		{
		    case 1: viprank = "{ce7d31}BRONZE VIP";
		    case 2: viprank = "{C0C0C0}SILVER VIP";
		    case 3: viprank = "{ffd700}GOLD VIP";
		    default: viprank = "-";
  		}
	    new warrests = PlayerInfo[targetid][pWantedDeaths];
		new drugs = PlayerInfo[targetid][pDrugs];
		new mats = PlayerInfo[targetid][pMats];
		new wanted = PlayerInfo[targetid][pZvezdi];
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new playerip[144];
		GetPlayerIp(targetid, playerip, sizeof(playerip));
		new coordsstring[1200];
		new msg[] = "Имя:\t\t\t\t%s\n\nУровень:\t\t\t%d\nExp:\t\t\t\t%d/%d\nДеньги:\t\t\t%d\nТелефон:\t\t\t%d\nДата регистрации:\t\t%s\nЗаконопослушность:\t\t%d\nНаркозависимость:\t\t%d\nПреступлений:\t\t%d\nАрестов:\t\t\t%d\nСмертей в розыске:\t\t%d\nУровень розыска:\t\t%d\nНаркотики:\t\t\t%d\nМатериалы:\t\t\t%d\nЧасов в игре:\t\t\t%d\n\nОрганизация:\t\t\t%s\nРанг:\t\t\t\t%s\nРабота:\t\t\t%s\nСтатус:\t\t\t\t%s\nVIP Статус:\t\t\t%s\n{abcdef}Жена/Муж:\t\t\t%s\nПол:\t\t\t\t%s";
		format(coordsstring, sizeof(coordsstring), msg,GN(targetid),PlayerInfo[targetid][pLevel],PlayerInfo[targetid][pExp],nxtlevel*4,PlayerInfo[targetid][pCash],PlayerInfo[targetid][pPnumber],PlayerInfo[targetid][pDataReg],PlayerInfo[targetid][pZakonp],PlayerInfo[targetid][pNarcoZavisimost],PlayerInfo[targetid][pKills],PlayerInfo[targetid][pArrested],warrests,wanted,drugs,mats,PlayerInfo[targetid][pPayDay],GetFrac(PlayerInfo[targetid][pMember]),GetRank(targetid),jtext,adrank,viprank,"-",atext);
		SPD(playerid,0,DIALOG_STYLE_MSGBOX, "Статистика персонажа",coordsstring, "Ок", "");
	}
}
stock SetPlayerToTeamColor(playerid)
{
	switch(PlayerInfo[playerid][pMember])
	{
	case 0:	SetPlayerColor(playerid, 0xFFFFFF00);
	case 1: SetPlayerColor(playerid, 0x110CE7FF);
	case 2: SetPlayerColor(playerid, 0x313131AA);
	case 3: SetPlayerColor(playerid, 0x33AA33FF);
	case 4: SetPlayerColor(playerid, 0xA52A2AFF);
	case 5: SetPlayerColor(playerid, 0xDDA701FF);
	case 6: SetPlayerColor(playerid, 0xFF0000AA);
	case 7: SetPlayerColor(playerid, 0x114D71FF);
	case 8: SetPlayerColor(playerid, 0xFF830000);
	case 9: SetPlayerColor(playerid, 0x110CE7FF);
	case 10: SetPlayerColor(playerid, 0x139BECFF);
	case 11: SetPlayerColor(playerid, 0xB313E7FF);
	case 12: SetPlayerColor(playerid, 0xDBD604AA);
	case 13: SetPlayerColor(playerid, 0xB4B5B7FF);
	case 14: SetPlayerColor(playerid, 0x009F00AA);
	case 15: SetPlayerColor(playerid, 0x40848BAA);
	case 16: SetPlayerColor(playerid, 0x01FCFFC8);
	case 17: SetPlayerColor(playerid, 0x2A9170FF);
	case 18: SetPlayerColor(playerid, 0x33AA33FF);
	case 19: SetPlayerColor(playerid, 0xE6284EFF);
	case 20: SetPlayerColor(playerid, 0x110CE7FF);
	case 21: SetPlayerColor(playerid, 0xA52A2AFF);
	case 22: SetPlayerColor(playerid, 0x9ED201FF);
	case 23: SetPlayerColor(playerid, 0x49E789FF);
	case 24: SetPlayerColor(playerid, 0xF45000FF);
	}
	return true;
}
stock CreateVehicles()
{
	//===================== Medic LS ===========================================
	medicsls[0] = AddStaticVehicleEx(416,2036.0380,-1431.6392,17.2115,125.7160,1,6,600);
	medicsls[1] = AddStaticVehicleEx(416,2036.0978,-1425.8446,17.1702,127.2091,1,6,600);
	medicsls[2] = AddStaticVehicleEx(416,2030.8522,-1411.8403,17.1509,133.0324,1,6,600);
	medicsls[3] = AddStaticVehicleEx(416,2025.4503,-1410.4629,17.1323,131.3420,1,6,600);
	medicsls[4] = AddStaticVehicleEx(416,2020.4955,-1410.5007,17.1438,130.1588,1,6,600);
	medicsls[5] = AddStaticVehicleEx(416,2034.9678,-1420.1104,17.1428,132.0959,1,6,600);
	medicsls[6] = AddStaticVehicleEx(487,2008.2000000,-1414.3000000,17.3000000,270.0000000,1,6,600);
	//===================== Medic SF ===========================================
	medicssf[0] = AddStaticVehicleEx(416,-2665.4248,611.2086,14.6056,179.5688,1,3,600);
	medicssf[1] = AddStaticVehicleEx(416,-2661.2083,611.0942,14.6027,180.4825,1,3,600);
	medicssf[2] = AddStaticVehicleEx(416,-2669.6826,611.1447,14.5899,180.8062,1,3,600);
	medicssf[3] = AddStaticVehicleEx(416,-2617.8303,627.9868,14.6024,89.7837,1,3,600);
	medicssf[4] = AddStaticVehicleEx(416,-2617.8972,621.3510,14.6023,89.8205,1,3,600);
	medicssf[5] = AddStaticVehicleEx(416,-2706.2029,590.4933,14.6021,270.0135,1,3,600);
	medicssf[6] = AddStaticVehicleEx(416,-2706.2490,595.5879,14.6025,270.1201,1,3,600);
	medicssf[7] = AddStaticVehicleEx(487,-2703.4836,622.4868,14.6662,176.4144,1,3,600);
	//=================== Авианосец ============================================
	armysfcar[0] = AddStaticVehicleEx(520,-1430.4078,508.1596,18.9400,269.6329,1,1,600);
	armysfcar[1] = AddStaticVehicleEx(520,-1419.9038,493.5340,18.9350,269.6848,1,1,600);
	armysfcar[2] = AddStaticVehicleEx(520,-1398.6207,507.7513,18.9328,269.8143,1,1,600);
	armysfcar[3] = AddStaticVehicleEx(430,-1441.8682,504.9640,-0.1769,90.9145,46,26,600);
	armysfcar[4] = AddStaticVehicleEx(430,-1444.5718,497.6307,-0.2322,87.5099,46,26,600);
	armysfcar[5] = AddStaticVehicleEx(425,-1321.2970,451.5090,10.1526,359.4870,1,1,600);
	armysfcar[6] = AddStaticVehicleEx(497,-1257.3179,506.7929,18.4118,90.7347,44,0,600);
	armysfcar[7] = AddStaticVehicleEx(497,-1257.3862,494.6516,18.4108,90.0316,44,0,600);
	armysfcar[8] = AddStaticVehicleEx(470,-1353.6660,456.1287,7.1822,358.8921,0,0,600);
	armysfcar[9] = AddStaticVehicleEx(470,-1359.6062,456.1287,7.1794,0.0182,0,0,600);
	armysfcar[10] = AddStaticVehicleEx(470,-1365.3795,456.1287,7.1801,358.6357,0,0,600);
	armysfcar[11] = AddStaticVehicleEx(470,-1371.9751,456.1287,6.9083,0.0272,44,86,600);
	armysfcar[12] = AddStaticVehicleEx(470,-1377.7911,456.1287,6.9080,357.9779,44,86,600);
	armysfcar[13] = AddStaticVehicleEx(470,-1353.6660,478.0123,7.1810,177.4524,0,0,600);
	armysfcar[14] = AddStaticVehicleEx(470,-1359.6062,478.0123,7.1810,177.4524,0,0,600);
	armysfcar[15] = AddStaticVehicleEx(470,-1365.3795,478.0123,7.1810,177.4524,0,0,600);
	armysfcar[16] = AddStaticVehicleEx(470,-1371.9751,478.0123,7.1810,177.4524,0,0,600);
	armysfcar[17] = AddStaticVehicleEx(470,-1377.7911,478.0123,7.1810,177.4524,0,0,600);
	armysfcar[18] = AddStaticVehicleEx(470,-1477.1115,456.0595,7.1790,359.7971,0,0,600); 
	armysfcar[19] = AddStaticVehicleEx(470,-1473.1115,456.0595,7.1790,359.7971,0,0,600);
	armysfcar[20] = AddStaticVehicleEx(470,-1469.1115,456.0595,7.1790,359.7971,0,0,600);
	armysfcar[21] = AddStaticVehicleEx(470,-1465.1115,456.0595,7.1790,359.7971,0,0,600);
	armysfcar[22] = AddStaticVehicleEx(470,-1461.1115,456.0595,7.1790,359.7971,0,0,600);
	armysfcar[23] = AddStaticVehicleEx(432,-1248.5941,448.6846,7.1821,0.0000,0,0,600);
	armysfcar[24] = AddStaticVehicleEx(432,-1282.9900,448.6846,7.1821,0.0000,0,0,600);
	armysfcar[25] = AddStaticVehicleEx(432,-1269.6067,448.6846,7.1821,0.0000,0,0,600);
	armysfcar[26] = AddStaticVehicleEx(432,-1237.2456,448.6846,7.1821,0.0000,0,0,600);
	armysfcar[27] = AddStaticVehicleEx(548,-1273.7179,508.1303,19.8787,225.6477,1,0,600);
	armysfcar[28] = AddStaticVehicleEx(548,-1283.0133,494.4178,19.8151,225.4538,0,0,600);
	//=================== Army LV ==============================================
	armylvcar[0] = AddStaticVehicleEx(470,298.3018,1853.6997,17.6648,302.8787,0,0,600);
	armylvcar[1] = AddStaticVehicleEx(470,298.1906,1857.8590,17.6334,301.2071,1,0,600);
	armylvcar[2] = AddStaticVehicleEx(470,298.2596,1862.0547,17.6329,303.9269,1,0,600);
	armylvcar[3] = AddStaticVehicleEx(470,298.1759,1866.6698,17.6342,307.5489,0,0,600);
	armylvcar[4] = AddStaticVehicleEx(470,298.1513,1871.1449,17.6326,308.8005,1,0,600);
	armylvcar[5] = AddStaticVehicleEx(425,288.3243,1928.8093,18.2336,275.8014,37,37,600);
	armylvcar[6] = AddStaticVehicleEx(432,277.2724,2030.6893,17.6550,268.4021,0,0,600);
	armylvcar[7] = AddStaticVehicleEx(432,276.9091,2017.6702,18.0319,268.4021,0,0,600);
	armylvcar[8] = AddStaticVehicleEx(520,314.8157,2052.8928,18.6702,181.2181,0,0,600);
	armylvcar[9] = AddStaticVehicleEx(520,302.6985,2052.6353,18.6702,181.2181,0,0,600);
	armylvcar[10] = AddStaticVehicleEx(500,221.9194,1855.0072,13.0356,1.6078,77,77,600);
	armylvcar[11] = AddStaticVehicleEx(500,217.1713,1854.8744,13.0242,1.6078,77,77,600);
	armylvcar[12] = AddStaticVehicleEx(500,212.6617,1854.7483,13.0134,1.6078,77,77,600);
	armylvcar[13] = AddStaticVehicleEx(500,203.7943,1862.3488,13.2462,271.1720,77,77,600);
	armylvcar[14] = AddStaticVehicleEx(500,203.7240,1866.9736,13.2801,271.3324,77,77,600);
	armylvcar[15] = AddStaticVehicleEx(500,203.5927,1872.2008,13.2459,271.1720,77,77,600);
	armylvcar[16] = AddStaticVehicleEx(497,144.9689,1950.7150,29.1754,359.9992,44,44,600);
	armylvcar[17] = AddStaticVehicleEx(497,135.1045,1950.7152,29.1515,359.9985,44,44,600);
	armylvcar[18] = AddStaticVehicleEx(470,317.5983,1796.7000,17.6335,359.8372,0,0,600);
	armylvcar[19] = AddStaticVehicleEx(470,312.3935,1796.7180,17.6630,359.8343,0,0,600);
	armylvcar[20] = AddStaticVehicleEx(470,307.3818,1796.7289,17.6332,359.8372,0,0,600);
	armylvcar[21] = AddStaticVehicleEx(470,301.5827,1796.7452,17.6331,359.8372,0,0,600);
	matslvcar[0] = AddStaticVehicleEx(433,275.2985,1982.4747,18.0773,269.3129,34,34,600);
	matslvcar[1] = AddStaticVehicleEx(433,275.2985,1989.3337,18.0773,269.3129,34,34,600);
	matslvcar[2] = AddStaticVehicleEx(433,275.2985,1996.5306,18.0773,269.3129,34,34,600);
	matslvcar[3] = AddStaticVehicleEx(433,275.2985,1955.9137,18.0773,270.4897,1,0,600);
	matslvcar[4] = AddStaticVehicleEx(433,275.2985,1962.6503,18.0773,268.7370,1,0,600);
	matslvcar[5] = AddStaticVehicleEx(433,275.2985,1948.6509,18.0772,270.1710,1,0,600);
	//======================== LSPD ============================================
	lspdcar[0] = AddStaticVehicleEx(596,1591.1188,-1710.8458,5.6106,359.9953,1,79,600);
	lspdcar[1] = AddStaticVehicleEx(596,1587.0615,-1710.8457,5.6106,359.9914,1,79,600);
	lspdcar[2] = AddStaticVehicleEx(596,1582.9340,-1710.8418,5.6106,359.9973,1,79,600);
	lspdcar[3] = AddStaticVehicleEx(596,1578.0387,-1710.8459,5.6106,359.9960,1,79,600);
	lspdcar[4] = AddStaticVehicleEx(596,1574.0431,-1710.8464,5.6115,359.9565,1,79,600);
	lspdcar[5] = AddStaticVehicleEx(596,1569.6342,-1710.8481,5.5788,359.9579,1,79,600);
	lspdcar[6] = AddStaticVehicleEx(596,1558.3914,-1710.8352,5.6231,359.9962,1,79,600);
	lspdcar[7] = AddStaticVehicleEx(601,1545.4475,-1659.0334,5.6477,89.9272,1,1,600);
	lspdcar[8] = AddStaticVehicleEx(601,1545.4456,-1655.0054,5.6652,89.9993,1,1,600);
	lspdcar[9] = AddStaticVehicleEx(523,1545.6881,-1684.3760,5.4628,89.8548,1,1,600);
	lspdcar[10] = AddStaticVehicleEx(523,1545.6832,-1680.3370,5.4628,90.0000,1,1,600);
	lspdcar[11] = AddStaticVehicleEx(523,1545.6796,-1676.2489,5.4715,90.0000,1,1,600);
	lspdcar[12] = AddStaticVehicleEx(523,1545.6934,-1672.1342,5.4719,90.0000,1,1,600);
	lspdcar[13] = AddStaticVehicleEx(523,1545.7043,-1667.6414,5.4657,89.5909,1,1,600);
	lspdcar[14] = AddStaticVehicleEx(523,1545.6930,-1663.1404,5.4719,90.0000,1,1,600);
	lspdcar[15] = AddStaticVehicleEx(427,1538.1487,-1644.9996,6.0336,180.0003,1,79,600);
	lspdcar[16] = AddStaticVehicleEx(427,1534.1730,-1644.9996,6.0335,180.0002,1,79,600);
	lspdcar[17] = AddStaticVehicleEx(427,1529.9532,-1644.9991,6.0335,180.0003,1,79,600);
	lspdcar[18] = AddStaticVehicleEx(497,1551.7830,-1609.5548,13.5595,270.2284,1,79,600);
	lspdcar[19] = AddStaticVehicleEx(596,1595.4469,-1710.8026,5.6111,358.9272,1,79,600);
	//===================== SFPD ===============================================
	sfpdcar[0] = AddStaticVehicleEx(427,-1638.7850,653.7558,-5.1094,271.5658,1,86,600);
	sfpdcar[1] = AddStaticVehicleEx(427,-1638.8691,657.6266,-5.1104,271.5658,1,86,600);
	sfpdcar[2] = AddStaticVehicleEx(427,-1638.9778,661.6664,-5.1103,271.5658,1,86,600);
	sfpdcar[3] = AddStaticVehicleEx(427,-1639.0596,666.1422,-5.1103,271.5658,1,86,600);
	sfpdcar[4] = AddStaticVehicleEx(427,-1639.1912,670.1107,-5.1098,271.5658,1,86,600);
	sfpdcar[5] = AddStaticVehicleEx(597,-1572.8290,706.1410,-5.4730,89.0081,1,86,600); // sfpd1
	sfpdcar[6] = AddStaticVehicleEx(597,-1572.8290,718.2328,-5.4730,91.4521,1,86,600); // sfpd2
	sfpdcar[7] = AddStaticVehicleEx(597,-1572.8290,722.4382,-5.4730,89.6536,1,86,600); // sfpd3
	sfpdcar[8] = AddStaticVehicleEx(597,-1572.8290,726.4822,-5.4730,90.0279,1,86,600); // sfpd4
	sfpdcar[9] = AddStaticVehicleEx(597,-1572.8290,730.6655,-5.4730,90.4054,1,86,600); // sfpd5
	sfpdcar[10] = AddStaticVehicleEx(597,-1572.8290,734.6075,-5.4730,91.1203,1,86,600); // sfpd6
	sfpdcar[11] = AddStaticVehicleEx(597,-1572.8290,738.8035,-5.4730,90.8076,1,86,600); // sfpd7
	sfpdcar[12] = AddStaticVehicleEx(597,-1572.8290,742.5992,-5.4730,88.9938,1,86,600); // sfpd8
	sfpdcar[13] = AddStaticVehicleEx(497,-1680.9225,705.6724,30.7915,95.5060,1,86,600);
	sfpdcar[14] = AddStaticVehicleEx(523,-1600.0845,692.3514,-5.6700,180.5546,3,3,600);
	sfpdcar[15] = AddStaticVehicleEx(523,-1603.5908,692.3514,-5.6700,180.5546,3,3,600);
	sfpdcar[16] = AddStaticVehicleEx(523,-1608.4457,692.3514,-5.6700,180.5546,3,3,600);
	sfpdcar[17] = AddStaticVehicleEx(523,-1611.6722,692.3514,-5.6701,180.5546,3,3,600);
	sfpdcar[18] = AddStaticVehicleEx(523,-1616.8567,692.3514,-5.6723,177.3526,3,3,600);
	sfpdcar[19] = AddStaticVehicleEx(523,-1620.4467,692.3514,-5.6723,177.3526,3,3,600);
	sfpdcar[20] = AddStaticVehicleEx(523,-1624.2755,692.3514,-5.6723,177.3526,3,3,600);
	sfpdcar[21] = AddStaticVehicleEx(523,-1629.6143,692.3514,-5.6722,177.3526,3,3,600);
	sfpdcar[22] = AddStaticVehicleEx(523,-1632.7988,692.3514,-5.6722,177.3526,3,3,600);
	//=============== LVPD =====================================================
	lvpdcar[0] = AddStaticVehicleEx(598,2268.9678,2443.6958,10.5668,359.5409,1,17,600);
	lvpdcar[1] = AddStaticVehicleEx(598,2273.5706,2443.7290,10.5665,0.6987,1,17,600);
	lvpdcar[2] = AddStaticVehicleEx(598,2277.9482,2443.7490,10.5654,359.8027,1,17,600);
	lvpdcar[3] = AddStaticVehicleEx(598,2282.1309,2443.7957,10.5660,359.7104,1,17,600);
	lvpdcar[4] = AddStaticVehicleEx(598,2282.5002,2476.4595,10.5663,181.3129,1,17,600);
	lvpdcar[5] = AddStaticVehicleEx(598,2277.6665,2476.5178,10.5670,180.8092,1,17,600);
	lvpdcar[6] = AddStaticVehicleEx(598,2273.6030,2476.5684,10.5669,180.3357,1,17,600);
	lvpdcar[7] = AddStaticVehicleEx(598,2268.8853,2476.6331,10.5663,179.7468,1,17,600);
	lvpdcar[8] = AddStaticVehicleEx(598,2269.2004,2459.8330,10.5683,0.1298,1,17,600);
	lvpdcar[9] = AddStaticVehicleEx(598,2273.3623,2459.5422,10.5661,178.7547,1,17,600);
	lvpdcar[10] = AddStaticVehicleEx(598,2278.0513,2459.7075,10.5667,359.0662,1,17,600);
	lvpdcar[11] = AddStaticVehicleEx(598,2281.9307,2459.4504,10.5672,180.7914,1,17,600);
	lvpdcar[12] = AddStaticVehicleEx(599,2290.6970,2443.7861,11.0110,1.2899,1,17,600);
	lvpdcar[13] = AddStaticVehicleEx(599,2260.5859,2476.3032,11.0123,180.0692,1,17,600);
	lvpdcar[14] = AddStaticVehicleEx(497,2271.4736,2470.6799,38.8604,0.0013,1,17,600);
	//====================== FBI ===============================================
	fbicar[0] = AddStaticVehicleEx(490,-2429.6814,515.0826,30.0575,216.1757,0,0,600); // fbi1
	fbicar[1] = AddStaticVehicleEx(490,-2425.7739,518.4011,30.0572,221.9951,0,0,600); // fbi2
	fbicar[2] = AddStaticVehicleEx(490,-2422.2585,521.5679,30.0578,224.3326,0,0,600); // fbi3
	fbicar[3] = AddStaticVehicleEx(490,-2419.0886,524.8534,30.0576,231.1069,0,0,600); // fbi4
	fbicar[4] = AddStaticVehicleEx(490,-2416.6873,528.4308,30.0567,237.6759,0,0,600); // fbi5
	fbicar[5] = AddStaticVehicleEx(490,-2414.7859,532.1597,30.0540,248.3943,0,0,600); // fbi6
	fbicar[6] = AddStaticVehicleEx(490,-2413.7236,535.8014,30.0558,257.1161,0,0,600); // fbi7
	fbicar[7] = AddStaticVehicleEx(490,-2413.5222,539.9651,30.0604,268.5739,0,0,600); // fbi8
	fbicar[8] = AddStaticVehicleEx(487,-2469.8752,495.2847,30.2099,279.2241,0,0,600);
	//=================== SF News ==============================================
	sfnewscar[0] = AddStaticVehicleEx(582,-2031.1930,459.3309,35.2332,1.0561,1,16,600);
	sfnewscar[1] = AddStaticVehicleEx(582,-2022.5162,459.3569,35.2286,359.1067,1,16,600);
	sfnewscar[2] = AddStaticVehicleEx(582,-2056.8635,469.9971,35.2334,270.9870,1,16,600);
	sfnewscar[3] = AddStaticVehicleEx(582,-2051.2991,478.6587,35.2299,269.6934,1,16,600);
	sfnewscar[4] = AddStaticVehicleEx(582,-2051.2991,487.4715,35.2243,269.5258,1,16,600);
	sfnewscar[5] = AddStaticVehicleEx(488,-2060.9878,442.0086,139.9191,270.0095,11,16,600);
	//================== LS News ===============================================
	lsnewscar[0] = CreateVehicle(582,1668.2490,-1699.8988,15.6692,91.7245,1,2,600);
	lsnewscar[1] = CreateVehicle(582,1668.3706,-1705.5723,15.6659,91.7245,1,2,600);
	lsnewscar[2] = CreateVehicle(582,1668.7556,-1711.6621,15.6669,91.7245,1,2,600);
	lsnewscar[3] = CreateVehicle(582,1668.5909,-1718.2150,15.6650,91.7245,1,2,600);
	lsnewscar[4] = CreateVehicle(582,1667.6899,-1694.3616,15.6655,91.7245,1,2,600);
	lsnewscar[5] = CreateVehicle(488,1654.3325,-1637.6818,83.9478,360.0000,1,2,600);
	//=================== LV News ==============================================
	lvnewscar[0] = CreateVehicle(488,2647.3130,1214.7228,27.0833,179.9999,1,3,600);
	lvnewscar[1] = CreateVehicle(582,2639.1929,1167.8363,10.8775,33.1387,1,3,600);
	lvnewscar[2] = CreateVehicle(582,2646.3479,1168.2446,10.8790,34.0851,1,3,600);
	lvnewscar[3] = CreateVehicle(582,2653.7300,1169.2220,10.8752,35.7964,1,3,600);
	lvnewscar[4] = CreateVehicle(582,2660.8367,1168.9835,10.8743,33.8417,1,3,600);
	lvnewscar[5] = CreateVehicle(582,2666.9121,1169.7819,10.8752,34.9291,1,3,600);
	//================== Mayor =================================================
	govcar[0] =	AddStaticVehicleEx(421,1403.8197,-1783.1687,13.4294,55.2259,1,1,600);
	govcar[1] =	AddStaticVehicleEx(421,1403.0786,-1788.5404,13.4294,61.3711,1,1,600);
	govcar[2] =	AddStaticVehicleEx(421,1402.4175,-1795.5847,13.4294,63.5499,1,1,600);
	govcar[3] = AddStaticVehicleEx(409,1403.8895,-1777.7913,13.3469,60.2217,1,1,600);
	govcar[4] = AddStaticVehicleEx(421,1402.2646,-1800.3992,13.4294,59.6144,1,1,600);
	//====================== Автошкола =========================================
	liccar[0] = AddStaticVehicleEx(560,-2017.7323,-273.1447,35.0256,18.3781,6,6,600);
	liccar[1] = AddStaticVehicleEx(560,-2023.0665,-273.2216,35.0269,16.2995,6,6,600); //
    liccar[2] = AddStaticVehicleEx(560,-2028.4407,-273.0050,35.0325,17.2900,6,6,600); //
    liccar[3] = AddStaticVehicleEx(560,-2033.5422,-272.8250,35.0271,16.0755,6,6,600); //
    liccar[4] = AddStaticVehicleEx(560,-2038.5974,-272.7736,35.0253,17.1697,6,6,600); //
    liccar[5] = AddStaticVehicleEx(560,-2065.0977,-273.3770,35.0256,17.7838,6,6,600); //
    liccar[6] = AddStaticVehicleEx(560,-2054.5669,-273.1823,34.9782,19.4303,6,6,600); //
    liccar[7] = AddStaticVehicleEx(560,-2059.4128,-273.2928,34.9771,17.7735,6,6,600); //
    liccar[8] = AddStaticVehicleEx(560,-2049.2651,-272.8500,35.0256,15.4907,6,6,600);
	liccar[9] = AddStaticVehicleEx(487,-2081.1084,-121.2365,37.8954,271.0987,6,1,600);
	//========================= Aztec ==========================================
	azteccar[0] = AddStaticVehicleEx(534,1800.4995,-2118.9902,13.2414,314.5162,2,1,600);
	azteccar[1] = AddStaticVehicleEx(534,1810.9294,-2119.4177,13.2308,308.3774,2,1,600);
	azteccar[2] = AddStaticVehicleEx(567,1816.9189,-2124.5601,13.3774,230.6176,2,1,600);
	azteccar[3] = AddStaticVehicleEx(471,1790.7340,-2121.8611,13.0335,359.4933,2,1,600);
	azteccar[4] = AddStaticVehicleEx(471,1795.7632,-2121.9548,13.0343,0.0722,2,1,600);
	azteccar[5] = AddStaticVehicleEx(567,1814.7736,-2127.8967,13.4253,224.6898,2,1,600);
	matsfuraaztek[0] = AddStaticVehicleEx(482,1793.6886,-2131.9268,13.6988,0.5931,2,1,600);
	//======================= Вагос ============================================
	vagoscar[0] = AddStaticVehicleEx(576,2782.1636,-1623.6354,10.6842,329.0284,6,1,600);
	vagoscar[1] = AddStaticVehicleEx(576,2786.2476,-1623.0164,10.6844,329.1863,6,1,600);
	vagoscar[2] = AddStaticVehicleEx(474,2771.5493,-1615.1803,10.6637,270.9191,6,1,600);
	vagoscar[3] = AddStaticVehicleEx(474,2771.5737,-1606.5190,10.6637,270.9191,6,1,600);
	vagoscar[4] = AddStaticVehicleEx(471,2779.3840,-1602.6355,10.3996,179.9934,6,1,600);
	vagoscar[5] = AddStaticVehicleEx(471,2776.4170,-1603.0439,10.4031,187.7903,6,1,600);
	vagoscar[6] = AddStaticVehicleEx(576,2796.9263,-1608.9607,10.8690,337.0240,6,1,600);
	matsfuravagos[0] = AddStaticVehicleEx(482,2771.7048,-1610.7338,11.0415,270.4145,6,1,600);
	//=================== Грув стрит ===========================================
	grovecar[0] = AddStaticVehicleEx(492,2469.6772,-1671.0565,13.1814,13.2198,86,86,600);
	grovecar[1] = AddStaticVehicleEx(492,2509.2651,-1672.5288,13.1906,342.6730,86,86,600);
	grovecar[2] = AddStaticVehicleEx(492,2488.3328,-1684.1450,13.1991,85.5844,86,86,600);
	grovecar[3] = AddStaticVehicleEx(492,2506.2107,-1678.6152,13.2417,324.9343,86,86,600);
	grovecar[4] = AddStaticVehicleEx(471,2499.2139,-1653.4569,12.9358,162.2846,86,86,600);
	grovecar[5] = AddStaticVehicleEx(471,2496.9739,-1653.1532,12.9252,169.0225,86,86,600);
	grovecar[6] = AddStaticVehicleEx(600,2474.3723,-1692.1406,13.2249,1.0014,86,86,600);
	matsfuragrove[0] = AddStaticVehicleEx(482,2505.2205,-1694.3320,13.6723,358.9510,86,86,600);
	//=================== Rifa =================================================
	rifacar[0] = AddStaticVehicleEx(529,2190.4048,-1807.8641,13.0520,58.1347,93,93,600);
	rifacar[1] = AddStaticVehicleEx(529,2190.6704,-1803.1378,13.0552,61.6798,93,93,600);
	rifacar[2] = AddStaticVehicleEx(471,2156.6770,-1789.7209,13.0004,221.2595,93,93,600);
	rifacar[3] = AddStaticVehicleEx(471,2160.3552,-1789.6399,12.9993,219.7650,93,93,600);
	rifacar[4] = AddStaticVehicleEx(419,2165.5952,-1809.8390,13.3242,330.2465,93,93,600);
	rifacar[5] = AddStaticVehicleEx(419,2169.3149,-1810.7394,13.3190,330.9067,93,93,600);
	matsfurarifa[0] = AddStaticVehicleEx(482,2167.0652,-1791.2615,13.5795,273.9934,93,93,600);
	//================== Баллас ================================================
	ballascar[0] = AddStaticVehicleEx(412,2653.9341,-2009.0320,13.3056,323.4019,85,85,600);
	ballascar[1] = AddStaticVehicleEx(412,2658.0420,-2009.0884,13.3053,323.2690,85,85,600);
	ballascar[2] = AddStaticVehicleEx(412,2665.7573,-1997.6373,13.3918,269.8071,85,85,600);
	ballascar[3] = AddStaticVehicleEx(547,2658.5288,-2042.0422,13.2840,1.0220,85,85,600);
	ballascar[4] = AddStaticVehicleEx(547,2654.6658,-2041.6796,13.2850,0.4804,85,85,600);
	ballascar[5] = AddStaticVehicleEx(566,2661.5547,-2009.6567,13.2471,326.0598,85,85,600);
	ballascar[6] = AddStaticVehicleEx(471,2636.8945,-2001.4171,13.0334,267.3848,85,85,600);
	ballascar[7] = AddStaticVehicleEx(471,2636.8511,-2004.5959,13.0394,280.1125,85,85,600);
	ballascar[8] = AddStaticVehicleEx(566,2665.0559,-2009.7874,13.2323,327.4051,85,85,600);
	matsfura[0] = AddStaticVehicleEx(482,2644.6274,-2034.3457,13.6755,357.7817,85,85,600);
	//===================== Russia Mafia =======================================
	ruscar[0] = AddStaticVehicleEx(579,984.1832,1720.4199,9.0000,90.3216,0,0,600);
	ruscar[1] = AddStaticVehicleEx(579,984.1126,1723.8441,9.0000,91.2075,0,0,600);
	ruscar[2] = AddStaticVehicleEx(579,984.1122,1727.3198,9.0000,91.1532,0,0,600);
	ruscar[3] = AddStaticVehicleEx(579,983.9010,1734.5618,9.0000,90.6430,0,0,600);
	ruscar[4] = AddStaticVehicleEx(579,983.8235,1737.5437,9.0000,91.0029,0,0,600);
	ruscar[5] = AddStaticVehicleEx(579,983.6899,1740.7048,9.0000,92.9132,0,0,600);
	ruscar[6] = AddStaticVehicleEx(579,983.7421,1744.0139,9.0000,91.0281,0,0,600);
	ruscar[7] = AddStaticVehicleEx(580,966.0602,1706.5366,8.5400,270.8105,0,0,600);
	ruscar[8] = AddStaticVehicleEx(580,959.2162,1706.4982,8.5321,270.0911,0,0,600);
	ruscar[9] = AddStaticVehicleEx(579,983.9714,1730.7939,9.0000,90.0946,0,0,600);
	ruscar[10] = AddStaticVehicleEx(487,957.9562,1754.1691,8.4446,248.4217,0,0,600);
	ruscar[11] = AddStaticVehicleEx(409,949.6057,1715.6672,8.5426,181.0793,0,0,600);
	//===================== La Cosa Nostra =====================================
	lcncar[0] = AddStaticVehicleEx(445,1413.5298,784.6968,10.6952,270.0358,0,0,600);
	lcncar[1] = AddStaticVehicleEx(445,1413.5338,778.3932,10.6951,270.0358,0,0,600);
	lcncar[2] = AddStaticVehicleEx(445,1413.5380,771.8521,10.6949,270.0358,0,0,600);
	lcncar[3] = AddStaticVehicleEx(445,1413.5419,765.7633,10.9611,270.0358,0,0,600);
	lcncar[4] = AddStaticVehicleEx(445,1413.5499,759.3215,10.6498,270.0358,0,0,600);
	lcncar[5] = AddStaticVehicleEx(445,1413.5537,753.0690,10.6495,270.0358,0,0,600);
	lcncar[6] = AddStaticVehicleEx(445,1413.5576,746.6254,10.6493,270.0358,0,0,600);
	lcncar[7] = AddStaticVehicleEx(487,1414.5128,730.6333,10.9784,267.1382,0,0,600);
	lcncar[8] = AddStaticVehicleEx(409,1429.0035,787.3469,10.6200,179.3787,0,0,600);
	//=================== Якудза ===============================================
	yakcar[0] = AddStaticVehicleEx(550,1494.2484,2838.6116,10.6405,178.6475,0,0,600);
	yakcar[1] = AddStaticVehicleEx(550,1489.7351,2838.6116,10.6399,179.4486,0,0,600);
	yakcar[2] = AddStaticVehicleEx(550,1484.5413,2838.6116,10.6357,177.8342,0,0,600);
	yakcar[3] = AddStaticVehicleEx(550,1479.5450,2838.6116,10.6412,180.0046,0,0,600);
	yakcar[4] = AddStaticVehicleEx(550,1475.3090,2838.6116,10.6374,179.9559,0,0,600);
	yakcar[5] = AddStaticVehicleEx(409,1472.8611,2773.2961,10.5400,180.4315,0,0,600);
	yakcar[6] = AddStaticVehicleEx(487,1500.6167,2820.9463,10.9702,180.0113,0,0,600);
	yakcar[7] = AddStaticVehicleEx(550,1470.2028,2838.6116,10.6373,179.7756,0,0,600); // yaki1
	yakcar[8] = AddStaticVehicleEx(550,1465.4185,2838.6116,10.6379,180.0159,0,0,600); // yaki2
	yakcar[9] = AddStaticVehicleEx(550,1460.5872,2838.6116,10.6385,179.4524,0,0,600); // yaki3*
	//================ Продуктовозы ============================================
	prodcar[0] = AddStaticVehicleEx(440,1.0235,-368.0243,5.5643,90.6093,2,2,600);
	prodcar[1] = AddStaticVehicleEx(440,0.9863,-364.7068,5.5351,90.6048,1,1,600);
	prodcar[2] = AddStaticVehicleEx(440,0.9476,-361.0444,5.5351,90.6048,0,0,600);
	prodcar[3] = AddStaticVehicleEx(440,0.9099,-357.4743,5.5351,90.6048,43,43,600);
	prodcar[4] = AddStaticVehicleEx(440,0.8716,-353.8435,5.5351,90.6048,34,34,600);
	prodcar[5] = AddStaticVehicleEx(440,0.8365,-350.5167,5.5351,90.6048,55,45,600);
	prodcar[6] = AddStaticVehicleEx(440,0.7862,-346.9642,6.4105,90.6048,56,56,600);
	prodcar[7] = AddStaticVehicleEx(440,0.6810,-343.2654,5.5471,90.6511,35,35,600);
	prodcar[8] = AddStaticVehicleEx(440,0.6531,-340.0890,5.5368,90.6518,3,3,600);
	//================= Строительные ===========================================
	mater[0] = AddStaticVehicleEx(499,-2046.4924,145.0096,28.8269,181.8623,-1,-1,1200);
	mater[1] = AddStaticVehicleEx(499,-2050.2781,144.5244,28.8104,181.6690,-1,-1,1200);
	mater[2] = AddStaticVehicleEx(499,-2055.2783,146.6800,28.8274,181.0139,-1,-1,1200);
	mater[3] = AddStaticVehicleEx(499,-2033.4447,180.2613,28.8337,270.5106,-1,-1,1200);
	mater[4] = AddStaticVehicleEx(499,-2033.3988,175.0207,28.8530,270.5118,-1,-1,1200);
	mater[5] = AddStaticVehicleEx(499,-2033.3473,169.2416,28.8695,270.5136,-1,-1,1200);
	//======================= Бензовозы ========================================
	benzovoz[0] = AddStaticVehicleEx(403,-1004.8691,-686.8160,32.6148,90.4683,3,3,600);
	benzovoz[1] = AddStaticVehicleEx(403,-1004.9096,-681.8693,32.6147,90.4683,3,3,600);
	benzovoz[2] = AddStaticVehicleEx(403,-1004.9517,-676.7342,32.6146,90.4683,3,3,600);
	benzovoz[3] = AddStaticVehicleEx(403,-1004.9948,-671.4503,32.6146,90.4683,3,3,600);
	benzovoz[4] = AddStaticVehicleEx(403,-1005.0370,-666.2866,32.6145,90.4683,3,3,600);
	benzovoz[5] = AddStaticVehicleEx(403,-1005.0771,-661.3845,32.6145,90.4683,3,3,600);
	benzovoz[6] = AddStaticVehicleEx(403,-1005.1198,-656.1423,32.6144,90.4683,3,3,600);
	benzovoz[7] = AddStaticVehicleEx(403,-1005.1617,-651.0016,32.6144,90.4683,3,3,600);
	benzovoz[8] = AddStaticVehicleEx(403,-1005.2026,-645.9958,32.6143,90.4683,3,3,600);
	benzovoz[9] = AddStaticVehicleEx(403,-1005.2440,-640.9403,32.6143,90.4683,3,3,600);
	AddStaticVehicleEx(584,-984.8389,-635.7936,33.1543,91.1889,3,3,600);
	AddStaticVehicleEx(584,-984.7327,-640.9091,33.1543,91.1889,3,3,600);
	AddStaticVehicleEx(584,-984.6266,-646.0191,33.1543,91.1889,3,3,600);
	AddStaticVehicleEx(584,-984.5270,-650.8137,33.1543,91.1889,3,3,600);
	AddStaticVehicleEx(584,-984.4152,-656.2086,33.1543,91.1889,3,3,600);
	AddStaticVehicleEx(584,-984.3068,-661.4308,33.1543,91.1889,3,3,600);
	//=================== Такси ================================================
	taxicar[0] = AddStaticVehicleEx(438,1279.9930,-1794.9031,13.0766,90.3490,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[1] = AddStaticVehicleEx(438,1279.9930,-1798.5837,13.0745,89.6356,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[2] = AddStaticVehicleEx(438,1279.9930,-1802.0580,13.0715,88.3839,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[3] = AddStaticVehicleEx(438,1279.9930,-1805.5640,13.0635,89.9160,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[4] = AddStaticVehicleEx(438,1279.9930,-1809.0481,13.0370,88.8682,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[5] = AddStaticVehicleEx(438,1279.9930,-1812.3816,13.0748,89.5555,5,5,600); // Автовокзал ЛС (Респа)
	taxicar[6] = AddStaticVehicleEx(438,1279.9930,-1816.0032,13.0834,90.0849,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[7] = AddStaticVehicleEx(438,1279.9930,-1819.5033,13.0567,91.7324,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[8] = AddStaticVehicleEx(438,1279.9930,-1822.9399,13.0401,91.7138,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[9] = AddStaticVehicleEx(438,1279.9930,-1826.5159,13.0418,90.8909,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[10] = AddStaticVehicleEx(438,1279.9930,-1830.0350,13.0816,89.6202,6,6,600); // Автовокзал ЛС (Респа)
	taxicar[11] = AddStaticVehicleEx(560,2805.6475,1325.9688,10.7589,270.1906,1,1,600);
	taxicar[12] = AddStaticVehicleEx(560,2805.6365,1329.1567,10.7589,270.1906,1,1,600);
	taxicar[13] = AddStaticVehicleEx(560,2805.6248,1332.6895,10.7589,270.1906,1,1,600);
	taxicar[14] = AddStaticVehicleEx(560,2805.6140,1335.8807,10.7589,270.1906,1,1,600);
	taxicar[15] = AddStaticVehicleEx(560,2805.6028,1339.1978,10.7589,270.1906,1,1,600);
	taxicar[16] = AddStaticVehicleEx(560,2805.5916,1342.6688,10.7589,270.1906,1,1,600);
	taxicar[17] = AddStaticVehicleEx(560,2805.5808,1345.8571,10.7588,270.1906,1,1,600);
	taxicar[18] = AddStaticVehicleEx(560,2805.5686,1349.4170,10.7588,270.1906,1,1,600);
	taxicar[19] = AddStaticVehicleEx(560,2805.5591,1352.3472,10.7588,270.1906,1,1,600);
	taxicar[20] = AddStaticVehicleEx(560,2805.5486,1355.3315,10.7588,270.1906,1,1,600);
	taxicar[21] = AddStaticVehicleEx(560,2805.5378,1358.5138,10.7588,270.1906,1,1,600);
	taxicar[22] = AddStaticVehicleEx(560,2805.5266,1361.8738,10.7588,270.1906,1,1,600);
	taxicar[23] = AddStaticVehicleEx(560,2805.5168,1364.7805,10.7587,270.1906,1,1,600);
	taxicar[24] = AddStaticVehicleEx(560,2805.5056,1368.1226,10.7587,270.1906,1,1,600);
	taxicar[25] = AddStaticVehicleEx(420,-1974.5120,174.7777,27.4954,89.9957,6,1,600); // Автовокзал СФ (Респа)
	taxicar[26] = AddStaticVehicleEx(420,-1974.5120,180.9085,27.4943,90.1653,6,1,600); // Автовокзал СФ (Респа)
	taxicar[27] = AddStaticVehicleEx(420,-1974.5120,187.1477,27.4295,91.0159,6,1,600); // Автовокзал СФ (Респа)
	taxicar[28] = AddStaticVehicleEx(420,-1974.5120,193.3009,27.2492,87.9330,6,1,600); // Автовокзал СФ (Респа)
	taxicar[29] = AddStaticVehicleEx(420,-1974.5120,199.0602,27.1328,89.3561,6,1,600); // Автовокзал СФ (Респа)
	taxicar[30] = AddStaticVehicleEx(438,1279.9924,-1833.6654,13.3888,91.3736,6,6,600); // Автовокзал ЛС (Респа)
	//================== Автобусы ==============================================
	bus[0] = AddStaticVehicleEx(437,1673.9640,-1111.2640,24.0405,89.4855,1,6,600);
	bus[1] = AddStaticVehicleEx(437,1674.1030,-1106.9041,24.0405,90.0608,1,6,600);
	bus[2] = AddStaticVehicleEx(437,1674.1869,-1102.4531,24.0405,89.7656,1,6,600);
	bus[3] = AddStaticVehicleEx(437,1674.1510,-1097.9965,24.0405,89.4179,1,6,600);
	//====================== Механики ==========================================
	mehanik[0] = AddStaticVehicleEx(525,1649.8070,-1107.4197,23.7879,270.4307,3,3,600);
	mehanik[1] = AddStaticVehicleEx(525,1649.5594,-1097.9303,23.7825,271.0184,3,3,600);
	mehanik[2] = AddStaticVehicleEx(525,1649.5481,-1088.9520,23.7802,271.2585,3,3,600);
	mehanik[3] = AddStaticVehicleEx(525,1649.4701,-1080.2677,23.7859,269.8732,3,3,600);
	mehanik[4] = AddStaticVehicleEx(525,1630.1318,-1107.5986,23.7810,90.0636,3,3,600);
	mehanik[5] = AddStaticVehicleEx(525,1629.4932,-1098.3491,23.7889,91.1477,3,3,600);
	mehanik[6] = AddStaticVehicleEx(525,1629.3313,-1089.4033,23.7905,89.8329,3,3,600);
	mehanik[7] = AddStaticVehicleEx(525,-70.9419,-1156.6366,1.6491,106.9529,0,3,600);
	mehanik[8] = AddStaticVehicleEx(525,-75.4985,-1153.8265,1.5561,106.9529,0,3,600);
	mehanik[9] = AddStaticVehicleEx(525,-79.4743,-1152.0967,2.1477,106.9529,0,3,600);
	mehanik[10] = AddStaticVehicleEx(525,-81.0021,-1197.2158,2.0621,13.2738,0,3,600);
	mehanik[11] = AddStaticVehicleEx(525,-85.3324,-1197.1295,2.1304,13.2739,0,3,600);
	mehanik[12] = AddStaticVehicleEx(525,-89.2924,-1196.4034,2.1066,13.2739,0,3,600);
	//=========================== Мопеды на руднике ============================
	AddStaticVehicleEx(462,-1853.1683,-1565.7795,21.3487,82.9301,1,1,300);
	AddStaticVehicleEx(462,-1853.1017,-1564.1594,21.3490,85.8838,1,1,300);
	AddStaticVehicleEx(462,-1853.0446,-1562.5585,21.3493,84.4313,1,1,300);
	//=========================== Мопеды на автошколе ==========================
	AddStaticVehicleEx(462,-2019.9895,-93.7086,34.7597,91.8433,1,1,300);
	AddStaticVehicleEx(462,-2020.0319,-95.5214,34.7639,88.7101,1,1,300);
	AddStaticVehicleEx(462,-2020.1151,-97.3221,34.7640,87.8581,1,1,300);
	AddStaticVehicleEx(462,-2020.2170,-99.0214,34.7621,90.7809,1,1,300);
	AddStaticVehicleEx(462,-2020.0748,-101.1508,34.7641,86.7102,1,1,300);
	//============== Аренда SF =================================================
	rentcarsf[0] = AddStaticVehicleEx(401,-1992.3820,243.3328,34.9512,261.7145,0,0,600);
	rentcarsf[1] = AddStaticVehicleEx(405,-1991.3319,247.8476,35.0468,261.2777,3,3,600);
	rentcarsf[2] = AddStaticVehicleEx(404,-1990.6476,251.4531,34.9059,261.8576,2,2,600);
	rentcarsf[3] = AddStaticVehicleEx(410,-1990.2252,255.0063,34.8230,263.9150,1,1,600);
	rentcarsf[4] = AddStaticVehicleEx(426,-1989.7439,259.0538,34.9228,264.1123,5,5,600);
	rentcarsf[5] = AddStaticVehicleEx(436,-1989.3835,263.5551,34.9737,264.1029,6,6,600);
	//============== Аренда LS =================================================
	rentcarls[0] = AddStaticVehicleEx(401,519.7533,-1290.0048,17.0217,242.5766,3,3,600);
	rentcarls[1] = AddStaticVehicleEx(404,523.1928,-1287.7258,16.9749,238.3987,0,0,600);
	rentcarls[2] = AddStaticVehicleEx(405,526.4354,-1285.3699,17.1448,235.8959,1,1,600);
	rentcarls[3] = AddStaticVehicleEx(410,529.5605,-1283.0753,16.9009,233.4568,2,2,600);
	rentcarls[4] = AddStaticVehicleEx(426,533.1606,-1280.0093,17.0078,235.9369,4,4,600);
	rentcarls[5] = AddStaticVehicleEx(529,1098.6141,-1754.8154,12.9975,89.2885,53,53,600); // Автовокзал (ЛС)
	rentcarls[6] = AddStaticVehicleEx(436,1098.5259,-1757.8270,13.1663,92.6704,109,1,600); // Автовокзал (ЛС)
	rentcarls[7] = AddStaticVehicleEx(436,1098.5294,-1760.8109,13.0875,91.3050,95,1,600); // Автовокзал (ЛС)
	rentcarls[8] = AddStaticVehicleEx(405,1098.6001,-1763.9081,13.2711,89.1510,36,1,600); // Автовокзал (ЛС)
	rentcarls[9] = AddStaticVehicleEx(401,1098.6057,-1766.6813,13.0918,91.1784,66,66,600); // Автовокзал (ЛС)
	rentcarls[10] = AddStaticVehicleEx(529,1098.6781,-1769.5826,12.9853,89.0951,37,37,600); // Автовокзал (ЛС)
	rentcarls[11] = AddStaticVehicleEx(404,1098.5414,-1772.8309,13.0719,88.7086,119,50,600); // Автовокзал (ЛС)
	rentcarls[12] = AddStaticVehicleEx(401,1098.9235,-1775.5602,13.1435,91.6417,47,47,600); // Автовокзал (ЛС)
	rentcarls[13] = AddStaticVehicleEx(436,537.3063,-1277.2213,17.0356,234.1004,5,5,600);
	//=============== Хот-Дог ==================================================
	hotdogcar[0] = AddStaticVehicleEx(588,-2429.2341,741.4066,34.9217,179.6980,34,34,600);
	hotdogcar[1] = AddStaticVehicleEx(588,-2433.9192,741.2372,34.9212,179.6447,34,34,600);
	hotdogcar[2] = AddStaticVehicleEx(588,-2437.8342,741.0984,34.9189,179.8946,34,34,600);
	hotdogcar[3] = AddStaticVehicleEx(588,-2442.5227,741.0941,34.9182,179.8704,34,34,600);
	hotdogcar[4] = AddStaticVehicleEx(588,-2446.9268,740.9801,34.9242,179.3379,34,34,600);
	hotdogcar[5] = AddStaticVehicleEx(588,-2451.2832,740.9025,34.9189,180.1623,34,34,600);
	hotdogcar[6] = AddStaticVehicleEx(588,-2455.7896,740.9033,34.9215,179.2092,34,34,600);
	hotdogcar[7] = AddStaticVehicleEx(588,-2460.1279,740.7226,34.9204,180.5361,34,34,600);
	hotdogcar[8] = AddStaticVehicleEx(588,-2464.4287,740.7175,34.9191,180.0000,34,34,600);
	//===================== Лодки ==============================================
    arendlod[0] = AddStaticVehicleEx(493,-27.5086,-1739.1360,-0.1118,123.6952,36,13,600);
    arendlod[1] = AddStaticVehicleEx(493,-34.4976,-1731.1881,-0.1353,127.2233,36,13,600);
    arendlod[2] = AddStaticVehicleEx(493,-51.2356,-1707.9650,0.0217,125.6537,36,13,600);
    arendlod[3] = AddStaticVehicleEx(493,-45.0683,-1716.5365,-0.0097,124.5288,36,13,600);
	return true;
}
stock CreateObjects()
{
	//============== Обьекты ===================================================
	CreateDynamicObject(3268,-1242.63647461,447.92861938,6.18750000,0.00000000,0.00000000,270.00000000); //object(mil_hangar1_) (1)
	CreateDynamicObject(3268,-1276.29675293,447.92861938,6.18750000,0.00000000,0.00000000,269.99450684); //object(mil_hangar1_) (2)
	//===================== Обьекты FL =========================================
	CreateDynamicObject(1215, -95.14, -1038.00, 23.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, -83.09, -1031.75, 23.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, -103.43, -1000.23, 23.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, -370.04, -850.19, 46.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, -364.14, -838.92, 46.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, -399.30, -835.14, 46.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, -393.50, -823.78, 46.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -138.46, -963.27, 22.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -169.45, -938.79, 27.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -538.27, -1056.28, 28.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -200.08, -916.99, 33.00,   0.00, 0.00, 11.00);
	CreateDynamicObject(708, -226.21, -900.55, 34.00,   0.00, 0.00, 55.00);
	CreateDynamicObject(708, -267.57, -877.80, 38.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -348.84, -863.97, 43.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -313.38, -878.09, 43.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -397.36, -822.55, 47.20,   0.00, -3.00, 172.00);
	CreateDynamicObject(973, -406.64, -821.49, 47.77,   0.00, -4.00, 175.00);
	CreateDynamicObject(979, -415.88, -821.88, 48.26,   0.00, -2.00, 190.00);
	CreateDynamicObject(973, -425.11, -823.51, 48.58,   0.00, -2.00, 190.00);
	CreateDynamicObject(979, -434.24, -825.61, 48.91,   0.00, -2.00, 196.00);
	CreateDynamicObject(973, -443.15, -828.51, 49.28,   0.00, -2.50, -160.00);
	CreateDynamicObject(979, -452.05, -831.40, 49.65,   0.00, -2.00, 196.00);
	CreateDynamicObject(1215, -457.98, -833.42, 49.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(691, -447.26, -822.93, 44.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(691, -428.01, -818.34, 43.83,   0.00, 0.00, 193.00);
	CreateDynamicObject(691, -405.98, -814.62, 43.83,   0.00, 0.00, 124.00);
	CreateDynamicObject(3379, -473.61, -864.93, 51.00,   0.00, 0.00, -76.00);
	CreateDynamicObject(3380, -364.90, -838.42, 46.60,   0.00, 0.00, 55.00);
	CreateDynamicObject(3379, -113.31, -1009.29, 24.00,   0.00, 0.00, 200.00);
	CreateDynamicObject(3380, -73.72, -1084.99, 8.00,   0.00, 0.00, -18.00);
    CreateDynamicObject(1215, 1494.47, -1750.44, 15.00,   0.00, 0.00, 0.00);
    CreateDynamicObject(1215, 1489.27, -1750.44, 15.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, 1483.87, -1750.44, 15.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, 1478.47, -1750.44, 15.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, 1473.07, -1750.44, 15.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, 1467.97, -1750.44, 15.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -510.26, -903.26, 54.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -563.85, -960.84, 55.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -584.78, -980.38, 59.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -611.16, -995.16, 62.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -630.78, -1005.40, 64.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -677.05, -1016.92, 65.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, -709.07, -1020.43, 69.29,   0.00, 0.00, 105.00);
	CreateDynamicObject(708, -528.07, -923.73, 54.29,   0.00, 0.00, 25.00);
	CreateDynamicObject(708, -543.83, -941.74, 54.29,   0.00, 0.00, 33.00);
	CreateDynamicObject(708, -652.96, -1013.50, 65.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(800, -665.29, -1017.36, 72.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(800, -642.79, -1011.73, 71.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(800, -579.07, -974.48, 66.02,   0.00, 0.00, 0.00);
	//====================== Полоски на дороге (Стоянки) =======================
	CreateDynamicObject(18285,1413.29,-1678.01, 12.57,0.00000,0.00000,-61.60000);
	//====================== Рудники ===========================================
	CreateDynamicObject(984, -1899.991088,-1504.727905,21.359994, 0.000000,0.000000,54.000015);
    CreateDynamicObject(982, -1884.536499,-1516.099853,21.400003, 0.000000,0.000000,53.300045);
    CreateDynamicObject(982, -1864.030761,-1531.422241,21.400060, 0.000000,0.000000,53.099983);
    CreateDynamicObject(982, -1843.607788,-1546.907714,21.400003, 0.000000,0.000000,52.300052);
    CreateDynamicObject(7347, -1814.808959,-1546.617553,-20.859987, 0.000000,0.000000,-32.500000);
    CreateDynamicObject(18257, -1866.500732,-1624.567260,20.885532, 0.000000,0.000000,-80.799980);
    CreateDynamicObject(1685, -1864.353271,-1616.345825,21.585529, 0.000000,0.000000,7.099998);
    CreateDynamicObject(3630, -1847.547851,-1621.988281,22.395532, 0.000000,0.000000,91.400009);
    CreateDynamicObject(828, -1803.469604,-1655.385131,24.845531, 0.000000,-42.199993,0.000000);
    CreateDynamicObject(816, -1788.244628,-1641.433105,27.071035, -46.799999,-9.900002,0.000000);
    CreateDynamicObject(816, -1802.962890,-1643.755737,23.716806, -14.600000,-19.200002,0.000000);
    CreateDynamicObject(13635, -1827.894775,-1660.721313,23.150497, 0.000000,0.000000,-64.799995);
	//====================== San-Fierro by Charles_Harrell ====================================
	CreateDynamicObject(869, -1806.579589,-595.638977,15.846330, 0.000000,0.000000,-13.599996);
    CreateDynamicObject(869, -1806.363037,-598.027343,15.836333, 0.000000,0.000000,-4.299999);
    CreateDynamicObject(869, -1806.536132,-600.558776,15.996335, 0.000000,0.000000,-5.299999);
    CreateDynamicObject(869, -1805.968872,-603.373168,15.856335, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.915771,-605.498168,15.886333, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.508178,-607.980163,15.914370, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.513671,-610.312622,15.794378, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.566650,-612.505920,15.804376, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.171020,-614.659179,15.799219, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.372680,-616.585815,16.003774, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.234985,-618.951660,15.904337, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.292236,-621.253906,15.905698, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1805.128784,-623.276184,15.847059, 0.000000,0.000000,0.000000);
    CreateDynamicObject(703, -1801.284545,-639.970031,16.503149, 0.000000,0.000000,-83.900016);
    CreateDynamicObject(869, -1804.950683,-625.397521,15.969058, 0.000000,0.000000,0.000000);
    CreateDynamicObject(708, -1803.688354,-653.426452,16.111146, 0.000000,0.000000,67.400047);
    CreateDynamicObject(703, -1800.989990,-678.684875,18.769821, 0.000000,0.000000,-71.400009);
    CreateDynamicObject(703, -1763.864746,-714.050292,26.825103, 0.000000,0.000000,140.000045);
    CreateDynamicObject(869, -1761.195190,-714.462890,28.424613, 0.000000,0.000000,97.799972);
    CreateDynamicObject(869, -1762.391845,-711.956481,28.066404, 0.000000,0.000000,100.500030);
    CreateDynamicObject(869, -1763.432250,-709.381591,27.695819, 0.000000,0.000000,107.499984);
    CreateDynamicObject(869, -1764.712890,-706.395446,27.429399, 0.000000,0.000000,100.799972);
    CreateDynamicObject(869, -1765.892578,-703.744079,27.016576, 0.000000,0.000000,95.099983);
    CreateDynamicObject(869, -1767.455688,-700.575988,26.310670, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1767.712768,-697.818542,25.754758, 0.000000,0.000000,97.100006);
    CreateDynamicObject(869, -1804.311645,-613.140136,15.650346, 0.000000,0.000000,91.699996);
    CreateDynamicObject(869, -1805.185424,-604.384094,15.622219, 0.000000,0.000000,90.400009);
    CreateDynamicObject(869, -1804.584594,-608.885009,15.615813, 0.000000,0.000000,81.299987);
    CreateDynamicObject(869, -1805.436157,-599.891784,15.553219, 0.000000,0.000000,59.599990);
    CreateDynamicObject(869, -1805.458862,-595.846191,15.494972, 0.000000,0.000000,88.099967);
    CreateDynamicObject(869, -1805.448730,-597.973449,15.424785, 0.000000,0.000000,85.500000);
    CreateDynamicObject(869, -1766.629882,-701.950012,26.577850, -2.500000,4.599998,91.499992);
    CreateDynamicObject(869, -1768.279663,-694.861572,25.378513, 0.000000,2.800000,84.600006);
    CreateDynamicObject(869, -1769.221313,-692.674743,24.946123, 0.000000,1.499998,80.899993);
    CreateDynamicObject(869, -1769.655151,-689.015686,24.522079, 0.000000,9.099993,89.699996);
    CreateDynamicObject(869, -1770.088989,-685.692138,24.078042, 0.000000,13.099994,76.399986);
    CreateDynamicObject(869, -1770.402099,-683.152282,23.712810, 0.000000,6.500005,86.999954);
    CreateDynamicObject(869, -1770.793701,-680.346862,23.218009, 0.000000,2.000000,77.099967);
    CreateDynamicObject(869, -1770.888671,-676.832885,22.777778, 0.000000,8.999994,78.599998);
    CreateDynamicObject(869, -1771.217529,-673.373413,22.361734, 0.000000,3.500001,80.799987);
    CreateDynamicObject(869, -1770.998046,-670.568908,22.080104, 0.000000,-9.799985,-113.999992);
    CreateDynamicObject(869, -1770.668823,-667.491821,21.554075, 0.000000,-4.599995,-105.899993);
    CreateDynamicObject(869, -1770.765502,-663.833801,21.060916, 0.000000,-10.299997,-102.399986);
    CreateDynamicObject(869, -1770.601318,-660.005126,20.643251, 0.000000,6.300000,71.299972);
    CreateDynamicObject(869, -1770.366455,-656.966674,20.020885, 0.000000,2.099999,67.999992);
    CreateDynamicObject(869, -1770.456665,-653.884094,19.690536, 0.000000,1.300000,75.000007);
    CreateDynamicObject(869, -1770.194335,-650.653259,19.303848, 0.000000,3.399999,74.899986);
    CreateDynamicObject(869, -1770.111938,-647.527404,18.907558, -0.899999,2.000000,79.599998);
    CreateDynamicObject(869, -1770.155395,-644.411926,18.648864, 0.000000,4.900000,73.000000);
    CreateDynamicObject(869, -1770.178100,-641.412414,18.247585, 0.299999,2.299999,76.300033);
    CreateDynamicObject(869, -1769.973022,-638.225524,17.943803, 0.000000,0.000000,84.599998);
    CreateDynamicObject(869, -1770.072021,-634.645568,17.606857, -2.100000,2.900001,74.899993);
    CreateDynamicObject(869, -1770.354370,-631.655273,17.354011, 0.000000,0.600000,76.699974);
    CreateDynamicObject(869, -1770.322509,-628.354187,17.124794, 0.000000,0.499997,84.099990);
    CreateDynamicObject(869, -1770.357666,-624.862976,16.859125, 0.000000,-3.699999,-101.299995);
    CreateDynamicObject(869, -1770.458984,-621.348144,16.641807, 0.000000,-2.799999,-107.699989);
    CreateDynamicObject(869, -1770.538574,-617.747314,16.325304, 0.000000,2.599999,80.899993);
    CreateDynamicObject(869, -1770.718750,-614.478149,16.164451, 0.000000,1.299998,80.899986);
    CreateDynamicObject(869, -1771.032836,-611.233337,15.968355, 0.000000,-2.200000,-96.300025);
    CreateDynamicObject(869, -1771.055053,-607.676818,15.830815, 0.000000,-0.299999,71.799980);
    CreateDynamicObject(869, -1770.470825,-604.316833,15.791783, 0.000000,-0.200000,73.699974);
    CreateDynamicObject(869, -1770.041870,-600.935729,15.850638, 0.000000,-1.100000,74.500022);
    CreateDynamicObject(869, -1769.293945,-597.878295,15.918888, 0.000000,-2.600000,-109.700027);
    CreateDynamicObject(869, -1769.390136,-595.434204,15.784377, 0.000000,0.000000,-2.799999);
    CreateDynamicObject(869, -1772.876708,-595.697204,15.834370, 0.000000,0.000000,-24.800003);
    CreateDynamicObject(869, -1776.184082,-595.524658,15.844375, 0.000000,0.000000,-13.200000);
    CreateDynamicObject(869, -1802.835815,-595.244201,15.516671, 0.000000,-2.300000,0.000000);
    CreateDynamicObject(869, -1799.946166,-595.354614,15.537121, 0.000000,-2.599999,0.000000);
    CreateDynamicObject(869, -1784.102539,-595.630676,15.894375, 0.000000,0.000000,-21.100006);
    CreateDynamicObject(869, -1780.239013,-595.716186,15.904378, 0.000000,0.000000,-18.600002);
    CreateDynamicObject(869, -1796.595947,-595.423706,15.674144, 0.000000,0.000000,-7.499998);
    CreateDynamicObject(869, -1793.630615,-595.481994,15.662026, 0.000000,0.000000,-7.199999);
    CreateDynamicObject(869, -1787.810180,-604.379882,15.844782, 0.000000,0.000000,-12.800002);
    CreateDynamicObject(869, -1784.663696,-603.919433,15.844645, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1781.911499,-605.329345,15.832116, 2.399999,0.000000,-75.499992);
    CreateDynamicObject(869, -1780.906982,-608.739929,15.763833, 0.000000,0.000000,96.600013);
    CreateDynamicObject(869, -1780.062988,-612.383300,16.004991, 0.000000,0.000000,91.799995);
    CreateDynamicObject(869, -1781.103149,-614.888427,16.281557, 11.300000,-13.699996,-149.199981);
    CreateDynamicObject(869, -1784.330566,-615.552917,17.067363, -12.199999,0.000000,-2.699992);
    CreateDynamicObject(869, -1787.196655,-615.476989,17.258934, -15.099998,0.000000,-16.300003);
    CreateDynamicObject(869, -1796.861450,-604.004394,15.648334, 0.000000,0.000000,0.000000);
    CreateDynamicObject(869, -1796.993774,-607.400268,15.546635, 0.000000,-3.799999,79.000007);
    CreateDynamicObject(869, -1797.091552,-610.870483,15.737318, -1.000000,4.699999,94.000038);
    CreateDynamicObject(869, -1797.130004,-613.821105,16.117767, 2.400001,9.600001,81.099906);
    CreateDynamicObject(869, -1796.960449,-615.860717,16.459419, -1.199999,6.099999,87.299987);
    CreateDynamicObject(869, -1794.037719,-615.602294,16.885978, -7.899994,0.100000,13.800008);
    CreateDynamicObject(869, -1793.218505,-611.991394,16.256370, 0.699999,11.000005,75.599998);
    CreateDynamicObject(869, -1794.635498,-609.315124,15.815737, -2.200000,4.499999,127.800003);
    CreateDynamicObject(869, -1799.562622,-616.097778,16.265876, -0.899999,-4.700000,-64.799964);
    CreateDynamicObject(869, -1800.663940,-613.033508,15.841396, -0.499999,6.200001,99.700004);
    CreateDynamicObject(869, -1799.464477,-609.677307,15.607750, 0.000000,0.000000,38.099990);
    CreateDynamicObject(708, -1766.837158,-702.097167,24.603200, 0.000000,0.000000,0.000000);
    CreateDynamicObject(703, -1774.984008,-683.194335,23.195573, 0.000000,0.000000,123.100006);
    CreateDynamicObject(708, -1772.767456,-664.686706,20.133169, 0.000000,0.000000,0.000000);
    CreateDynamicObject(703, -1776.116333,-642.795837,17.585584, 0.000000,0.000000,52.200004);
    CreateDynamicObject(708, -1774.097900,-624.378173,15.993166, 0.000000,0.000000,133.800003);
    CreateDynamicObject(703, -1774.763916,-601.993225,14.695585, 0.000000,0.000000,77.999992);
    CreateDynamicObject(18880, -1754.125244,-608.753295,15.258814, 0.000000,0.000000,179.299957);
    //====================== ПИРС by Charles_Harrell ====================================
	CreateDynamicObject(9829, -34.200370,-1669.026489,-62.234622, 0.000000,0.000000,125.799964);
    CreateDynamicObject(3458, -45.569896,-1609.202636,0.478235, -86.299972,-3.299998,33.200008);
    CreateDynamicObject(3458, -19.645145,-1613.015380,0.390496, -85.199951,0.000000,-54.299983);
    CreateDynamicObject(17026, -36.147712,-1597.699096,-25.032333, 124.000038,73.299980,36.000022);
    CreateDynamicObject(17026, -26.134513,-1620.812377,-8.862088, -28.199989,91.699958,9.499983);
    CreateDynamicObject(17026, -12.991857,-1631.922363,-27.629680, -39.200004,27.100002,-11.700000);
    CreateDynamicObject(3627, -40.805782,-1618.482543,7.204770, 0.000000,0.000000,-54.200122);
    CreateDynamicObject(3444, -82.958358,-1657.045288,5.584764, 0.000000,0.000000,-144.199996);
    CreateDynamicObject(9241, -19.526939,-1643.536132,4.724763, 0.000000,0.000000,-54.099998);
    CreateDynamicObject(749, -30.904325,-1596.312255,-2.823105, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3877, -31.670951,-1597.935546,2.557395, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3877, -35.440753,-1600.662109,2.550990, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3877, -39.177413,-1603.387084,2.550703, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3877, -43.343219,-1606.493408,2.564034, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3660, -54.154918,-1614.400878,4.557155, -2.099999,0.000000,36.600017);
    CreateDynamicObject(3877, -91.655975,-1634.479980,2.770365, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3877, -97.754920,-1636.590820,2.730365, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3877, -103.960060,-1638.649169,2.726562, 0.000000,0.000000,0.000000);
    CreateDynamicObject(749, -113.961479,-1641.377807,-1.655534, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3877, -110.701583,-1640.504394,2.592634, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3660, -79.378852,-1670.914184,5.380074, 0.000000,0.000000,35.899982);
    CreateDynamicObject(3660, -70.447570,-1664.434326,5.390067, 0.000000,0.000000,35.999965);
    CreateDynamicObject(1297, -85.432220,-1677.657836,5.070064, 0.000000,0.000000,-139.100021);
    CreateDynamicObject(1297, -81.235412,-1682.503784,5.070064, 0.000000,0.000000,-139.100021);
    CreateDynamicObject(1297, -75.389953,-1690.658447,5.070064, 0.000000,0.000000,-139.100021);
    CreateDynamicObject(3864, -66.512489,-1701.331176,8.840076, 0.000000,0.000000,-86.099990);
    CreateDynamicObject(3872, -68.364273,-1695.309570,9.779884, -0.600000,0.499999,-73.699989);
    CreateDynamicObject(3666, -56.681911,-1715.617309,1.247754, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3666, -53.827869,-1719.526489,1.175690, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3666, -37.237957,-1742.555541,1.160436, 0.000000,0.099999,0.000000);
    CreateDynamicObject(3666, -40.033004,-1738.660644,1.215689, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3463, -35.118675,-1686.187744,3.236934, 0.000000,0.000000,42.900009);
    CreateDynamicObject(3463, -29.212886,-1694.745483,3.236934, 0.000000,0.000000,42.900009);
    CreateDynamicObject(3463, -23.393705,-1702.578125,3.236934, 0.000000,0.000000,42.900009);
    CreateDynamicObject(3463, -17.517400,-1710.591430,3.236934, 0.000000,0.000000,42.900009);
    CreateDynamicObject(3463, -11.510728,-1718.714721,3.236934, 0.000000,0.000000,42.900009);
    CreateDynamicObject(3864, -8.961086,-1741.083007,8.850067, 0.000000,0.000000,-82.899971);
    CreateDynamicObject(3864, 11.719511,-1726.414306,8.850069, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3872, 5.177031,-1726.410278,9.685984, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3872, -10.293848,-1736.055175,9.295986, 0.000000,0.000000,-72.900001);
    CreateDynamicObject(1280, -6.438402,-1708.686401,3.460064, 0.000000,0.000000,-145.399902);
    CreateDynamicObject(1280, -12.105502,-1700.471191,3.460064, 0.000000,0.000000,-145.399902);
    CreateDynamicObject(1280, -17.448921,-1692.726074,3.460064, 0.000000,0.000000,-145.399902);
    CreateDynamicObject(1280, -23.468080,-1684.000854,3.460064, 0.000000,0.000000,-145.399902);
    CreateDynamicObject(1297, -22.828886,-1672.471435,5.070064, 0.000000,0.000000,-44.499992);
    CreateDynamicObject(1297, 4.387687,-1648.097534,5.070064, 0.000000,0.000000,0.000000);
    CreateDynamicObject(1297, -3.095494,-1638.589355,5.070064, 0.000000,0.000000,30.000005);
    CreateDynamicObject(1297, -13.218118,-1623.254272,5.070064, 0.000000,0.000000,30.000005);
	//====================== АВТОШКОЛА =========================================
	CreateDynamicObject(18755, 1786.6781, -1303.4595, 14.5710, 0.0000, 0.0000, 270.0000); // object (1)
	CreateDynamicObject(18757, 1788.2277, -1303.4595, 14.5266, 0.0000, 0.0000, 270.0000); // object (2)
	CreateDynamicObject(18756, 1785.0277, -1303.4595, 14.5266, 0.0000, 0.0000, 270.0000); // object (3)
	CreateDynamicObject(18757, 1788.2277, -1303.1711, 14.5115, 0.0000, 0.0000, 270.0000); // object (4)
	CreateDynamicObject(18756, 1785.0277, -1303.1711, 14.5115, 0.0000, 0.0000, 270.0000); // object (5)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 23.0594, 0.0000, 0.0000, 270.0000); // object (6)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 23.0594, 0.0000, 0.0000, 270.0000); // object (7)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 28.5109, 0.0000, 0.0000, 270.0000); // object (8)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 28.5109, 0.0000, 0.0000, 270.0000); // object (9)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 33.9625, 0.0000, 0.0000, 270.0000); // object (10)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 33.9625, 0.0000, 0.0000, 270.0000); // object (11)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 39.4140, 0.0000, 0.0000, 270.0000); // object (12)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 39.4140, 0.0000, 0.0000, 270.0000); // object (13)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 44.8656, 0.0000, 0.0000, 270.0000); // object (14)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 44.8656, 0.0000, 0.0000, 270.0000); // object (15)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 50.3171, 0.0000, 0.0000, 270.0000); // object (16)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 50.3171, 0.0000, 0.0000, 270.0000); // object (17)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 55.7687, 0.0000, 0.0000, 270.0000); // object (18)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 55.7687, 0.0000, 0.0000, 270.0000); // object (19)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 61.2202, 0.0000, 0.0000, 270.0000); // object (20)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 61.2202, 0.0000, 0.0000, 270.0000); // object (21)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 66.6718, 0.0000, 0.0000, 270.0000); // object (22)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 66.6718, 0.0000, 0.0000, 270.0000); // object (23)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 72.1233, 0.0000, 0.0000, 270.0000); // object (24)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 72.1233, 0.0000, 0.0000, 270.0000); // object (25)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 77.5749, 0.0000, 0.0000, 270.0000); // object (26)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 77.5749, 0.0000, 0.0000, 270.0000); // object (27)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 83.0264, 0.0000, 0.0000, 270.0000); // object (28)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 83.0264, 0.0000, 0.0000, 270.0000); // object (29)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 88.4780, 0.0000, 0.0000, 270.0000); // object (30)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 88.4780, 0.0000, 0.0000, 270.0000); // object (31)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 93.9295, 0.0000, 0.0000, 270.0000); // object (32)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 93.9295, 0.0000, 0.0000, 270.0000); // object (33)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 99.3811, 0.0000, 0.0000, 270.0000); // object (34)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 99.3811, 0.0000, 0.0000, 270.0000); // object (35)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 104.8326, 0.0000, 0.0000, 270.0000); // object (36)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 104.8326, 0.0000, 0.0000, 270.0000); // object (37)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 110.2842, 0.0000, 0.0000, 270.0000); // object (38)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 110.2842, 0.0000, 0.0000, 270.0000); // object (39)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 115.7357, 0.0000, 0.0000, 270.0000); // object (40)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 115.7357, 0.0000, 0.0000, 270.0000); // object (41)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 121.1873, 0.0000, 0.0000, 270.0000); // object (42)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 121.1873, 0.0000, 0.0000, 270.0000); // object (43)
	CreateDynamicObject(18757, 1786.6277, -1303.1711, 126.6388, 0.0000, 0.0000, 270.0000); // object (44)
	CreateDynamicObject(18756, 1786.6277, -1303.1711, 126.6388, 0.0000, 0.0000, 270.0000); // object (45)
	CreateDynamicObject(5706, 135.9336, 1953.4072, 23.3076, 0.0000, 0.0000, 179.9945); // object (47)
	CreateDynamicObject(3707, 353.6700, 1950.3446, 24.6238, 0.1416, 0.0000, 180.0000); // object (48)
	CreateDynamicObject(18759, 5512.3423, 1244.4044, 22.1886, 0.0000, 0.0000, 0.0000); // object (49)
	CreateDynamicObject(3115, 2413.3933, -805.0808, 1420.9392, 0.0000, 0.0000, 0.0000); // object (50)
	CreateDynamicObject(3115, 2433.7783, -805.0808, 1420.9392, 0.0000, 0.0000, 0.0000); // object (51)
	CreateDynamicObject(3115, 2413.3933, -786.7371, 1420.9392, 0.0000, 0.0000, 0.0000); // object (52)
	CreateDynamicObject(3115, 2433.7783, -786.7363, 1420.9392, 0.0000, 0.0000, 0.0000); // object (53)
	CreateDynamicObject(3115, 2413.3926, -768.0615, 1420.9392, 0.0000, 0.0000, 0.0000); // object (54)
	CreateDynamicObject(3115, 2433.7783, -768.0615, 1420.9392, 0.0000, 0.0000, 0.0000); // object (55)
	CreateDynamicObject(3115, 2454.9360, -768.0615, 1420.9392, 0.0000, 0.0000, 0.0000); // object (56)
	CreateDynamicObject(3115, 2454.9360, -786.6678, 1420.9392, 0.0000, 0.0000, 0.0000); // object (57)
	CreateDynamicObject(3115, 2454.9360, -805.0808, 1420.9392, 0.0000, 0.0000, 0.0000); // object (58)
	CreateDynamicObject(3115, 2413.3926, -749.5715, 1420.9392, 0.0000, 0.0000, 0.0000); // object (59)
	CreateDynamicObject(3115, 2433.7783, -749.5715, 1420.9392, 0.0000, 0.0000, 0.0000); // object (60)
	CreateDynamicObject(3115, 2454.9360, -749.5715, 1420.9392, 0.0000, 0.0000, 0.0000); // object (61)
	CreateDynamicObject(14444, 2343.5100, -1387.9600, 1059.8000, 0.0000, 0.0000, 0.0000); // object (62)
	CreateDynamicObject(14388, 1251.8199, -874.0300, 1086.2600, 0.0000, 0.0000, 0.0000); // object (63)
	CreateDynamicObject(14602, 191.1600, 63.6800, 1107.6300, 0.0000, 0.0000, 0.0000); // object (64)
	CreateDynamicObject(14867, 191.9100, 73.5300, 1103.8000, 0.0000, 0.0000, 90.0000); // object (65)
	CreateDynamicObject(14597, 180.7400, 92.7900, 1104.2600, 0.0000, 0.0000, 270.0000); // object (66)
	CreateDynamicObject(14597, 186.9400, 36.5600, 1104.2600, 0.0000, 0.0000, 90.0000); // object (67)
	CreateDynamicObject(2669, 156.2100, 51.3300, 1103.6700, 0.0000, 0.0000, 0.0000); // object (68)
	CreateDynamicObject(14701, -2456.4099, -2673.4900, 1000.6000, 0.0000, 0.0000, 316.0000); // object (69)
	CreateDynamicObject(14701, -2155.9900, -2669.9299, 1000.6300, 0.0000, 0.0000, 180.0000); // object (70)
	CreateDynamicObject(14713, -2468.6201, -2364.9600, 1000.3600, 0.0000, 0.0000, -90.0000); // object (71)
	CreateDynamicObject(14713, -2165.6899, -2366.1699, 1000.3600, 0.0000, 0.0000, 180.0000); // object (72)
	CreateDynamicObject(14710, -2465.0100, -2068.5200, 1000.0600, 0.0000, 0.0000, 0.0000); // object (73)
	CreateDynamicObject(14710, -2168.0200, -2074.4800, 1000.0600, 0.0000, 0.0000, 180.0000); // object (74)
	CreateDynamicObject(14711, -2470.3401, -1767.7700, 1000.1600, 0.0000, 0.0000, 180.0000); // object (75)
	CreateDynamicObject(14711, -2166.6001, -1756.5900, 1000.1600, 0.0000, 0.0000, 180.0000); // object (76)
	CreateDynamicObject(15029, -2469.2900, -1467.2600, 1000.3000, 0.0000, 0.0000, 0.0000); // object (77)
	CreateDynamicObject(15029, -2162.7300, -1467.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (78)
	CreateDynamicObject(14590, -1862.0100, -1167.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (79)
	CreateDynamicObject(14590, -2162.0100, -1167.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (80)
	CreateDynamicObject(14865, -2465.9199, 864.1800, 1000.3100, 0.0000, 0.0000, 0.0000); // object (81)
	CreateDynamicObject(14713, -2465.6899, 1155.7500, 1000.3600, 0.0000, 0.0000, 180.0000); // object (82)
	CreateDynamicObject(14710, -2268.0200, 1347.4399, 1000.0600, 0.0000, 0.0000, 180.0000); // object (83)
	CreateDynamicObject(14701, -1865.4301, -2670.5601, 1000.6300, 0.0000, 0.0000, 0.0000); // object (84)
	CreateDynamicObject(15029, -1969.2900, 1054.6600, 1000.3000, 0.0000, 0.0000, 0.0000); // object (85)
	CreateDynamicObject(15058, -1865.6899, -2366.1699, 1000.3600, 0.0000, 0.0000, 180.0000); // object (86)
	CreateDynamicObject(14383, -1870.3400, -1767.7700, 1000.1600, 0.0000, 0.0000, 180.0000); // object (87)
	CreateDynamicObject(15058, -1865.0100, -2068.5200, 1000.0600, 0.0000, 0.0000, 0.0000); // object (88)
	CreateDynamicObject(15053, -1862.7300, -1467.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (89)
	CreateDynamicObject(15042, -1556.4100, -2673.4900, 1000.6000, 0.0000, 0.0000, 180.0000); // object (90)
	CreateDynamicObject(18026, 414.2600, -79.7500, 1021.6000, 0.0000, 0.0000, 0.0000); // object (92)
	CreateDynamicObject(10615, -2489.3601, 578.8500, 1000.0000, 0.0000, 0.0000, 0.0000); // object (93)
	CreateDynamicObject(3520, -2061.5701, -178.7100, 34.4100, 0.0000, 0.0000, 0.0000); // object (96)
	CreateDynamicObject(3522, -2061.8201, -178.9600, 34.3700, 0.0000, 0.0000, 0.0000); // object (97)
	CreateDynamicObject(1280, -2060.1899, -174.8400, 34.6900, 0.0000, 0.0000, 180.0000); // object (98)
	CreateDynamicObject(3515, -2056.3501, -170.3500, 34.9900, 0.0000, 0.0000, 0.0000); // object (99)
	CreateDynamicObject(700, -2062.1599, -169.8700, 34.1300, 0.0000, 0.0000, 0.0000); // object (100)
	CreateDynamicObject(1568, -2054.6001, -165.7900, 34.2800, 0.0000, 0.0000, 0.0000); // object (101)
	CreateDynamicObject(1568, -2054.6001, -160.5500, 34.2800, 0.0000, 0.0000, 0.0000); // object (102)
	CreateDynamicObject(1238, -2076.0715, -176.7859, 34.6385, 0.0000, 0.0000, 0.0000); // object (103)
	CreateDynamicObject(1238, -2076.2380, -184.5934, 34.6385, 0.0000, 0.0000, 0.0000); // object (104)
	CreateDynamicObject(3520, -2061.7300, -199.8300, 34.4100, 0.0000, 0.0000, 0.0000); // object (105)
	CreateDynamicObject(3522, -2061.8101, -200.3100, 34.3700, 0.0000, 0.0000, 0.0000); // object (106)
	CreateDynamicObject(1238, -2075.9214, -168.6452, 34.6385, 0.0000, 0.0000, 0.0000); // object (107)
	CreateDynamicObject(1568, -2054.6001, -155.3100, 34.2800, 0.0000, 0.0000, 0.0000); // object (108)
	CreateDynamicObject(18285, -2059.6899, -154.3600, 34.3400, 0.0000, -0.3600, 118.0000); // object (109)
	CreateDynamicObject(1280, -2060.1399, -204.3900, 34.6900, 0.0000, 0.0000, 180.0000); // object (110)
	CreateDynamicObject(1238, -2083.4497, -176.4236, 34.6385, 0.0000, 0.0000, 0.0000); // object (111)
	CreateDynamicObject(1238, -2083.2402, -185.0199, 34.6385, 0.0000, 0.0000, 0.0000); // object (112)
	CreateDynamicObject(1238, -2076.0881, -160.0232, 34.6385, 0.0000, 0.0000, 0.0000); // object (113)
	CreateDynamicObject(1238, -2083.6836, -168.9091, 34.6385, 0.0000, 0.0000, 0.0000); // object (114)
	CreateDynamicObject(1568, -2054.6001, -150.0500, 34.2800, 0.0000, 0.0000, 0.0000); // object (115)
	CreateDynamicObject(3515, -2057.1001, -208.4800, 34.9900, 0.0000, 0.0000, 0.0000); // object (116)
	CreateDynamicObject(9950, -2076.9299, -189.6300, 46.2400, 0.0000, 0.0000, 180.0000); // object (117)
	CreateDynamicObject(700, -2061.5901, -210.3100, 34.1300, 0.0000, 0.0000, 0.0000); // object (118)
	CreateDynamicObject(1238, -2083.6621, -160.3963, 34.6385, 0.0000, 0.0000, 0.0000); // object (119)
	CreateDynamicObject(1568, -2055.8000, -212.3500, 34.2800, 0.0000, 0.0000, 0.0000); // object (120)
	CreateDynamicObject(1568, -2054.6001, -144.8000, 34.2800, 0.0000, 0.0000, 0.0000); // object (121)
	CreateDynamicObject(1238, -2076.2107, -150.6393, 34.6385, 0.0000, 0.0000, 0.0000); // object (122)
	CreateDynamicObject(1568, -2055.8000, -217.5500, 34.2800, 0.0000, 0.0000, 0.0000); // object (123)
	CreateDynamicObject(1238, -2083.8987, -151.0594, 34.6385, 0.0000, 0.0000, 0.0000); // object (124)
	CreateDynamicObject(1568, -2054.5601, -139.5700, 34.2800, 0.0000, 0.0000, 0.0000); // object (125)
	CreateDynamicObject(700, -2061.3501, -138.3500, 34.1300, 0.0000, 0.0000, 0.0000); // object (126)
	CreateDynamicObject(1568, -2015.8800, -182.9100, 34.2800, 0.0000, 0.0000, 0.0000); // object (127)
	CreateDynamicObject(1281, -2014.9900, -179.4500, 35.1300, 0.0000, 0.0000, 0.0000); // object (128)
	CreateDynamicObject(1238, -2076.4592, -141.5260, 34.6385, 0.0000, 0.0000, 0.0000); // object (129)
	CreateDynamicObject(1281, -2015.2800, -173.0300, 35.1300, 0.0000, 0.0000, 0.0000); // object (130)
	CreateDynamicObject(1281, -2015.2900, -186.2600, 35.1300, 0.0000, 0.0000, 0.0000); // object (131)
	CreateDynamicObject(1568, -2016.4000, -163.9900, 34.2800, 0.0000, 0.0000, 0.0000); // object (132)
	CreateDynamicObject(1568, -2055.8000, -222.7900, 34.2800, 0.0000, 0.0000, 0.0000); // object (133)
	CreateDynamicObject(1281, -2015.3700, -166.9400, 35.1300, 0.0000, 0.0000, 0.0000); // object (134)
	CreateDynamicObject(1281, -2015.5400, -194.0900, 35.1300, 0.0000, 0.0000, 0.0000); // object (135)
	CreateDynamicObject(700, -2014.7700, -161.7700, 34.1300, 0.0000, 0.0000, 0.0000); // object (136)
	CreateDynamicObject(1568, -2015.3900, -198.4600, 34.2800, 0.0000, 0.0000, 0.0000); // object (137)
	CreateDynamicObject(1238, -2083.9597, -141.6709, 34.6385, 0.0000, 0.0000, 0.0000); // object (138)
	CreateDynamicObject(3515, -2015.5900, -156.8100, 34.9900, 0.0000, 0.0000, 0.0000); // object (139)
	CreateDynamicObject(1280, -2015.0500, -200.9600, 34.6900, 0.0000, 0.0000, 0.0000); // object (140)
	CreateDynamicObject(18285, -2060.6201, -227.0200, 34.3400, 0.0000, -0.3600, 118.0000); // object (141)
	CreateDynamicObject(1568, -2016.3199, -152.7400, 34.2800, 0.0000, 0.0000, 0.0000); // object (142)
	CreateDynamicObject(1568, -2055.8000, -228.0300, 34.2800, 0.0000, 0.0000, 0.0000); // object (143)
	CreateDynamicObject(700, -2014.9200, -204.7800, 34.1300, 0.0000, 0.0000, 0.0000); // object (144)
	CreateDynamicObject(1568, -2015.8101, -206.6300, 34.2800, 0.0000, 0.0000, 0.0000); // object (145)
	CreateDynamicObject(700, -2014.3000, -150.6600, 34.1300, 0.0000, 0.0000, 0.0000); // object (146)
	CreateDynamicObject(1280, -2015.2600, -208.8700, 34.6900, 0.0000, 0.0000, 0.0000); // object (147)
	CreateDynamicObject(1568, -2055.8000, -233.3400, 34.2800, 0.0000, 0.0000, 0.0000); // object (148)
	CreateDynamicObject(700, -2014.8101, -213.1600, 34.1300, 0.0000, 0.0000, 0.0000); // object (149)
	CreateDynamicObject(1568, -2015.9000, -214.8500, 34.2800, 0.0000, 0.0000, 0.0000); // object (150)
	CreateDynamicObject(1280, -2015.3700, -217.3200, 34.6900, 0.0000, 0.0000, 0.0000); // object (151)
	CreateDynamicObject(1568, -2055.8000, -238.5200, 34.2800, 0.0000, 0.0000, 0.0000); // object (152)
	CreateDynamicObject(1568, -2016.2800, -222.3500, 34.2800, 0.0000, 0.0000, 0.0000); // object (153)
	CreateDynamicObject(700, -2014.5601, -220.7300, 34.1300, 0.0000, 0.0000, 0.0000); // object (154)
	CreateDynamicObject(8843, -2049.0901, -117.3600, 34.3000, 0.0000, 0.0000, 180.0000); // object (155)
	CreateDynamicObject(8843, -2043.0400, -117.2700, 34.3000, 0.0000, 0.0000, 0.0000); // object (156)
	CreateDynamicObject(9241, -2082.8601, -121.4800, 35.8700, 0.0000, 0.0000, 180.0000); // object (157)
	CreateDynamicObject(8673, -2048.6699, -242.6900, 34.3500, 0.0000, 0.0000, 0.0000); // object (158)
	CreateDynamicObject(19467, -2027.6100, -236.2200, 34.3600, 0.0000, 15.0000, 180.0000); // object (159)
	CreateDynamicObject(8673, -2069.1399, -242.6900, 34.3500, 0.0000, 0.0000, 0.0000); // object (160)
	CreateDynamicObject(1506, -2030.5300, -120.1900, 34.2600, 0.0000, 0.0000, 0.0000); // object (161)
	CreateDynamicObject(19467, -2027.6100, -237.2900, 34.3600, 0.0000, -15.0000, 0.0000); // object (162)
	CreateDynamicObject(3440, -2022.3101, -235.8900, 33.3300, 0.0000, 0.0000, 0.0000); // object (164)
	CreateDynamicObject(19467, -2023.2500, -236.2200, 35.5300, 0.0000, 15.0000, 180.0000); // object (165)
	CreateDynamicObject(19467, -2023.2500, -237.2900, 35.5300, 0.0000, -15.0000, 0.0000); // object (166)
	CreateDynamicObject(3440, -2022.3101, -237.6100, 33.3300, 0.0000, 0.0000, 0.0000); // object (167)
	CreateDynamicObject(1568, -2019.4800, -122.4100, 34.2800, 0.0000, 0.0000, 0.0000); // object (168)
	CreateDynamicObject(3440, -2018.8800, -235.8900, 33.7400, 0.0000, 0.0000, 0.0000); // object (169)
	CreateDynamicObject(966, -2031.5000, -242.6800, 34.2000, 0.0000, 0.0000, 0.0000); // object (170)
	CreateDynamicObject(700, -2062.9399, -247.5300, 34.1300, 0.0000, 0.0000, 0.0000); // object (171)
	CreateDynamicObject(19467, -2018.8400, -236.2200, 36.1100, 0.0000, 0.0000, 180.0000); // object (172)
	CreateDynamicObject(3440, -2018.8800, -237.6100, 33.7400, 0.0000, 0.0000, 0.0000); // object (173)
	CreateDynamicObject(19467, -2018.8400, -237.2900, 36.1100, 0.0000, 0.0000, 0.0000); // object (174)
	CreateDynamicObject(1568, -2057.2900, -108.6000, 34.2800, 0.0000, 0.0000, 0.0000); // object (175)
	CreateDynamicObject(3440, -2014.3000, -235.8900, 33.7400, 0.0000, 0.0000, 0.0000); // object (176)
	CreateDynamicObject(1568, -2083.6699, -245.1300, 34.2800, 0.0000, 0.0000, 0.0000); // object (177)
	CreateDynamicObject(19467, -2014.3101, -236.2200, 36.1100, 0.0000, 0.0000, 180.0000); // object (178)
	CreateDynamicObject(3440, -2014.3000, -237.6100, 33.7400, 0.0000, 0.0000, 0.0000); // object (179)
	CreateDynamicObject(19467, -2014.3101, -237.2900, 36.1100, 0.0000, 0.0000, 0.0000); // object (180)
	CreateDynamicObject(8673, -2020.6600, -242.6900, 34.3500, 0.0000, 0.0000, 0.0000); // object (181)
	CreateDynamicObject(700, -2092.8401, -246.7200, 34.1300, 0.0000, 0.0000, 0.0000); // object (182)
	CreateDynamicObject(1568, -2084.3401, -105.1900, 34.2800, 0.0000, 0.0000, 0.0000); // object (183)
	CreateDynamicObject(2754, -2035.7061, -102.3549, 35.0740, 0.0000, 0.0000, 270.0000); // object (184)
	CreateDynamicObject(700, -2092.6599, -106.5800, 34.1300, 0.0000, 0.0000, 0.0000); // object (185)
	CreateDynamicObject(3335, -1990.5000, -227.4800, 33.8800, 0.0000, 0.0000, 90.0000); // object (186)
	CreateDynamicObject(1568, -2046.2800, -265.3100, 34.2800, 0.0000, 0.0000, 0.0000); // object (187)
	CreateDynamicObject(1597, -2018.1375, -97.5663, 36.8214, 0.0000, 0.0000, 0.0000); // object (188)
	CreateDynamicObject(984, -2017.0640, -96.1500, 34.8167, 0.0000, 0.0000, 0.0000); // object (189)
	CreateDynamicObject(1280, -2035.4608, -88.6267, 34.7217, 0.0000, 0.0000, 90.0000); // object (190)
	CreateDynamicObject(18285, -2059.9399, -272.4500, 34.3400, 0.0000, -0.3600, 208.0000); // object (191)
	CreateDynamicObject(2799, -2032.0730, -88.8491, 34.8303, 0.0000, 0.0000, 30.0000); // object (192)
	CreateDynamicObject(1280, -2028.6526, -88.6948, 34.7217, 0.0000, 0.0000, 90.0000); // object (193)
	CreateDynamicObject(1594, -2023.8623, -89.3115, 34.7973, 0.0000, 0.0000, 0.0000); // object (194)
	CreateDynamicObject(1594, -2019.7349, -90.8097, 34.7973, 0.0000, 0.0000, 0.0000); // object (195)
	CreateDynamicObject(1280, -2038.0577, -83.8963, 34.7217, 0.0000, 0.0000, 0.0000); // object (196)
	CreateDynamicObject(3660, -2026.9607, -87.1264, 37.1687, 0.0000, 0.0000, 179.9945); // object (197)
	CreateDynamicObject(1280, -2019.9653, -88.6937, 34.7217, 0.0000, 0.0000, 90.0000); // object (198)
	CreateDynamicObject(700, -2014.7800, -267.4700, 34.1300, 0.0000, 0.0000, 0.0000); // object (199)
	CreateDynamicObject(18285, -2028.4100, -273.0900, 34.3400, 0.0000, -0.3600, 208.0000); // object (200)
	CreateDynamicObject(700, -2043.3400, -276.5400, 34.1300, 0.0000, 0.0000, 0.0000); // object (201)
	CreateDynamicObject(1597, -2057.2061, -81.1977, 36.9777, 0.0000, 0.0000, 270.0000); // object (202)
	CreateDynamicObject(983, -2054.2773, -80.2272, 34.8587, 0.0000, 0.0000, 270.0000); // object (203)
	CreateDynamicObject(984, -2063.8650, -80.2189, 34.7970, 0.0000, 0.0000, 270.0000); // object (204)
	CreateDynamicObject(3660, -2026.9762, -84.9220, 37.1687, 0.0000, 0.0000, 359.9995); // object (205)
	CreateDynamicObject(966, -2043.6587, -80.3096, 34.1641, 0.0000, 0.0000, 0.0000); // object (206)
	CreateDynamicObject(3660, -2026.9741, -83.4828, 37.1687, 0.0000, 0.0000, 180.0000); // object (208)
	CreateDynamicObject(984, -2017.0745, -86.5584, 34.8215, 0.0000, 0.0000, 0.0000); // object (209)
	CreateDynamicObject(984, -2036.2312, -80.1909, 34.7970, 0.0000, 0.0000, 270.0000); // object (210)
	CreateDynamicObject(982, -2083.0479, -80.2039, 34.8387, 0.0000, 0.0000, 270.0000); // object (211)
	CreateDynamicObject(3660, -2026.9741, -80.9573, 37.1687, 0.0000, 0.0000, 0.0000); // object (212)
	CreateDynamicObject(700, -2092.6699, -277.3000, 34.1300, 0.0000, 0.0000, 0.0000); // object (215)
	CreateDynamicObject(984, -2023.4591, -80.1776, 34.8170, 0.0000, 0.0000, 270.0000); // object (216)
	CreateDynamicObject(1257, -2030.9200, -61.1100, 35.3000, 0.0000, 0.0000, 90.0000); // object (218)
	CreateDynamicObject(10837, -2010.5699, -42.2700, 38.3100, 0.0000, 0.0000, -104.0000); // object (221)
	CreateDynamicObject(2992, 1967.1100, 1022.5000, 992.3600, 0.0000, 0.0000, 0.0000); // object (222)
	CreateDynamicObject(2992, 1967.2999, 1015.1100, 992.3600, 0.0000, 0.0000, 0.0000); // object (223)
    //========================= Админ-квартира =================================
	CreateObject(3115,2413.39331055,-805.08081055,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (1)
	CreateObject(3115,2433.77832031,-805.08007812,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (2)
	CreateObject(3115,2413.39331055,-786.73712158,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (3)
	CreateObject(3115,2433.77832031,-786.73632812,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (4)
	CreateObject(3115,2413.39257812,-768.06152344,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (5)
	CreateObject(3115,2433.77832031,-768.06152344,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (4)
	CreateDynamicObject(5442,2434.75122070,-784.52813721,1421.44885254,0.00000000,0.00000000,90.00000000); //object(binnt07_la) (1)
	CreateObject(3115,2454.93603516,-768.06152344,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (4)
	CreateObject(3115,2454.93603516,-786.66784668,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (4)
	CreateObject(3115,2454.93603516,-805.08007812,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (4)
	CreateObject(3115,2413.39257812,-749.57153320,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (5)
	CreateObject(3115,2433.77832031,-749.57153320,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (5)
	CreateObject(3115,2454.93603516,-749.57153320,1420.93920898,0.00000000,0.00000000,0.00000000); //object(carrier_lift1_sfse) (5)
	CreateDynamicObject(3313,2415.34033203,-801.94824219,1424.20129395,0.00000000,0.00000000,90.00000000); //object(sw_woodhaus03) (1)
	CreateDynamicObject(3313,2415.34033203,-776.85382080,1424.22790527,0.00000000,0.00000000,90.00000000); //object(sw_woodhaus03) (2)
	CreateDynamicObject(3313,2415.34033203,-752.01678467,1424.21081543,0.00000000,0.00000000,90.00000000); //object(sw_woodhaus03) (3)
	CreateDynamicObject(3312,2452.97460938,-801.88977051,1424.29797363,0.00000000,0.00000000,0.00000000); //object(sw_woodhaus02) (1)
	CreateDynamicObject(3312,2452.97460938,-776.95153809,1424.29797363,0.00000000,0.00000000,0.00000000); //object(sw_woodhaus02) (2)
	CreateDynamicObject(3312,2452.97460938,-751.93359375,1424.29797363,0.00000000,0.00000000,0.00000000); //object(sw_woodhaus02) (3)
	CreateDynamicObject(5442,2434.75122070,-769.43823242,1421.44885254,0.00000000,0.00000000,90.00000000); //object(binnt07_la) (1)
	CreateDynamicObject(8646,2438.49707031,-814.22290039,1422.21020508,0.00000000,0.00000000,90.00000000); //object(shbbyhswall02_lvs) (1)
	CreateDynamicObject(8646,2447.28002930,-739.69586182,1422.22692871,0.00000000,0.00000000,90.00000000); //object(shbbyhswall02_lvs) (2)
	CreateDynamicObject(8646,2424.17236328,-739.69586182,1422.21667480,0.00000000,0.00000000,90.00000000); //object(shbbyhswall02_lvs) (3)
	//========================= Присон =========================================
	CreateObject(18759,5512.3423,1244.4044,22.188636779785,0.00000000,0.00000000,0.00000000, 250.0); //Присон
	//======================= Респа ============================================
	CreateDynamicObject(983, 1256.73, -1842.25, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1250.36, -1842.27, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1244.00, -1842.28, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1250.36, -1842.27, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1237.62, -1842.31, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1231.22, -1842.31, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1228.04, -1842.32, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1284.22, -1842.26, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1287.43, -1839.06, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1287.43, -1832.68, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1287.43, -1826.30, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1287.44, -1819.94, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1287.44, -1813.56, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1287.45, -1807.18, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1287.45, -1800.80, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1287.47, -1796.00, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1284.86, -1790.98, 13.08,   0.00, 0.00, 54.50);
	CreateDynamicObject(983, 1279.67, -1787.27, 13.08,   0.00, 0.00, 54.50);
	CreateDynamicObject(983, 1193.18, -1842.25, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1199.55, -1842.25, 13.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1189.98, -1839.04, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1189.95, -1832.63, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1189.96, -1826.25, 13.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1192.75, -1821.50, 13.08,   0.00, 0.00, -61.00);
	//============== Medical by Charles_Harrell =============================
	CreateObject(18755, 1786.6781, -1303.4595, 14.5710, 0.0000, 0.0000, 270.0000); // object (1)
    CreateObject(18757, 1788.2277, -1303.4595, 14.5266, 0.0000, 0.0000, 270.0000); // object (2)
    CreateObject(18756, 1785.0277, -1303.4595, 14.5266, 0.0000, 0.0000, 270.0000); // object (3)
    CreateObject(18757, 1788.2277, -1303.1711, 14.5115, 0.0000, 0.0000, 270.0000); // object (4)
    CreateObject(18756, 1785.0277, -1303.1711, 14.5115, 0.0000, 0.0000, 270.0000); // object (5)
    CreateObject(18757, 1786.6277, -1303.1711, 23.0594, 0.0000, 0.0000, 270.0000); // object (6)
    CreateObject(18756, 1786.6277, -1303.1711, 23.0594, 0.0000, 0.0000, 270.0000); // object (7)
    CreateObject(18757, 1786.6277, -1303.1711, 28.5109, 0.0000, 0.0000, 270.0000); // object (8)
    CreateObject(18756, 1786.6277, -1303.1711, 28.5109, 0.0000, 0.0000, 270.0000); // object (9)
    CreateObject(18757, 1786.6277, -1303.1711, 33.9625, 0.0000, 0.0000, 270.0000); // object (10)
    CreateObject(18756, 1786.6277, -1303.1711, 33.9625, 0.0000, 0.0000, 270.0000); // object (11)
    CreateObject(18757, 1786.6277, -1303.1711, 39.4140, 0.0000, 0.0000, 270.0000); // object (12)
    CreateObject(18756, 1786.6277, -1303.1711, 39.4140, 0.0000, 0.0000, 270.0000); // object (13)
    CreateObject(18757, 1786.6277, -1303.1711, 44.8656, 0.0000, 0.0000, 270.0000); // object (14)
    CreateObject(18756, 1786.6277, -1303.1711, 44.8656, 0.0000, 0.0000, 270.0000); // object (15)
    CreateObject(18757, 1786.6277, -1303.1711, 50.3171, 0.0000, 0.0000, 270.0000); // object (16)
    CreateObject(18756, 1786.6277, -1303.1711, 50.3171, 0.0000, 0.0000, 270.0000); // object (17)
    CreateObject(18757, 1786.6277, -1303.1711, 55.7687, 0.0000, 0.0000, 270.0000); // object (18)
    CreateObject(18756, 1786.6277, -1303.1711, 55.7687, 0.0000, 0.0000, 270.0000); // object (19)
    CreateObject(18757, 1786.6277, -1303.1711, 61.2202, 0.0000, 0.0000, 270.0000); // object (20)
    CreateObject(18756, 1786.6277, -1303.1711, 61.2202, 0.0000, 0.0000, 270.0000); // object (21)
    CreateObject(18757, 1786.6277, -1303.1711, 66.6718, 0.0000, 0.0000, 270.0000); // object (22)
    CreateObject(18756, 1786.6277, -1303.1711, 66.6718, 0.0000, 0.0000, 270.0000); // object (23)
    CreateObject(18757, 1786.6277, -1303.1711, 72.1233, 0.0000, 0.0000, 270.0000); // object (24)
    CreateObject(18756, 1786.6277, -1303.1711, 72.1233, 0.0000, 0.0000, 270.0000); // object (25)
    CreateObject(18757, 1786.6277, -1303.1711, 77.5749, 0.0000, 0.0000, 270.0000); // object (26)
    CreateObject(18756, 1786.6277, -1303.1711, 77.5749, 0.0000, 0.0000, 270.0000); // object (27)
    CreateObject(18757, 1786.6277, -1303.1711, 83.0264, 0.0000, 0.0000, 270.0000); // object (28)
    CreateObject(18756, 1786.6277, -1303.1711, 83.0264, 0.0000, 0.0000, 270.0000); // object (29)
    CreateObject(18757, 1786.6277, -1303.1711, 88.4780, 0.0000, 0.0000, 270.0000); // object (30)
    CreateObject(18756, 1786.6277, -1303.1711, 88.4780, 0.0000, 0.0000, 270.0000); // object (31)
    CreateObject(18757, 1786.6277, -1303.1711, 93.9295, 0.0000, 0.0000, 270.0000); // object (32)
    CreateObject(18756, 1786.6277, -1303.1711, 93.9295, 0.0000, 0.0000, 270.0000); // object (33)
    CreateObject(18757, 1786.6277, -1303.1711, 99.3811, 0.0000, 0.0000, 270.0000); // object (34)
    CreateObject(18756, 1786.6277, -1303.1711, 99.3811, 0.0000, 0.0000, 270.0000); // object (35)
    CreateObject(18757, 1786.6277, -1303.1711, 104.8326, 0.0000, 0.0000, 270.0000); // object (36)
    CreateObject(18756, 1786.6277, -1303.1711, 104.8326, 0.0000, 0.0000, 270.0000); // object (37)
    CreateObject(18757, 1786.6277, -1303.1711, 110.2842, 0.0000, 0.0000, 270.0000); // object (38)
    CreateObject(18756, 1786.6277, -1303.1711, 110.2842, 0.0000, 0.0000, 270.0000); // object (39)
    CreateObject(18757, 1786.6277, -1303.1711, 115.7357, 0.0000, 0.0000, 270.0000); // object (40)
    CreateObject(18756, 1786.6277, -1303.1711, 115.7357, 0.0000, 0.0000, 270.0000); // object (41)
    CreateObject(18757, 1786.6277, -1303.1711, 121.1873, 0.0000, 0.0000, 270.0000); // object (42)
    CreateObject(18756, 1786.6277, -1303.1711, 121.1873, 0.0000, 0.0000, 270.0000); // object (43)
    CreateObject(18757, 1786.6277, -1303.1711, 126.6388, 0.0000, 0.0000, 270.0000); // object (44)
    CreateObject(18756, 1786.6277, -1303.1711, 126.6388, 0.0000, 0.0000, 270.0000); // object (45)
    CreateObject(5706, 135.9336, 1953.4072, 23.3076, 0.0000, 0.0000, 179.9945); // object (47)
    CreateObject(3707, 353.6700, 1950.3446, 24.6238, 0.1416, 0.0000, 180.0000); // object (48)
    CreateObject(18759, 5512.3423, 1244.4044, 22.1886, 0.0000, 0.0000, 0.0000); // object (49)
    CreateObject(3115, 2413.3933, -805.0808, 1420.9392, 0.0000, 0.0000, 0.0000); // object (50)
    CreateObject(3115, 2433.7783, -805.0808, 1420.9392, 0.0000, 0.0000, 0.0000); // object (51)
    CreateObject(3115, 2413.3933, -786.7371, 1420.9392, 0.0000, 0.0000, 0.0000); // object (52)
    CreateObject(3115, 2433.7783, -786.7363, 1420.9392, 0.0000, 0.0000, 0.0000); // object (53)
    CreateObject(3115, 2413.3926, -768.0615, 1420.9392, 0.0000, 0.0000, 0.0000); // object (54)
    CreateObject(3115, 2433.7783, -768.0615, 1420.9392, 0.0000, 0.0000, 0.0000); // object (55)
    CreateObject(3115, 2454.9360, -768.0615, 1420.9392, 0.0000, 0.0000, 0.0000); // object (56)
    CreateObject(3115, 2454.9360, -786.6678, 1420.9392, 0.0000, 0.0000, 0.0000); // object (57)
    CreateObject(3115, 2454.9360, -805.0808, 1420.9392, 0.0000, 0.0000, 0.0000); // object (58)
    CreateObject(3115, 2413.3926, -749.5715, 1420.9392, 0.0000, 0.0000, 0.0000); // object (59)
    CreateObject(3115, 2433.7783, -749.5715, 1420.9392, 0.0000, 0.0000, 0.0000); // object (60)
    CreateObject(3115, 2454.9360, -749.5715, 1420.9392, 0.0000, 0.0000, 0.0000); // object (61)
    CreateObject(14444, 2343.5100, -1387.9600, 1059.8000, 0.0000, 0.0000, 0.0000); // object (62)
    CreateObject(14388, 1251.8199, -874.0300, 1086.2600, 0.0000, 0.0000, 0.0000); // object (63)
    CreateObject(14602, 191.1600, 63.6800, 1107.6300, 0.0000, 0.0000, 0.0000); // object (64)
    CreateObject(14867, 191.9100, 73.5300, 1103.8000, 0.0000, 0.0000, 90.0000); // object (65)
    CreateObject(14597, 180.7400, 92.7900, 1104.2600, 0.0000, 0.0000, 270.0000); // object (66)
    CreateObject(14597, 186.9400, 36.5600, 1104.2600, 0.0000, 0.0000, 90.0000); // object (67)
    CreateObject(2669, 156.2100, 51.3300, 1103.6700, 0.0000, 0.0000, 0.0000); // object (68)
    CreateObject(14701, -2456.4099, -2673.4900, 1000.6000, 0.0000, 0.0000, 316.0000); // object (69)
    CreateObject(14701, -2155.9900, -2669.9299, 1000.6300, 0.0000, 0.0000, 180.0000); // object (70)
    CreateObject(14713, -2468.6201, -2364.9600, 1000.3600, 0.0000, 0.0000, -90.0000); // object (71)
    CreateObject(14713, -2165.6899, -2366.1699, 1000.3600, 0.0000, 0.0000, 180.0000); // object (72)
    CreateObject(14710, -2465.0100, -2068.5200, 1000.0600, 0.0000, 0.0000, 0.0000); // object (73)
    CreateObject(14710, -2168.0200, -2074.4800, 1000.0600, 0.0000, 0.0000, 180.0000); // object (74)
    CreateObject(14711, -2470.3401, -1767.7700, 1000.1600, 0.0000, 0.0000, 180.0000); // object (75)
    CreateObject(14711, -2166.6001, -1756.5900, 1000.1600, 0.0000, 0.0000, 180.0000); // object (76)
    CreateObject(15029, -2469.2900, -1467.2600, 1000.3000, 0.0000, 0.0000, 0.0000); // object (77)
    CreateObject(15029, -2162.7300, -1467.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (78)
    CreateObject(14590, -1862.0100, -1167.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (79)
    CreateObject(14590, -2162.0100, -1167.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (80)
    CreateObject(14865, -2465.9199, 864.1800, 1000.3100, 0.0000, 0.0000, 0.0000); // object (81)
    CreateObject(14713, -2465.6899, 1155.7500, 1000.3600, 0.0000, 0.0000, 180.0000); // object (82)
    CreateObject(14710, -2268.0200, 1347.4399, 1000.0600, 0.0000, 0.0000, 180.0000); // object (83)
    CreateObject(14701, -1865.4301, -2670.5601, 1000.6300, 0.0000, 0.0000, 0.0000); // object (84)
    CreateObject(15029, -1969.2900, 1054.6600, 1000.3000, 0.0000, 0.0000, 0.0000); // object (85)
    CreateObject(15058, -1865.6899, -2366.1699, 1000.3600, 0.0000, 0.0000, 180.0000); // object (86)
    CreateObject(14383, -1870.3400, -1767.7700, 1000.1600, 0.0000, 0.0000, 180.0000); // object (87)
    CreateObject(15058, -1865.0100, -2068.5200, 1000.0600, 0.0000, 0.0000, 0.0000); // object (88)
    CreateObject(15053, -1862.7300, -1467.9399, 1000.3000, 0.0000, 0.0000, -90.0000); // object (89)
    CreateObject(15042, -1556.4100, -2673.4900, 1000.6000, 0.0000, 0.0000, 180.0000); // object (90)
    CreateObject(18026, 414.2600, -79.7500, 1021.6000, 0.0000, 0.0000, 0.0000); // object (92)
    CreateObject(10615, -2489.3601, 578.8500, 1000.0000, 0.0000, 0.0000, 0.0000); // object (93)
    CreateObject(19338, 329.7500, -1851.2800, 2.9200, 0.0000, 0.0000, 0.0000); // object (94)
    CreateObject(19335, -1250.4100, -736.8300, 89.9600, 0.0000, 0.0000, 0.0000); // object (95)
    CreateObject(1805, 168.7000, 92.2600, 1102.4500, 0.0000, 0.0000, 0.0000); // object (96)
    CreateObject(1805, 168.6800, 93.9300, 1102.4500, 0.0000, 0.0000, 0.0000); // object (97)
    CreateObject(1796, 168.7400, 93.0000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (98)
    CreateObject(1796, 168.6100, 93.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (99)
    CreateObject(1805, 171.0300, 92.2100, 1102.4500, 0.0000, 0.0000, 0.0000); // object (100)
    CreateObject(1796, 170.9800, 93.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (101)
    CreateObject(1805, 171.0300, 93.9700, 1102.4500, 0.0000, 0.0000, 0.0000); // object (102)
    CreateObject(1796, 171.1200, 93.0000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (103)
    CreateObject(2021, 170.0000, 95.2000, 1102.2500, 0.0000, 0.0000, 0.0000); // object (104)
    CreateObject(2021, 169.9600, 90.8300, 1102.2500, 0.0000, 0.0000, 180.0000); // object (105)
    CreateObject(2021, 167.6600, 95.1900, 1102.2500, 0.0000, 0.0000, 0.0000); // object (106)
    CreateObject(2021, 167.5500, 90.8400, 1102.2500, 0.0000, 0.0000, 180.0000); // object (107)
    CreateObject(2021, 172.2300, 90.8600, 1102.2500, 0.0000, 0.0000, 180.0000); // object (108)
    CreateObject(2021, 172.2900, 95.2000, 1102.2500, 0.0000, 0.0000, 0.0000); // object (109)
    CreateObject(1796, 173.2400, 93.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (110)
    CreateObject(1805, 173.3100, 92.2000, 1102.4500, 0.0000, 0.0000, 0.0000); // object (111)
    CreateObject(1805, 173.3600, 93.8800, 1102.4500, 0.0000, 0.0000, 0.0000); // object (112)
    CreateObject(1796, 173.4700, 93.0000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (113)
    CreateObject(2021, 174.6100, 95.2200, 1102.2500, 0.0000, 0.0000, 0.0000); // object (114)
    CreateObject(2021, 174.6000, 90.8500, 1102.2500, 0.0000, 0.0000, 180.0000); // object (115)
    CreateObject(1997, 168.6500, 87.6600, 1102.2700, 0.0000, 0.0000, 0.0000); // object (116)
    CreateObject(1997, 170.9900, 87.6600, 1102.2700, 0.0000, 0.0000, 0.0000); // object (117)
    CreateObject(1805, 175.6900, 92.1900, 1102.4500, 0.0000, 0.0000, 0.0000); // object (118)
    CreateObject(1796, 175.7000, 93.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (119)
    CreateObject(1805, 175.7600, 93.9300, 1102.4500, 0.0000, 0.0000, 0.0000); // object (120)
    CreateObject(1796, 175.8500, 93.0000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (121)
    CreateObject(1997, 173.2500, 87.6600, 1102.2700, 0.0000, 0.0000, 0.0000); // object (122)
    CreateObject(1997, 175.5900, 87.6600, 1102.2700, 0.0000, 0.0000, 0.0000); // object (123)
    CreateObject(1997, 171.5700, 82.5800, 1102.2700, 0.0000, 0.0000, 180.0000); // object (124)
    CreateObject(1805, 179.9600, 97.7000, 1102.4500, 0.0000, 0.0000, 0.0000); // object (125)
    CreateObject(14532, 172.6900, 81.9700, 1103.2500, 0.0000, 0.0000, 0.0000); // object (126)
    CreateObject(2021, 179.2600, 99.9800, 1102.2500, 0.0000, 0.0000, 90.0000); // object (127)
    CreateObject(2021, 179.3500, 99.8900, 1102.2500, 0.0000, 0.0000, 90.0000); // object (128)
    CreateObject(1796, 180.1100, 98.7100, 1102.0000, 0.0000, 0.0000, -90.0000); // object (129)
    CreateObject(2994, 173.7700, 81.8400, 1102.7700, 0.0000, 0.0000, 270.0000); // object (130)
    CreateObject(1997, 175.3700, 82.5800, 1102.2700, 0.0000, 0.0000, 180.0000); // object (131)
    CreateObject(1805, 180.0800, 100.1900, 1102.4500, 0.0000, 0.0000, 0.0000); // object (132)
    CreateObject(1805, 181.6600, 97.6800, 1102.4500, 0.0000, 0.0000, 0.0000); // object (133)
    CreateObject(1796, 181.4000, 98.5300, 1102.0000, 0.0000, 0.0000, 90.0000); // object (134)
    CreateObject(14532, 176.6700, 81.9700, 1103.2500, 0.0000, 0.0000, 0.0000); // object (135)
    CreateObject(1796, 180.1100, 101.3000, 1102.0000, 0.0000, 0.0000, -90.0000); // object (136)
    CreateObject(2021, 179.2500, 102.4700, 1102.2500, 0.0000, 0.0000, 90.0000); // object (137)
    CreateObject(2021, 179.2500, 102.4700, 1102.2500, 0.0000, 0.0000, 90.0000); // object (138)
    CreateObject(1805, 181.5100, 100.2200, 1102.4500, 0.0000, 0.0000, 0.0000); // object (139)
    CreateObject(2021, 181.7300, 99.8700, 1102.2500, 0.0000, 0.0000, -90.0000); // object (140)
    CreateObject(2021, 181.7300, 99.8700, 1102.2500, 0.0000, 0.0000, -90.0000); // object (141)
    CreateObject(1805, 180.0200, 102.8000, 1102.4500, 0.0000, 0.0000, 0.0000); // object (142)
    CreateObject(1796, 181.4000, 101.0600, 1102.0000, 0.0000, 0.0000, 90.0000); // object (143)
    CreateObject(1766, 174.1400, 78.7500, 1102.1899, 0.0000, 0.0000, 0.0000); // object (144)
    CreateObject(1796, 180.1100, 103.9300, 1102.0000, 0.0000, 0.0000, -90.0000); // object (145)
    CreateObject(627, 173.1900, 78.2900, 1104.0300, 0.0000, 0.0000, 0.0000); // object (146)
    CreateObject(1997, 184.6900, 90.7600, 1102.2700, 0.0000, 0.0000, 180.0000); // object (147)
    CreateObject(1805, 181.5100, 102.8200, 1102.4500, 0.0000, 0.0000, 0.0000); // object (148)
    CreateObject(2021, 181.8200, 102.4700, 1102.2500, 0.0000, 0.0000, -90.0000); // object (149)
    CreateObject(2021, 181.8200, 102.4700, 1102.2500, 0.0000, 0.0000, -90.0000); // object (150)
    CreateObject(2021, 179.3900, 105.0900, 1102.2500, 0.0000, 0.0000, 90.0000); // object (151)
    CreateObject(2164, 168.4600, 77.2800, 1102.2300, 0.0000, 0.0000, 90.0000); // object (152)
    CreateObject(1796, 181.4000, 103.6800, 1102.0000, 0.0000, 0.0000, 90.0000); // object (153)
    CreateObject(1766, 177.4700, 78.7400, 1102.1899, 0.0000, 0.0000, 0.0000); // object (154)
    CreateObject(9131, 179.9000, 79.8600, 1102.1400, 0.0000, 0.0000, 0.0000); // object (155)
    CreateObject(9131, 179.9000, 79.8600, 1104.4100, 0.0000, 0.0000, 0.0000); // object (156)
    CreateObject(3396, 186.3400, 95.8000, 1102.2400, 0.0000, 0.0000, 90.0000); // object (157)
    CreateObject(1502, 180.4000, 79.6900, 1102.2700, 0.0000, 0.0000, 0.0000); // object (158)
    CreateObject(1805, 185.4300, 85.9200, 1102.4500, 0.0000, 0.0000, 0.0000); // object (159)
    CreateObject(2021, 182.0500, 105.1400, 1102.2500, 0.0000, 0.0000, -90.0000); // object (160)
    CreateObject(3396, 186.8400, 90.0000, 1102.2400, 0.0000, 0.0000, -90.0000); // object (161)
    CreateObject(1796, 185.2900, 85.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (162)
    CreateObject(2164, 168.4600, 75.5100, 1102.2300, 0.0000, 0.0000, 90.0000); // object (163)
    CreateObject(9131, 181.3400, 79.7600, 1105.1500, 0.0000, 90.0000, 0.0000); // object (164)
    CreateObject(1796, 185.5900, 85.1000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (165)
    CreateObject(2021, 186.6000, 87.3600, 1102.2500, 0.0000, 0.0000, 0.0000); // object (166)
    CreateObject(1805, 185.3700, 84.3200, 1102.4500, 0.0000, 0.0000, 0.0000); // object (167)
    CreateObject(9131, 182.4500, 79.9500, 1102.1400, 0.0000, 0.0000, 0.0000); // object (168)
    CreateObject(9131, 182.4500, 79.9500, 1104.4100, 0.0000, 0.0000, 0.0000); // object (169)
    CreateObject(3383, 188.5300, 93.1400, 1102.2700, 0.0000, 0.0000, 0.0000); // object (170)
    CreateObject(2164, 168.4600, 73.7500, 1102.2200, 0.0000, 0.0000, 90.0000); // object (171)
    CreateObject(627, 182.7700, 78.7300, 1104.0300, 0.0000, 0.0000, 0.0000); // object (172)
    CreateObject(1805, 187.8100, 85.9200, 1102.4500, 0.0000, 0.0000, 0.0000); // object (173)
    CreateObject(2021, 186.6800, 83.0600, 1102.2500, 0.0000, 0.0000, 180.0000); // object (174)
    CreateObject(1796, 187.7400, 85.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (175)
    CreateObject(1796, 187.9900, 85.1000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (176)
    CreateObject(1805, 187.8000, 84.2700, 1102.4500, 0.0000, 0.0000, 0.0000); // object (177)
    CreateObject(2021, 189.0000, 87.3800, 1102.2500, 0.0000, 0.0000, 0.0000); // object (178)
    CreateObject(2154, 189.5600, 89.6000, 1102.2700, 0.0000, 0.0000, 180.0000); // object (179)
    CreateObject(1649, 183.5500, 76.9700, 1103.9301, 0.0000, 0.0000, 90.0000); // object (180)
    CreateObject(1649, 183.6000, 76.9800, 1103.9301, 0.0000, 0.0000, 270.0000); // object (181)
    CreateObject(2151, 190.9300, 89.6000, 1102.2700, 0.0000, 0.0000, 180.0000); // object (182)
    CreateObject(1805, 190.1700, 85.8900, 1102.4500, 0.0000, 0.0000, 0.0000); // object (183)
    CreateObject(2164, 168.4600, 71.3200, 1102.2300, 0.0000, 0.0000, 90.0000); // object (184)
    CreateObject(14532, 191.5100, 94.0200, 1103.2600, 0.0000, 0.0000, 61.0000); // object (185)
    CreateObject(2021, 189.1100, 83.0500, 1102.2500, 0.0000, 0.0000, 180.0000); // object (186)
    CreateObject(1796, 190.1600, 85.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (187)
    CreateObject(14532, 191.7000, 95.2100, 1103.2500, 0.0000, 0.0000, 90.0000); // object (188)
    CreateObject(2296, 186.8700, 79.0100, 1102.2700, 0.0000, 0.0000, 0.0000); // object (189)
    CreateObject(1796, 190.3900, 85.1000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (190)
    CreateObject(1805, 190.1700, 84.3500, 1102.4500, 0.0000, 0.0000, 0.0000); // object (191)
    CreateObject(2021, 191.4700, 87.4100, 1102.2500, 0.0000, 0.0000, 0.0000); // object (192)
    CreateObject(2151, 192.3000, 89.6000, 1102.2700, 0.0000, 0.0000, 180.0000); // object (193)
    CreateObject(2164, 168.4600, 69.5600, 1102.2300, 0.0000, 0.0000, 90.0000); // object (194)
    CreateObject(3394, 193.4900, 92.8600, 1102.2400, 0.0000, 0.0000, 0.0000); // object (195)
    CreateObject(2021, 191.4600, 83.0900, 1102.2500, 0.0000, 0.0000, 180.0000); // object (196)
    CreateObject(1805, 192.7400, 85.8900, 1102.4500, 0.0000, 0.0000, 0.0000); // object (197)
    CreateObject(2151, 193.6600, 89.6000, 1102.2700, 0.0000, 0.0000, 180.0000); // object (198)
    CreateObject(1796, 192.7300, 85.1000, 1102.0000, 0.0000, 0.0000, 0.0000); // object (199)
    CreateObject(1766, 182.8100, 72.4400, 1102.1899, 0.0000, 0.0000, -90.0000); // object (200)
    CreateObject(1796, 192.8000, 85.1000, 1102.0000, 0.0000, 0.0000, 180.0000); // object (201)
    CreateObject(1805, 192.6500, 84.3500, 1102.4500, 0.0000, 0.0000, 0.0000); // object (202)
    CreateObject(2021, 193.8700, 87.4100, 1102.2500, 0.0000, 0.0000, 0.0000); // object (203)
    CreateObject(2164, 168.4600, 67.7900, 1102.2300, 0.0000, 0.0000, 90.0000); // object (204)
    CreateObject(1649, 183.5400, 71.7600, 1103.9301, 0.0000, 0.0000, 90.0000); // object (205)
    CreateObject(1649, 183.5700, 71.7600, 1103.9301, 0.0000, 0.0000, 270.0000); // object (206)
    CreateObject(1808, 190.2900, 78.0000, 1102.2700, 0.0000, 0.0000, 320.0000); // object (207)
    CreateObject(1703, 186.0000, 73.1000, 1102.2700, 0.0000, 0.0000, 90.0000); // object (208)
    CreateObject(2021, 193.7900, 83.0500, 1102.2500, 0.0000, 0.0000, 180.0000); // object (209)
    CreateObject(1703, 189.3400, 75.1700, 1102.2700, 0.0000, 0.0000, 270.0000); // object (210)
    CreateObject(627, 182.7000, 69.5000, 1104.0300, 0.0000, 0.0000, 0.0000); // object (211)
    CreateObject(1671, 169.1400, 64.4900, 1102.7300, 0.0000, 0.0000, 272.0000); // object (212)
    CreateObject(2165, 168.5100, 63.8200, 1102.2700, 0.0000, 0.0000, 92.0000); // object (213)
    CreateObject(1671, 173.3400, 63.4400, 1102.7300, 0.0000, 0.0000, 90.0000); // object (214)
    CreateObject(1649, 188.4600, 69.5200, 1103.9301, 0.0000, 0.0000, 180.0000); // object (215)
    CreateObject(1649, 188.4200, 69.3400, 1103.9301, 0.0000, 0.0000, 0.0000); // object (216)
    CreateObject(2202, 168.6200, 62.0000, 1102.2700, 0.0000, 0.0000, 92.0000); // object (217)
    CreateObject(627, 191.3100, 68.4600, 1104.0300, 0.0000, 0.0000, 0.0000); // object (218)
    CreateObject(1649, 192.8900, 69.5200, 1103.9301, 0.0000, 0.0000, 180.0000); // object (219)
    CreateObject(1649, 192.8300, 69.3400, 1103.9500, 0.0000, 0.0000, 0.0000); // object (220)
    CreateObject(2164, 168.4600, 59.4100, 1102.3000, 0.0000, 0.0000, 90.0000); // object (221)
    CreateObject(1811, 193.4000, 67.2800, 1102.8500, 0.0000, 0.0000, 90.0000); // object (222)
    CreateObject(2164, 168.4600, 57.6500, 1102.3000, 0.0000, 0.0000, 90.0000); // object (223)
    CreateObject(1811, 194.6200, 67.2400, 1102.8500, 0.0000, 0.0000, 90.0000); // object (224)
    CreateObject(1811, 195.7600, 67.2600, 1102.8500, 0.0000, 0.0000, 90.0000); // object (225)
    CreateObject(2164, 168.4600, 55.8800, 1102.3000, 0.0000, 0.0000, 90.0000); // object (226)
    CreateObject(1811, 197.0200, 67.2500, 1102.8500, 0.0000, 0.0000, 90.0000); // object (227)
    CreateObject(1811, 198.0800, 67.2300, 1102.8500, 0.0000, 0.0000, 90.0000); // object (228)
    CreateObject(1808, 183.2800, 56.3500, 1102.0000, 0.0000, 0.0000, -90.0000); // object (229)
    CreateObject(1811, 199.2600, 67.2300, 1102.8500, 0.0000, 0.0000, 90.0000); // object (230)
    CreateObject(2164, 168.4600, 53.4800, 1102.3000, 0.0000, 0.0000, 90.0000); // object (231)
    CreateObject(1766, 183.0500, 55.5800, 1102.1899, 0.0000, 0.0000, -90.0000); // object (232)
    CreateObject(1502, 185.8700, 56.5700, 1102.2700, 0.0000, 0.0000, 0.0000); // object (233)
    CreateObject(1811, 200.5000, 67.2500, 1102.8500, 0.0000, 0.0000, 90.0000); // object (234)
    CreateObject(627, 188.1800, 57.1600, 1104.0300, 0.0000, 0.0000, 0.0000); // object (235)
    CreateObject(1811, 201.6700, 67.2800, 1102.8500, 0.0000, 0.0000, 90.0000); // object (236)
    CreateObject(2099, 156.8500, 53.9000, 1102.4500, 0.0000, 0.0000, 0.0000); // object (237)
    CreateObject(2164, 168.4600, 51.7000, 1102.3000, 0.0000, 0.0000, 90.0000); // object (238)
    CreateObject(1766, 191.7400, 57.1700, 1102.1899, 0.0000, 0.0000, 180.0000); // object (239)
    CreateObject(627, 182.8600, 52.5800, 1104.0300, 0.0000, 0.0000, 48.0000); // object (240)
    CreateObject(1734, 155.9900, 52.7500, 1105.5200, 0.0000, 0.0000, 0.0000); // object (241)
    CreateObject(2164, 168.4600, 49.9300, 1102.3000, 0.0000, 0.0000, 90.0000); // object (242)
    CreateObject(1806, 157.3600, 51.4200, 1102.4000, 0.0000, 0.0000, 113.0000); // object (243)
    CreateObject(1766, 183.0500, 51.4500, 1102.1899, 0.0000, 0.0000, -90.0000); // object (244)
    CreateObject(1811, 199.2600, 60.0700, 1102.8500, 0.0000, 0.0000, -90.0000); // object (245)
    CreateObject(627, 173.2400, 48.7900, 1104.0300, 0.0000, 0.0000, 48.0000); // object (246)
    CreateObject(1806, 154.9900, 51.0900, 1102.4000, 0.0000, 0.0000, -113.0000); // object (247)
    CreateObject(1766, 176.1400, 48.6600, 1102.1899, 0.0000, 0.0000, 180.0000); // object (248)
    CreateObject(1800, 155.3000, 50.3900, 1102.3000, 0.0000, 0.0000, 0.0000); // object (249)
    CreateObject(1811, 200.4600, 60.0500, 1102.8500, 0.0000, 0.0000, -90.0000); // object (250)
    CreateObject(1806, 154.9900, 50.1600, 1102.4000, 0.0000, 0.0000, -69.0000); // object (251)
    CreateObject(1766, 179.1700, 48.6600, 1102.1899, 0.0000, 0.0000, 180.0000); // object (252)
    CreateObject(1737, 157.0800, 49.4000, 1102.4100, 0.0000, 0.0000, 90.0000); // object (253)
    CreateObject(1811, 201.6400, 60.0700, 1102.8500, 0.0000, 0.0000, -90.0000); // object (254)
    CreateObject(1752, 157.2600, 48.7400, 1104.0500, 0.0000, 0.0000, -145.0000); // object (255)
    CreateObject(1522, 205.6400, 64.3700, 1102.2700, 0.0000, 0.0000, 272.0000); // object (256)
    CreateObject(973, 185.2000, 49.7000, 1102.8101, 0.0000, 90.0000, 0.0000); // object (257)
    CreateObject(2135, 155.2100, 49.2800, 1102.2700, 0.0000, 0.0000, 90.0000); // object (258)
    CreateObject(1505, 156.8800, 48.6300, 1102.4301, 0.0000, 0.0000, 0.0000); // object (259)
    CreateObject(3387, 185.0400, 49.1900, 1102.2300, 0.0000, 0.0000, 90.0000); // object (260)
    CreateObject(3396, 177.0900, 47.0200, 1102.2400, 0.0000, 0.0000, 90.0000); // object (261)
    CreateObject(1505, 155.3800, 48.6300, 1102.4301, 0.0000, 0.0000, 0.0000); // object (262)
    CreateObject(973, 188.2200, 49.7000, 1102.8101, 0.0000, 90.0000, 0.0000); // object (263)
    CreateObject(3396, 174.3500, 45.9800, 1102.2400, 0.0000, 0.0000, 180.0000); // object (264)
    CreateObject(3396, 180.7800, 47.0100, 1102.2400, 0.0000, 0.0000, 90.0000); // object (265)
    CreateObject(3387, 188.4300, 49.1900, 1102.2300, 0.0000, 0.0000, 90.0000); // object (266)
    CreateObject(3386, 182.9700, 47.0600, 1102.2200, 0.0000, 0.0000, 90.0000); // object (267)
    CreateObject(3383, 179.0700, 44.1800, 1102.1500, 0.0000, 0.0000, 0.0000); // object (268)
    CreateObject(3394, 174.3600, 42.4000, 1102.2400, 0.0000, 0.0000, 180.0000); // object (269)
    CreateObject(3396, 177.0300, 41.1900, 1102.2400, 0.0000, 0.0000, -90.0000); // object (270)
    CreateObject(3394, 180.6400, 41.2000, 1102.2400, 0.0000, 0.0000, -90.0000); // object (271)
    CreateObject(1997, 184.6300, 41.8900, 1102.2700, 0.0000, 0.0000, 180.0000); // object (272)
    CreateObject(3394, 177.0800, 39.1400, 1102.2400, 0.0000, 0.0000, 90.0000); // object (273)
    CreateObject(1997, 189.2200, 42.1700, 1102.2700, 0.0000, 0.0000, 180.0000); // object (274)
    CreateObject(3394, 174.4500, 38.4200, 1102.2400, 0.0000, 0.0000, 180.0000); // object (275)
    CreateObject(3395, 180.6500, 39.1100, 1102.2400, 0.0000, 0.0000, 90.0000); // object (276)
    CreateObject(2164, 200.1300, 47.0000, 1102.2100, 0.0000, 0.0000, -90.0000); // object (277)
    CreateObject(3386, 182.8400, 39.0800, 1102.2200, 0.0000, 0.0000, 90.0000); // object (278)
    CreateObject(18092, 196.6100, 43.9200, 1102.7300, 0.0000, 0.0000, 90.0000); // object (279)
    CreateObject(1714, 198.1900, 44.7200, 1102.2200, 0.0000, 0.0000, -90.0000); // object (280)
    CreateObject(1997, 184.6200, 38.4900, 1102.2700, 0.0000, 0.0000, 180.0000); // object (281)
    CreateObject(2164, 200.1300, 44.5000, 1102.2100, 0.0000, 0.0000, -90.0000); // object (282)
    CreateObject(3383, 178.9100, 36.4500, 1102.1500, 0.0000, 0.0000, 0.0000); // object (283)
    CreateObject(1714, 198.1900, 43.0800, 1102.2200, 0.0000, 0.0000, -90.0000); // object (284)
    CreateObject(1997, 189.2900, 38.4800, 1102.2700, 0.0000, 0.0000, 180.0000); // object (285)
    CreateObject(3395, 174.4600, 34.8100, 1102.2400, 0.0000, 0.0000, 180.0000); // object (286)
    CreateObject(3394, 193.4200, 39.1300, 1102.2400, 0.0000, 0.0000, 90.0000); // object (287)
    CreateObject(2164, 200.1300, 42.0000, 1102.2100, 0.0000, 0.0000, -90.0000); // object (288)
    CreateObject(3396, 177.0100, 33.6000, 1102.2400, 0.0000, 0.0000, -90.0000); // object (289)
    CreateObject(3395, 180.6800, 33.6400, 1102.2400, 0.0000, 0.0000, -90.0000); // object (290)
    CreateObject(3394, 197.1000, 39.1500, 1102.2400, 0.0000, 0.0000, 90.0000); // object (291)
    CreateObject(3383, 194.8400, 36.4000, 1102.1500, 0.0000, 0.0000, 0.0000); // object (292)
    CreateObject(3395, 199.5700, 37.9400, 1102.2400, 0.0000, 0.0000, 0.0000); // object (293)
    CreateObject(3386, 191.0500, 33.4300, 1102.2200, 0.0000, 0.0000, -90.0000); // object (294)
    CreateObject(3386, 184.7300, 31.4000, 1102.2200, 0.0000, 0.0000, 180.0000); // object (295)
    CreateObject(3396, 193.2800, 33.3400, 1102.2400, 0.0000, 0.0000, -90.0000); // object (296)
    CreateObject(3386, 184.7500, 30.2400, 1102.2200, 0.0000, 0.0000, 180.0000); // object (297)
    CreateObject(3386, 189.1800, 31.3800, 1102.2200, 0.0000, 0.0000, 90.0000); // object (298)
    CreateObject(3394, 196.9500, 33.3300, 1102.2400, 0.0000, 0.0000, -90.0000); // object (299)
    CreateObject(3386, 184.7700, 29.0900, 1102.2200, 0.0000, 0.0000, 180.0000); // object (300)
    CreateObject(3395, 199.6200, 34.3600, 1102.2400, 0.0000, 0.0000, 0.0000); // object (301)
    CreateObject(3383, 187.8600, 26.8800, 1102.1500, 0.0000, 0.0000, 90.0000); // object (302)
    CreateObject(3396, 185.0700, 25.8900, 1102.2400, 0.0000, 0.0000, 180.0000); // object (303)
    CreateObject(3386, 189.2500, 23.7300, 1102.2200, 0.0000, 0.0000, -90.0000); // object (304)
    CreateObject(2992, 1967.8301, 1023.6400, 992.3600, 0.0000, 0.0000, 0.0000); // object (305)
    //============== авианосец,ограждения by Charles_Harrell =============================
    CreateDynamicObject(18856, 142.5300, 1937.5800, 19.7700, 0.0000, 0.0000, 0.0000); // ?????? ???
	CreateDynamicObject(17070, 122.0700, 1836.8900, 16.6800, 0.0400, 0.1200, 273.0000); // ???????? ???
	CreateDynamicObject(1297, -884.2900, -1092.4301, 98.8000, 0.0000, 0.0000, 167.0000); // ??????? ????? ??-??
	CreateDynamicObject(1297, -870.0000, -1052.7500, 93.6000, 0.0000, 0.0000, 142.0000); // ??????? ????? ??-??
	CreateDynamicObject(1297, -841.8500, -1016.0000, 88.3000, 0.0000, 0.0000, 133.0000); // ??????? ????? ??-??
	CreateDynamicObject(1297, -826.7200, -1006.6300, 86.3000, 0.0000, 0.0000, 111.0000); // ??????? ????? ??-??
	CreateDynamicObject(978, -876.9100, -1131.6500, 99.5000, 0.0000, 7.6000, 82.5000); // ??????
	CreateDynamicObject(973, -875.6300, -1122.4399, 98.6500, 0.0000, 2.8000, 81.8000); // ??????
	CreateDynamicObject(979, -873.6700, -1113.3400, 98.4200, 0.0000, 0.0000, 74.0000); // ??????
	CreateDynamicObject(973, -1754.5000, -567.0400, 16.3000, 0.0000, 0.0000, -180.0000); // ??????
	CreateDynamicObject(979, -1763.5200, -567.0400, 16.3000, 0.0000, 0.0000, -180.0000); // ??????
	CreateDynamicObject(978, -1745.1300, -567.0400, 16.3000, 0.0000, 0.0000, -180.0000); // ??????
	CreateDynamicObject(973, -1772.6400, -567.0400, 16.3000, 0.0000, 0.0000, -180.0000); // ??????
	CreateDynamicObject(973, -1735.9900, -567.0400, 16.3000, 0.0000, 0.0000, -180.0000); // ??????
	CreateDynamicObject(973, -1518.3000, 505.5900, 7.0000, 0.0000, 0.0000, 90.0000); // ??????
	CreateDynamicObject(973, -1518.3000, 514.9700, 7.0000, 0.0000, 0.0000, 90.0000); // ??????
	CreateDynamicObject(973, -1518.3000, 524.3500, 7.0000, 0.0000, 0.0000, 90.0000); // ??????
	CreateDynamicObject(973, -1518.3000, 533.7300, 7.0000, 0.0000, 0.0000, 90.0000); // ??????
	CreateDynamicObject(973, -1518.3000, 543.1100, 7.0000, 0.0000, 0.0000, 90.0000); // ??????
	CreateDynamicObject(973, -1518.3000, 552.4900, 7.0000, 0.0000, 0.0000, 90.0000); // ??????
	CreateDynamicObject(973, -1518.3000, 561.8700, 7.0000, 0.0000, 0.0000, 90.0000); // ??????
	CreateDynamicObject(18285, -1526.5699, 519.4000, 6.2000, 0.0300, -0.3700, 118.8000); // ???????? ???
	CreateDynamicObject(18285, -1526.5300, 540.4100, 6.2000, 0.0300, -0.3700, 118.8000); // ???????? ???
	CreateDynamicObject(3279, -1678.8600, 263.0200, 6.0000, 0.0000, 0.0000, 90.0000); // ????? ???
	CreateDynamicObject(3279, -1447.8900, 263.1300, 6.0000, 0.0000, 0.0000, 180.0000); // ????? ???
	CreateDynamicObject(3279, -1337.9100, 299.6800, 6.0000, 0.0000, 0.0000, 134.6500); // ????? ???
	CreateDynamicObject(1278, -1474.7000, 261.3500, 20.3800, 0.0000, 0.0000, 180.0000); // ?????? ???
	CreateDynamicObject(1278, -1342.3500, 293.0100, 20.3800, 0.0000, 0.0000, 0.0000); // ?????? ???
	CreateDynamicObject(3279, -1309.3700, 436.6800, 6.0000, 0.0000, 0.0000, 90.0000);// ????? ???
	//============== Клуб LS-SF by Charles_Harrell =============================
	CreateDynamicObject(17038, -1243.937744,-751.943847,66.757629, -179.699981,-0.900051,-61.499984);
	CreateDynamicObject(17559, -1261.014404,-760.143432,65.505447, 0.000000,0.000000,-61.299991);
    CreateDynamicObject(17038, -1257.157226,-769.506103,66.591049, -0.199999,-179.699996,118.199958);
    CreateDynamicObject(3361, -1240.065185,-742.651733,87.439346, 0.000000,0.000000,29.600002);
    CreateDynamicObject(4028, -1268.359252,-754.118774,74.385032, 0.000000,0.000000,-151.100036);
    CreateDynamicObject(19130, -1230.651977,-762.350402,65.862327, -86.700004,0.000000,119.500007);
    CreateDynamicObject(19130, -1231.644653,-762.892333,65.887054, -88.300003,3.899999,122.900016);
    CreateDynamicObject(19130, -1233.655761,-764.001953,65.885421, -88.899971,0.000000,-61.400028);
    CreateDynamicObject(19130, -1234.729614,-764.613586,65.864547, -88.500000,32.900001,-28.399837);
    CreateDynamicObject(3361, -1277.678466,-770.991943,69.172363, 0.199963,0.000000,-59.900001);
    CreateDynamicObject(11493, -1314.448120,-789.531921,71.909301, 6.199999,0.199999,-33.699996);
    CreateDynamicObject(3361, -1292.838378,-766.634277,82.566902, 0.000000,0.000000,-154.699981);
    CreateDynamicObject(3361, -1284.550659,-759.218933,83.380653, 0.000000,0.000000,-154.099990);
    CreateDynamicObject(3361, -1282.414672,-763.617858,83.380653, 0.000000,0.000000,-154.099990);
    CreateDynamicObject(2898, -1282.733764,-747.194519,85.636260, 0.000000,0.000000,27.899997);
    CreateDynamicObject(715, -1281.809936,-747.727722,93.146278, 0.000000,0.000000,0.000000);
    CreateDynamicObject(3578, -1282.235717,-744.305175,84.866172, 0.000000,0.000000,-62.599983);
    CreateDynamicObject(3578, -1282.783081,-744.585937,84.866195, 0.000000,0.000000,-62.099998);
    CreateDynamicObject(3578, -1283.399047,-744.907714,84.866172, 0.000000,0.000000,-62.599983);
    CreateDynamicObject(3578, -1283.985229,-745.200073,84.866195, 0.000000,0.000000,-62.099998);
    CreateDynamicObject(3578, -1284.588623,-745.524414,84.866172, 0.000000,0.000000,-62.599983);
    CreateDynamicObject(19129, -1272.002197,-755.936584,85.648498, 0.000000,0.000000,28.199995);
    CreateDynamicObject(2898, -1274.703979,-762.360107,85.686271, 0.000000,0.000000,27.899997);
    CreateDynamicObject(715, -1273.571289,-762.479431,93.278800, 0.000000,0.000000,0.000000);
    CreateDynamicObject(2773, -1287.017822,-747.620117,86.164962, 0.000000,0.000000,26.599998);
    CreateDynamicObject(2773, -1285.784667,-749.990478,86.184936, 0.000000,0.000000,27.599996);
    CreateDynamicObject(2773, -1284.510498,-752.627014,86.214965, 0.000000,0.000000,26.599998);
    CreateDynamicObject(2773, -1280.294921,-744.140869,86.214965, 0.000000,0.000000,26.599998);
    CreateDynamicObject(2773, -1279.028564,-746.616149,86.214942, 0.000000,0.000000,27.599996);
    CreateDynamicObject(2773, -1277.264526,-747.832763,86.218788, 0.000000,0.000000,-61.700008);
    CreateDynamicObject(2773, -1274.848266,-746.561706,86.218818, 0.000000,0.000000,118.399978);
    CreateDynamicObject(2773, -1272.360717,-745.192138,86.218788, 0.000000,0.000000,-61.700008);
    CreateDynamicObject(2773, -1269.781738,-743.822021,86.218818, 0.000000,0.000000,118.399978);
    CreateDynamicObject(2773, -1267.218627,-742.423339,86.218788, 0.000000,0.000000,-61.700008);
    CreateDynamicObject(2773, -1264.706420,-741.077636,86.208816, 0.000000,0.000000,118.399978);
    CreateDynamicObject(2773, -1262.314453,-739.782653,86.218788, 0.000000,0.000000,-61.700008);
    CreateDynamicObject(2773, -1252.312011,-734.396789,86.218788, 0.000000,0.000000,-61.700008);
    CreateDynamicObject(2773, -1254.739746,-735.688842,86.208816, 0.000000,0.000000,118.399978);
    CreateDynamicObject(2773, -1250.200439,-734.656005,86.168495, 0.000000,0.000000,65.999992);
    CreateDynamicObject(2898, -1251.706298,-736.739074,85.638481, 0.000000,0.000000,28.999996);
    CreateDynamicObject(2898, -1255.215209,-738.673706,85.638458, 0.000000,0.000000,28.999994);
    CreateDynamicObject(2898, -1258.781616,-740.661010,85.638481, 0.000000,0.000000,28.999996);
    CreateDynamicObject(2898, -1262.351684,-742.630004,85.638458, 0.000000,0.000000,28.999994);
    CreateDynamicObject(2898, -1265.900878,-744.607482,85.638481, 0.000000,0.000000,28.999996);
    CreateDynamicObject(2898, -1263.282958,-749.330444,85.638481, 0.000000,0.000000,28.999996);
    CreateDynamicObject(2898, -1259.728759,-747.361633,85.638458, 0.000000,0.000000,28.999994);
    CreateDynamicObject(2898, -1256.146606,-745.373962,85.638481, 0.000000,0.000000,28.999996);
    CreateDynamicObject(2898, -1252.574829,-743.395812,85.638458, 0.000000,0.000000,28.999994);
    CreateDynamicObject(2898, -1249.018798,-741.422790,85.638481, 0.000000,0.000000,28.999996);
    CreateDynamicObject(2898, -1257.300903,-753.493408,85.638465, 0.000000,0.000000,-60.699985);
    CreateDynamicObject(715, -1255.928955,-754.865539,93.208465, 0.000000,0.000000,0.000000);
    CreateDynamicObject(2773, -1247.814086,-734.285583,86.188812, 0.000000,0.000000,118.399978);
    CreateDynamicObject(2773, -1245.512695,-733.018310,86.198783, 0.000000,0.000000,-61.700008);
    CreateDynamicObject(2773, -1242.958251,-731.660217,86.188812, 0.000000,0.000000,118.399978);
    CreateDynamicObject(2773, -1241.310913,-732.528564,86.178482, 0.000000,0.000000,30.500015);
    CreateDynamicObject(2898, -1242.687377,-734.837768,85.638481, 0.000000,0.000000,28.999996);
    CreateDynamicObject(2773, -1240.090209,-734.783691,86.188415, 0.000000,0.000000,27.699996);
    CreateDynamicObject(2773, -1238.820190,-737.073059,86.178482, 0.000000,0.000000,30.500015);
    CreateDynamicObject(2773, -1237.588500,-739.354980,86.188415, 0.000000,0.000000,27.699996);
    CreateDynamicObject(2773, -1236.370117,-741.862426,86.178482, 0.000000,0.000000,30.500015);
    CreateDynamicObject(715, -1242.279663,-735.483093,92.843475, 0.000000,0.000000,-29.799999);
    CreateDynamicObject(2773, -1239.036621,-745.045837,86.198783, 0.000000,0.000000,-61.700008);
    CreateDynamicObject(2773, -1236.623657,-743.775512,86.188812, 0.000000,0.000000,118.399978);
    CreateDynamicObject(2773, -1241.390625,-746.375854,86.188812, 0.000000,0.000000,118.399978);
    CreateDynamicObject(14537, -1246.247558,-741.352966,87.568489, 0.000000,0.000000,28.799999);
    CreateDynamicObject(19128, -1246.406250,-741.271301,89.546852, 0.000000,0.000000,29.499998);
    CreateDynamicObject(17038, -1239.640258,-759.887939,66.825714, -179.699981,-0.900049,-60.799995);
	//======================= Хот-Доги =========================================
	CreateDynamicObject(1340, 1414.2425537109, -1718.1134033203, 13.692994117737, 0, 0, 0.000);
	CreateDynamicObject(1340,1471.03857422,-1675.05468750,14.17446136,0.00000000,0.00000000,270.00000000); //object(chillidogcart) (3)
	CreateDynamicObject(1340,1477.06201172,-1675.11145020,14.17446136,0.00000000,0.00000000,270.00000000); //object(chillidogcart) (4)
	CreateDynamicObject(1340, 2182.3732910156, -2268.9443359375, 13.593506813049, 0, 0, 0.000);//грузкичи
	//===================== Грузчики ===========================================
	CreateDynamicObject(2060,2172.89526367,-2256.86108398,12.46142387,0.00000000,0.00000000,44.00000000);
	CreateDynamicObject(2060,2172.89453125,-2256.86035156,12.46142387,0.00000000,0.00000000,43.99475098);
	CreateDynamicObject(2060,2172.42309570,-2256.42822266,12.46099281,0.00000000,0.00000000,47.25003052);
	CreateDynamicObject(2060,2173.31835938,-2257.36694336,12.46148300,0.00000000,0.00000000,43.75000000);
	CreateDynamicObject(2060,2172.75854492,-2256.49853516,12.77687645,0.00000000,0.00000000,315.24987793);
	CreateDynamicObject(2060,2172.41381836,-2256.85815430,12.77693558,0.00000000,0.00000000,316.25000000);
	CreateDynamicObject(2060,2173.61865234,-2257.31201172,12.77693558,0.00000000,0.00000000,136.00000000);
	CreateDynamicObject(2060,2173.29321289,-2257.70800781,12.77693558,0.00000000,0.00000000,134.00000000);
	CreateDynamicObject(2060,2173.73193359,-2257.77856445,12.46504116,0.00000000,0.00000000,42.00000000);
	CreateDynamicObject(2060,2172.61962891,-2256.63281250,13.09232903,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(2060,2229.29809570,-2286.05883789,13.53178787,0.00000000,0.00000000,226.00000000);
	CreateDynamicObject(2060,2229.61987305,-2286.45825195,13.53178787,0.00000000,0.00000000,45.00000000);
	CreateDynamicObject(2060,2230.00610352,-2286.81738281,13.53178787,0.00000000,0.00000000,44.00000000);
	CreateDynamicObject(2060,2230.39746094,-2287.23168945,13.53178787,0.00000000,0.00000000,44.00000000);
	CreateDynamicObject(2060,2229.35400391,-2286.54858398,13.80724049,0.00000000,0.00000000,134.00000000);
	CreateDynamicObject(2060,2230.20898438,-2286.95312500,13.82723999,0.00000000,0.00000000,102.00000000);
	CreateDynamicObject(1482,2222.66113281,-2289.36279297,12.31155109,0.00000000,0.00000000,135.00000000);
	//===================== Банкоматы ==========================================
	CreateDynamicObject(2754, 1497.86, -1750.30, 15.27,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2754, 1243.21973, -1806.49548, 13.45270,   0.00000, 0.00000, 112.40000);
	CreateDynamicObject(2754,1919.78381348,-1766.21813965,13.44901943,0.00000000,0.00000000,270.00000000); //object(otb_machine) (4)
	CreateDynamicObject(2754,2236.16186523,-1665.79772949,15.27980804,0.00000000,0.00000000,344.00000000); //object(otb_machine) (6)
	CreateDynamicObject(2754,1367.56359863,-1290.13696289,13.44901943,0.00000000,0.00000000,0.00000000); //object(otb_machine) (7)
	CreateDynamicObject(2754,1142.44287109,-1763.92932129,13.59816360,0.00000000,0.00000000,180.00000000); //object(otb_machine) (8)
	CreateDynamicObject(2754,557.32824707,-1294.28137207,17.24994087,0.00000000,0.00000000,270.00000000); //object(otb_machine) (9)
	CreateDynamicObject(2754,847.58093262,-1799.19348145,13.71945286,0.00000000,0.00000000,354.00000000); //object(otb_machine) (10)
	CreateDynamicObject(2754,-78.74282837,-1171.64892578,1.95329499,0.00000000,0.00000000,336.00000000); //object(otb_machine) (11)
	CreateDynamicObject(2754,-1551.53637695,-2737.33691406,48.64560318,0.00000000,0.00000000,146.00000000); //object(otb_machine) (13)
	CreateDynamicObject(2754,661.71307373,-576.21777344,16.25428581,0.00000000,0.00000000,0.00000000); //object(otb_machine) (14)
	CreateObject(1696,-1334.93273926,487.19998169,10.39754200,355.00000000,0.00000000,180.00000000);
	CreateDynamicObject(2754,-2035.70605469,-102.35491180,35.07402039,0.00000000,0.00000000,270.00000000); //object(otb_machine) (16)
	CreateDynamicObject(2754,-2033.32604980,159.50723267,28.94120598,0.00000000,0.00000000,178.00000000); //object(otb_machine) (17)
	CreateDynamicObject(2754,-1676.34570312,434.01806641,7.08183193,0.00000000,0.00000000,226.00000000); //object(otb_machine) (19)
	CreateDynamicObject(2754,-2421.45410156,958.35540771,45.18632126,0.00000000,0.00000000,88.00000000); //object(otb_machine) (20)
	CreateDynamicObject(2754,-2621.31445312,1415.23510742,6.88521862,0.00000000,0.00000000,158.00000000); //object(otb_machine) (22)
	CreateDynamicObject(2754,-2452.32275391,2252.62988281,4.87058449,0.00000000,0.00000000,92.00000000); //object(otb_machine) (23)
	CreateDynamicObject(2754,-1282.38098145,2715.18652344,50.16842651,0.00000000,0.00000000,28.00000000); //object(otb_machine) (24)
	CreateDynamicObject(2754,91.92106628,1180.56555176,18.56620598,0.00000000,0.00000000,90.00000000); //object(otb_machine) (25)
	CreateDynamicObject(2754,-818.55200195,1567.63708496,27.01933098,0.00000000,0.00000000,178.00000000); //object(otb_machine) (26)
	CreateDynamicObject(2754,2174.20336914,1402.93469238,10.96464443,0.00000000,0.00000000,0.00000000); //object(otb_machine) (27)
	CreateDynamicObject(2754,1587.30920410,2218.34838867,10.96464443,0.00000000,0.00000000,88.00000000); //object(otb_machine) (28)
	CreateDynamicObject(2754,2187.36035156,2478.89160156,11.14433193,0.00000000,0.00000000,180.00000000); //object(otb_machine) (29)
	CreateDynamicObject(2754,2843.30444336,1286.17187500,11.29276943,0.00000000,0.00000000,270.00000000); //object(otb_machine) (30)
    //================ Мостик ==================================================
	CreateDynamicObject(7191,-1330.23962402,411.70687866,5.86217785,0.00000000,90.00000000,180.00000000); //object(vegasnnewfence2b) (1)
	CreateDynamicObject(7191,-1330.25866699,367.41680908,5.86217785,0.00000000,90.00000000,0.00000000); //object(vegasnnewfence2b) (2)
	CreateDynamicObject(994,-1332.18188477,350.85299683,5.94952583,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (1)
	CreateDynamicObject(994,-1328.31640625,345.79153442,5.85952473,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (2)
	CreateDynamicObject(994,-1328.31640625,354.84710693,5.85952473,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (3)
	CreateDynamicObject(994,-1332.18188477,386.53088379,5.94952583,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (4)
	CreateDynamicObject(994,-1328.31640625,381.78265381,5.85952473,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (5)
	CreateDynamicObject(994,-1328.31640625,391.44033813,5.94952583,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (6)
	CreateDynamicObject(994,-1328.31640625,417.81451416,5.94952583,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (7)
	CreateDynamicObject(994,-1328.31640625,426.36065674,5.94952583,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (8)
	CreateDynamicObject(994,-1332.18188477,422.44912720,5.94952583,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (9)
	//=============== Ворота Аэро ==============================================
	CreateDynamicObject(969, 1961.7924,-2189.6584,12.7000, 0.0000, 0.0000, 180.000);
	CreateDynamicObject(969, 1970.2289,-2189.7229,12.7000, 0.0000, 0.0000, 180.000);
	CreateObject(5706,135.93359375,1953.40722656,23.30762100,0.00000000,0.00000000,179.99450684); //object(studiobld03_law) (1)
	CreateObject(3361,130.43261719,1935.47949219,25.07071495,0.00000000,0.00000000,270.00000000); //object(cxref_woodstair) (1)
	CreateObject(3361,130.43457031,1929.55761719,21.12256813,0.00000000,0.00000000,269.98901367); //object(cxref_woodstair) (2)
	CreateObject(3361,130.43457031,1927.51074219,19.75853539,0.00000000,0.00000000,269.98901367); //object(cxref_woodstair) (3)
	CreateObject(8580,131.89939880,1956.01074219,27.35955429,0.00000000,0.00000000,0.00000000); //object(vgssstairs05_lvs) (1)
	CreateObject(994,119.38395691,1940.31347656,27.12810516,0.00000000,0.00000000,0.00000000); //object(lhouse_barrier2) (1)
	CreateObject(994,146.13539124,1940.31347656,27.12810516,0.00000000,0.00000000,0.00000000); //object(lhouse_barrier2) (2)
    //==================== Заборы на респе SAMP-RP =============================
	CreateDynamicObject(982,1152.15075684,-1722.22851562,13.64132500,0.00000000,0.00000000,90.00000000); //object(fenceshit) (1)
	CreateDynamicObject(984,1133.00854492,-1722.22851562,13.34931469,358.50000000,0.00000000,90.00000000); //object(fenceshit2) (1)
	CreateDynamicObject(982,1113.80603027,-1722.22851562,13.23042965,0.00000000,0.00000000,90.00000000); //object(fenceshit) (2)
	CreateDynamicObject(982,1088.21301270,-1722.22851562,13.23794270,0.00000000,0.00000000,90.00000000); //object(fenceshit) (3)
	CreateDynamicObject(984,1069.08020020,-1722.22851562,13.18355465,0.00000000,0.00000000,90.00000000); //object(fenceshit2) (2)
	CreateDynamicObject(983,1061.10009766,-1722.22851562,13.23042965,0.00000000,0.00000000,90.00000000); //object(fenceshit3) (1)
	CreateDynamicObject(982,1057.89489746,-1735.00000000,13.31189728,0.00000000,0.00000000,0.00000000); //object(fenceshit) (4)
	CreateDynamicObject(982,1057.89489746,-1760.58935547,13.25795174,0.00000000,0.00000000,0.00000000); //object(fenceshit) (5)
	CreateDynamicObject(983,1057.89489746,-1775.00000000,13.23992157,0.00000000,0.00000000,0.00000000); //object(fenceshit3) (2)
	CreateDynamicObject(982,1070.71105957,-1778.17041016,13.19638634,0.00000000,0.00000000,90.00000000); //object(fenceshit) (6)
	CreateDynamicObject(982,1096.30371094,-1778.17041016,13.23059177,0.00000000,0.00000000,90.00000000); //object(fenceshit) (7)
	CreateDynamicObject(983,1109.09997559,-1778.17041016,13.26394463,0.00000000,0.00000000,90.00000000); //object(fenceshit3) (3)
	CreateDynamicObject(983,1112.30480957,-1781.35913086,13.26394463,0.00000000,0.00000000,0.00000000); //object(fenceshit3) (4)
	CreateDynamicObject(983,1164.91748047,-1725.40405273,13.57842827,0.60000610,0.00000000,0.00000000); //object(fenceshit3) (5)
	CreateDynamicObject(983,1164.91748047,-1727.00097656,13.54496384,0.59875488,0.00000000,0.00000000); //object(fenceshit3) (6)
	CreateDynamicObject(982,1178.37780762,-1734.99987793,13.32712841,0.29998779,0.00000000,0.00000000); //object(fenceshit) (8)
	CreateDynamicObject(982,1178.37780762,-1760.53796387,13.25386715,0.00000000,0.00000000,0.00000000); //object(fenceshit) (9)
	CreateDynamicObject(984,1178.37780762,-1779.75317383,13.20699215,0.00000000,0.00000000,0.00000000); //object(fenceshit2) (3)
	//======================== Авианосец =======================================
	CreateDynamicObject(5130, -1334.831909, 478.695892, 8.176680, 0.356194, 0.000000, 224.0);
	CreateDynamicObject(3279, -1541.521606, 475.820618, 6.263117, 0.0, 0.0, 0.0);
	//======================= Army LV ==========================================
	CreateObject(3707,353.669983, 1950.344604, 24.623753,0.141593, 0.000000, 180.000000);
	CreateDynamicObject(3279,384.702789, 1892.396484, 16.716242,-1.570796, 0.000000, 180.000000);
	CreateDynamicObject(3279,350.380798, 1807.448975, 17.561840,1.748893, 0.000000, 180.000000);
	CreateDynamicObject(3279, 333.368652, 1795.830444, 17.059250,0.552544, 0.000000, 180.000000);
	CreateDynamicObject(11480,289.229370, 1822.304443, 18.834333,0.570796, 0.000000, 90.000000);
	CreateDynamicObject(11480, 282.921143, 1822.302612, 18.834333,0.570796, 0.000000, 90.000000);
	CreateDynamicObject(16095, 291.7807,1830.3577,16.6481, 0.000000, 0.000000, 270.000000);
	//======================== Закрытие покрасочных ============================
	CreateDynamicObject(971,2071.5937500,-1830.4843750,14.9919996,0.0000000,0.0000000,90.0000000); //object(subwaygate) (2)
	CreateDynamicObject(975,1025.4489746,-1029.4639893,32.7589989,0.0000000,0.0000000,180.0000000); //object(columbiangate) (1)
	CreateDynamicObject(971,487.2919922,-1735.1710205,13.5190001,0.0000000,0.0000000,172.0000000); //object(subwaygate) (3)
	CreateDynamicObject(971,720.1810303,-462.5469971,17.4640007,0.0000000,0.0000000,0.0000000); //object(subwaygate) (4)
	CreateDynamicObject(971,-1904.6359863,277.8080139,43.5919991,0.0000000,0.0000000,0.0000000); //object(subwaygate) (5)
	CreateDynamicObject(971,-2425.4299316,1028.1400146,52.8860016,0.0000000,0.0000000,180.0000000); //object(subwaygate) (6)
	CreateDynamicObject(971,-1420.5620117,2591.1159668,57.0569992,0.0000000,0.0000000,180.0000000); //object(subwaygate) (7)
	CreateDynamicObject(971,-99.9700012,1111.5050049,20.8619995,0.0000000,0.0000000,0.0000000); //object(subwaygate) (8)
	CreateDynamicObject(971,2393.5839844,1483.4739990,13.3149996,0.0000000,0.0000000,0.0000000); //object(subwaygate) (9)
	CreateDynamicObject(971,1968.4689941,2162.6369629,12.5400000,0.0000000,0.0000000,270.0000000); //object(subwaygate) (10)
	CreateDynamicObject(971,-1787.2659912,1209.3830566,26.6749992,0.0000000,0.0000000,0.0000000); //object(subwaygate) (11)
	//==========================================================================
	Barrier = CreateObject(968,-2031.4800,-242.67,35.01,0.00000000,-90.00000000,0.00000000);
	return 1;
}
stock CreatePickups()
{
	burger[0] = CreatePickupAC(1318,23,362.9606,-75.2571,1001.5078,1);//
	burger[1] = CreatePickupAC(1318,23,1199.3116,-918.5775,43.1196);//
	burger[2] = CreatePickupAC(1318,23,460.5558,-88.6921,999.5547,2);//
	burger[3] = CreatePickupAC(1318,23,810.4846,-1616.1753,13.5469);//
	pizza[0] = CreatePickupAC(1318,23,372.3208,-133.5208,1001.4922,3);//
	pizza[1] = CreatePickupAC(1318,23,2105.4885,-1806.4802,13.5547);//
	pizza[2] = CreatePickupAC(1318,23,364.9203,-11.7854,1001.8516,4);//
	pizza[3] = CreatePickupAC(1318,23,-1816.5275,618.6845,35.1719);//
	tengreen[0] = CreatePickupAC(1318,23,502.0838,-67.5646,998.7578,5);//
	tengreen[1] = CreatePickupAC(1318,23,2310.0317,-1643.4805,14.8270);//
	parashut = CreatePickupAC(1274,23,2428.0544,-741.8817,1422.5161);
	//==================== Грибы ===============================================
	grib[0] = CreatePickupAC(1603, 2, -332.3008,-1987.6200,26.1051);
	grib[1] = CreatePickupAC(1603, 2, -375.2895,-2004.4412,28.4262);
	grib[2] = CreatePickupAC(1603, 2, -420.7345,-1962.1367,20.7989);
	grib[3] = CreatePickupAC(1603, 2, -370.9467,-2049.1355,28.5462);
	grib[4] = CreatePickupAC(1603, 2, -448.5980,-2072.9041,80.6654);
	grib[5] = CreatePickupAC(1603, 2, -490.3048,-2121.0930,89.5054);
	grib[6] = CreatePickupAC(1603, 2, -515.2039,-2223.6245,42.7538);
	grib[7] = CreatePickupAC(1603, 2, -556.2787,-2223.5444,34.8664);
	grib[8] = CreatePickupAC(1603, 2, -653.4810,-2185.8540,14.6571);
	grib[9] = CreatePickupAC(1603, 2, -697.4235,-2144.5728,24.7645);
	grib[10] = CreatePickupAC(1603, 2, -913.5545,-2281.5803,45.6804);
	grib[11] = CreatePickupAC(1603, 2, -924.2963,-2392.5601,63.9710);
	grib[12] = CreatePickupAC(1603, 2, -921.2469,-2419.2676,73.1529);
	grib[13] = CreatePickupAC(1603, 2, -928.6000,-2452.7974,90.8816);
	grib[14] = CreatePickupAC(1603, 2, -1092.1782,-2576.2622,77.2730);
	grib[15] = CreatePickupAC(1603, 2, -1114.4218,-2326.8787,44.7146);
	grib[16] = CreatePickupAC(1603, 2, -1095.8896,-2317.7642,51.1427);
	grib[17] = CreatePickupAC(1603, 2, -1036.0745,-2331.6079,60.0633);
	grib[18] = CreatePickupAC(1603, 2, -1823.0471,-2169.1082,77.6051);
	grib[19] = CreatePickupAC(1603, 2, -1745.4077,-2018.1677,74.5071);
	grib[20] = CreatePickupAC(1603, 2, -1943.8130,-2144.5457,76.9309);
	grib[21] = CreatePickupAC(1603, 2, -1955.9766,-2162.8020,75.9688);
	grib[22] = CreatePickupAC(1603, 2, -1685.1254,-2385.9275,99.3290);
	grib[23] = CreatePickupAC(1603, 2, -1643.7135,-2411.9897,95.7691);
	grib[24] = CreatePickupAC(1603, 2, -1551.1573,-2505.1743,90.8708);
	grib[25] = CreatePickupAC(1603, 2, -1465.4910,-2556.2893,63.7663);
	grib[26] = CreatePickupAC(1603, 2, -1435.4855,-2544.3879,60.4281);
	grib[27] = CreatePickupAC(1603, 2, -1401.0656,-2548.1582,55.9067);
	grib[28] = CreatePickupAC(1603, 2, -1347.5752,-2507.9780,37.0068);
	grib[29] = CreatePickupAC(1603, 2, -1328.0197,-2467.7183,27.8259);
	grib[30] = CreatePickupAC(1603, 2, -1290.3135,-2479.8984,16.9108);
	grib[31] = CreatePickupAC(1603, 2, -1277.4055,-2498.1367,11.4951);
	grib[32] = CreatePickupAC(1603, 2, -568.3260,-2276.3220,27.5938);
	grib[33] = CreatePickupAC(1603, 2, -653.1019,-2255.4465,23.3936);
	grib[34] = CreatePickupAC(1603, 2, -614.5738,-2398.0959,28.0911);
	grib[35] = CreatePickupAC(1603, 2, -620.2932,-2477.4644,52.8450);
	grib[36] = CreatePickupAC(1603, 2, -673.6429,-2562.6052,58.4840);
	grib[37] = CreatePickupAC(1603, 2, -797.0350,-2611.4380,85.9543);
	grib[38] = CreatePickupAC(1603, 2, -814.8298,-2713.2485,90.4954);
	grib[39] = CreatePickupAC(1603, 2, -900.3575,-2635.6716,96.5351);
	grib[40] = CreatePickupAC(1603, 2, -908.8201,-2450.1675,86.1361);
	grib[41] = CreatePickupAC(1603, 2, -564.7324,-2000.7518,48.2172);
	grib[42] = CreatePickupAC(1603, 2, -514.0831,-1990.8127,46.7821);
	grib[43] = CreatePickupAC(1603, 2, -386.3437,-1968.6517,25.7109);
	grib[44] = CreatePickupAC(1603, 2, -285.8642,-2063.6074,34.5075);
	grib[45] = CreatePickupAC(1603, 2, -1735.6969,-2501.1594,10.1409);
	grib[46] = CreatePickupAC(1603, 2, -1840.7139,-2382.2207,29.1400);
	grib[47] = CreatePickupAC(1603, 2, -1906.1353,-2212.6089,77.4492);
	grib[48] = CreatePickupAC(1603, 2, -1874.5731,-1969.2981,87.2874);
	grib[49] = CreatePickupAC(1603, 2, -1739.6145,-1950.4650,98.8599);
	grib[50] = CreatePickupAC(1603, 2, -1613.4684,-1867.4391,86.1701);
	grib[51] = CreatePickupAC(1603, 2, -1868.5590,-1894.4634,88.9713);
	grib[52] = CreatePickupAC(1603, 2, -2005.6901,-1937.4910,77.0140);
	//==========================================================================
	sportzal[0] = CreatePickupAC(1318,23,2229.7566,-1721.5988,13.5646);
	sportzal[1] = CreatePickupAC(1318,23,772.4290,-5.0806,1000.7289);//gym
	lspic[0] = CreatePickupAC(1318,23,1658.6239,-1691.3878,15.6094);//Ls news
	lspic[1] = CreatePickupAC(1318,23,1648.8322,-1641.8181,83.7813);//
	rabota1 = CreatePickupAC(1239,23,2226.1624,-2214.5242,13.2982);//Груз
	//================== Авианосец =============================================
	chekmats[0] = CreatePickupAC(1239,2,-1297.3777,505.1444,11.1953); // пикап1
	chekmats[1] = CreatePickupAC(1239,2,-1405.5594,502.5779,11.1953); // пикап1
	chekmats[2] = CreatePickupAC(1239,2,-1336.0455,500.4789,11.3047); // пикап1
	chekmats[3] = CreatePickupAC(1239,2,-1398.7252,493.6896,5.2717); // пикап1
	chekmats[4] = CreatePickupAC(1239,2,-1383.6670,507.1056,3.0391); // пикап1
	serdce[0] = CreatePickupAC(2355,23,1487.8766,-1770.3346,18.7958);//мэрия
	serdce[1] = CreatePickupAC(2355,23,1214.8615,-1816.1633,16.5938);//респа лс
	serdce[2] = CreatePickupAC(2355,23,1762.5649,-1916.1613,13.5719);//сердечко в ав законка
	serdce[3] = CreatePickupAC(2355,23,-2022.4574,-118.4710,1035.1719,1);//сердечко в аш
	serdce[4] = CreatePickupAC(2355,23,-1855.6213,-1560.6726,21.7500);// рудник
	serdce[5] = CreatePickupAC(2355,23,2125.8967,-2273.4565,20.6719);// грузчики
	clothes = CreatePickupAC(1275, 23, 2137.9661,-2282.2017,20.6719, -1);
	cashs = CreatePickupAC(1274, 23, 2127.5701,-2275.1938,20.6719, -1);
	gunarm[1] = CreatePickupAC(353,23,-1341.7183,491.6123,11.1953);//Оружие Армии
	gunarm[0] = CreatePickupAC(353,23,245.6338,1859.2839,14.0840);//Оружие Армии
	skinshop[0] = CreatePickupAC(1275,23,206.0302,-3.5463,1001.2109);//скиншоп
	skinshop[1] = CreatePickupAC(1275,23,205.9253,-12.9991,1001.2178);//скиншо
	skinshop[2] = CreatePickupAC(1275,23,181.3787,-86.4860,1002.0234);//скиншо
	skinshop[3] = CreatePickupAC(1275,23,181.5291,-89.3950,1002.0307);//скиншо
	Army = GangZoneCreate(-49.979476, 1695.982177, 414.020507, 2175.982177);
	chekmatlva[0] = CreatePickupAC(1239,2,223.8502,1931.5122,17.6406); // пикап1
	chekmatlva[1] = CreatePickupAC(1239,2,190.7502,1931.7085,17.6406); // пикап1
	chekmatlva[2] = CreatePickupAC(1239,2,155.8935,1903.3306,18.6603); // пикап3
	chekmatlva[3] = CreatePickupAC(1239,2,137.4635,1880.8014,17.8359); // пикап4
	chekmatlva[4] = CreatePickupAC(1239,2,117.9774,1869.8710,17.8359); // пикап5
	chekmatlva[5] = CreatePickupAC(1239,2,112.7323,1875.2440,17.8359); // пикап6
	chekmatlva[6] = CreatePickupAC(1239,2,153.5131,1845.9530,17.6406); // пикап7
	chekmatlva[7] = CreatePickupAC(1239,2,171.9801,1834.7606,17.6406); // пикап8
	chekmatlva[8] = CreatePickupAC(1239,2,176.9783,1841.3126,17.6406); // пикап9
	chekmatlva[9]= CreatePickupAC(1239,2,233.3041,1842.0875,17.6406); // пикап10
	chekmatlva[10]= CreatePickupAC(1239,2,268.6562,1967.3164,17.6406); // пикап10
	chekmatlva[11]= CreatePickupAC(1239,2,268.2658,2001.1211,17.6406); // пикап10
	chekmatlva[12]= CreatePickupAC(1239,2,268.2543,2034.8973,17.6406); // пикап10
	carpick[0] = CreatePickupAC(1239, 23, 562.4449,-1291.9125,17.2482, 0);
	carpick[1] = CreatePickupAC(1239, 23, -1952.2794,297.8026,35.4688, 0);
	carpick[2] = CreatePickupAC(1239, 23, -1656.6951,1210.4526,7.2500, 0);
	victim[0] = CreatePickupAC(1318,23,461.7025,-1500.7941,31.0454);// магаз одежды стрелка
	victim[1] = CreatePickupAC(1318,23,227.5632,-8.0904,1002.2109);
	mysti = CreatePickupAC(1318,23,1212.0931,-25.8776,1000.9531);
	zip[0] = CreatePickupAC(1318,23,-1882.5100,866.3918,35.1719);
	zip[1] = CreatePickupAC(1318,23,161.3232,-97.1035,1001.8047);
	shop[0] = CreatePickupAC(1318,23,-25.8496,-141.5474,1003.5469);
	shop[1] = CreatePickupAC(1318,23,-25.9730,-188.2542,1003.5469);
	shop[3] = CreatePickupAC(1318,23,-31.0230,-92.0109,1003.5469);
	shop[2] = CreatePickupAC(1318,23,6.0346,-31.6810,1003.5494);
	pdd = CreatePickupAC(1239,23,-2032.8153,-115.7249,1035.1719,1);//
	buygunzakon[0] = CreatePickupAC(353,23,326.0734,306.7083,999.1484); //gun FBI
	buygunzakon[1] = CreatePickupAC(353,23,311.9774,-165.2273,999.6010,5); //gun Police
	buygunzakon[2] = CreatePickupAC(353,23,311.9774,-165.2273,999.6010,1); //gun Police
	buygunzakon[3] = CreatePickupAC(353,23,302.5668,-127.6718,1004.0625,15); //gun Police
	lspd[0] = CreatePickupAC(1318,23,1555.1332,-1675.7180,16.1953);//Lspd вход
	lspd[1] = CreatePickupAC(1318,23,246.7096,62.8786,1003.6406);//Lspd выход
	lspd[4] = CreatePickupAC(1318,23,316.6778,-170.0422,999.5938,5);//Lspd вых из аммо
	lspd[2] = CreatePickupAC(1318,23,1524.486938,-1677.990844,6.218750);//Lspd Вход
	lspd[5] = CreatePickupAC(1318,23,1568.6144,-1689.9901,6.2188);//Lspd Вход из гаража
	lspd[3] = CreatePickupAC(1318,23,246.4416,87.6784,1003.6406);//Lspd выход в гараже
	sfpd[4]  = CreatePickupAC(1318,23,-1606.4298,672.0637,-4.9063);//sfpd выход в гараже склад
	sfpd[0]  = CreatePickupAC(1318,23,316.3047,-170.2971,999.5938,1);//sfpd выход в гараже склад
	sfpd[1]  = CreatePickupAC(1318,23,213.9762,120.8990,999.0156);//sfpd выход в гараже 
	sfpd[2] = CreatePickupAC(1318,23,-1594.2096,716.1803,-4.9063);//sfpd
	sfpd[3] = CreatePickupAC(1318,23,246.4636,107.2969,1003.2188);//сфпд
	sfpd[5] = CreatePickupAC(1318,23,-1605.6124,711.0394,13.8672);//сфпд
	lvpdpic[0] = CreatePickupAC(1318,23,2297.1138,2451.4346,10.8203);//lvpd вход с гаража
	lvpdpic[1] = CreatePickupAC(1318,23,238.7510,138.6254,1003.0234,122);//lvpd вход в гараж
	lvpdpic[2] = CreatePickupAC(1318,23,2337.1335,2459.3105,14.9742);//Центральный вход
	lvpdpic[3] = CreatePickupAC(1318,23,288.8456,166.9235,1007.1719,122);//Центральный выход
	lvpdpic[4] = CreatePickupAC(1318,23,2297.1165,2468.6892,10.8203);//lvpd оружие вход
	lvpdpic[5] = CreatePickupAC(1318,23,299.9460,-141.8767,1004.0625,15);//lvpd оружие выход
	lvpdpic[6] = CreatePickupAC(1318,23,2278.3835,2458.0950,38.6837);//крыша
	sfn[1] = CreatePickupAC(1318,23,-2056.5552,454.0199,35.1719);//
	sfn[0] = CreatePickupAC(1318,23,-2046.4412,453.8438,139.7422);//
	rmpic[0] = CreatePickupAC(1318,23,1298.7498,-797.0133,1084.0078,1);//
	rmpic[1] = CreatePickupAC(1318,23,937.0892,1733.2124,8.8516);//RM вход
	yakexit[0] = CreatePickupAC(1318,23,1298.7498,-797.0133,1084.0078);//
	yakexit[1] = CreatePickupAC(1318,23,1456.1324,2773.4790,10.8203);//
	medicls[0] = CreatePickupAC(1318,23,205.2513,63.5841,1103.2628,1);//
	medicls[1] = CreatePickupAC(1318,23,2034.1421,-1401.7711,17.2945);//
	medicsf[0] = CreatePickupAC(1318,23,205.2513,63.5841,1103.2628,2);//
	medicsf[1] = CreatePickupAC(1318,23,-2685.6318,640.1635,14.4531);//
	fbi[1] = CreatePickupAC(1318,23,322.1946,302.3625,999.1484);//fbi
	fbi[0] = CreatePickupAC(1318,23,-2456.1270,503.7910,30.0781);//fbi вход
	lcnpic[0] = CreatePickupAC(1318,23,1298.7498,-797.0133,1084.0078,2);//
	lcnpic[1] = CreatePickupAC(1318,23,1455.8972,751.4310,11.0234);//lcn вход
	ammonac[0] = CreatePickupAC(1318,23,1368.9360,-1279.7216,13.5469);//
	ammonac[1] = CreatePickupAC(1318,23,285.4752,-41.7966,1001.5156);//
	ammonac[2] = CreatePickupAC(1318,23,-2625.8296,208.2379,4.8125);//
	ammonac[3] = CreatePickupAC(1318,23,285.9187,-86.7644,1001.5229);//
	ammonac[4] = CreatePickupAC(1318,23,2159.5449,943.2165,10.8203);//
	ammonac[5] = CreatePickupAC(1318,23,315.8831,-143.6591,999.6016);//
	narko[0] =  CreatePickupAC(1318,23,2166.0068,-1671.3362,15.0734);//наркопритон
	narko[1] = CreatePickupAC(1318,23,318.6952,1114.5037,1083.8828);//наркопритон
	autoschool[1] = CreatePickupAC(1318,23,-2026.8085,-103.6107,1035.1798,1);//autoschool1
    autoschool[0] = CreatePickupAC(1318,23,-2063.8271,-186.4697,35.3203);//Автошкола 1 вход
	marenter[0] = CreatePickupAC(1318,23,1481.1272,-1771.6830,18.7958);//Мэрия
	marenter[1]  = CreatePickupAC(1318,23,368.4153,194.0033,1008.3828,1);//2выход у мэрии
	marenter[2]  = CreatePickupAC(1318,23,1413.2067,-1790.5966,15.4356);//
	marenter[3] = CreatePickupAC(1318,23,390.1618,173.8988,1008.3828,1);//city hall
	marenter[4] = CreatePickupAC(1318,23,390.1618,173.8988,1008.3828,2);//city hall
	marenter[5] = CreatePickupAC(1318,23,-2765.9202,375.5913,6.3347);//city hall
	bankpic[0] = CreatePickupAC(1318,23,1411.5004,-1699.6112,13.5395);//Банк вход
	bankpic[1] = CreatePickupAC(1318,23,2304.6968,-16.1388,26.7422);//Банк выход
	banksf = CreatePickupAC(1318,23,-2648.8894,376.0311,6.1593);//Банк  sf выход
	ballasvhod[0] = CreatePickupAC(1318,23,-68.8021,1351.1979,1080.2109,34);//Ballas на улицу
	ballasvhod[1] = CreatePickupAC(1318,23,2650.6992,-2021.8175,14.1766);//Ballas в интерьр
	rifa[0] = CreatePickupAC(1318,23,-229.29,1401.13,27.77,63);//Рифа вход на улицу
	rifa[1] = CreatePickupAC(1318,23,2185.8225,-1815.2219,13.5469);//Рифа вход
	vagospic[0] = CreatePickupAC(1318,23,2770.7471,-1628.7227,12.1775);//Vagos вход
	vagospic[1] = CreatePickupAC(1318,23,300.4915,305.8677,1003.5391,75);//Vagos выход
	aztecpic[0] = CreatePickupAC(1318,23,1804.1624,-2124.8953,13.9424);//Aztec вход
	aztecpic[1] = CreatePickupAC(1318,23,-42.5856,1405.4747,1084.4297,36);//Aztec выход
	groove[1] = CreatePickupAC(1318,23,2496.0042,-1692.0835,1014.7422,1);//grove spawn выход
	groove[0] = CreatePickupAC(1318,23,2495.3271,-1690.9893,14.7656);//Дом грув
	plen[0] = CreatePickupAC(1318,23,305.6964,-159.2085,999.5938);
	plen[1] = CreatePickupAC(1318,23,306.4392,-159.2731,999.5938);
	zona[0] = CreatePickupAC(1318,23,279.2340,1833.1393,18.0874);
	zona[1] = CreatePickupAC(1318,23,291.8918,1833.7253,18.1027);
	sklad[0] = CreatePickupAC(1318,23,340.5722,1949.2020,22.0172);
	sklad[1] = CreatePickupAC(1318,23,316.3806,-170.2857,999.5938);
	paras1 = CreatePickupAC(1314,23,1544.1898,-1353.3282,329.4743);
    picjob = CreatePickupAC(1275,23,-1864.6566,-1559.6449,21.7500,0);
	Create3DTextLabel("Место добычи {FF0000}№1\n{AAFFAA}||\n{AAFFAA}v",0xFFFFFFFF,-1806.9043,-1648.0068,23.8841,30,0,1);
    Create3DTextLabel("Место добычи {FF0000}№2\n{AAFFAA}||\n{AAFFAA}v",0xFFFFFFFF,-1799.6934,-1639.2765,23.9029,30,0,1);
    Create3DTextLabel("Место добычи {FF0000}№3\n{AAFFAA}||\n{AAFFAA}v",0xFFFFFFFF,-1798.7091,-1645.7821,27.5569,30,0,1);
    Create3DTextLabel("Место добычи {FF0000}№4\n{AAFFAA}||\n{AAFFAA}v",0xFFFFFFFF,-1800.4758,-1651.8302,27.6368,30,0,1);
    Create3DTextLabel("Место добычи {FF0000}№5\n{AAFFAA}||\n{AAFFAA}v",0xFFFFFFFF,-1828.2452,-1662.8949,21.7500,30,0,1);
	//================= Респы банд =============================================
	CreateDynamicMapIcon(2648.8896,-2021.3033,13.5469,59,0); // Баллас
	CreateDynamicMapIcon(2774.1741,-1627.7917,12.1775,60,0); // Вагос
	CreateDynamicMapIcon(2495.3684,-1688.0365,13.5553,62,0); // Гроув
	CreateDynamicMapIcon(1804.1624,-2124.8953,13.9424,58,0); // Ацтеки
	CreateDynamicMapIcon(2185.9600,-1811.9399,13.5469,61,0); // Рифа
	CreateDynamicMapIcon(523.9487,-1812.9863,6.5781,19,0);
	CreateDynamicMapIcon(2337.7820,-1247.8042,22.5000,43,0); // Гопники
	//================= Иконки на карте ========================================
	CreateDynamicMapIcon(-2.9803,-363.4466,5.4297,51,0);     // Продуктовозы
	CreateDynamicMapIcon(-1882.5100,866.3918,35.1719,45,0);  // Магазин одежды SF
	CreateDynamicMapIcon(472.4380,-1515.5332,40.5726,45,0);  // Магазин одежды LS
	CreateDynamicMapIcon(542.1437,-1272.3624,51.3059,55,0);  // Car ls
	CreateDynamicMapIcon(-1948.4501,278.1562,68.9698,55,0);  // Car sf
	CreateDynamicMapIcon(-1638.6560,1206.3889,68.9698,55,0); // car sf
	CreateDynamicMapIcon(1657.0205,2254.5571,10.8203,25,0);  // Casino Rich
	CreateDynamicMapIcon(1481.2144,-1756.5200,17.5313,20,0); //
	CreateDynamicMapIcon(1552.8314,-1675.9022,16.1953,30,0); //
	CreateDynamicMapIcon(-2243.8826,-87.9706,35.3203,49,0);  // Мисти
	CreateDynamicMapIcon(2312.4189,-1641.4185,22.3378,49,0); // Бар
	CreateDynamicMapIcon(1414.0972,-1701.0652,13.5395,52,0); // Банк LS
	CreateDynamicMapIcon(-2648.8894,376.0311,6.1593,52,0);  // Банк SF
	CreateDynamicMapIcon(2421.2842,-1221.6509,25.4070,49,0); // Pig Pen
	CreateDynamicMapIcon(1834.7672,-1682.3358,13.4178,49,0); // Клуб "Альхамбра"
	CreateDynamicMapIcon(-2623.7166,1410.6890,7.0938,49,0);  // Клуб "Джиззи"
	CreateDynamicMapIcon(1365.6863,-1279.8872,13.5469,18,0); // Ammo LS
	CreateDynamicMapIcon(-2051.3333,-188.9438,35.0250,36,0); // Автошкола
	CreateDynamicMapIcon(1365.6863,-1279.8872,13.5469,18,0); // Аммо лс
	CreateDynamicMapIcon(-2626.6384,210.3960,4.5971,18,0);   // Аммо сф
	CreateDynamicMapIcon(2159.5449,943.2165,10.8203,18,0);   // Аммо лв
	CreateDynamicMapIcon(2228.5789,-1721.7820,13.5654,54,0); // спортзал лс
	CreateDynamicMapIcon(-2270.6406,-155.9734,35.3203,54,0); // спортзал сф
	CreateDynamicMapIcon(1961.8124,-2189.2671,13.5469,53,0); // Гонка
	//======================== Army LV =========================================
	CreateDynamicMapIcon(212.2816,1812.2374,21.8672,56,0); //точка наблюдения
	//======================== Пицерии и бургеры ===============================
	CreateDynamicMapIcon(-1816.5311,618.6709,35.1719,29,0); //pizza
	CreateDynamicMapIcon(-1911.7004,828.8093,35.1719,10,0); //burger
	CreateDynamicMapIcon(-2336.1675,-168.1730,35.3203,10,0); //burger
	CreateDynamicMapIcon(-2671.7808,257.9283,4.6328,29,0); //pizza
	CreateDynamicMapIcon(2102.0913,-1808.8442,38.0027,29,0); //pizza
	CreateDynamicMapIcon(800.9893,-1619.9106,38.0027,10,0); //burger
	CreateDynamicMapIcon(183.6340,1175.7919,22.6676,29,0); //pizza
	CreateDynamicMapIcon(2420.4573,-1508.2711,24.0000,14,0); //pizza
	CreateDynamicMapIcon(1204.3881,-915.2735,66.4264,10,0); //burger
	CreateDynamicMapIcon(1163.3766,2079.7026,40.0850,10,0); //burger*/
}
stock GetNearestVehicle(playerid)
{
	for(new i=0; i<MAX_VEHICLES; i++)
	{
		if(GetVehicleModel(i))
		{
			new Float:X,Float:Y,Float:Z;
			GetVehiclePos(i,X,Y,Z);
			if(PlayerToPoint(6.0, playerid, X, Y, Z))return i;
		}
	}
	return -1;
}
stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return true;
		}
	}
	return false;
}
stock AnRepairVehicle(vehicleid)
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
				player_NoCheckTimeVeh[i] = 3;
			}
		}
	}
	RepairVehicle(vehicleid);
	return true;
}
publics CheckForCheater(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid,20,610.9915,-11.1024,1000.9219))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(!player_NoCheckTimeVeh[playerid])
			{
				GetVehicleHealth(GetPlayerVehicleID(playerid),player_VehHealth[playerid]);
				if(PlayerInfo[playerid][pAdmin] >= 1) return 1;
				if(player_VehHealth[playerid] > HealthVeh[playerid])
				{
					if(IsPlayerInRangeOfPoint(playerid,7.5,2064.2842,-1831.4736,13.5469)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,487.6401,-1739.9479,11.1385)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,1024.8651,-1024.0870,32.1016)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,617.5467,-2.0437,1000.5823)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,615.2847,-124.2390,997.6888)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,-1904.7019,284.5968,41.0469)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,-2425.7822,1022.1392,50.3977)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,-1420.5195,2584.2305,55.8433)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,-99.9417,1117.9048,19.7417)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,1975.2384,2162.5088,11.0703)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,720.0854,-457.8807,16.3359)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					if(IsPlayerInRangeOfPoint(playerid,7.5,615.9690,-75.0127,997.9922)) { player_NoCheckTimeVeh[playerid] = 3; return true; }
					new string[128];
					format(string, sizeof(string), "Подозрение: %s[%i] | Lvl: %i | Warns: %i | Починка машины",GN(playerid),playerid,PlayerInfo[playerid][pLevel],PlayerInfo[playerid][pWarns]);
					ABroadCast(0xFFFF00AA,string,1);
				}
			}
			else player_NoCheckTimeVeh[playerid] -= 1; GetVehicleHealth(GetPlayerVehicleID(playerid), HealthVeh[playerid]);
		}
	}
	return true;
}
stock admintp(playerid,Float:ax,Float:ay,Float:az)
{
	if (GetPlayerState(playerid) == 2)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), ax,ay,az);
		return 1;
	}
	else
	{
		SetPlayerPos(playerid, ax,ay,az);
	}
	SendClientMessage(playerid, -1, "Вы были телепортированы");
	SetPlayerInterior(playerid,0);
	return 1;
}
stock SetRank(level,member)
{
	switch(member)
	{
	    case 1,10,21: if(level > 14 || 1 > level) return true;
	    case 2,4,11,14,22: if(level > 7 || 1 > level) return true;
	    case 3,19: if(level > 15 || 1 > level) return true;
	    case 5..6,12,15,17..18: if(level > 9 || 1 > level) return true;
	    case 7,9,16,20: if(level > 5 || 1 > level) return true;
	    case 8: if(level > 4 || 1 > level) return true;
	    case 13: if(level > 10 || 1 > level) return true;
	}
	return 0;
}
stock SetInvite(member,level)
{

	switch(member)
	{
	    case 1,10,21: if(level < 14) return true;
	    case 4,11,14,22,2: if(level < 7)  return true;
	    case 3,19: if(level < 15) return true;
	    case 5..6,12,15,17..18: if(level < 9) return true;
	    case 7,9,16,20: if(level < 5) return true;
	    case 13: if(level < 10) return true;
	    case 8: if(level < 4) return true;
	}
	return 0;
}
stock GetFrac(level)
{
	new ftext[40];
	switch(level)
	{
		case 0: ftext = "Неизвестно";
		case 1: ftext = "LSPD";
		case 2: ftext = "FBI";
		case 3: ftext = "Army SF";
		case 4: ftext = "МЧС СФ";
		case 5: ftext = "La Cosa Nostra";
		case 6: ftext = "Yakuza";
		case 7: ftext = "Мэрия";
		case 8: ftext = "Казино";
		case 9: ftext = "Новости СФ";
		case 10: ftext = "SFPD";
		case 11: ftext = "Инструкторы";
		case 12: ftext = "Ballas Gang";
		case 13: ftext = "Vagos Gang";
		case 14: ftext = "Russian Mafia";
		case 15: ftext = "The Grove";
		case 16: ftext = "Новости ЛС";
		case 17: ftext = "Aztecas Gang";
		case 18: ftext = "Rifa Gang";
		case 19: ftext = "Army LV";
		case 20: ftext = "Новости ЛВ";
		case 21: ftext = "SWAT";
		case 22: ftext = "МЧС ЛС";
		case 23: ftext = "Гопники";
	}
	return ftext;
 }
stock GetRank(targetid)
{
	new rtext[40];
	if(PlayerInfo[targetid][pAdmin] >= 1 && dostup[targetid])
	{
	    strmid(rtext,"Администратор", 0, 15, 16);
		return rtext;
	}
	switch(PlayerInfo[targetid][pMember])
	{
	    case 1,10,21:
	    {
	        switch(PlayerInfo[targetid][pRank])
	        {
	            case 15: rtext = "Шериф";
	            case 14: rtext = "Полковник";
	            case 13: rtext = "Подполковник";
	            case 12: rtext = "Майор";
	            case 11: rtext = "Капитан";
	            case 10: rtext = "Ст. лейтенант";
	            case 9: rtext = "Лейтенант";
	            case 8: rtext = "Мл. лейтенант";
	            case 7: rtext = "Ст. прапорщик";
	            case 6: rtext = "Прапорщик";
	            case 5: rtext = "Ст. сержант";
	            case 4: rtext = "Сержант";
	            case 3: rtext = "Мл. сержант";
	            case 2: rtext = "Офицер";
	            case 1: rtext = "Кадет";
	        }
  		}
  		case 2:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 8: rtext = "Директор";
	            case 7: rtext = "Зам. директора";
	            case 6: rtext = "Нач. отдела";
	            case 5: rtext = "Инспектор";
	            case 4: rtext = "Специалист";
	            case 3: rtext = "Ст. агент";
	            case 2: rtext = "Агент";
	            case 1: rtext = "Стажёр";
	        }
  		}
  		case 3:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 16: rtext = "Адмирал";
	            case 15: rtext = "Вице-адмирал";
	            case 14: rtext = "Контр-адмирал";
	            case 13: rtext = "Капитан-лейтенант";
	            case 12: rtext = "Ст. лейтенант";
	            case 11: rtext = "Лейтенант";
	            case 10: rtext = "Мл. лейтенант";
	            case 9: rtext = "Ст. мичман";
	            case 8: rtext = "Мичман";
	            case 7: rtext = "Прапорщик";
	            case 6: rtext = "Боцман";
	            case 5: rtext = "Гл. старшина";
	            case 4: rtext = "Старшина";
	            case 3: rtext = "Ст. матрос";
	            case 2: rtext = "Матрос";
	            case 1: rtext = "Юнга";
	        }
  		}
  		case 19:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 16: rtext = "Генерал";
				case 15: rtext = "Полковник";
				case 14: rtext = "Подполковник";
				case 13: rtext = "Майор";
				case 12: rtext = "Капитан";
				case 11: rtext = "Ст. лейтенант";
				case 10: rtext = "Лейтенант";
				case 9: rtext = "Мл. лейтенант";
				case 8: rtext = "Ст. прапорщик";
				case 7: rtext = "Прапорщик";
				case 6: rtext = "Старшина";
				case 5: rtext = "Ст. сержант";
				case 4: rtext = "Сержант";
				case 3: rtext = "Мл. сержант";
				case 2: rtext = "Ефрейтор";
				case 1: rtext = "Рядовой";
	        }
  		}
		case 4,22:
		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 8: rtext = "Главврач";
	            case 7: rtext = "Зав. отделением";
	            case 6: rtext = "Терапевт";
	            case 5: rtext = "Хирург";
	            case 4: rtext = "Интерн";
	            case 3: rtext = "Стажёр";
	            case 2: rtext = "Практикант";
	            case 1: rtext = "Санитар";
	        }
		}
		case 9,16,20:
		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 6: rtext = "Гл. редактор";
	            case 5: rtext = "Редактор";
	            case 4: rtext = "Журналист";
	            case 3: rtext = "Папарацци";
	            case 2: rtext = "Фотограф";
	            case 1: rtext = "Стажёр";
	        }
  		}
  		case 5:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 10: rtext = "Дон";
	            case 9: rtext = "Консильери";
	            case 8: rtext = "Мл. босс";
	            case 7: rtext = "Капо";
	            case 6: rtext = "Сотто Капо";
	            case 5: rtext = "Боец";
	            case 4: rtext = "Солдато";
	            case 3: rtext = "Сомбаттенте";
	            case 2: rtext = "Ассосиато";
	            case 1: rtext = "Новицио";
	        }
  		}
  		case 6:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	        	case 10: rtext = "Кумите";
	            case 9: rtext = "Оядзи";
	            case 8: rtext = "Сайко Комон";
	            case 7: rtext = "Камбу";
	            case 6: rtext = "Со-Хонбуте";
	            case 5: rtext = "Вакагасира";
	            case 4: rtext = "Фуку-Хомбуте";
	            case 3: rtext = "Кедай";
	            case 2: rtext = "Сятэй";
	            case 1: rtext = "Вакасю";
	        }
  		}
  		case 14:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	        	case 10: rtext = "Авторитет";
	            case 9: rtext = "Вор в законе";
	            case 8: rtext = "Вор";
	            case 7: rtext = "Браток";
	            case 6: rtext = "Свояк";
	            case 5: rtext = "Блатной";
	            case 4: rtext = "Барыга";
	            case 3: rtext = "Бык";
	            case 2: rtext = "Фраер";
	            case 1: rtext = "Шнырь";
	        }
  		}
  		case 7:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 6: rtext = "Мэр";
	            case 5: rtext = "Зам. мэра";
	            case 4: rtext = "Нач. охраны";
	            case 3: rtext = "Охранник";
	            case 2: rtext = "Адвокат";
	            case 1: rtext = "Секретарь";
	        }
  		}
  		case 12:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 10: rtext = "Биг Вилли";
	            case 9: rtext = "Райч Нигга";
	            case 8: rtext = "Фолкс";
	            case 7: rtext = "Федерал Блок";
	            case 6: rtext = "Гангстер";
	            case 5: rtext = "Ап Бро";
	            case 4: rtext = "Гун бро";
	            case 3: rtext = "Крэкер";
	            case 2: rtext = "Бастер";
	            case 1: rtext = "Блайд";
	        }
        }
  		case 23:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 8: rtext = "Опасный";
	            case 7: rtext = "Громила";
	            case 6: rtext = "Беспредельник";
	            case 5: rtext = "Неуловимый";
	            case 4: rtext = "Глава гопников";
	            case 3: rtext = "Гопник";
	            case 2: rtext = "Начинающий";
	            case 1: rtext = "Новенький";
	        }
  		}
  		case 13:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
				case 10: rtext = "Падре";
	            case 9: rtext = "Падрино";
	            case 8: rtext = "Лидер V.E.G";
	            case 7: rtext = "Авторитарио";
	            case 6: rtext = "Асесино";
	            case 5: rtext = "Амиго";
	            case 4: rtext = "Эстимадо";
	            case 3: rtext = "Сольдадо";
	            case 2: rtext = "Криминаль";
	            case 1: rtext = "Новато";
	        }
  		}
  		case 15:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 10: rtext = "Мэд Дог";
	            case 9: rtext = "Легенд";
	            case 8: rtext = "Де Кинг";
	            case 7: rtext = "Мобста";
	            case 6: rtext = "О.Г";
	            case 5: rtext = "Гангста";
	            case 4: rtext = "Юонг Г";
	            case 3: rtext = "Килла";
	            case 2: rtext = "Хастла";
	            case 1: rtext = "Плэйя";
	        }
  		}
  		case 17:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 10: rtext = "Падре";
	            case 9: rtext = "Нестро";
	            case 8: rtext = "Тесореро";
	            case 7: rtext = "Инвасор";
	            case 6: rtext = "Сабио";
	            case 5: rtext = "Мирандо";
	            case 4: rtext = "Лас Геррас";
	            case 3: rtext = "Геттор";
	            case 2: rtext = "Тирадо";
	            case 1: rtext = "Перро";
	        }
  		}
  		case 18:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 10: rtext = "Падре";
	            case 9: rtext = "Аджунто";
	            case 8: rtext = "Ауторидад";
	            case 7: rtext = "Бандидо";
	            case 6: rtext = "Эрмано";
	            case 5: rtext = "Джуниор";
	            case 4: rtext = "Мачо";
	            case 3: rtext = "Амиго";
	            case 2: rtext = "Новато";
	            case 1: rtext = "Ладрон";
	        }
  		}
    	case 8:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 5: rtext = "Директор";
	            case 4: rtext = "Зам. директора";
	            case 3: rtext = "Крупье";
	            case 2: rtext = "Охранник";
	            case 1: rtext = "Чипер";
	        }
  		}
  		case 11:
  		{
  		    switch(PlayerInfo[targetid][pRank])
	        {
	            case 8: rtext = "Управляющий";
	            case 7: rtext = "Директор";
	            case 6: rtext = "Зав. отделом";
	            case 5: rtext = "Методист";
	            case 4: rtext = "Экзаменатор";
	            case 3: rtext = "Ст. инструктор";
	            case 2: rtext = "Инструктор";
	            case 1: rtext = "Стажёр";
	        }
  		}
  		default: { if(PlayerInfo[targetid][pRank] == 0) { rtext = "Нет"; } }
  	}
	return rtext;
}
stock NoNalog(playerid)
{
	if(!IsPlayerConnected(playerid)) return true;
    switch(PlayerInfo[playerid][pMember]) { case 5..6,12..15,17..18: return true; }
	if(PlayerInfo[playerid][pMember] == 0 && PlayerInfo[playerid][pJob] == 0) return true;
	if(PlayerInfo[playerid][pMember] == 0 && PlayerInfo[playerid][pKrisha] > 0) return true;
	return false;
}
stock IsAArm(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    switch(PlayerInfo[playerid][pMember])
	 	{
	 	    case 3,19:return true;
   		}
	}
	return false;
}
stock IsAOhrana(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		switch(PlayerInfo[playerid][pMember])
		{
			case 7:
			{
			    switch(PlayerInfo[playerid][pRank])
			    {
			        case 3..4: return true;
			    }
			}
		}
	}
	return false;
}
stock IsACop(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    switch(PlayerInfo[playerid][pMember])
	 	{
	 	    case 1,2,10,21:return true;
   		}
	}
	return false;
}
stock IsAMayor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    switch(PlayerInfo[playerid][pMember])
	 	{
	 	    case 7:return true;
   		}
	}
	return false;
}
stock IsAMedic(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    switch(PlayerInfo[playerid][pMember])
	 	{
	 	    case 4,22:return true;
   		}
	}
	return false;
}
stock SuperGt(carid){switch (GetVehicleModel(carid)){case 402,411,415,429,451,477,506,541,552,602:return true;}return false;}
stock IsABoat(carid){switch(GetVehicleModel(carid)){case 472,473,493,595,484,430,452..454,446:return true;}return false;}
stock IsAPlane(carid) { switch(GetVehicleModel(carid)) { case 417,425,430,432,446,447,452,453,454,460,469,472,473,476,449,484,487,488,493,497,519,520,537,538,548,553,563,577,592,593,595:return true; } return false; }
stock VodPrava(carid)
{
	switch (GetVehicleModel(carid))
	{
		case 400..416,418..424,426..429,431..445,449,451,455,456,458,459,461: return true;
		case 463,466..468,470,471,474,475,477..480,482,483,485,486,489..492,494..496,498..508: return true;
		case 514..518,521..531,533..537,539..547,549..551,554..562,564..568,572..576,578..583,585..589,596..605,609: return true;
	}
	return false;
}
stock CreatePickupAC(model, type, Float:X, Float:Y, Float:Z, virtualworld = 0)
{
    new TempID = CreatePickup(model, type, X, Y, Z, virtualworld);
    PickupInfo[TempID][PickX] = X;
    PickupInfo[TempID][PickY] = Y;
    PickupInfo[TempID][PickZ] = Z;
    return TempID;
}
// ========== [ Прочее ] ==========
stock IsPlayerApplyAnimation(playerid, animation[])
{
    if(!GetPlayerAnimationIndex(playerid)) return false;
    if(!GetPlayerAnimationIndex(playerid)) return false;
    new animlib[32], animname[32];
    GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
    if(strcmp(animname, animation, true) == 0) return 1;
    else
    {
        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
        if(!strcmp(animname, animation, true)) return true;
    }
    return false;
}
stock ProxDetector(idx,Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		foreach(new i : Player)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SendClientMessage(i, col1, string);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SendClientMessage(i, col2, string);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SendClientMessage(i, col3, string);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SendClientMessage(i, col4, string);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SendClientMessage(i, col5, string);
					}
					else if ((chat[i] && idx == 0) && ((idx != 1 || idx != 4) && playerid == i))
					{
					    format(req,sizeof(req),"[%d]%s",playerid,string);
						SendClientMessage(i, col1, req);
					}
					else if ((noobchat[i] && PlayerInfo[playerid][pLevel] <= 2 && idx == 0 ) && ((idx != 1 || idx != 4) && playerid == i))
					{
					    format(req,sizeof(req),"[%d]%s",playerid,string);
						SendClientMessage(i, col1, req);
					}
				}
			}
		}
	}
	return 1;
}
stock ProxDetectorS(Float:radi, playerid, targetid)
{
	if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
stock GetClosestPlayer(p1)
{
	new x,Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	for (x=0;x<MAX_PLAYERS;x++)
	{
		if(IsPlayerConnected(x))
		{
			if(x != p1)
			{
				dis2 = GetDistanceBetweenPlayers(x,p1);
				if(dis2 < dis && dis2 != -1.00)
				{
					dis = dis2;
					player = x;
				}
			}
		}
	}
	return player;
}
stock Spawn_Player(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		new Float:slx, Float:sly, Float:slz;
		GetPlayerPos(playerid, slx, sly, slz);
		SetPlayerPos(playerid, slx, sly, slz+5);
	}
	SpawnPlayer(playerid);
}
stock FixHour(hour)
{
	hour = timeshift+hour;
	if(hour < 0)
	{
		hour = hour+24;
	}
	else if (hour > 23)
	{
		hour = hour-24;
	}
	return true;
}
stock IsVehicleOccupied(vehicleid)
{
	foreach(new i : Player)
	{
		if(IsPlayerInVehicle(i,vehicleid))
		return true;
	}
	return false;
}
