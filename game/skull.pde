PImage[] skullImgs;
PImage[] curseImgs;

class Skull{
  PVector loc;
  PVector dir;
  int f;
  PVector speed;
  boolean toDelete = false;
  PImage img = new PImage();
  int countDown = 0;
  boolean curse;
  PVector targetLoc;
  int i;
  
  Skull(int i, PVector startLoc){
    this.i = i;
    this.loc = startLoc.copy();
    this.dir = new PVector(1, 1);
    this.targetLoc = p.loc.copy();
    this.speed = PVector.sub(targetLoc, loc).setMag(i*2);
    if(b.hp < 15){
      this.speed = PVector.sub(targetLoc, loc).setMag(i*4);
    }
    
  }
  
  void display(){
    shot();
    pushMatrix();
    int i = (frameCount - f)/(frameRate/jump_rate) % skullImgs.length;
    scale(dir.x, 1);
    img = skullImgs[i];
    if(curse && countDown < 6){
      img = curseImgs[countDown];
      countDown++;
      
    } 
    image(img, loc.x, loc.y-img.height/2);
    if(countDown >= 6){
      outsks.add(this);
    }
    popMatrix();
  }
  
  void shot(){
    loc.add(speed);
    checkBound();
  }
  
  void checkBound(){
    if(loc.x < 0 || loc.x > width){
      outsks.add(this);
    }
    if(loc.y < 0 || loc.y > height){
      outsks.add(this);
    }
  }
  
}
