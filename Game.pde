import papaya.*;

import processing.video.*;
import java.util.Comparator;
import java.util.Collections;
import java.util.Random;

float depth = 100;
float rotationX = 0.0;
float rotationY = 0.0;
float rotationZ = 0.0;
float boardSpeed = 0.7;

float boardSize = 50;
float ballSize = 2;

boolean addCylinderMode = false;

PVector gravity;

float cylinderBaseSize = 4;
float cylinderHeight = 9;
int cylinderResolution = 40;

PShape closedCylinder = new PShape();
PShape openCylinder = new PShape();
PShape topCylinder = new PShape();
PShape bottomCylinder = new PShape();

PShape sheep_shape_alive = new PShape();
PShape sheep_shape_dead = new PShape();
ArrayList<Sheep> sheeps;
int sheeps_num = 5;
PImage background;

ArrayList<PVector> cylinderList;

float coin1; // coin du plateau 1 
float coin2; // coin du plateau 2 

PGraphics backgroundSurface;
PGraphics topViewSurface;
PGraphics scoreSurface;
PGraphics barChartSurface;

float score;
float totalScore;
int nbCurrentScore = 0;
int nbScoreMax;

int timeSinceLastEvent = 0;

float[] tabScore;

Mover ball;
HScrollbar hs;

Capture cam;
PImage img;
PImage sob;
PImage back;

ArrayList<int[]> cycles = new ArrayList<int[]>();
int[][] graph;


void setup() {
  size(1000, 700, P3D);  // size always goes first!
  if (frame != null) {
    frame.setResizable(true);
  }
  frameRate(60);
  
  PImage load = loadImage("loading.jpg");
  load.resize(1000, 700);
  //background(load);
  //image(load, 0, 0);
  
  back = loadImage("background.jpg");
  back.resize(width, height);

  backgroundSurface = createGraphics(width, 150, P2D);
  topViewSurface = createGraphics(backgroundSurface.height - 10, backgroundSurface.height - 10, P2D);
  scoreSurface = createGraphics(120, backgroundSurface.height - 10, P2D);
  barChartSurface = createGraphics(backgroundSurface.width - topViewSurface.width - scoreSurface.width - 70, backgroundSurface.height - 40, P2D);
  nbScoreMax = (int)(barChartSurface.width/(pow(4.0, 0.5)));
  tabScore = new float[nbScoreMax];

  ball = new Mover();
  cylinderList = new ArrayList<PVector>();
  //createCylinder();
  closedCylinder = loadShape("tourTextUnit.obj");
  closedCylinder.scale(0.36f);
  closedCylinder.rotateX(PI/2);
  
  sheeps = new ArrayList<Sheep>();
  createSheeps();
  sheep_shape_alive = loadShape("Sheep.obj");
  sheep_shape_alive.scale(10.f);
  sheep_shape_dead = loadShape("blood2.obj");
  sheep_shape_dead.scale(20.0f, 20.f, 10.0f);
  sheep_shape_dead.rotateX(PI/2);

  score = 0.0;
  totalScore = 0.0;

  hs = new HScrollbar(topViewSurface.width + scoreSurface.width +50, height - 40, backgroundSurface.width - topViewSurface.width - scoreSurface.width - 70, 20);
  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[7]);
    cam.start();
  }
}


void createSheeps(){
    for (int i = 0; i < sheeps_num; i++){
      sheeps.add(new Sheep(new PVector(random(-boardSize/2, boardSize/2),random(-boardSize/2, boardSize)/2), boardSize));
      sheeps.get(i).sheep_orientation = random(-PI, PI); 
    }
    
}

