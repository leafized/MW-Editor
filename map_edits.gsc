/*
  All current custom functions and their params
  spawnCarepackage(ent_num,origin,angles,is_solid,type,lowerMessage,notify_bool) spawns a carepackage
    spawnWeapon(ent_num,isRandomWeapon,weapon,origin,angles,lowerMessage,allowPickup) spawns a weapon
    returnMap() gets the name of the map
    spawnSpecial(ent_num,attachment,effect,origin,lowerMessage,canPickup) spawns a effect with a perk or boost
    spawnMapModel(ent_num,type,origin) spawns a model in the map.
    
*/
returnMap()
{
    return GetDvar("mapname");
}

mapSetup()
{
    if(returnMap() == "mp_rust")
        level thread map_mp_rust();
}

map_mp_rust()
{
    spawnCarepackage(0, (839.695, 478.659, -235.577),undefined, true ,"friendly","Test",true);
    spawnCarepackage(1, (1533.15, 945.376, -231.814),undefined, true, "friendly","Test",true);
    spawnCarepackage(2, (478.385, 1800.66, -226.032),undefined, true, "friendly","Test",true);
    
    spawnWeapon(0,"cheytac_mp",(839.695, 478.659, -235.577),undefined,"Press ^3[{+activate}] ^7to pickup ^3Intervention",false);
    spawnWeapon(1,"deserteaglegold_mp",(1533.15, 945.376, -245.814),undefined,"Press ^3[{+activate}] ^7to pickup ^3Desert Eagle Gold",false);
    spawnWeapon(2,"ump45_mp",(478.385, 1800.66, -226.032),undefined,"Press ^3[{+activate}] ^7to pickup ^3UMP45",false);
    
    spawnMapModel(0,"foliage_cod5_tree_pine05_large" , (-79.5368, 883.821,-239.389));
    spawnMapModel(1,"foliage_cod5_tree_pine05_large" , (-58.9049, 260.902,-239.536));
    //spawnMapModel(2,"foliage_cod5_tree_pine05_large" , (1074.05, 511.428, -238.365));
    spawnMapModel(3,"foliage_shrub_desertspikey" , (1074.05, 511.428, -238.365));
    
    spawnSpecial(0,"_silencer","ac130_light_red_blink",(478.385, 1800.66, -200.032),lowerMessage,canPickup);//ac130_flare
}


