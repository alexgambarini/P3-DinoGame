void mousePressed() {
  if (mouseButton == RIGHT) {
    toggleGrid();
  } else {
    //pressedUI();
  }

  minTimeBetObs = 10;
}

void mouseMoved() {
  //movedUI();
}




void keyReleased() {
  switch(key) {
  case 's': 
    if (!dino.dead) {
      dino.ducking(false);
      //playSoundduck();
    }
    break;
  case 'm':
    music.stop();
    break;
  case 'p':
    music.loop();
    break;
  case 'r': 
    currentDateTime = starting_date.getTime();
    if (dino.dead) {
      /*file.play();**********/

      reset();
    }
    break;
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      forward();
    } else if (keyCode == LEFT) {
      backward();
    }
  }
  if (key == 'g')
    toggleGrid();

  if (key == ' '){
  }
   // play = !play;


  switch(key) {
  case 'q': 
    dino.jump();
    playSoundjump();

    break;
  case 's': 
    if (!dino.dead) {
      dino.ducking(true);
      playSoundduck();
    }
    break;
  }
}

//void mouseWheel(MouseEvent event) {
//float e = event.getCount();
//if (e > 0) {
//forward();
//} else {
//backward();
//}
//}