void draw() {
  pushMatrix();
  
  
  directionalLight(200, 150, 100, 0, -1, 0);
  directionalLight(130, 130, 130, 100, 1, 0);
  directionalLight(130, 130, 130, 0, 0, -1);
  ambientLight(102, 102, 102);
  image(back, 0, 0);

  noStroke();

  if (addCylinderMode == true) {
    camera(width/2, 200, 0.1, width/2, height/2, 0, 0, 1, 0);

    translate(width/2, height/2, 0);
    pushMatrix();
    scale(1, 0.07, 1);
    fill(60, 170, 130);
    box(boardSize);
    popMatrix();
    // on determine la positions des coins sur l'ecran
    coin1 = screenX(-boardSize/2, 0, boardSize/2);
    coin2 = screenX(boardSize/2, 0, boardSize/2);
  } else {
    ball.checkEdges();
    ball.checkCylinderCollision();


    camera(width/2, height/2 - 20, depth, width/2, height/2, 0, 0, 1, 0);

    translate(width/2, height/2, 0);

    rotateX(rotationX);
    rotateY(rotationY);
    rotateZ(rotationZ);

    pushMatrix();
    scale(1, 0.07, 1);
    fill(60, 170, 130);
    box(boardSize);
    popMatrix();
  }

  ball.display();

  for (int i=0; i<cylinderList.size (); i++) {
    pushMatrix();
    translate(cylinderList.get(i).x, -1, cylinderList.get(i).y);
    rotateX(PI/2);
    shape(closedCylinder);
    popMatrix();
  }
  
  for (int i = 0 ; i < sheeps.size(); i ++){
    sheeps.get(i).Sheep_move();
     pushMatrix();
     if (sheeps.get(i).sheep_is_alive){
        translate(sheeps.get(i).sheep_position.x, -3.2 - sheeps.get(i).sheep_height , sheeps.get(i).sheep_position.y);
       //translate(boardSize/2, -3.2 - sheeps.get(i).sheep_height, -boardSize/2); 
     }
     else{
         translate(sheeps.get(i).sheep_position.x, -1.65 , sheeps.get(i).sheep_position.y); 
     }
    rotateX(PI/2);
    rotateZ(sheeps.get(i).sheep_orientation);
    if (sheeps.get(i).sheep_is_alive){
      shape(sheep_shape_alive);
    }
    else{
       shape(sheep_shape_dead); 
    }
    popMatrix();
  }

  popMatrix();

  drawBackgroundSurface();
  drawScoreSurface();
  drawBarChartSurface();
  drawTopViewSurface();
  image(backgroundSurface, 0, height - backgroundSurface.height);
  image(topViewSurface, 5, height-backgroundSurface.height+5);
  image(scoreSurface, topViewSurface.width + 20, height - scoreSurface.height - 5);
  image(barChartSurface, topViewSurface.width + scoreSurface.width +50, height - scoreSurface.height - 5);

  hs.update();
  hs.display();
  
  if (cam.available() == true) {
    cam.read();
  }
  img = cam.get();
  //img = loadImage("board1.jpg");
  //img.resize(300, 225);
  image(img, 0, 0);
  sob = sobel(convolute(hueTh(convolute(convolute(img)))));
  //image(convolute(hueTh(convolute(convolute(img)))), 0, 0);
  //image(convolute(hueTh(convolute(convolute(convolute(convolute(img)))))), 0, 0);
  hough(sob, 4);
  
  fill(255);
}

void createCylinder() {

  noStroke();
  fill(255, 0, 0);
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }

  closedCylinder = createShape(GROUP);

  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i], 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();

  topCylinder = createShape();
  topCylinder.beginShape(TRIANGLE_FAN);
  topCylinder.vertex(0, 0, 0);
  for (int i = 0; i < x.length; i++) {
    topCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  topCylinder.endShape();

  bottomCylinder = createShape();
  bottomCylinder.beginShape(TRIANGLE_FAN);
  bottomCylinder.vertex(0, 0, cylinderHeight);
  for (int i = 0; i < x.length; i++) {
    bottomCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  bottomCylinder.endShape();

  closedCylinder.addChild(openCylinder);
  closedCylinder.addChild(topCylinder);
  closedCylinder.addChild(bottomCylinder);
}

void keyPressed() {
  if (key == CODED) {
    /*if (keyCode == RIGHT) {
     rotationY += 0.06 * boardSpeed;
     } else if (keyCode == LEFT) {
     rotationY -= 0.06 * boardSpeed;
     } else */    if (keyCode == SHIFT) {
      addCylinderMode = true;
    }
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      addCylinderMode = false;
    }
  }
}

void mouseClicked() {
  if (addCylinderMode == true) {

    float boardWidthOnScreen = coin2 - coin1;
    float zoom = boardSize/boardWidthOnScreen;
    float x = mouseX - width/2;
    float y = mouseY - height/2;

    if (width/2 - boardWidthOnScreen/2 <= mouseX && mouseX <= width/2 + boardWidthOnScreen/2 && height/2 - boardWidthOnScreen/2 <= mouseY && mouseY <= height/2 + boardWidthOnScreen) { // PAS CHANGER

      PVector n = new PVector(ball.location.x, 0, ball.location.z);
      n.sub(new PVector(x*zoom, 0, y*zoom));

      if (n.mag() > cylinderBaseSize + ballSize) { // cylindre pas dans ball
        cylinderList.add(new PVector(x*zoom, y*zoom));
      }
    }
  }
}

/*void mouseDragged() {
  if (!hs.locked) {
    rotationX = -map(mouseY - height/2, -height/2, height/2, -PI/3, PI/3) * boardSpeed;
    if (rotationX < -PI/3)
      rotationX = -PI/3;

    if (rotationX > PI/3)
      rotationX = PI/3;

    rotationZ = map(mouseX - width/2, -width/2, width/2, -PI/3, PI/3) * boardSpeed;
    if (rotationZ < -PI/3)
      rotationZ = -PI/3;

    if (rotationZ > PI/3)
      rotationZ = PI/3;
      
  }
}*/

void mouseWheel(MouseEvent event) {
  if (event.getCount() < 0.0) {
    boardSpeed /= 1.1;
  } else {
    boardSpeed *= 1.1;
  }
}

