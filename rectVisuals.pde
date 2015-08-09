void loadImages()
{
  int n = (int) random(imageCount-1)+1;
  try
  {
    img = loadImage("./data/images/img"+n+".jpg");
  }
  catch (NullPointerException e)
  {
    img = loadImage("./data/Images/img1.jpg");
  }
  //Make the image proportional to the new height
  img.resize(imageHeight*img.width/img.height, imageHeight);
  //size(img.width, img.height);
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
}
