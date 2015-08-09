


public class circleGraph
{
  int x, y, innerRad, outerRad;
  public circleGraph(int x, int y, int innerRad, int outerRad)
  {
    this.x = x;
    this.y = y;
    this.innerRad = innerRad;
    this.outerRad = outerRad;
  }

  void draw()
  {
    pushMatrix();
    translate(this.x, this.y);

    for (int i = 0; i < fft.avgSize (); i++)
    {
      rotate(2*PI/fft.avgSize());
      //full color scale
      color thisColor = color(map(i, 0, fft.avgSize(), 255, 0), map(i, 0, fft.avgSize(), 0, 170), map(abs((fft.avgSize()/2)-i), 0, fft.avgSize()/2, 255, 0) );
      //Red Bass, Purple, Blue
      thisColor = color(map(fft.avgSize()-i, 0, fft.avgSize(), 0, 255), 50, map(i, 0, fft.avgSize(), 0, 255));

      stroke(thisColor);
      fill(thisColor);
      strokeWeight(1);
      //noStroke();
      strokeCap(SQUARE);

      //Polygons to make congruent shape
      float end1 = map(fft.getAvg(i), 0, maxAverages[i], innerRad, outerRad);
      float end2 = map(fft.getAvg((i+1)%fft.avgSize()), 0, maxAverages[(i+1)%fft.avgSize()], 100, 200);
      float p2Y =  (end2 * sin(2*PI/fft.avgSize()));
      float p2X =  (end2 * cos(2*PI/fft.avgSize()));
      //quad(0.0, 0.0, end1, 0.0, p2X, p2Y, 0.0, 0.0);
      
      //Simply lines coming from center
      line(0, 0, end1, 0);
      
    }
    popMatrix();

    fill(0);
    strokeWeight(2);
    //ellipse(width/2, height/2, 200, 200);
  }
}

