import java.text.SimpleDateFormat;  
import java.util.*;  

PFont font;
float easing = 0.95;
float opacity = 255;

long oneweek_ms = 1000*24*7*60*60;
long oneday_ms = 1000*24*60*60;
long onehour_ms = 1000*60*60;
long oneminute_ms = 1000*60;
int oneweek_minutes = 24*7*60;
int oneweek_hours = 24*7;
int oneweek_days = 7;

int counter = 0;
int counterDelay = 50;
int mode = 2; // 0=minute / 1=hour / 2=day / 3=week

int finderCounter = 0;
int finderDelay = 5;
boolean moved = true;
long currentDateTime;
long currentBaseDateTime;

boolean grid = true;
boolean play = true;
int playSpeed = 1;

long starting;
long ending;

ArrayList<EventObject> selectedEvents = new ArrayList<EventObject>();

String[] dateFormats = { "EEEEE',' HH:mm", "EEEE 'from' H 'to' ", "EEEE", "'A week of " + projectName + "'" };
//String[] dateFormats = { "EEEEE" };
long[] modeMS = { oneminute_ms, onehour_ms, oneday_ms, oneweek_ms };
int[] modeRange = { oneweek_minutes, oneweek_hours, oneweek_days, oneweek_days };

PGraphics ui;

void loadUI() {
  font = loadFont("GTAmerica-Medium-84.vlw");

  // Start on begining of week
  currentDateTime = starting_date.getTime();
  ui = createGraphics(width, height);
}
void updateUI() {
  if (frameCount % playSpeed == 0 && play) {
    if (!dino.dead)
      forward();
  }

  finderCounter ++;

  if (frameCount%4 == 1) {

    moved = false;
    finderCounter = 0;
    selectedEvents.clear();
    for (int i = 0; i < events.size(); i++) {
      long start = currentDateTime;
      long end = currentDateTime + modeMS[mode];

      if (mode == 3) {
        start = starting_date.getTime();
        end =  starting_date.getTime() + oneweek_ms;
      }

      if (events.get(i).datetime.getTime() > start && events.get(i).datetime.getTime() < end) 
        selectedEvents.add(events.get(i));
    }
  } 

  starting = currentDateTime;
  ending = currentDateTime + modeMS[mode];
  if (mode==3) {
    starting = starting_date.getTime();
    ending = starting_date.getTime() + modeMS[mode];
  }

  counter ++;
  if (counter >= counterDelay) {
    opacity *= easing;
  } else {
    opacity = 250;
    //if(player.dead=true){
    //opacity =0;
    //}
  }

  ui.beginDraw();
  ui.pushMatrix();
  ui.pushStyle();
  //ui.background(0);
  if (grid)
    drawGrid();
  drawText();
  ui.popStyle();
  ui.popMatrix();
  ui.endDraw();

  image(ui, 0, 0);

  ui.beginDraw();
  ui.clear();
  ui.endDraw();
}

void drawGrid() {
  //Grid
  int cmode = (mode == 0) ? 1 : mode; 
  float m = (float) modeRange[cmode];
  float xSpacing = width/m;

  float pulse = abs(sin(frameCount*0.1)*100);
  /*
  if (mode != 3) {
   for (int i = 0; i <= modeRange[mode]; i++) {
   ui.stroke(100);
   if (i == round(map(currentDateTime, starting_date.getTime(), starting_date.getTime()+oneweek_ms, 0, modeRange[cmode]))) {
   if (mode != 0) {
   ui.pushStyle();
   ui.noStroke();
   ui.fill(255, pulse*0.5);
   ui.rect(i*xSpacing, 0, xSpacing, height);
   ui.popStyle();
   }
   }
   ui.line((i+1)*xSpacing, 0, (i+1)*xSpacing, height);
   }
   }
   */
  if (mode == 0) {
    float pos = round(map(currentDateTime, starting_date.getTime(), starting_date.getTime()+oneweek_ms, 0, width));
    ui.pushStyle();
    ui.stroke(100+pulse);
    ui.line(pos, 0, pos, height);
    ui.popStyle();
  }
}

void drawText() {
  ui.fill(0, 0, 0, opacity);
  ui.textSize(100);
  String date = new SimpleDateFormat(dateFormats[0], Locale.ENGLISH).format(new Date(currentDateTime));
  //if (mode == 1)
  //  date += new SimpleDateFormat("H:00", Locale.ENGLISH).format(new Date(currentDateTime + onehour_ms));
  String cap = date.substring(0, 1).toUpperCase() +date.substring(1);

  ui.textFont(font, 100);
  //ui.textAlign(CENTER);
  ui.text(cap, 60, 850);///////////////////////////////////////
}

void pressedUI () {
  mode = (mode + 3) % 4;
  resetStage();
  updatePosition();
}

void movedUI() {
  //resetStage();
  //updatePosition();
}

void updatePosition() {
  currentDateTime = starting_date.getTime() + 400;//floor(map(mouseX, 0, width, 0, modeRange[mode]))*modeMS[mode];
}


void forward() {
  if (currentDateTime >= starting_date.getTime() && currentDateTime < (starting_date.getTime() + oneweek_ms) - modeMS[mode]) {
    currentDateTime += modeMS[0];
  } else {
    currentDateTime = starting_date.getTime();
  }
  resetStage();
}

void backward() {
  if (currentDateTime > starting_date.getTime() && currentDateTime <= (starting_date.getTime() + oneweek_ms) - modeMS[mode]) {
    currentDateTime -= modeMS[mode];
  } else {
    currentDateTime = (starting_date.getTime() + oneweek_ms) - modeMS[mode];
  }
  resetStage();
}

void resetStage() {
  counter = 0;
  finderCounter = 0;
  moved = true;
}

void toggleGrid() {
  grid = !grid;
}
void debug() {
  for (int i = 0; i < selectedEvents.size(); i++) {
    println(selectedEvents.get(i).datetime);
  }
  println("————————————————— " + selectedEvents.size() + " event(s)");
}
