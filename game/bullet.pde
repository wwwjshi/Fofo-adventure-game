PImage[] bulletImgs;
PImage[] blastImgs;

class Bullet{
  PVector loc;
  float dir;
  int f;
  float speed  = 5;
  boolean toDelete = false;
  PImage img = new PImage();
  int countDown = 0;
  boolean blast;
  
  Bullet(float x, float y, float dir, int f){
    this.loc = new PVector(x, y);
    this.dir = dir;
    this.f = f;
  }
  
  void display(){
    pushMatrix();
    int i = (frameCount - f)/(frameRate/jump_rate) % bulletImgs.length;
    scale(dir, 1);
    img = bulletImgs[i];
    if(blast && countDown < 6){
      img = blastImgs[countDown];
      countDown++;
    } 
    image(img, dir*loc.x, loc.y-bulletImgs[i].height/2);
    if(countDown >= 6){
      outbls.add(this);
    }
    popMatrix();
  }
  
  void shot(){
    loc.x += speed*dir;
    checkBound();
  }
  
  void checkBound(){
    if(loc.x < 0 || loc.x > width){
      outbls.add(this);
    }
  }
  
}
