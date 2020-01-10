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


}


map_mp_outpost()
{

}
