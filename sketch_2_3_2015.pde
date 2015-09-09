import ddf.minim.*;
import ddf.minim.analysis.*;
//Minim documentation: http://code.compartmental.net/minim/javadoc/

PImage img;
int imageCount, songCount, imageIndex, visualizationType;
//Audio variables
float maxAverages[];
Minim minim;
FFT fft;
AudioPlayer player;
AudioInput in;

//visualizer 1 variables *********************
int imageHeight, smallestSquare, largestSquare, squareWidth;
//visualizer 2 variables ********************
//Easily change the index of outside Circle
int outerCircleFourierValue;
//visaulizer 3 variables ********************

ArrayList circleGraphs;

void setup()
{
  size(500, 500);

  imageCount = 78;
  songCount = 13;
  loadMusic();

  //number of values the fft object returns is 63
  maxAverages = new float[fft.avgSize()];
  for (float i : maxAverages)
  {
    i = 20;
  }
  updateMaxAverages();

  //Visualization 1
  /*imageHeight = displayHeight;
   smallestSquare = 1;
   largestSquare = (int) displayWidth/10;
   loadImages();
   */
  circleGraphs = new ArrayList();

  for (int i = 1; i < 5; i++)
  {
    for (int j = 1; j < 5; j++)
    {
      //circleGraphs.add(new circleGraph(i*(width/5), j*(width/5), 10, 50));
    }
  }
  circleGraphs.add(new circleGraph(width/2,height/2,20,100));
}
void draw()
{
  background(0);
  //update the fourier object an display 
  fft.forward(player.mix);

  //updateResolution();
  //circleVisuals();

  //update meta data and info
  updateMaxAverages();
  printInfo();
  displayInfo();

  for (int i = 0; i < circleGraphs.size (); i++)
  {
    ((circleGraph)circleGraphs.get(i)).draw();
  }
  //visualizer4();
}




