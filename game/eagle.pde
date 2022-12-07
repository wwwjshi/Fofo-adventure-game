PImage[] eagleFlyImgs;
PImage[] eagleAttackImg;

class Eagle{
  PVector loc = new PVector(width/2,height/6);
  PVector velo = new PVector(4, 0);
  PVector dir = new PVector(-1, 1);
  PImage img = new PImage();
  boolean onAttack = false;
  PVector targetLoc = p.loc.copy();
  PVector attackVelo = new PVector(0,0);
  boolean attackEnd = false;
  int countDown = 5;
  
  Eagle(){}
  
  void display(){
    move();
    int f = frameCount /(frameRate/star_rate) % eagleFlyImgs.length;
    img = eagleFlyImgs[f];
    if(frameCount % 100 == 0){
      attack();
      onAttack = true;
      attackVelo = PVector.sub(targetLoc, loc).setMag(8);
      eagleEffect.play();
    }
    
    if(onAttack){
      PImage imgCopy = img.copy();
      //imgCopy.filter(INVERT);
      tint(255,0,0);
      img = imgCopy;
    }
    
    if(onAttack && targetLoc.x < this.loc.x + this.img.width/2 
         && targetLoc.x > this.loc.x - this.img.width/2
         && targetLoc.y > this.loc.y - this.img.height/2
         && targetLoc.y < this.loc.y + this.img.height/2){
      onAttack = false;
      img = eagleAttackImg[0];
    }   

    pushMatrix();
    imageMode(CENTER);
    scale(dir.x, 1);
    image(img, dir.x*loc.x, loc.y-img.height/2);
    popMatrix();
    noTint();
  }
  
  
  void move(){
    if(!onAttack){
      if(loc.x > width - 50){
        dir.x *= -1;
        loc.x = width - 50;
      }
      if(loc.x < width/6){
        dir.x *= -1;
        loc.x =  width/6;
      }
      loc.x -= dir.x * velo.x;
    }
    else {
      loc.add(attackVelo);
      if(attackVelo.x > 0){
        dir.x = -1;
      }
      else {
        dir.x = 1;
      }
    }  
  }
  
  
  void attack(){
    float distBoss = PVector.dist(loc, b.locBody);
    float distPlayer = PVector.dist(loc, p.loc);
    targetLoc = p.loc.copy();
    if(distBoss < distPlayer){
      targetLoc = b.locBody.copy();
    }
  }
    
}
