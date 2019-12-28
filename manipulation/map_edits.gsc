/*
  All current custom functions and their params
  spawnCarepackage(ent_num,origin,angles,is_solid,type,lowerMessage,notify_bool) spawns a carepackage
    spawnWeapon(ent_num,isRandomWeapon,weapon,origin,angles,lowerMessage,allowPickup) spawns a weapon
    returnMap() gets the name of the map
    spawnSpecial(ent_num,attachment,effect,origin,lowerMessage,canPickup) spawns a effect with a perk or boost
    spawnMapModel(ent_num,type,origin) spawns a model in the map.
    spawnBox(ent_num,origin) spawns a mystery box.
    
*/
returnMap()
{
    return GetDvar("mapname");
}

mapSetup()
{
    if(returnMap() == "mp_rust")
        level thread map_mp_rust();
    if(returnMap() == "mp_derail")
        level thread map_mp_outpost();
}

map_mp_rust()
{
    //spawnCarepackage(0, (839.695, 478.659, -235.577),undefined, true ,"friendly","Test",true);
    spawnCarepackage(1, (1533.15, 945.376, -231.814),undefined, true, "friendly","Test",true);
    spawnCarepackage(2, (478.385, 1800.66, -226.032),undefined, true, "friendly","Test",true);
    
    spawnRandomWeapon(0,(839.695, 478.659, -235.577));
    //spawnWeapon(0,"cheytac_mp",(839.695, 478.659, -235.577),undefined,"Intervention",false);
    spawnWeapon(1,"deserteaglegold_mp",(1533.15, 945.376, -245.814),undefined,"Desert Eagle Gold",false);
    spawnWeapon(2,"ump45_mp",(478.385, 1800.66, -226.032),undefined,"Press ^3[{+activate}] ^7to pickup ^3UMP45",false);
    
    spawnMapModel(0,"foliage_cod5_tree_pine05_large" , (-79.5368, 883.821,-239.389));
    spawnMapModel(1,"foliage_cod5_tree_pine05_large" , (-58.9049, 260.902,-239.536));
    spawnMapModel(2,"foliage_cod5_tree_pine05_sm" , (1074.05, 511.428, -238.365));
    spawnMapModel(3,"projectile_rpg7", (725.493, 1084.04, 268.125));
    
    spawnBox(1,(1546.74, 1396.64, -229.348));
    //spawnSpecial(0,"specialty_falldamage",(478.385, 1800.66, -200.032),"Commando Pro",true,true);
}


map_mp_outpost()
{
    spawnCarepackage(0,(2741.54, 2212.63, 128.125),undefined,true,"friendly","Press ^3[{+activate}] ^7to pickup!",false);
    spawnWeapon(0,"deserteaglegold_mp",(2741.54, 2212.63, 128.125),undefined,"Press [{+activate}] to pickup!",true);
    
    spawnMapModel(0,"vehicle_little_bird_armed", (-866.476, 1533.88, -15.875) + (0,0,120), true);
}


getWeaponNameString(base_weapon)
{
    tableRow         = tableLookup("mp/statstable.csv",4,base_weapon,0);
    weaponNameString = tableLookupIString("mp/statstable.csv",0,tableRow,3);
    return weaponNameString;
}