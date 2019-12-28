/*
    
        THIS MODIFICATION HAS BEEN CREATED FOR USAGE ON MODERN WARFARE SERIES GAMES. 
        CREATED BY LEAFIZED.
        
        
        1. Information and Guide:
            -You must be able to understand basic GSC to understand how this works.
            -The code should be easy to understand and implement in your own right.
            -Spawning systems may chane, location monitoring will change as well.
            
       2. Setting up maps 
           - Each map is already defined as a function in map_edits.gsc file. 
           - Each map is monitored already.
           - Some maps do not have the same models, you will need to find the models.
           - Some features won't work on certain maps, and will be disabled on those maps.
      3. Custom Functions
           -This is a  list of all current custom functions within this mod.
           
           spawnCarepackage(ent_num,origin,angles,is_solid,type,lowerMessage,notify_bool)
           spawns a carepackage.
           
           spawnMapModel(ent_num,type,origin,isHeli)
           spawns a map model / helicopter
           
           spawnSpecial(ent_num,entity_item,origin,lowerMessage,canPickup,isPerk,isAmmo,isKillstreak)
           spawns  perks, attachments, ammo,etc..
           
           monitorWeaps()
           -monitors weapon 
           
           monitorPerks()
           -monitors perks / special spawns
           
           buttonMonitor()
           - monitors buttons
            - aim + knife to print location
           pLocation() 
           - prints current location
           
           
       4. 
*/