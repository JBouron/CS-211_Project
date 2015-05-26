void drawBackgroundSurface() { 
  backgroundSurface.noStroke();
  backgroundSurface.beginDraw();
  backgroundSurface.background(230, 225, 175);
  backgroundSurface.fill(230, 225, 175);
  backgroundSurface.rect(0, 0, backgroundSurface.width, backgroundSurface.height);
  backgroundSurface.endDraw();
}

void drawTopViewSurface() {
  topViewSurface.noStroke();
  topViewSurface.beginDraw();
  topViewSurface.background(60, 130, 170);
  float zoom = boardSize/topViewSurface.width;
  topViewSurface.fill(255, 0, 0);
  for (int i = 0; i < cylinderList.size (); i ++) {
    float posX =  (boardSize/2 + cylinderList.get(i).x) / zoom;
    float posY = (boardSize/2 + cylinderList.get(i).y) / zoom;
    topViewSurface.ellipse(posX, posY, 2*cylinderBaseSize/zoom, 2*cylinderBaseSize/zoom);
  }

  float ballPosX = (ball.location.x + boardSize/2)/zoom; //adding topViewSurfaceSize/2 because the ball isa at position 0, 0 at thecenter of the plate.
  float ballPosY = (ball.location.z  + boardSize/2)/zoom;
  topViewSurface.fill(0, 255, 0);
  topViewSurface.ellipse(ballPosX, ballPosY, 2*ballSize/zoom, 2*ballSize/zoom);
  topViewSurface.endDraw();
}

void drawScoreSurface() {

  scoreSurface.beginDraw();
  scoreSurface.stroke(255);
  scoreSurface.strokeWeight(4);
  scoreSurface.strokeJoin(ROUND);
  scoreSurface.fill(230, 225, 175);
  scoreSurface.rect(0, 0, scoreSurface.width, scoreSurface.height);
  scoreSurface.textSize(16);
  scoreSurface.fill(60, 130, 170);
  scoreSurface.text("Total Score", 5, 17);
  scoreSurface.text(totalScore, 5, 32);
  scoreSurface.text("Velocity", 5, 62);
  scoreSurface.text(ball.velocity.mag(), 5, 77);
  scoreSurface.text("Last Score", 5, 107);
  scoreSurface.text(score, 5, 122);
  scoreSurface.endDraw();
}

void drawBarChartSurface() {  
  float rectWidth = pow(4.0, hs.getPos() + 0.5);
  float rectHeight = 4.0;

  if (millis() - timeSinceLastEvent >= 400) {
    barChartSurface.beginDraw();
    barChartSurface.background(255);

    timeSinceLastEvent = millis();
    nbCurrentScore ++;

    for (int i = nbScoreMax - 1; i > 0; i--) {
      tabScore[i] = tabScore[i-1];
    }
    tabScore[0] = totalScore;

    barChartSurface.fill(23);
    barChartSurface.line(0, barChartSurface.height/2, barChartSurface.width, barChartSurface.height/2);
    
    for (int i = 0; i < nbScoreMax; i++) {
      if (tabScore[i] > 0) {
        barChartSurface.fill(0, 255, 0);
        for (int j = 0; j < tabScore[i]; j++) {
          barChartSurface.rect(i * rectWidth, barChartSurface.height - j * rectHeight - barChartSurface.height/2 - rectHeight, rectWidth, rectHeight);
        }
      }
      else {
        barChartSurface.fill(255, 0, 0);
        for (int j = 0; j > tabScore[i]; j--) {
          barChartSurface.rect(i * rectWidth, barChartSurface.height - j * rectHeight - barChartSurface.height/2, rectWidth, rectHeight);
        }
      }
    }

    barChartSurface.endDraw();
  }
}

