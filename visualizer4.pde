
void visualizer4()
{

  int lineWidth = width/(fft.avgSize()/4);
  strokeWeight(lineWidth);
  strokeCap(SQUARE);


  for (int i = 0; i < fft.avgSize (); i++)
  {
    int lineLength = (int) map(fft.getAvg(i), 0, maxAverages[i], 0, 10);
    color thisColor = color(map(fft.avgSize()-i, 0, fft.avgSize(), 0, 255), 50, map(i, 0, fft.avgSize(), 0, 255));
    stroke(thisColor);

    if (i < (fft.avgSize()/4))
    {

      line(i*lineWidth, height, i*lineWidth, height-lineLength);
    } else if ( i < (2*(fft.avgSize()/4)))
    {
      int adjustedI = (int) map(i, fft.avgSize()/4, 2*(fft.avgSize()/4), fft.avgSize()/4, 0);
      line(width, adjustedI*lineWidth, width-lineLength, adjustedI*lineWidth);
    } else if ( i < (3*(fft.avgSize()/4)))
    {
      int adjustedI = (int) map(i, fft.avgSize()/2, 3*(fft.avgSize()/4), 0, fft.avgSize()/4);

      line(width -(adjustedI*lineWidth), 0, width-(adjustedI*lineWidth), lineLength);
    } else
    {
      int adjustedI = (int) map(i, 3*(fft.avgSize()/4), fft.avgSize(), 0,fft.avgSize()/4);
      line(0, adjustedI*lineWidth, lineLength, adjustedI*lineWidth);
    }
  }
}

