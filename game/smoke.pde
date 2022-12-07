PImage[] smokeImgs;

class Smoke{
  PVector loc;
  int f;
  
  Smoke(float x, float y, int f){
    this.loc = new PVector(x, y);
    this.f = f;
  }
  
  void display(){
    pushMatrix();
    int i = (frameCount - f)/(frameRate/star_rate) % smokeImgs.length;
    image(smokeImgs[i], loc.x, loc.y-smokeImgs[i].height/2);
    if(i >= 4){
      outsms.add(this);
    }
    popMatrix();
  }
}
