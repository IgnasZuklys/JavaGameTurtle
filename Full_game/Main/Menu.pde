public class Menu {
    boolean inMenu = true; //kad pradzia butu in menu
    boolean edit = false;

    void draw() {
        if (inMenu) {
            drawMenu();
        } else if (edit) {
            createPlatforms("map.csv");
        }
    }

    void drawMenu() {
        background(255);
        fill(0);
        textSize(32);
        textAlign(CENTER, CENTER);
        text("The turtle game", width / 2, height / 4);

        // Start Game mygtukas
        fill(200);
        rect(width / 2 - 100, height / 2 - 50, 200, 50);
        fill(0);
        text("Start Game", width / 2, (height / 2) - 27);

        // Edit lygio mygtukas
        fill(200);
        rect(width / 2 - 100, height / 2 + 20, 200, 50);
        fill(0);
        text("Edit", width / 2, height / 2 + 44);

        // Exit mygtukas
        fill(200);
        rect(width / 2 - 100, height / 2 + 90, 200, 50);
        fill(0);
        text("Exit", width / 2, height / 2 + 113);
    }


    void mousePressed() {
        if (inMenu) {
            if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
                    mouseY > height / 2 - 50 && mouseY < height / 2) {
                inMenu = false;
            }
            //ar pele ant edit
            else if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
                    mouseY > height / 2 + 20 && mouseY < height / 2 + 70) {
                inMenu = false;
                edit = false;
                p.lives = 5;
            }
            //ar pele ant exit
            else if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
                    mouseY > height / 2 + 90 && mouseY < height / 2 + 140) {
                exit();
            }
        }
    }
}
