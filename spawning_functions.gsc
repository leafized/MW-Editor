spawnCarepackage(ent_num, origin, angles, is_solid, type, lowerMessage, notify_bool)
{
    if(level.spawnedCP[ent_num ] == false)
    {
        level.spawnedCP[ent_num] = true;
        level.spawnCP[ent_num] = spawn("script_model", origin + (0,0,15)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
        level.spawnCP[ent_num] SetModel( "com_plasticcase_" + type);
        level.spawnCP[ent_num] CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
        level.spawnCP[ent_num].message = lowerMessage;
    }
}

spawnMapModel(ent_num , type , origin, isHeli)
{
    level.spawnedModel[ent_num] = true;
    level.spawnModel[ent_num]   = spawn("script_model", origin);
    level.spawnModel[ent_num]   setModel(type);
}

spawnWeapon(ent_num, weapon, origin, angles, lowerMessage,  allowPickup)
{
   if(level.spawnedWep[ent_num ] == false)
   {
       level.spawnedWep[ent_num] = true;
       level.spawnWep[ent_num] = spawn("script_model", origin + (0,0, 45)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
       level.spawnWep[ent_num] SetModel( GetWeaponModel( weapon ) );
       level.spawnWep[ent_num].message = "Press ^3[{+activate}] ^7to pickup ^3" + lowerMessage;
       level.spawnWep[ent_num].weap = weapon;
   }
}

spawnSpecial(ent_num, entity_item, origin, lowerMessage, canPickup, isPerk , isAmmo, isKillstreak)
{
    if(level.spawnedSP[ent_num] == false)
    {
        level._effect[ "ac130_light_red_blink" ]    = loadfx( "misc/aircraft_light_red_blink" );
        level.spawnSP[ent_num] = spawn("script_model", origin + (0,0,10));
        level.spawnSP[ent_num] SetModel( "com_plasticcase_dummy" );
        level.spawnSP[ent_num].message = lowerMessage;
        level.spawnSP[ent_num].isPerk = isPerk;
        if(isPerk)
        {
            level.spawnSP[ent_num].atr = entity_item;
        }
        wait .05;
        level.spawnSP[ent_num ].eff = PlayLoopedFX( level._effect["ac130_light_red_blink"], .1, origin );//ac130_flare; PlayFXOnTag( <effect id >, <entity>, <tag name> )
         level.spawnedSP[ent_num] = true;
    }
    
}

 
spawnBox(ent_num , origin)
{

    level.packRB[ent_num]        = spawn( "script_model", origin + (0,0,5) );
    level.packRB[ent_num].angles = (0,0,0);
    level.packRB[ent_num] setModel( "com_plasticcase_friendly" );
    level.wepRB[ent_num] = spawn("script_model",level.packRB[ent_num].origin + (0,0,30));
    level.wepRB[ent_num].angles = (0,0,0);
    for(;;)
    {
        level.wepmodel[ent_num] = level.weaponList[RandomInt( level.weaponList.size)];
        level.wepRB[ent_num] setModel(GetWeaponModel(level.wepmodel[ent_num]));
        wait 0.2;
    }
}

monitorBox()
{
    self endon("disconnect");
    for(;;)
    {
        for(i=0;i<level.packRB.size;i++)
        {
            if(distance(self.origin, level.packRB[i].origin) <100)
            {
                
                self setLowerMessage("getGun" + i, "Press ^3[{+activate}] ^7to Select a random Weapon",undefined, 50);
                if(self usebuttonpressed())
                {
                wait 1;
                    self takeWeapon(self getCurrentWeapon());
                    self freezeControls(false);
                    self giveWeapon( level.wepmodel[i], RandomInt(9));
                    self SwitchToWeapon(level.wepmodel[i]);
                }
            }
            else if(distance(self.origin, level.packRB.origin) > 100)
            {
                self clearLowerMessage("getGun" + i);
            }
            if(i > level.packRB.size)
            {
                i = 0;
            }
        }
        wait .2;
    }
}
 monitorWeaps()
{
    self endon("disconnect");
    for(;;)
    {

        //Monitor Weapons
        for(i=0;i<level.spawnWep.size;i++)
        {   
            
            if(Distance( self.origin, level.spawnWep[i].origin ) <= 100)
            {
                self setLowerMessage("msg"+ i, "" + level.spawnWep[i].message, undefined, 50);
               if(self UseButtonPressed() && level.spawnedCP[i] == true)
               {
                   self giveWeapon(level.spawnWep[i].weap);
                   wait .05;
                   self SwitchToWeapon( level.spawnWep[i].weap);
                   self clearLowerMessage("msg" + i);
                   level.spawnWep[i] delete();
                   level.spawnCP[i] delete();
                   level.spawnedCP[i] = false;
               }
            }
           if(Distance( self.origin, level.spawnWep[i].origin ) > 100)
            {
                self clearLowerMessage("msg" + i);
            }
            
        }
        wait .1;
    }
}

monitorPerks()
{
            //Monitor Specials
        for(s=0;i<level.spawnSP.size;s++)
        {   
            if(Distance( self.origin, level.spawnSP[s].origin ) < 70)
            {
                self setLowerMessagE("msg" +s, "Press ^3[{+activate}] ^7 to pickup ^3" + level.spawnSP[s].message );
                
                if(self useButtonPressed() && level.spawnSP[s].isPerk == true)
               {
                   self SetPerk(level.spawnSP[s].atr);
                   level.spawnSP[s] delete();
               }
            }
           else if(Distance( self.origin, level.spawnSP[s].origin ) > 70)
            {
                self clearLowerMessage("msg" + s);
            }
            
        }
        wait .1;
        s = 0;
}