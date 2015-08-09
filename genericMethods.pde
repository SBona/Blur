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
  //pause with spacebar
  if (key == 32)
  {
    if (player.isPlaying())
    {
      player.pause();
    } else
    {
      player.play();
    }
  }
  //r
  if (key == 114)
  {
    player.rewind();
  }
  //m
  if (key == 109)
  {
    player.mute();
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

  /*fill(255, 0, 0);
   stroke(255, 0, 0);
   int textSize = 9;
   textAlign(CENTER);
   textSize(textSize);
   text(player.getMetaData().title(), width/2, (height/2)-textSize);
   text(player.getMetaData().album(), width/2, height/2 );
   text(player.getMetaData().author(), width/2, (height/2)+textSize);*/

  //stext("Image: "+imageIndex, textSize, textSize);
}
void updateMaxAverages()
{
  for (int i = 0; i < maxAverages.length; i++) 
  {
    if (fft.getAvg(i) > maxAverages[i]) 
    {
      maxAverages[i] = fft.getAvg(i);
    }
  }
}
void printInfo()
{
  println();
  for (int i = 1; i < fft.avgSize (); i+= 5)
  {
    print(i+":"+ ((int)fft.getAvg(i))+" - ");
  }
}
void loadMusic()
{
  minim = new Minim(this);
  try 
  {
    int songIndex = (int) random(songCount);
    player = minim.loadFile("./data/songs/song"+songIndex+".mp3");
  } 
  catch(NullPointerException e) {
    println("Null Pointer, default to song1");
    player = minim.loadFile("./data/songs/song1.mp3");
  }
  //player = minim.loadFile("./data/songs/song1.mp3");
  fft = new FFT(player.bufferSize(), player.sampleRate());

  //fft.logAverages(starting frequency?, how many values each octave is cut up into);
  //standard fouriet
  fft.logAverages(60, 7);
  //more samples = smoother circle visuals
  //fft.logAverages(2, 16);
  player.play();
}
