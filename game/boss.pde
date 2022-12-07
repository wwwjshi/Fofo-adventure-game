PImage[] bossBodyImgs;
PImage[] bossPartImg;

class Boss{
  PVector locBody = new PVector(0,0);
  PImage img = new PImage();
  int hp = 30;
  
  Boss(){}
  
  void display(){

    bg_frame = frameCount/(frameRate/player_rate)% all_coords.length;
    int r = frameCount % player_rate + 1;
    int f = frameCount /(frameRate/star_rate) % bossBodyImgs.length;
    int p = frameCount /(frameRate/star_rate) % bossPartImg.length;
    
    //if(frameCount % 30 == 0){
    //  attack();
    //  battackEffect.play();
    //}
    
    PVector[] coords = all_coords[bg_frame];
    
    pushMatrix();
    textFont(pixelFont);
    fill(0);
    String hpstr = "Boss HP: "+ hp;
    text(hpstr, 100, 100);
    imageMode(CENTER);
    if(bg_frame > 0){
      hurt();
      PVector[] prevCoords = all_coords[bg_frame-1];
      PVector[] drawCoords = new PVector[prevCoords.length];
      for(int i=prevCoords.length-1; i>-1; i--){
        PVector dispVect = PVector.sub(coords[i], prevCoords[i]).mult(1/r);
        drawCoords[i] = PVector.sub(coords[i], dispVect);
      }
      locBody = drawCoords[0];
      img = bossBodyImgs[f];
      
      
      for(int i = 1; i < drawCoords.length; i++){
        stroke(135,30,120,300);
        strokeWeight(40);
        line(locBody.x, locBody.y-20, drawCoords[i].x, drawCoords[i].y);
      }
      
      image(bossPartImg[(p-1+2)%bossPartImg.length], drawCoords[2].x, drawCoords[2].y);
      image(bossPartImg[(p-1+4)%bossPartImg.length], drawCoords[4].x, drawCoords[4].y);
      image(img, locBody.x, locBody.y-20);
      image(bossPartImg[(p-1+1)%bossPartImg.length], drawCoords[1].x, drawCoords[1].y);
      image(bossPartImg[(p-1+3)%bossPartImg.length], drawCoords[3].x, drawCoords[3].y);
      
      if(frameCount % 30 == 0){
        int i = int(random(1,5));
        attack(i, drawCoords[i]);
        battackEffect.play();
      }
    
    popMatrix();
    }
  }
  
  
  void hurt(){
    for(Bullet b: bls){
      // if bullet collide with boss
      if(b.loc.x - b.img.width/2 < this.locBody.x + this.img.width/2 
         && b.loc.x + b.img.width/2 > this.locBody.x - this.img.width/2
         && b.loc.y + b.img.height/2 > this.locBody.y - this.img.height/2
         && b.loc.y - b.img.height/2 < this.locBody.y + this.img.height/2
         && b.blast == false){
          this.hp --;
          b.blast = true;
          bhurtEffect.play();
      }
    }
      
    if(e.onAttack && e.loc.x - e.img.width/2 < this.locBody.x + this.img.width/3
         && e.loc.x + e.img.width/2 > this.locBody.x - this.img.width/3
         && e.loc.y + e.img.height/2 > this.locBody.y - this.img.height/2
         && e.loc.y - e.img.height/2 < this.locBody.y + this.img.height/2){
        this.hp --;
        bhurtEffect.play();
        e.onAttack = false;
        e.dir.x *= -1;
        Smoke s = new Smoke(locBody.x, locBody.y, frameCount);
        sms.add(s);
    }
  }
  
  
  void attack(int i, PVector startLoc){
    Skull s = new Skull(i, startLoc);
    sks.add(s);
  }
    
}
