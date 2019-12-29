getFont()
{
    return "default";
}

retClass()
{
    return self getWeaponClass(weapon);
}
SpawnBots5()
{
    //for(i = 0; i < 5; i++)
    //{
        ent = addtestclient();
        wait 1;
        ent.pers["isBot"] = true;
        ent initBot();
        wait 0.1;
    //}
}

initBot()
{
    
    self endon( "disconnect" );
    self notify("menuresponse", game["menu_team"], "autoassign");
    wait 0.5;
    self notify("menuresponse", "changeclass", "class" + randomInt( 5));

}