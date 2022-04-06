final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24;
PImage groundhogDown, groundhogIdle, groundhogLeft, groundhogRight;//土撥鼠前下左右

//土撥鼠XY
int ghX, ghY;

//土撥鼠移動速度
float ghSpeed = 80.0;
//計時
int time;
//出現吧 土撥鼠
int ghgood =1;
final int down = 2;
final int right = 3;
final int left = 4; 
final int idle = 5;
// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

//土壤的種類
int soilN = 6;
PImage []imgSoil;

//土壤寬度
int soilSize = 80;

//土壤位置控制
int soilMove = 0;

//土壤位置陣列
int soilX;
int soilY;

//控制土撥鼠可不可以往下
int ghDown ; 
//控制土壤往上
int soilUP;

//土撥鼠生命
PImage life;

//石頭
PImage stone1, stone2;

void setup() {
  size(640, 480, P2D);
  // Enter your setup code here (please put loadImage() here or your game will lag like crazy)
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  soil8x24 = loadImage("img/soil8x24.png");
  //土撥鼠
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  //生命
  life = loadImage("img/life.png");
  //石頭
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  //土壤
  imgSoil = new PImage[soilN];
  for (int i=0; i<soilN; i++) {
    imgSoil[i] = loadImage("img/soil"+i+".png");
  }
  //土撥鼠xy
  ghX = 4*soilSize;
  ghY = 1*soilSize;
  //土撥鼠狀態
  ghgood = idle;
}

