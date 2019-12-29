/*
    *    Welcome to MW Editor Source Code
     Need to Add the following
     
     Carepackage Spawn System
     Weapon Spawning
     Spawn Animation
     Spawn With no weaps, or ammo
     Spawn with no perks
     Spawn with a USP Tac knife, no ammo.
     
     
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#define game_weapon = "usp_tactical_mp";
init()
{
    
    level thread onPlayerConnect();
    level.airDropCrates = getEntArray( "care_package", "targetname" );
    level.airDropCrateCollision = getEnt( level.airDropCrates[0].target, "targetname" );
    foreach( models in StrTok( "foliage_cod5_tree_pine05_large, foliage_pacific_tropic_shrub01,foliage_shrub_desertspikey, vehicle_little_bird_armed", "," ))
     PreCacheModel( models );
     PreCacheShader( "compassping_enemyfiring" );
    level thread mapSetup();
    SetDvar( "g_hardcore", 1 );
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.playerSpawned))
            continue;
        self.playerSpawned = true;
        self freezeControls(false);
        if(GetDvar("mapname") != "mp_rust" && GetDvar("mapname") != "mp_derail")
        {
            self IPrintLnBold("^1NOT AVIALABLE ON THIS MAP");
        }
        if(self isHost() && self.isFirstSpa == false)
        {
            self thread SpawnBots5();
            self.isFirstSpa = true;
        }
        self TakeAllWeapons();
        self thread spawnAnim();
        
        self.maxHealth = 150;
        self.health    = 150;
        
        self thread buttonMonitor();
        self thread monitorWeaps();
        self thread monitorPerks();
        self thread monitorBox();
        self thread monitorRWeapons();
        self thread monitorVision();
        self thread monitorWeapons();

    }
}

monitorVision()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        if(self.vss == false)
        {
            self VisionSetNakedForPlayer( "grayscale", .2 );
           self _setPerk( "_specialty_blastshield" );
        }
        wait .05;
    }
}
monitorWeapons()
{
    self endon("death" || "gun_pickup");
    for(;;)
    {
        if( self GetCurrentWeapon() != game_weapon && self.gotWeapon == false )
        {
            self IPrintLnBold("^1Your weapon is invalid.");
            self TakeAllWeapons();
            self GiveWeapon( game_weapon );
            self SwitchToWeaponImmediate( game_weapon );
            self SetWeaponAmmoClip( game_weapon ,  0 );
            self SetWeaponAmmoStock( game_weapon , 0 );
        }
        wait .1;
    }
}

buttonMonitor()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        if(self AdsButtonPressed() && self MeleeButtonPressed() && self.isPrinting == false)
        {
            self.isPrinting = true;
            self thread pLocation();
        }
        if(self AdsButtonPressed() && self MeleeButtonPressed() && self.isPrinting == true)
        {
            self.isPrinting = false;
            self notify("stop_printing");
        }
        wait .4;
    }
}

pLocation()
{
    self endon("stop_printing");
    self endon("death");
    for(;;)
    {
        self IPrintLnBold(self.origin);
        wait .4;
    }
}

spawnAnim()
{
    self DisableWeapons();
    self FreezeControls( true );
    self endon( "disconnect" );
    self endon( "death" );
    newlocs = self.origin + (0,0, 25);
    self SetOrigin( self.origin + (3900, 4100, 2000));
        s = 40;
        wait .5;
        self.Hud.IntroScreen = createRectangle("CENTER","CENTER",0,0,1000,1000,(0,0,0),1,0,"white");
        self.Hud.IntroScreen elemManage(3,undefined,undefined,0);
        self.FlyBy delete();
        self.myWeap       = self getCurrentWeapon();
        self.InVehicle    = false;
        self.FlyBy        = spawnHelicopter(self, self.origin+(0,0,250.75), self.angles, "pavelow_mp", "vehicle_pavelow");
        self.FlyBy.angles = ( 0, 0, 0 );
        self.InVehicle    = true;
        self clearLowerMessage("destroy");
        self playerLinkTo( self.FlyBy, "tag_guy1" );
        self setOrigin( self.FlyBy.origin );
        self setPlayerAngles( self.FlyBy.angles + ( 0, 0, 0 ) );
        self.FlyBy Vehicle_SetSpeed(45, 30);
        self.FlyBy setVehGoalPos( newlocs + (100,100,100));
        wait 0.2;
        self thread spawnHeli(newlocs );
        
        

}


spawnHeli(newlocs)
{
    self endon("stop_teleporting");
    for(;;)
    {
        

        if( Distance(self.FlyBy.origin, newlocs ) <= 800 && self.InVehicle == true)
       {
           self.FlyBy vehicle_setspeed(5, 100);
       }
       
       if( Distance(self.origin, newlocs ) <= 150 && self.InVehicle == true)
       {
           self.FlyBy vehicle_setspeedimmediate(0, 1);
           wait 1;
           self.InVehicle = false;
           self.FlyBy delete();
           self show();
           self EnableWeapons();
           self FreezeControls( false );
           self giveWeapon( self.myWeap, 0, false );
           self switchToWeapon( self.myWeap );
           self unlink( self.FlyBy );
           self SetOrigin(newlocs);
           self setClientDvar( "cg_thirdperson", 0 ); 
           self ShowAllParts();
           self _setPerk( "_specialty_blastshield" );
           self VisionSetNaked( "grayscale", 0.5 );
           self notify("default_night_mp");

       }
       wait 1;
    }
}

getRandomWeapon()
{
    wep = level.weaponList[RandomInt( level.weaponList.size)] ;
    self IPrintLn(getWeaponNameString(wep.id));
    return wep;
    
}