import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_2_3_2015 extends PApplet {




int squareWidth;
PImage img;
int imageHeight, smallestSquare, largestSquare, imageCount, songCount, imageIndex, oddsToRenderCircle;
float maxAvg;
Minim minim;
FFT fft;
AudioPlayer player;
AudioInput in;
public void setup()
{
  size(displayWidth, displayHeight);
  
  imageHeight = displayHeight;
  smallestSquare = 1;
  largestSquare = (int) displayWidth/10;
  imageCount = 78;
  songCount = 25;
  maxAvg = 10;
  oddsToRenderCircle = 20;

  loadImages();
  loadMusic();
}
public void draw()
{
  fill(0);
  rect(0,0,width,height);
  //update the fouriet object and display 
  fft.forward(player.mix);
  updateResolution();
  displayInfo();

  if (fft.getAvg(5) > maxAvg) {
    maxAvg = fft.getAvg(5);
    //loadImages();
  }
  println(fft.getAvg(5));

  if (random(100)>97) {
    //loadImages();
  }
}
public void keyPressed()
{
  if (key == 32)
  {
    loadImages();
  }
}

public void updateResolution()
{
  noStroke();
  image(img, 0, 0);

  for (int i = 0; i < img.width; i+=squareWidth)
  {
    for (int j = 0; j < img.height; j+=squareWidth)
    {      
      squareWidth = (int) map(fft.getAvg(5), 0, (int) maxAvg, smallestSquare, largestSquare);

      fill(img.get(i+(squareWidth/2), j+(squareWidth/2)));
      rect(i, j, squareWidth, squareWidth);
    }
  }
  /*for (int i = 0; i < img.width; i+=squareWidth)
  {
    for (int j = 0; j < img.height; j+=squareWidth)
    {  
      squareWidth = (int) map(fft.getAvg(15), 0, (int) maxAvg, smallestSquare, largestSquare);
      fill(img.get(i+(squareWidth/2), j+(squareWidth/2)));
      ellipse(i,j,squareWidth,squareWidth);
    }
  }*/
}

public void loadImages()
{
  int n = (int) random(imageCount-1)+1;
  img = loadImage("./data/images/img"+n+".jpg");
  //Make the image proportional to the new height
  img.resize(imageHeight*img.width/img.height, imageHeight);
  //size(img.width, img.height);
}

public void loadMusic()
{
  int songIndex = (int) random(songCount);

  minim = new Minim(this);
  player = minim.loadFile("./data/songs/song"+songIndex+".mp3"); 
  //player = minim.loadFile("./data/songs/song5.mp3");
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.logAverages(60, 7);
  player.play();
}

public void displayInfo()
{
  stroke(0);
  int textSize = (int) height/50;
  textAlign(RIGHT);
  textSize(textSize);
  text(player.getMetaData().title(), width-textSize, textSize);
  text(player.getMetaData().album(), width-textSize, (2*textSize)+2);
  text(player.getMetaData().author(), width-textSize, (3*textSize)+4);
  textAlign(LEFT);
  text("Image: "+imageIndex, textSize, textSize);
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "sketch_2_3_2015" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