void draw() {
  /* ------ Debug Function ------ 
   
   Please DO NOT edit the code here.
   It's for reviewing other requirements when you fail to complete the camera moving requirement.
   
   */
  if (debugMode) {
    pushMatrix();
    translate(0, cameraOffsetY);
  }
  /* ------ End of Debug Function ------ */


  switch (gameState) {

  case GAME_START: // Start Screen
    image(title, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else {

      image(startNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;

  case GAME_RUN: // In-Game

    // Background
    image(bg, 0, 0);

    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);

    // Grass
    fill(124, 204, 25);
    noStroke();
    rect(0, 160-soilMove - GRASS_HEIGHT, width, GRASS_HEIGHT);

    // Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
    //顯示土壤
    for (int i = 0; i<8; i++) {
      for (int j = 0; j<24; j++) {
        soilX =i*soilSize;
        soilY =j*soilSize+160;
        if (soilY < 4*soilSize+160) {
          image(imgSoil[0], soilX, soilY-soilMove);
        } else if (soilY < 8*soilSize+160) {
          image(imgSoil[1], soilX, soilY-soilMove);
        } else if (soilY < 12*soilSize+160) {
          image(imgSoil[2], soilX, soilY-soilMove);
        } else if (soilY < 16*soilSize+160) {
          image(imgSoil[3], soilX, soilY-soilMove);
        } else if (soilY < 20*soilSize+160) {
          image(imgSoil[4], soilX, soilY-soilMove);
        } else if (soilY < 24*soilSize+160) {
          image(imgSoil[5], soilX, soilY-soilMove);
        }
      }
    }
    //畫石頭
    for (int i = 0; i<8; i++) {
      for (int j = 0; j<24; j++) {
        soilX =i*soilSize;
        soilY =j*soilSize+160;
        if (j < 8) {
          image(stone1, soilX, soilX+160-soilMove);
        } else if (j < 16) {
          image(stone1, soilSize*8-(soilX+160)-soilSize*1, 8*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)-soilSize*5, 8*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)+soilSize*3, 8*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)+soilSize*7, 8*soilSize+soilX+160-soilMove);
          image(stone1, soilX+160, 8*soilSize+soilX+160-soilMove);
          image(stone1, soilX+160+4*soilSize, 8*soilSize+soilX+160-soilMove);
          image(stone1, soilX+160-4*soilSize, 8*soilSize+soilX+160-soilMove);
          image(stone1, soilX+160-8*soilSize, 8*soilSize+soilX+160-soilMove);
        } else if (j < 24) {
          image(stone1, soilSize*8-(soilX+160)+soilSize*8, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)+soilSize*7, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)+soilSize*5, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)+soilSize*4, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)+soilSize*2, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)+soilSize*1, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)-soilSize*1, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)-soilSize*2, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)-soilSize*4, 16*soilSize+soilX+160-soilMove);
          image(stone1, soilSize*8-(soilX+160)-soilSize*5, 16*soilSize+soilX+160-soilMove);
          image(stone2, soilSize*8-(soilX+160)-soilSize*4, 16*soilSize+soilX+160-soilMove);
          image(stone2, soilSize*8-(soilX+160)-soilSize*1, 16*soilSize+soilX+160-soilMove);
          image(stone2, soilSize*8-(soilX+160)+soilSize*2, 16*soilSize+soilX+160-soilMove);
          image(stone2, soilSize*8-(soilX+160)+soilSize*5, 16*soilSize+soilX+160-soilMove);
          image(stone2, soilSize*8-(soilX+160)+soilSize*8, 16*soilSize+soilX+160-soilMove);
        }
        // image(stone1, soilX, soilX+160-soilMove);
      }
    }
    //keyPressed控制ghstate

    if (time < 15) {
      switch (ghgood) {
      case down:
        time++;
        image(groundhogDown, ghX, ghY, 80, 80);
        soilMove += (ghSpeed/15.0+1)*soilUP;

        ghY += (ghSpeed/15.0+1)*ghDown;

        if (time ==15) {
          ghgood = idle;
          soilMove = round(soilMove/80.0)*80;
        }
        break;
      case right:
        time++;
        image(groundhogRight, ghX, ghY, 80, 80);
        ghX += ghSpeed/15.0+1;
        if (time ==15) {
          ghgood = idle;
        }
        break;
      case left:
        time++;
        image(groundhogLeft, ghX, ghY, 80, 80);
        ghX -= ghSpeed/15.0+1;
        if (time ==15) {
          ghgood = idle;
        }
        break;
      case idle:
        image(groundhogIdle, ghX, ghY, 80, 80);
        break;
      }
    } else { 
      image(groundhogIdle, ghX, ghY, 80, 80);
    }
    if (time ==15) {
      ghX = round(ghX/80.0)*80;
      ghY = round(ghY/80.0)*80;
    }
    //讓土撥鼠不要超出邊界的設定
    if (ghX > width-80) {
      ghX = width-80;
    }
    if (ghX < 0) {
      ghX = 0;
    }
    if (ghY < 80) {
      ghY = 80;
    }
    if (ghY > height-80) {
      ghY = height-80;
    }
    // Player

    // Health UI
    for (int i = 0; i <playerHealth; i++) {
      //生命間隔
      int lifeSP = i*70;
      image (life, 10+lifeSP, 10);
    }
    break;

  case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
        // Remember to initialize the game here!
      }
    } else {

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }

  // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
  if (debugMode) {
    popMatrix();
  }
}

void keyPressed() {
  // Add your moving input code here
  if (key == CODED) {
    switch(keyCode) {
    case DOWN :
      time = 0;
      ghgood = down;
      if (soilMove < 20*soilSize) { 
        ghDown = 0;
        soilUP = 1;
      } else {
        ghDown = 1;
        soilUP = 0;
      }
      break;

    case LEFT:
      time = 0;
      ghgood = left;
      break;

    case RIGHT:
      time = 0;
      ghgood = right;
      break;
    }
  }
  // DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
  switch(key) {
  case 'w':
    debugMode = true;
    cameraOffsetY += 25;
    break;

  case 's':
    debugMode = true;
    cameraOffsetY -= 25;
    break;

  case 'a':
    if (playerHealth > 0) playerHealth --;
    break;

  case 'd':
    if (playerHealth < 5) playerHealth ++;
    break;
  }
}



void keyReleased() {
}
