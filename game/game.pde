import processing.sound.*;

// Sounds
SoundFile bgm;
SoundFile enterEffect;
SoundFile shotEffect;
SoundFile phurtEffect;
SoundFile bhurtEffect;
SoundFile pattackEffect;
SoundFile battackEffect;
SoundFile winEffect;
SoundFile loseEffect;
SoundFile eagleEffect;

// Coordinates of monkey
Table t;
PVector[][] all_coords;
int height_offset;
int width_offset;

// frame counters
int bg_frame;
int frameRate;
int animate_frame;
int player_rate;
int star_rate;
int jump_rate;

// game status (0 start, 1 instruction 2 playing, 3 win, 4 lost)
int gameStatus;

// background image
float hRatio;
float wRatio;
PImage bgImg;
PImage bgBush;
PImage groundImg;
PImage bgDarkImg;

// fonts
PFont pixelFont;
PFont titleFont;

// init screen text/images
String title = "F o f o\nA D V E N TU R E";
PImage[] playerRunImgs;
PImage[] starImgs;

// game objects
ArrayList<Platform> plfs = new ArrayList<Platform>();
ArrayList<Bullet> bls = new ArrayList<Bullet>();
ArrayList<Bullet> outbls = new ArrayList<Bullet>();
ArrayList<Skull> sks = new ArrayList<Skull>();
ArrayList<Skull> outsks = new ArrayList<Skull>();
ArrayList<Smoke> sms = new ArrayList<Smoke>();
ArrayList<Smoke> outsms = new ArrayList<Smoke>();
Player p;
Boss b;
Eagle e;



void setup(){
  // display settings
  size(900, 600);
  frameRate = 30;
  frameRate(frameRate);  
  player_rate = 10;
  jump_rate = 5;
  
  // sound
  bgm = new SoundFile(this, "sounds/the_valley.wav");
  bgm.loop();
  phurtEffect = new SoundFile(this, "sounds/hurt.wav");
  bhurtEffect = new SoundFile(this, "sounds/bosshurt.wav");
  enterEffect = new SoundFile(this, "sounds/start.wav");
  pattackEffect = new SoundFile(this, "sounds/attack.wav");
  pattackEffect.amp(0.5);
  battackEffect = new SoundFile(this, "sounds/bossattack.wav");
  battackEffect.amp(0.5);
  winEffect = new SoundFile(this, "sounds/win.wav");
  loseEffect = new SoundFile(this, "sounds/lose.wav");
  eagleEffect = new SoundFile(this, "sounds/eagle.wav");
  
  // fonts
  titleFont = createFont("font/ArcadeClassic.ttf", 60);
  pixelFont = createFont("font/PressStart2P-Regular.ttf", 14);
  
  // getting coords
  // read csv file that contains the coodinate of monkey in each frame (952 frames * 5 body parts in each frame)
  t = loadTable("coords.csv");
  int num_rows = t.getRowCount();
  int num_cols = t.getColumnCount();
  all_coords = new PVector[num_rows][num_cols/2];
  height_offset = height/3;
  width_offset = 0; //width/8;
  
  int i = 0;
  for (TableRow row : t.rows()) {
    for(int j=0; j< num_cols/2; j++){
      all_coords[i][j] = new PVector(row.getInt(2*j+1)/1.5+width_offset, row.getInt(2*j)/1.5+height_offset);
    }
    i++;
  }
  
  
  // load game images
  bgImg = loadImage("background/bg.png");
  float wd = width;
  float wi = bgImg.width;
  float hd = height;
  float hi = bgImg.height;
  wRatio = wd/wi;
  hRatio = hd/hi;
  bgImg.resize(width, height);
  
  bgBush = loadImage("background/bush.png");
  bgBush.resize(int(bgBush.width*wRatio), int(bgBush.height*hRatio));
  
  groundImg = loadImage("background/ground.png");
  groundImg.resize(width,0);
  
  bgDarkImg = loadImage("background/Back.png");
  bgDarkImg.resize(width,0);
  
  platformImg = loadImage("props/platform-long.png");
  platformImg.resize(int(platformImg.width*wRatio), int(platformImg.height*hRatio));

  playerRunImgs = new PImage[6];
  loadAllImgs(playerRunImgs, 6, "player/run/player-run-");
  
  starImgs = new PImage[5];
  loadAllImgs(starImgs, 5, "star/star-");
  star_rate = 6;
  
  bossBodyImgs = new PImage[4];
  loadAllImgs(bossBodyImgs, 4, "boss/Witch/");
  for(PImage img : bossBodyImgs){
    img.resize(120,120);
  }
  bossPartImg = new PImage[10];
  loadAllImgs(bossPartImg, 10, "boss/part/");
  
  blastImgs = new PImage[6];
  loadAllImgs(blastImgs, 6, "enemy-death/enemy-death-");
  
  smokeImgs = new PImage[5];
  loadAllImgs(smokeImgs, 5, "smoke/FX001_0");

  idleAnimation = new PImage[4];
  loadAllImgs(idleAnimation, 4, "player/idle/player-idle-");
  runAnimation = new PImage[6];
  loadAllImgs(runAnimation, 6, "player/run/player-run-");
  jumpAnimation = new PImage[2];
  loadAllImgs(jumpAnimation, 2, "player/jump/player-jump-");
  hurtAnimation = new PImage[2];
  loadAllImgs(hurtAnimation, 2, "player/hurt/player-hurt-");
  attackAnimation = new PImage[2];
  loadAllImgs(attackAnimation, 2, "player/crouch/player-crouch-");
  
  bulletImgs = new PImage[3];
  loadAllImgs(bulletImgs, 3, "player/bullet/");
  for(PImage img : bulletImgs){
    img.resize(50,50);
  }
  
  skullImgs = new PImage[10];
  loadAllImgs(skullImgs, 10, "boss/skull/1/");
  curseImgs = new PImage[6];
  loadAllImgs(curseImgs, 6, "boss/skull/2/");
  
  eagleFlyImgs = new PImage[4];
  loadAllImgs(eagleFlyImgs, 4, "eagle/fly/");
  eagleAttackImg = new PImage[2];
  loadAllImgs(eagleAttackImg, 2, "eagle/attack/attack");
  
  // create set of platforms
  Platform plf = new Platform(width-200, height-groundImg.height-20, platformImg);
  plfs.add(plf);
  plf = new Platform(width-3*100, height-groundImg.height-40, platformImg);
  plfs.add(plf);
  plf = new Platform(width-400, height-groundImg.height-70, platformImg);
  plfs.add(plf);
  plf = new Platform(width-500, height-groundImg.height-100, platformImg);
  plfs.add(plf);
  plf = new Platform(width-550, height-groundImg.height-150, platformImg);
  plfs.add(plf);
  plf = new Platform(width-100-5*platformImg.width, height-groundImg.height-200, platformImg);
  plfs.add(plf);
  plf = new Platform(width-100-4*platformImg.width, height-groundImg.height-200, platformImg);
  plfs.add(plf);


  // game status initialisation
  gameStatus = 0;
  
  // game characters
  p = new Player();
  b = new Boss();
  e = new Eagle();
}


