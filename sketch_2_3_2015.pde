import ddf.minim.*;
import ddf.minim.analysis.*;

int squareWidth;
PImage img;
int imageHeight, smallestSquare,largestSquare, imageCount, songCount, imageIndex, oddsToRenderCircle;
float maxAvg;
Minim minim;
FFT fft;
AudioPlayer player;
AudioInput in;
void setup()
{
  imageHeight = 900;
  smallestSquare = 9;
  largestSquare = 90;
  imageCount = 40;
  songCount = 18;
  maxAvg = 10;
  oddsToRenderCircle = 20;
  
  loadImages();
  loadMusic();
}
void draw()
{
  //update the fouriet object and display 
  fft.forward(player.mix);
  updateResolution();
  displayInfo();
    
  if(fft.getAvg(5) > maxAvg){
    maxAvg = fft.getAvg(5);
    loadImages();
  }
  println(fft.getAvg(5));
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
      squareWidth = (int) map(fft.getAvg(5),0,(int) maxAvg,smallestSquare,largestSquare);
      
      fill(img.get(i+(squareWidth/2),j+(squareWidth/2)));
      //rect(i,j,squareWidth,squareWidth);
      if(random(100) > 20)
      {
        ellipse(i,j,squareWidth,squareWidth);
      }
    }
  } 
  
}

void loadImages()
{
  int n = (int) random(imageCount-1)+1;
  img = loadImage("./data/images/img"+n+".jpg");
  //Make the image proportional to the new height
  img.resize(imageHeight*img.width/img.height, imageHeight);
  size(img.width,img.height); 
}

void loadMusic()
{
  int songIndex = (int) random(songCount);
  
  minim = new Minim(this);
  player = minim.loadFile("./data/songs/song"+songIndex+".mp3"); 
  //player = minim.loadFile("./data/songs/song5.mp3");
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
