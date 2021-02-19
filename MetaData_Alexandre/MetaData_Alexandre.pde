import processing.sound.*;

SinOsc oscduck ;
Env envduck;
SinOsc oscjump ;
Env envjump;

String projectName = "meta datas"; // Nom du projet
String date = "30/11/2020"; // Date de début

// https://airtable.com/api
String baseID = "app5AXjjj5VujpbOk"; // ID de la base
String tableName = "Event"; // Nom du tableau Airtable
String apiKey = "keyZKpxb6lauqPFv2"; // Clé API

PGraphics canvas;

PImage dinoRun1;
PImage dinoRun2;
PImage dinoJump;
PImage dinoDuck;
PImage dinoDuck1;
PImage smallCactus;
PImage bigCactus;
PImage manySmallCactus;
PImage bird;
PImage bird1;
PImage mute;
PImage duckbutton;
PImage jumpbutton;
PImage musicplaybutton;
PImage dinodead;
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Bird> birds =   new ArrayList<Bird>();
ArrayList<Ground> grounds = new ArrayList<Ground>();

int obstacleTimer = 0;
int minTimeBetObs = 1000;
int randomAddition = 0;
int groundCounter = 0;
float speed = 10;

int groundHeight = 200;
int playerXpos = 100;
int highScore = 0;

Player dino;
SoundFile file;
SoundFile music;

void setup() {
  //size(1200, 900);
  fullScreen();
  pixelDensity(1);
  //frameRate(60);

  file = new SoundFile(this, "gameover.mp3");
  music = new SoundFile(this, "music.mp3");
  dinodead = loadImage("cervoDead0000.png");
  dinoRun1 = loadImage("cervorun0000.png");
  dinoRun2 = loadImage("cervorun0001.png");
  dinoJump = loadImage("cervoJump0000.png");
  dinoDuck = loadImage("cervoduck0000.png");
  dinoDuck1 = loadImage("cervoduck0001.png");

  musicplaybutton = loadImage("play.png");
  mute = loadImage("mute.png");
  duckbutton = loadImage("duckbutton.png");
  jumpbutton = loadImage("jumpbutton.png");

  smallCactus = loadImage("cactusSmall0000.png");
  bigCactus = loadImage("cactusBig0000.png");
  manySmallCactus = loadImage("cactusSmallMany0000.png");
  bird = loadImage("berd.png");
  bird1 = loadImage("berd2.png");

  dino = new Player();
  oscduck = new SinOsc(this);
  envduck = new Env(this);
  oscjump = new SinOsc(this);
  envjump = new Env(this);

  fetch();
  loadUI();
  canvas = createGraphics(width, height);
}

void draw() {
  background(250);
  stroke(0);
  strokeWeight(2);
  line(0, height - groundHeight - 30, width, height - groundHeight - 30);
  image(mute, width/2-128, 30);
  image(musicplaybutton, width/2, 30);
  image(duckbutton, width/2-64, 30);
  image(jumpbutton, width/2+64, 30);
  updateObstacles();

  if (dino.score > highScore) {
    highScore = dino.score;
  }
  
  textFont(font, 40);
  textSize(40);
  fill(0);
  text("Score: " + dino.score, 5, 40);
  text("High Score: " + highScore, width - (380 + (str(highScore).length() * 10)), 40);

  updateUI();
  println(selectedEvents.size());
  minTimeBetObs = round(map(selectedEvents.size(), 0, 8, 15, 150));
  //println(minTimeBetObs);
}


void playSoundduck() {
  oscduck.play(500, 0.5);

  envduck.play(oscduck, 0.01, 0.01, 0.3, 0.1);
}
void playSoundjump() {
  oscjump.play(400, 1);  
  envjump.play(oscjump, 0.01, 0.01, 0.3, 0.01);
}


void updateObstacles() {
  showObstacles();
  dino.show();
  if (!dino.dead) {
    obstacleTimer++;
    speed += 0.002;
    if (obstacleTimer > minTimeBetObs + randomAddition) {
      addObstacle();
    }
    groundCounter++;
    if (groundCounter > 10) {
      groundCounter = 0;
      grounds.add(new Ground());
    }
    moveObstacles();

    dino.update();
  } else {
    textSize(64);
    fill(0);
    image(dinodead, width/2-270, 100);
    music.stop();
    text("GO BACK TO WORK !", width/2-340, height/2);
    textSize(32);
    text("(Or press 'r' to restart)", width/2-190, height/2+100);
  }
}

void showObstacles() {
  for (int i = 0; i < grounds.size(); i++) {
    grounds.get(i).show();
  }
  for (int i = 0; i < obstacles.size(); i++) {
    obstacles.get(i).show();
  }
  for (int i = 0; i < birds.size(); i++) {
    birds.get(i).show();
  }
}

void addObstacle() {
  if (random(1) < 0.15) {
    birds.add(new Bird(floor(random(3))));
  } else {
    obstacles.add(new Obstacle(floor(random(3))));
  }
  randomAddition = floor(random(50));
  obstacleTimer = 0;
}

void moveObstacles() {
  for (int i = 0; i < grounds.size(); i++) {
    grounds.get(i).move(speed);
    if (grounds.get(i).posX < -playerXpos) {
      grounds.remove(i);
      i--;
    }
  }
  for (int i = 0; i < obstacles.size(); i++) {
    obstacles.get(i).move(speed);
    if (obstacles.get(i).posX < -playerXpos) {
      obstacles.remove(i);
      i--;
    }
  }
  for (int i = 0; i < birds.size(); i++) {
    birds.get(i).move(speed);
    if (birds.get(i).posX < -playerXpos) {
      birds.remove(i);
      i--;
    }
  }
}

void reset() {
  dino = new Player();
  obstacles = new ArrayList<Obstacle>();
  birds = new ArrayList<Bird>();
  grounds = new ArrayList<Ground>();
  //music.loop();
  obstacleTimer = 0;
  randomAddition = floor(random(50));
  groundCounter = 0;
  speed = 10;
}
