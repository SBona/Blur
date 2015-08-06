import ddf.minim.*;
import ddf.minim.analysis.*;

PImage img;
int imageCount, songCount, imageIndex, oddsToRenderCircle, visualizationType;
//Audio variables
float maxAverages[];
Minim minim;
FFT fft;
AudioPlayer player;
AudioInput in;

//visualizer 1 variables *********************
int imageHeight, smallestSquare, largestSquare, squareWidth;
//visualizer 2 variables ********************
int outerCircleColor;
//Easily change the index of outside Circle
int outerCircleFourierValue;
//visaulizer 3 variables ********************
int smallRadius, largeRadius;

void setup()
{
  size(620, 620);

  imageCount = 78;
  songCount = 28;
  //number of values the fft object returns is 63
  maxAverages = new float[63];
  for (float i : maxAverages)
  {
    i = 100;
  }

  oddsToRenderCircle = 20;
  outerCircleColor = 1;

  updateAverages();
  loadMusic();

  //Visualization 1
  imageHeight = displayHeight;
  smallestSquare = 1;
  largestSquare = (int) displayWidth/10;
  loadImages();

  visualizationType = 3;
}
void draw()
{
  fill(0, 0, 0, 10);
  rect(0, 0, width, height);

  //update the fourier object an display 
  fft.forward(player.mix);

  //Set the type of visualization

  if (visualizationType == 1)
  {
    updateResolution();
  } else if (visualizationType == 2)
  {
    circleVisuals();
  } else {
    centerGraph();
  }

  //update meta data and info
  updateAverages();
  printInfo();
  displayInfo();
}

void centerGraph()
{
  background(0);
  pushMatrix();
  translate(width/2, height/2);

  for (int i = 0; i < fft.avgSize (); i++)
  {
    rotate(2*PI/fft.avgSize());
    stroke(i, 0, fft.avgSize()-i);
    strokeWeight(2);
    line(0, 0, map(fft.getAvg(i), 0, 200, 100, (width/2)-(width/10)), 0);
  }
  popMatrix();

  fill(0);
  ellipse(width/2, height/2, 100, 100);
}


void keyPressed()
{
  //load new image with space
  if (key == 32)
  {
    loadImages();
  }
  //change song with 's'
  if (key == 115)
  {
    player.close();
    loadMusic();
    background(0);
  }
  //pause with 'p'
  if (key == 112)
  {
    if (player.isPlaying())
    {
      player.pause();
    } else
    {
      player.play();
    }
  }
}

void displayInfo()
{
  stroke(255);
  int textSize = (int) height/50;
  textAlign(RIGHT);
  textSize(textSize);
  text(player.getMetaData().title(), width-textSize, textSize);
  text(player.getMetaData().album(), width-textSize, (2*textSize)+2);
  text(player.getMetaData().author(), width-textSize, (3*textSize)+4);
  textAlign(LEFT);
  //stext("Image: "+imageIndex, textSize, textSize);
}

void updateAverages()
{
  for (int i = 0; i < maxAverages.length; i++) {
    if (fft.getAvg(i) > maxAverages[i]) {
      maxAverages[i] = fft.getAvg(i);
    }
  }
}

void printInfo()
{
  println();
  for (int i = 1; i < 61; i+= 5)
  {
    print(i+":"+ ((int)fft.getAvg(i))+" - ");
  }
}
//******************Squares that blur and change size
void updateResolution()
{
  noStroke();
  image(img, 0, 0);

  for (int i = 0; i < img.width; i+=squareWidth)
  {
    for (int j = 0; j < img.height; j+=squareWidth)
    {      
      squareWidth = (int) map(fft.getAvg(5), 0, (int) maxAverages[5], smallestSquare, largestSquare);

      fill(img.get(i+(squareWidth/2), j+(squareWidth/2)));
      rect(i, j, squareWidth, squareWidth);
    }
  }
  /*for (int i = 0; i < img.width; i+=squareWidth)
   {
   for (int j = 0; j < img.height; j+=squareWidth)
   {  
   squareWidth = (int) map(fft.getAvg(15), 0, (int) maxAverages[5], smallestSquare, largestSquare);
   fill(img.get(i+(squareWidth/2), j+(squareWidth/2)));
   ellipse(i,j,squareWidth,squareWidth);
   }
   }*/
}
void loadImages()
{
  int n = (int) random(imageCount-1)+1;
  img = loadImage("./data/images/img"+n+".jpg");
  //Make the image proportional to the new height
  img.resize(imageHeight*img.width/img.height, imageHeight);
  //size(img.width, img.height);
}
void loadMusic()
{
  int songIndex = (int) random(songCount);

  minim = new Minim(this);
  player = minim.loadFile("./data/songs/song"+songIndex+".mp3"); 
  //player = minim.loadFile("./data/songs/song1.mp3");
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.logAverages(60, 7);
  player.play();
}

//*****************************Bass Circle with Treble Circles
void circleVisuals()
{
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

  if (outerCircleColor == 1)
  {
    stroke(0, 0, 255);
    outerCircleColor = 2;
  } else {
    stroke(255, 255, 0);
    outerCircleColor = 1;
  }

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

