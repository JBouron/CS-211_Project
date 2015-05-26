public class RunnableSobel implements Runnable {
  int id;
  int starting_row;
  int ending_row;
  PImage original_image;
  PImage result_image;
  int width;
  int height;
  int threshold;

  int[][] kernelX= {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
  int[][] kernelY= {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

  public RunnableSobel(int id, int starting_row, int ending_row,
      PImage original_image, PImage result_image, int width,
      int height) {
    super();
    this.id = id;
    this.starting_row = starting_row;
    this.ending_row = ending_row;
    this.original_image = original_image;
    this.result_image = result_image;
    this.width = width;
    this.height = height;
    this.threshold = threshold;
    
  }

  @Override
  public void run() {
    float max = 0;
    for (int y = starting_row; y < ending_row; y++) {
      for (int x = 0; x < width; x++) {
        int convResultX = 0;
        int convResultY = 0;

        for (int i = 0; i <= 2; i++) {
          for (int j = 0; j <= 2; j++) {
            int clampedX = x + i - 1;
            if (x + i - 1 < 0) {
              clampedX = 0;
            } else if (x + i - 1 >= width) {
              clampedX = width - 1;
            }

            int clampedY = y + j - 1;
            if (y + j - 1 < 0) {
              clampedY = 0;
            } else if (y + j - 1 >= height) {
              clampedY = height - 1;
            }

            convResultX += original_image.pixels[clampedY * width + clampedX]
                * kernelX[i][j];
            convResultY += original_image.pixels[clampedY * width + clampedX]
                * kernelY[i][j];
          }
        }

        if (Math.abs(convResultX) + Math.abs(convResultY) > threshold) {
          result_image.pixels[y * width + x] = color(255, 255, 255);
        } else {
          result_image.pixels[y * width + x] = color(0, 0, 0);
        }
      }
    }
    result_image.updatePixels();
  }
}
