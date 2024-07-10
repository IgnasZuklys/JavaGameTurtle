public class AnimatedSprite extends Sprite{
  PImage[] currentImages;
  PImage[] moveLeft;
  PImage[] moveRight;
  int direction;
  int index;
  int frame;
  public AnimatedSprite(PImage img, float scale){
    super(img, scale);
    index = 0;
    frame = 0;
    
  }  

  public void updateAnimation(){
    frame++;
    if(frame % 3 == 0){ //kas 3 frames animacija
        selectDirection();
        selectCurrentImages();
        advanceToNextImage();
    }
  }
  
  public void selectDirection(){
    if(change_x > 0){
      direction = RIGHT_FACING;
    }else if(change_x < 0){
      direction = LEFT_FACING;
    }
  }
  
  public void selectCurrentImages(){
    if(direction == RIGHT_FACING){
      currentImages = moveRight;
    }else if(direction == LEFT_FACING){
      currentImages = moveLeft;
    }
  }
  
  public void advanceToNextImage(){
    index++;
    if(index >= currentImages.length){
      index = 0;
    }
    image = currentImages[index];
  
  }
}
