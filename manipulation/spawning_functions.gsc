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

spawnWeaponRand(ent_num, origin, angles)
{
   if(level.spawnedWep[ent_num ] == false)
   {
       weapon = level.weaponList[level.weaponList.size ];
       level.spawnedWep[ent_num] = true;
       level.spawnWep[ent_num] = spawn("script_model", origin + (0,0, 45)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
       level.spawnWep[ent_num] SetModel( GetWeaponModel( weapon ) );
       level.spawnWep[ent_num].message = "Press ^3[{+activate}] ^7to pickup ^3" + getWeaponNameString(weapon.id);
       level.spawnWep[ent_num].weap = weapon;
   }
}


spawnRandomWeapon(ent_num , origin)
{
    level.RandomWepCP[ent_num]        = spawn( "script_model", origin + (0,0,5) );
    level.RandomWepCP[ent_num].angles = (0,0,0);
    level.RandomWepCP[ent_num] setModel( "com_plasticcase_friendly" );
    level.WeaponModelCP[ent_num] = spawn("script_model",level.WeaponModelCP[ent_num].origin + (0,0,30));
    level.WeaponModelCP[ent_num].angles = (0,0,0);
    wait .1;
    level.randomModel[ent_num] = level.weaponList[RandomInt( level.weaponList.size)];
        level.WeaponModelCP[ent_num] setModel(GetWeaponModel(level.randomModel[ent_num]));
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

 addFogEnt()
{
    if(!isDefined(level.fog_ent))
    {
        level.fog_ent = [];
    }
    i = level.fog_ent.size;
    level.fog_ent[i] = SpawnFx(level._effect["nuke_aftermath"],leve.mapCenter);
}
monitorRWeapons()
{
    self endon("disconnect");
    for(;;)
    {
        for(i=0;i<level.RandomWepCP.size;i++)
        {
            if(distance(self.origin, level.RandomWepCP[i].origin) < 100)
            {
                
                self setLowerMessage("ranGun" + i, "Press ^3[{+activate}] ^7to Select a random Weapon",undefined, 50);
                if(self usebuttonpressed())
                {
                    
                    self notify("gun_pickup");
                    self.gotWeapon = true;
                    wait .3;
                    self takeWeapon(self getCurrentWeapon());
                    self freezeControls(false);
                    self giveWeapon( level.randomModel[i], RandomInt(9));
                    self SwitchToWeapon(level.randomModel[i]);
                }
            }
            else if(distance(self.origin, level.RandomWepCP[i].origin) > 100)
            {
                self clearLowerMessage("ranGun" + i);
            }
            if(i > level.RandomWepCP.size)
            {
                i = 0;
            }
        }
        wait .2;
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
                    self.gotWeapon = true;
                    self notify("gun_pickup");
                wait 1;
                    self takeWeapon(self getCurrentWeapon());
                    self freezeControls(false);
                    self giveWeapon( level.wepmodel[i], RandomInt(9));
                    self SwitchToWeapon(level.wepmodel[i]);
                }
            }
            else if(distance(self.origin, level.packRB[i].origin) > 100)
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
                   self.gotWeapon = true;
                   self notify("gun_pickup");
                   self giveWeapon(level.spawnWep[i].weap);
                   wait .05;
                   self SwitchToWeapon( level.spawnWep[i].weap);
                   if(retClass() == "weapon_pistol")
                   {
                       self SetWeaponAmmoStock( level.spawnWep[i], RandomInt(30) );
                   }                   self SwitchToWeapon( level.spawnWep[i].weap);
                   if(retClass() == "weapon_sniper")
                   {
                       self SetWeaponAmmoStock( level.spawnWep[i], RandomInt(60) );
                   }
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