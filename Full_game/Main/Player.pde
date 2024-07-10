public class Player extends AnimatedSprite{
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;
  public Player(PImage img, float scale){
    super(img, scale);
    lives = 3;
    direction = RIGHT_FACING;
    onPlatform = true;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("left_1.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("right_1.png");
    
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("left_2.png");
    moveLeft[1] = loadImage("left_3.png");
    
    moveRight = new PImage[2];
    moveRight[0] = loadImage("right_2.png");
    moveRight[1] = loadImage("right_3.png");
    currentImages = standRight;
  }
  @Override
  public void updateAnimation(){
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
  
  }
  
  @Override
  public void selectDirection(){
      if(change_x > 0){
      direction = RIGHT_FACING;
    }else if(change_x < 0){
      direction = LEFT_FACING;
    }
  }
  
  @Override
  public void selectCurrentImages(){
    if(direction == RIGHT_FACING){
      if(inPlace){
        currentImages = standRight;
      }else{
        currentImages = moveRight;
      }
      }
    
    
    if(direction == LEFT_FACING){
        if(inPlace){
          currentImages = standLeft;
        }else{
          currentImages = moveLeft;
        }
      }
    
  }


}
