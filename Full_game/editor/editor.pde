PImage tilemap;
int tileSize = 20;
int rows = 12;
int cols = 34;
int[][] grid;
int selectedBlockIndex = -1;
int tilemapWidth = 320;
int tilemapHeight = 140;
int buttonWidth = 80;
int buttonHeight = 30;
int buttonX = 330;
int buttonY = 250;

void settings() {
  size(cols * tileSize + 50, (rows * tileSize) + tilemapHeight);
}

void setup() {
  tilemap = loadImage("tilemap.png");
  grid = new int[rows][cols];
  loadGridFromFile("data/map.csv"); //parodyti kaip dabar atrodo
}

void draw() {
  background(255);
  
  // Draw tilemap
  image(tilemap, 0, height - tilemapHeight, tilemapWidth, tilemapHeight);
  
  // Draw grid
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int blockIndex = grid[i][j];
      String indexText = String.valueOf(blockIndex);
      textSize(12);
      fill(0);
      textAlign(CENTER, CENTER);
      text(indexText, j * tileSize + tileSize / 2, i * tileSize + tileSize / 2);
    }
  }
  
  //saev mygtukas
  fill(200);
  rect(buttonX, buttonY, buttonWidth, buttonHeight);
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Save", buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
  
  fill(200);
  rect(buttonX, buttonY + buttonHeight + 10, buttonWidth, buttonHeight); // Adjusted position
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Erase", buttonX + buttonWidth / 2, buttonY + buttonHeight + 10 + buttonHeight / 2); // Adjusted position
}


void mousePressed() {
  if (mouseY >= height - tilemapHeight && mouseX < 320) {
    // paspausta ant vieno is bloko
    int tileX = mouseX / tileSize;
    int tileY = (mouseY - (height - tilemapHeight)) / tileSize;
    if (tileX >= 0 && tileX < 18 && tileY >= 0 && tileY < 7) {
      // pasirinkti bloką
      selectedBlockIndex = tileX + tileY * 18+1; // +1 to start index from 1
    }
  } else if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth && mouseY >= buttonY && mouseY <= buttonY + buttonHeight) {
    //saugoma
    saveGrid();
  } else if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth && mouseY >= buttonY + buttonHeight + 10 && mouseY <= buttonY + 2 * buttonHeight + 10) {
    //padaryti, kad butu trintukas
    selectedBlockIndex = 0; //0 - nera bloko, padaro kad butu 0
  } else {
    //jei paspaudzia ant grid
    int i = mouseY / tileSize;
    int j = mouseX / tileSize;
    if (i >= 0 && i < rows && j >= 0 && j < cols) {
      if (selectedBlockIndex != -1) {
        grid[i][j] = selectedBlockIndex;
      } else {
        grid[i][j] = 0;
      }
    }
  }
}

void saveGrid() {
  String[] lines = new String[rows];
  for (int i = 0; i < rows; i++) {
    String line = "";
    for (int j = 0; j < cols; j++) {
      line += grid[i][j];
      if (j < cols - 1) {
        line += ",";
      }
    }
    lines[i] = line;
  }
  saveStrings("../game/Main/data/map.csv", lines); //kad iskart i game file
  println("Taip atrodo map.csv:"); //parodo ar tikrai toks pats
  for (String line : lines) {
    println(line);
  }
}

void loadGridFromFile(String filename) {
  String[] lines = loadStrings(filename);
  for (int i = 0; i < rows; i++) {
    String[] values = split(lines[i], ",");
    for (int j = 0; j < cols; j++) {
      grid[i][j] = int(values[j]);
    }
  }
}
