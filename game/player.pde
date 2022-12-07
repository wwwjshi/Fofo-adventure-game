PImage[] idleAnimation;
PImage[] runAnimation;
PImage[] jumpAnimation;
PImage[] hurtAnimation;
PImage[] attackAnimation;  

class Player {
  PVector loc;
  PVector velo;
  PVector dir;
  
  boolean left;
  boolean right;
  boolean up;
  boolean down;
  
  boolean attack;

  boolean onGround = true;
  boolean onJump;
  boolean onFall; // fall after jump
  int action; // idle, run, jump, attack, hurt
  int actionCountDown;
  
  int hp;

  PImage dispImg;
  
  int runSpeed = 6;
  float jumpSpeed = -2*platformImg.height;
  int fallSpeed = 5;
  
  boolean onPlatform;
  Platform standingPlf;
  
  float xOffset;
  float yOffset;
  
  
  Player(float x, float y){
    loc = new PVector(x, y);
    velo = new PVector(0, 0);
    dir = new PVector(-1, 1);
    hp = 5;
    action = 0;
    actionCountDown = 2;
    dispImg = new PImage();
    standingPlf = null;
  }
  
  
  Player(){
    loc = new PVector(width-100, height-groundImg.height);
    velo = new PVector(0, 0);
    dir = new PVector(-1, 1);
    hp = 5;
    action = 0;
    actionCountDown = 100;
    dispImg = new PImage();
    xOffset = 0;
  }
  
  void display(){
    for(int l = 1; l <= hp; l++){
      image(hurtAnimation[0], width-l*50, 100);
    }
    
    takeAction();

    if(action == 0){
      dispImg = getFrame(idleAnimation, player_rate);
    }
    else if (action == 1){
      dispImg = getFrame(runAnimation, player_rate);
    }
    else if (action == 2){
      dispImg = getFrame(jumpAnimation, jump_rate);
    }
    else if (action == 3){
      dispImg = getFrame(attackAnimation, jump_rate);
    }
    else if (action == 4){
      dispImg = getFrame(hurtAnimation, jump_rate);
    }
    
    xOffset = dispImg.width/4;
    yOffset = dispImg.height/2;
    pushMatrix();
    scale(dir.x, dir.y);
    image(dispImg, dir.x*loc.x, dir.y*(loc.y-dispImg.height/2));
    popMatrix();
  }
  
  
  PImage getFrame(PImage[] actionFrames, int actionRate){
    PImage dispFrame = new PImage();
    int i = frameCount /(frameRate/actionRate) % actionFrames.length;
    dispFrame = actionFrames[i];
    return dispFrame;
  }
  
  
  void takeAction(){
    action = 0;
    
    // horizontal movement
    if(left || right){
      action = 1;
      velo.x = runSpeed * dir.x;
      loc.x += velo.x;
      checkFallingPlfs();
    } else {
      velo.x = 0;
    }
    
    // verical movement
    if(up && (onGround || onPlatform)){
      action = 2;
      velo.y = jumpSpeed * dir.y;
      onPlatform = false;
      onGround = false;
      loc.y += velo.y;
    }
    else if(!onGround && !onPlatform){
      action = 2;
      velo.y = fallSpeed * dir.y;
      loc.y += velo.y;
      checkLandingPlfs();
    } 
    checkBound();
    
    // attack
    if(attack){
      action = 3;
      Bullet b = new Bullet(loc.x, loc.y, dir.x, frameCount);
      bls.add(b);
      attack = false;
      pattackEffect.play();
    }
    
    // hurt
    hurt();
  }
  
  
  void checkLandingPlfs(){
    for(Platform plf : plfs){
      if(loc.y + yOffset/2 > plf.y - plf.yOffset && loc.y + yOffset/2 < plf.y &&
          loc.x-xOffset <= plf.x+plf.w/2 && loc.x+xOffset >= plf.x-plf.w/2){
        onPlatform = true;
        standingPlf = plf;
        up=false;
        velo.y= 0; 
        loc.y = plf.y - dispImg.height/2 ;
      } 
    }
  }
  
  
  void checkFallingPlfs(){
    if(onPlatform){
      if(loc.x-xOffset > standingPlf.x+standingPlf.w/2 || loc.x+xOffset < standingPlf.x-standingPlf.w/2){
          onPlatform = false;
          onGround = false;
          standingPlf = null;
      }
    }
  }
    
    
  void checkBound(){
    if(loc.x <= 0){
      loc.x = 0;
    }
    if(loc.x >= width){
      loc.x = width;
    }
    if(loc.y >= height-groundImg.height){
      loc.y = height-groundImg.height;
      onGround = true;
    }
    if(loc.y <= 0){
      loc.y = 0;
    }
  }
  
  
  void hurt(){
    for(Skull s: sks){
      if(s.loc.x - s.img.width/6 < this.loc.x + this.dispImg.width/4
         && s.loc.x + s.img.width/4 > this.loc.x - this.dispImg.width/6
         && s.loc.y + s.img.height/6 > this.loc.y - this.dispImg.height/6
         && s.loc.y - s.img.height/4 < this.loc.y + this.dispImg.height/4
         && s.curse == false){
          this.hp --;
          s.curse = true;
          action = 4;
          phurtEffect.play();
      }
    }
    
    // imediate death is collide boss
    if(loc.x - dispImg.width/4 < b.locBody.x + b.img.width/4
         && loc.x + dispImg.width/4 > b.locBody.x - b.img.width/4
         && loc.y + dispImg.height/4 > b.locBody.y - b.img.height/4
         && loc.y - dispImg.height/4 < b.locBody.y + b.img.height/4){
        this.hp = 0;
        action = 4;
        phurtEffect.play();
    }
    
    if(e.onAttack && e.loc.x - e.img.width/2 < this.loc.x + this.dispImg.width/4
         && e.loc.x + e.img.width/2 > this.loc.x - this.dispImg.width/6
         && e.loc.y + e.img.height/2 > this.loc.y - this.dispImg.height/6
         && e.loc.y - e.img.height/2 < this.loc.y + this.dispImg.height/4){
        this.hp --;
        action = 4;
        phurtEffect.play();
        e.onAttack = false;
        e.dir.x *= -1;
        Smoke s = new Smoke(loc.x, loc.y, frameCount);
        sms.add(s);
    }
  }
  
}
