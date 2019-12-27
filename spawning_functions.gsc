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

 spawnWeapon(ent_num, weapon, origin, angles, lowerMessage,  allowPickup)
 {
    if(level.spawnedWep[ent_num ] == false)
    {
        level.spawnedWep[ent_num] = true;
        level.spawnWep[ent_num] = spawn("script_model", origin + (0,0, 45)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
        level.spawnWep[ent_num] SetModel( GetWeaponModel( weapon ) );
        level.spawnWep[ent_num].message = lowerMessage;
        level.spawnWep[ent_num].weap = weapon;
    }
 }

spawnSpecial(ent_num, attachment, effect, origin, lowerMessage, canPickup )
{
    if(level.spawnedSP[ent_num] == false)
    {
        level.spawnSP[ent_num] = true;
        level.spawnSP[ent_num].effect = effect;
        PlayFX( level._effect[effect ], origin );//ac130_flare
    }
    
}
monitorSystem()
{
    self endon("disconnect");
    for(;;)
    {
        for(i=0;i<level.spawnWep.size;i++)
        {
            if(Distance( self.origin, level.spawnWep[i].origin ) <= 100)
            {
               self setLowerMessage("msg", "" + level.spawnWep[i].message, undefined, 50);
               if(self UseButtonPressed() && level.spawnedCP[i] == true)
               {
                   self TakeWeapon(self GetCurrentWeapon());
                   wait .1;
                   self giveWeapon(level.spawnWep[i].weap);
                   wait .05;
                   self SwitchToWeapon( level.spawnWep[i].weap);
                   self clearLowerMessage("msg");
                   level.spawnWep[i] delete();
                   level.spawnCP[i] delete();
                   level.spawnedCP[i] = false;
               }
            }
           else if(Distance( self.origin, level.spawnWep[i].origin ) > 100)
            {
                self clearLowerMessage("msg");
            }
            
        }
        wait .1;
                for(i=0;i<level.spawnWep.size;i++)
        {
            if(Distance( self.origin, level.spawnWep[i].origin ) <= 100)
            {
               self setLowerMessage("msg", "" + level.spawnWep[i].message, undefined, 50);
               if(self UseButtonPressed() && level.spawnedCP[i] == true)
               {
                   self TakeWeapon(self GetCurrentWeapon());
                   wait .1;
                   self giveWeapon(level.spawnWep[i].weap);
                   wait .05;
                   self SwitchToWeapon( level.spawnWep[i].weap);
                   self clearLowerMessage("msg");
                   level.spawnWep[i] delete();
                   level.spawnCP[i] delete();
                   level.spawnedCP[i] = false;
               }
            }
           else if(Distance( self.origin, level.spawnWep[i].origin ) > 100)
            {
                self clearLowerMessage("msg");
            }
            
        }
    }
}