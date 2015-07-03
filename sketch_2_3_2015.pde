import ddf.minim.*;
import ddf.minim.analysis.*;

int squareWidth;
PImage img;
int imageHeight, smallestSquare,largestSquare, imageCount, songCount, imageIndex;

Minim minim;
FFT fft;
AudioPlayer player;
AudioInput in;
void setup()
{
  imageHeight = 900;
  smallestSquare = 3;
  largestSquare = 40;
  imageCount = 40;
  songCount = 18;
  
  loadImages();
  loadMusic();
}
void draw()
{
  fft.forward(player.mix);
  
  println(fft.getAvg(35));
  updateResolution();
  displayInfo();
  
  if(frameCount%450 == 5){
  loadImages(); 
 }
}
void keyPressed()
{
 if(key == 32)
 {
  loadImages(); 
 }
}

void updateResolution()
{
  noStroke();
  image(img,0,0);
  for(int i = 0; i < img.width; i+=squareWidth)
  {
    for(int j = 0; j < img.height; j+=squareWidth)
    {      
      squareWidth = (int) map(fft.getAvg(5),0,150,smallestSquare,largestSquare);
      
      fill(img.get(i+(squareWidth/2),j+(squareWidth/2)));
      rect(i,j,squareWidth,squareWidth);
    }
  }  
}

void loadImages()
{
  int n = (int) random(imageCount);
  img = loadImage("./data/images/img"+n+".jpg");
  img.resize(imageHeight*img.width/img.height, imageHeight);
  size(img.width,img.height); 
}

void loadMusic()
{
  imageIndex = (int) random(songCount);
  
  minim = new Minim(this);
  player = minim.loadFile("./data/songs/song"+imageIndex+".mp3"); 
  //player = minim.loadFile("./data/songs/song1.mp3");
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.logAverages(60,7);
  player.play();
}

void displayInfo()
{
  stroke(0);
  int textSize = (int) height/50;
  textAlign(RIGHT);
  textSize(textSize);
  text(player.getMetaData().title(), width-textSize, textSize);
  text(player.getMetaData().album(), width-textSize, (2*textSize)+2);
  text(player.getMetaData().author(), width-textSize , (3*textSize)+4);
  textAlign(LEFT);
  text("Image: "+imageIndex,textSize,textSize);
}
