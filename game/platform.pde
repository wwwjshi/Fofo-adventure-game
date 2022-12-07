PImage platformImg;

class Platform{
  int x;
  int y;
  PImage img;
  int w;
  int h;
  float yOffset;
  
  Platform(int x, int y, PImage img){
    this.x = x;
    this.y = y;
    this.img = img;
    this.w = img.width;
    this.h = img.height;
    this.yOffset = h/2;
  }
  
  
  void display(){
    image(img, x, y-yOffset);
  }
  
}
