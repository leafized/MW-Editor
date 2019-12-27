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

init()
{
    level._effect[ "ac130_light_red_blink" ]    = loadfx( "misc/aircraft_light_red_blink" );
    level thread onPlayerConnect();
    level.airDropCrates = getEntArray( "care_package", "targetname" );
    level.airDropCrateCollision = getEnt( level.airDropCrates[0].target, "targetname" );
    level thread mapSetup();
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
        if(GetDvar("mapname") != "mp_rust" )
        {
            self IPrintLnBold("^1NOT AVIALABLE ON THIS MAP");
        }
        self thread buttonMonitor();
        self thread monitorSystem();

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