/*
IGNAS ŽUKLYS
5 grupe
2 pogrupis
1 semestras

*/


static float MOVE_SPEED = 5;
static float SPRITE_SCALE = 50.0/18; //naudojam, kad padidinti musu sprites
static float SPRITE_SIZE = 50;
static float GRAVITY = 0.6;
static float RIGHT_MARGIN = 400;
static float LEFT_MARGIN = 400;
static float VERTICAL_MARGIN = 400;
static float HEIGHT = SPRITE_SIZE * 12;
static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

PImage tilemap, player, backgroundImage;

int tileWidth = 19;
int tileHeight = 19;
int currentLevel = 1;

Player p;
Menu menu;
ArrayList<Sprite> deco;//neturi collision
ArrayList<Sprite> platforms; //turi collision
ArrayList<Sprite> win; //turi collision, bet palietus laimima, o nesustabdoma
int[][] map;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

float view_x;
float view_y;
boolean isGameOver = false;
int currentHealth = 3;
void setup() {
  size(800, 600);
  imageMode(CENTER);
  player = loadImage("right_1.png");
  backgroundImage = loadImage("bg.jpg"); // Load background image
  p = new Player(player, 1);
  p.lives = currentHealth;
  
  if(currentLevel > 5 || currentLevel == 1 ){
    menu = new Menu();
  }
  p.setBottom(GROUND_LEVEL);
  
  p.change_x = 0;
  p.change_y = 0;
  p.center_x = 100;
  p.setBottom(GROUND_LEVEL);

  platforms = new ArrayList<Sprite>();
  win = new ArrayList<Sprite>();
  deco = new ArrayList<Sprite>();
  tilemap = loadImage("tilemap.png");

  if(currentLevel < 1){
    createPlatforms("map.csv");
  } else {
    createPlatforms("map"+currentLevel+".csv");
  }
}

//mini_uzd istrinti elipse
//boolean ellip = true;
//int el_x = 200, el_y = 200, el_w = 50, el_h=30;


void draw() {
  menu.draw();
  if(p.lives == 5){
    currentLevel=0;
    setup();
  }
  if(!menu.inMenu){
    if(!isGameOver){
      //scroll for bg
      float bg_x = -view_x * 0.2 +10;
      float bg_y = -view_y * 0.2;
      
      //bg image paisoma
      image(backgroundImage, width/2 + bg_x, height/2 + bg_y, width*2, height);
      
      scroll();
      //if(ellip){
      
        //ellipse(el_x, el_y, el_w, el_h);
      //}
      
      p.display();
      checkDeath();
      text("Lives:" + p.lives, view_x + 50, view_y + 100);
      if(currentLevel > 0){
            text("Level:" + currentLevel, view_x + 50, view_y + 50); //jei normlaus lygiai
      }else{
          text("Edit level", view_x + 70, view_y + 50); //jei edit lygis

      }
      
      p.updateAnimation();
      resolvePlatformCollisions(p, platforms);
      for (Sprite s : platforms){
        s.display();
      }
      
      for (Sprite s : deco){
        s.display();
      }
      
      for(Sprite s : win){
        s.display();
      }
    } else if(isGameOver){
      menu.inMenu = true;
      isGameOver = false;
      p.lives = 3  ;
    }
  }
}


void mousePressed() {
  menu.mousePressed();
}

void scroll() {

  float screenCenterX = view_x + width / 2;
  float charOffsetX = p.center_x - screenCenterX;
  float scrollThresholdX = width * 0.1;
  if (abs(charOffsetX) > scrollThresholdX) {
    if (charOffsetX > 0) {
      view_x += charOffsetX - scrollThresholdX;
    } else {
      view_x += charOffsetX + scrollThresholdX;
    }
  }

  translate(-view_x, -view_y);
}


void createPlatforms(String filename) {
  String[] lines = loadStrings(filename);
  map = new int[lines.length][];
  for (int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    map[row] = new int[values.length];
    for (int col = 0; col < values.length; col++) {
      int tileIndex = Integer.parseInt(values[col]);
      map[row][col] = tileIndex; // Store map values in the array
      if (tileIndex != 0) { // If not empty tile and less than 10
        PImage blockImage = getTile(tileIndex);
        Sprite s = new Sprite(blockImage, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE;
        if(tileIndex < 7 || (tileIndex >= 19 && tileIndex <= 25)
        || (tileIndex >= 37 && tileIndex <= 40)
        || (tileIndex >= 55 && tileIndex <= 58)
        || (tileIndex >= 95 && tileIndex <= 101)
        || (tileIndex >= 113 && tileIndex <= 119)){
           platforms.add(s); //jei vaikstomi blokai
        } else if(tileIndex == 10 || tileIndex == 73 || tileIndex == 74){
          win.add(s);
        } else {
          deco.add(s); //jei dekoracija
        }
      }
    }
  }
}

PImage getTile(int tileIndex) {
  int col = (tileIndex - 1) % 18;
  int row = (tileIndex - 1) / 18;
  PImage tile = tilemap.get(col * tileWidth, row * tileHeight, tileWidth, tileHeight);
  return tile;
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  s.change_y += GRAVITY; // Apply gravity
  
  s.center_y += s.change_y; // Move in y-direction
  
  ArrayList<Sprite> col_list = checkCollisionList(s, walls); // Check collision in y-direction
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    } else if(s.change_y < 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0; // Stop vertical movement
  }

  s.center_x += s.change_x; // Move in x-direction
  
  col_list = checkCollisionList(s, walls); // Check collision in x-direction
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_x > 0){
        s.setRight(collided.getLeft());
    } else if(s.change_x < 0){
        s.setLeft(collided.getRight());
    }
  }  
  
  ArrayList<Sprite> winCollisions = checkCollisionList(s, win);
  if (!winCollisions.isEmpty()) {
    //player steps on win block yippe
    nextLevel(); //next level
  }
}

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  //if(p.center_x < el_x+el_w && p.center_x > el_x-el_w && p.center_y < el_y+el_h){
  //ellip = false;
  //}
  return !(noXOverlap || noYOverlap);
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

void checkDeath(){
  boolean fallOffCliff = p.getBottom() > 550;
  if(fallOffCliff){
    p.lives--;
    currentHealth--;

  if(p.lives == 0){
    isGameOver = true;
  } else {
    p.center_x = 100;
    p.setBottom(GROUND_LEVEL);
  }
  }
}

void nextLevel() {
  
  if(currentLevel < 5){
    currentLevel++;
  } else {
    currentLevel = 1;
  }
    setup();
}

void keyPressed() {
  if (!menu.inMenu) {
    if (keyCode == RIGHT) {
      p.change_x = MOVE_SPEED;
    } else if (keyCode == LEFT) {
      p.change_x = -MOVE_SPEED;
    } else if (keyCode == UP) {
      p.change_y = -3*MOVE_SPEED;
    } else if (keyCode == DOWN) {
      p.change_y = MOVE_SPEED;
    }
  }
}

void keyReleased() {
  if (!menu.inMenu) {
    if (keyCode == RIGHT || keyCode == LEFT) {
      p.change_x = 0;
    } else if (keyCode == UP || keyCode == DOWN) {
      p.change_y = 0;
    }
  }
}

boolean isOnPlatform(Sprite s) {
  int col = (int) (s.center_x / SPRITE_SIZE);
  int row = (int) (s.center_y / SPRITE_SIZE);
  if (row >= 0 && row < map.length && col >= 0 && col < map[0].length) {
    return map[row][col] < 10;
  }
  return false;
}
