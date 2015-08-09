
//*****************************Bass Circle with Treble Circles
void circleVisuals()
{
  fill(0, 0, 0, 10);
  rect(0, 0, width, height);
  ellipseMode(RADIUS);

  //BASS circle
  stroke(255, 0, 0);
  fill(200, 0, 0);
  int rad = (int) map(fft.getAvg(5), 0, (int) maxAverages[5], 0, width/2);
  ellipse(width/2, height/2, rad, rad);

  //Treble Circle
  stroke(0, 0, 255);
  noFill();
  int trad = (int) map(fft.getAvg(25), 0, (int) maxAverages[25], 0, width/2);
  ellipse(width/2, height/2, trad, trad);

  stroke(255, 255, 0);

  outerCircleFourierValue = 50;
  if (fft.getAvg(outerCircleFourierValue)>(maxAverages[outerCircleFourierValue]/2))
  {
    for (int i = 1; i < 4; i++)
    {
      for (int j = 1; j < 4; j++)
      {
        PVector ellipseCenter = new PVector(i * width/4, j * height/4);

        //int smallRad = (int) dist(ellipseCenter.x, ellipseCenter.y, width/2, height/2);
        int smallRad = (int) map(fft.getAvg(outerCircleFourierValue), 0, (int) maxAverages[outerCircleFourierValue], 0, width/2);
        smallRad -= rad;

        ellipse(ellipseCenter.x, ellipseCenter.y, smallRad, smallRad);
      }
    }
  }
}