void draw(){
  movingBackground();
  
  // display screen content base on game status
  if(gameStatus == 0){
    initScreen();
  }
  else if(gameStatus == 1){
    instruScreen();
  }
  else if(gameStatus == 3){
    winScreen();
  }
  else if(gameStatus == 4){
    loseScreen();
  }
  else if(gameStatus == 2){
    displayBush();
    
    if(p.hp < 1){
     loseEffect.play();
     gameStatus = 4;
     gameReset();
     bgm.jump(0);
     delay(500);
   }
   
   if(b.hp < 1){
     winEffect.play();
     gameStatus = 3;
     gameReset();
     bgm.jump(0);
     delay(500);
   }
   
    b.display();
    for(Platform plf: plfs){
      plf.display();
    }
 
    p.display();
    
    for(Bullet b: bls){
      b.shot();
      b.display();
    }
    for(Bullet b: outbls){
      bls.remove(b);
    }
    outbls.clear();
    
    for(Skull s: sks){
      s.display();
    }
    for(Skull s: outsks){
      sks.remove(s);
    }
    outsks.clear();
    
    for(Smoke s: sms){
      s.display();
    }
    for(Smoke s: outsms){
      sms.remove(s);
    }
    outsms.clear();
    
    e.display();
   
  }

}


// reset game contents
void gameReset(){
  bls.clear();
  outbls.clear();
  sks.clear();
  outsks.clear();
  sms.clear();
  outsms.clear();
  b = new Boss();
  p = new Player();
  e = new Eagle();
}


void displayBush(){
  pushMatrix();
  translate(0,0);
  for(int i=0; i<width; i+=bgBush.width){
    image(bgBush,i, height*2/5);
  }
  image(groundImg, 0, height-groundImg.height);
  popMatrix();
}


void movingBackground(){
  // mimic moving background
  pushMatrix();
  imageMode(CORNER);
  PImage img = bgImg;
  int bg_offset = frameCount * 3 % width;
  if(b.hp < 15 || gameStatus == 4){
    img = bgDarkImg;
  }
  image(img, (-bg_offset), 0);
  image(img, (width-bg_offset), 0);
  popMatrix();
}


void initScreen(){
  displayStar();
  pushMatrix();
  translate(width/2, height/3);
  textAlign(CENTER);
  textFont(titleFont);
  fill(0);
  // mimic stroke & shade effect, by displace the text
  for(int x = -3; x < 9; x++){
    text(title, x, 0);
    text(title, 0, x);
  }
  fill(255, 120, 2);
  text(title, 0, 0);
  
  imageMode(CENTER);
  for(int i=-2; i<3; i++){
    image(platformImg, i*platformImg.width, height/2-30);
  }
  displayInitChar(0, height/2-90, playerRunImgs);
  
  fill(0);
  textFont(pixelFont);
  textSize(15);
  text("PRESS ENTER TO START", 0, height/2+10);
  popMatrix();
}


