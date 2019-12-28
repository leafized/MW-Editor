getFont()
{
    return "default";
}
pong()
{
    self freezeControls(true);
    hud=[];
    hud["bg"]=self createRectangle("CENTER","CENTER",0,0,1000,1000,(0,0,0),"white",1,1);
    hud["otherPlayer"]=self createText(getFont(),1.5,"CENTER","CENTER",0,0,2,1,undefined);
    hud["otherPlayer"] thread dotDot("Waiting for another player");
    self.attemptingToPlayPong=true;
    player2 = undefined;
    while(!isDefined(player2))
    {
        wait .05;
        for(a=0;a<getPlayers().size;a++)
            if(isDefined(getPlayers()[a].attemptingToPlayPong) && getPlayers()[a] != self || isDefined(self.pongConnect))
            {
                player2 = getPlayers()[a];
                player2.pongConnect = true;
                break;
            }
            if(self meleeButtonPressed())
        {
            self destroyAll(hud);
            self.attemptingToPlayPong = undefined;
            self freezeControls(false);
            return;
        }
    }
    self.attemptingToPlayPong = undefined;
    hud["otherPlayer"] notify("dotDot_endon");
    hud["otherPlayer"] setText(player2 getName()+" wants to play Pong!");
    wait 2;
    self.pongConnect = undefined;
    hud["otherPlayer"].y=-15;
    hud["otherPlayer"] setText("Game Beginning In:");
    hud["timer"]=self createText("big",2,"CENTER","CENTER",0,15,2,.85,undefined);
    hud["timer"].color=(1,1,.5);
    for(a=3;a>0;a--)
    {
        hud["timer"] setValue(a);
        hud["timer"] thread changeFontScaleOverTime(4,.1);
        wait .1;
        hud["timer"] thread changeFontScaleOverTime(2,.2);
        wait .9;
    }
    hud["otherPlayer"] destroy();
    hud["timer"] destroy();
    self.PONGSCORE  = self createText("default",2.5,"TOP","TOP",140,-20,3,1,"0");
    self.PONGSCORE2 = self createText("default",2.5,"TOP","TOP",-140,-20,3,1,"0");
    self.PONGBALL   = self createRectangle("CENTER","CENTER",0,0,15,30,(0,1,0),"compassping_enemyfiring",3,1);
    hud["title"]=self createText(getFont(),1.5,"TOP","TOP",0,0,3,1,"PONG");
    hud["topBar"]=self createRectangle("TOP","TOP",0,28,1000,2,(1,1,1),"white",2,1);
    hud["bottomBar"]=self createRectangle("BOTTOM","BOTTOM",0,-28,1000,2,(1,1,1),"white",2,1);
    hud["half"]=self createRectangle("CENTER","CENTER",0,0,2,336,(1,1,1),"white",2,1);
    hud["bar"]=self createRectangle("CENTER","CENTER",354,0,15,40,(0,0,1),"white",3,1);
    hud["bar2"]=self createRectangle("CENTER","CENTER",-354,0,15,40,(1,0,0),"white",3,1);
    self prepPong();
    self thread monitorPonging(hud["bar"]);
    player2 thread monitorPonging(hud["bar2"]);
    if(self getEntityNumber() < player2 getEntityNumber())
    {
        self thread monitorBallSpeed();
        self thread monitorPongBall(self.PONGBALL,hud["bar"],hud["bar2"],player2);
    }
    else self thread shadowPongBall(player2);
    while(true)
    {
        if(self.PSCORE == 5 || player2.PSCORE == 5 || isDefined(self.PONGFORFEIT) || isDefined(player2.PONGFORFEIT))break;
        wait .05;
    }
    hud["title"] setText("Pong - "+self getName()+" has ^2WON!");
    if(!isDefined(player2.PONGFORFEIT))hud["title"] setText("Pong - "+player2 getName()+" has ^2WON!");
    self.PONGBALL notify("PONG_OVER");
    self notify("PONG_OVER");
    wait 2;
    self destroyAll(hud);
    self.PONGBALL destroy();
    self.PONGSCORE destroy();
    self.PONGSCORE2 destroy();
    self.PONGFORFEIT = undefined;
    self.PSCORE      = undefined;
    self freezeControls(false);
}
prepPong()
{
    for(a=0;a<5;a++)hud[a]=self createRectangle("CENTER","CENTER",-70+a*35,0,35,70,(36/255,12/255,12/255),"ui_sliderbutt_1",0,1);
    for(a=0;a<5;a+=4)hud[a].color=(1,0,0);
    wait 1;
    for(a=0;a<5;a+=4)hud[a].color=(36/255,12/255,12/255);
    for(a=1;a<5;a+=2)hud[a].color=(1,1,0);
    wait 1;
    for(a=1;a<5;a+=2)hud[a].color=(36/255,12/255,12/255);
    hud[2].color=(0,1,0);
    wait 1;
    self destroyAll(hud);
}
shadowPongBall(other)
{
    self endon("PONG_OVER");
    while(true)
    {
        self.PONGBALL thread hudMoveXY(0.1,other.PONGBALL.x*-1,other.PONGBALL.y);
        wait .05;
    }
}
monitorPongBall(ball,stick,stick2,other)
{
    num=0;
    num2=0;
    ball.save = 0;
    self.pongBallX = 2;
    self.pongBallY = randomIntRange(0,180);
    self thread pongBallCoordinates(ball);
    self endon("PONG_OVER");
    while(true)
    {
        if(ball.y > 0) ball.bottom = undefined;
        else ball.bottom = true;
        if(ball.save < 0) ball.bottom = undefined;
        if(ball.save > 0) ball.bottom = true;
        if(ball.y <= -168)
        {
            ball notify("ponging");
            ball.y=-168;
            X=2;
            ball.save = -168;
            if(!isDefined(stick.PONG)) ball.x=ball.x-(self.pongSpeed-2)*2;
            else
            {
                ball.x=ball.x+(self.pongSpeed-2)*2;
                X=-2;
            }
            self.pongBallX = X;
            self.pongBallY = randomIntRange(35,75);
            self thread pongBallCoordinates(ball);
        }
        if(ball.y >= 167)
        {
            ball notify("ponging");
            ball.y=167;
            X=2;
            ball.save = 167;
            if(!isDefined(stick.PONG)) ball.x=ball.x-(self.pongSpeed-2)*2;
            else
            {
                ball.x=ball.x+(self.pongSpeed-2)*2;
                X=-2;
            }
            self.pongBallX = X;
            self.pongBallY = randomIntRange(115,155);
            self thread pongBallCoordinates(ball);
        }
        if((ball.x >=stick.x-15 && ball.x <=stick.x+15)&&(ball.y >=stick.y-33 && ball.y <=stick.y+33))
        {
            stick.PONG=true;
            ball notify("ponging");
            ball.x=stick.x-14.5;
            self.pongBallX = -2;
            self thread pongBallCoordinates(ball);
        }
        if((ball.x <=stick2.x+15 && ball.x >=stick2.x-15)&&(ball.y >=stick2.y-33 && ball.y <=stick2.y+33))
        {
            stick.PONG=undefined;
            ball notify("ponging");
            ball.x=stick2.x+14.5;
            self.pongBallX = 2;
            self thread pongBallCoordinates(ball);
        }
        if(ball.x <= -440)
        {
            num++;
            self.PSCORE = num;
            if(self.PSCORE == 5) other.PONGFORFEIT=true;
            self.PONGSCORE settext(num);
            other.PONGSCORE2 settext(num);
            stick.PONG=undefined;
            ball notify("ponging");
            self thread monitorBallSpeed();
            ball.y=0;
            ball.x=0;
            ball.save = 0;
            wait 1;
            self.pongBallX = 2;
            self.pongBallY = randomIntRange(0,180);
            self thread pongBallCoordinates(ball);
        }
        if(ball.x >= 440)
        {
            num2++;
            other.PSCORE = num2;
            if(other.PSCORE == 5) self.PONGFORFEIT=true;
            other.PONGSCORE settext(num2);
            self.PONGSCORE2 settext(num2);
            stick.PONG=true;
            ball notify("ponging");
            self thread monitorBallSpeed();
            ball.y=0;
            ball.x=0;
            ball.save = 0;
            wait 1;
            self.pongBallX = -2;
            self.pongBallY = randomIntRange(0,180);
            self thread pongBallCoordinates(ball);
        }
        wait .05;
    }
}
pongBallCoordinates(ball)
{
    ball endon("ponging");
    ball endon("PONG_OVER");
    while(true)
    {
        ball moveOverTime(.1);
        ball.x = ball.x+self.pongBallX*(self.pongSpeed);
        ball.y = ball.y+cos(self.pongBallY)*self.pongSpeed;
        wait .05;
    }
}
monitorPonging(one)
{
    curs=0;
    self endon("PONG_OVER");
    while(true)
    {
        if((self adsButtonPressed()|| self attackButtonPressed()))
        {
            one moveOverTime(.05);
            if(curs>=-18)
            {
                curs-=self adsButtonPressed();
                one.y=curs*8;
            }
            if(curs<=18)
            {
                curs+=self attackButtonPressed();
                one.y=curs*8;
            }
            if(one.y >=154)one.y=154;
            if(one.y <=-154)one.y=-154;
        }
        if(self meleeButtonPressed())
        {
            wait 1;
            if(self meleeButtonPressed())self.PONGFORFEIT=true;
        }
        wait .05;
    }
}
monitorBallSpeed()
{
    self.pongSpeed=7;
    self notify("PONG_SCORE");
    self endon("PONG_SCORE");
    self endon("PONG_OVER");
    while(true)
    {
        wait 12;
        if(self.PONGBALL < 430 || self.PONGBALL > -430) self.pongSpeed+=.5;
    }
}