void loadAllImgs(PImage[] imgArr, int numFrame, String path){
  for(int i=1; i<numFrame+1; i++){
    String name = path + i + ".png"; 
    PImage img = loadImage(name);
    img.resize(int(img.width*wRatio), int(img.height*hRatio));
    imgArr[i-1] = img;
  }
}


void displayInitChar(float x, float y, PImage[] imgs){
  int frameI = frameCount/(frameRate/player_rate) % imgs.length;
  image(imgs[frameI], x, y);
}


void displayStar(){
  bg_frame = frameCount/(frameRate/player_rate)% all_coords.length;
  
  int r = frameCount % player_rate + 1;
  int f = frameCount /(frameRate/star_rate) % starImgs.length;
  
  PVector[] coords = all_coords[bg_frame];
  
  pushMatrix();
  imageMode(CENTER);
  if(bg_frame > 0){
    PVector[] prevCoords = all_coords[bg_frame-1];
    for(int i=0; i<prevCoords.length; i++){
        PVector dispVect = PVector.sub(coords[i], prevCoords[i]).mult(1/r);
        PVector drawCoord = PVector.sub(coords[i], dispVect);
        image(starImgs[(f+i)%starImgs.length], (drawCoord.x-width_offset)*2, (drawCoord.y-height_offset)*2);
    }
  }
  popMatrix();
}


void instruScreen(){
  pushMatrix();
  translate(width/2, height/3);
  
  fill(100);
  stroke(0);
  strokeWeight(10);
  rect(-width/4,-height/4,width/2,height/2);
  textFont(pixelFont);
  fill(0);
  textAlign(CENTER);
  text("INSTRUCTION", 0, -height/4+40);
  textAlign(LEFT);
  text("←, →: run", -width/4+40, -height/4+80);
  text("SPACE: Jump", -width/4+40, -height/4+110);
  text("x: Shot fireball", -width/4+40, -height/4+140);
  
  textAlign(CENTER);
  text("GOAL", 0, -height/4+200);
  text("Defeat the Evil Witcher!\nBe careful of the Angry Eagle!", 0, -height/4+240);
  
  imageMode(CENTER);
  for(int i=-2; i<3; i++){
    image(platformImg, i*platformImg.width, height/2-30);
  }
  displayInitChar(0, height/2-90, playerRunImgs);
  
  fill(0);
  textSize(15);
  textAlign(CENTER);
  text("PRESS ENTER TO CONTINUE", 0, height/2+10);
  popMatrix();
}


void loseScreen(){
  pushMatrix();
  translate(width/2, height/2);
  textAlign(CENTER);
  textFont(titleFont);
  fill(0);
  // mimic stroke & shade effect, by displace the text
  for(int x = -3; x < 9; x++){
    text("GAME  OVER", x, 0);
    text("GAME  OVER", 0, x);
  }
  fill(255, 120, 2);
  text("GAME  OVER", 0, 0);
  
  fill(0);
  textFont(pixelFont);
  textSize(15);
  text("PRESS ENTER TO RETRY", 0, height/3+10);
  popMatrix();
}


void winScreen(){
  pushMatrix();
  translate(width/2, height/2);
  textAlign(CENTER);
  textFont(titleFont);
  fill(0);
  // mimic stroke & shade effect, by displace the text
  for(int x = -3; x < 9; x++){
    text("YOU  WIN", x, 0);
    text("YOU  WIN", 0, x);
  }
  fill(255, 120, 2);
  text("YOU  WIN", 0, 0);
  
  fill(0);
  textFont(pixelFont);
  textSize(15);
  text("PRESS ENTER TO RETRY", 0, height/3+10);
  popMatrix();
}


void keyPressed(){
  if(key == ENTER ){
    if(gameStatus  == 0){
      gameStatus += 1; // 
      frameCount = 0; // restart frameCount
      enterEffect.play();
      return;
    }
    else if(gameStatus  == 1){
      gameStatus += 1; 
      frameCount = 0; 
      bgm.jump(72.5);
      enterEffect.play();
      return;
    } else if (gameStatus > 2){
      gameStatus = 0;
      frameCount = 0;
      enterEffect.play();
      return;
    }
  }
  
  if(gameStatus == 2){
    if(keyCode == LEFT){
      p.left = true;
      p.dir.x = -1;
    } 
    if(keyCode == RIGHT) {
      p.right = true;
      p.dir.x = 1;
    }
    if(key == ' '){
      p.up = true;
    }
    if(key == 'x'){
      p.attack = true;
    }
  }
}


void keyReleased(){
  if(gameStatus == 2){
    if(keyCode == LEFT){
      p.left = false;
      p.velo.x = 0;
    } 
    if(keyCode == RIGHT) {
      p.right = false;
      p.velo.x = 0;
    }
    if(key == ' '){
      p.up = false;
      p.velo.y = 0;
    }
    if(key == 'x'){
      p.attack = false;
    }
  }
}
