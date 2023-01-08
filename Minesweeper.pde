import javax.swing.JOptionPane;
import java.util.Random;
import javax.swing.JDialog;
import javax.swing.JFrame;

Cell[][] grid;
int cols;
int rows;
int w = 20;
int revealed;
int totalCells;
int totalBees;

int minBeesMultiplier = 6;
int maxBeesMultiplier = 7;

void setup() {
  //fullScreen();
  size(600, 600);
  cols = floor(width / w);
  rows = floor(height / w);
  totalBees = floor((cols * rows) / getRandomNumberInRange(minBeesMultiplier, maxBeesMultiplier));
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = new Cell(i, j, w);
    }
  }

  // Pick totalBees spots
  ArrayList<int[]> options = new ArrayList<int[]>();

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int[] option = new int[2];
      option[0] = i;
      option[1] = j;
      options.add(option);
    }
  }


  for (int n = 0; n < totalBees; n++) {
    int index = floor(random(options.size()));
    int[] choice = options.get(index);
    int i = choice[0];
    int j = choice[1];
    // Deletes that spot so it's no longer an option
    options.remove(index);
    grid[i][j].bee = true;
  }


  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].countBees();
    }
  }
}

void gameOver() {
  int n;
  revealingStuff();
  if (totalCells - revealed == totalBees) {
    n = JOptionPane.showConfirmDialog(frame, "You won! - Replay?", "", JOptionPane.YES_NO_OPTION);
  } else {
    n = JOptionPane.showConfirmDialog(frame, "You lose! - Replay?", "Replay - losing", JOptionPane.YES_NO_OPTION);
  }
  if (n == 0) {
    setup();
  } else {
    exit();
  }
}

void revealingStuff() { 
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].revealed = true;
    }
  }
}

private static int getRandomNumberInRange(int min, int max) {
  int temp;
  if (min >= max) {
    temp = min;
    min = max;
    max = temp;
  }
  if (min == max) {
    return max;
  } else {
    Random r = new Random();
    return r.nextInt((max - min) + 1) + min;
  }
}

void mousePressed() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j].contains(mouseX, mouseY)) {
        grid[i][j].reveal();

        for (int x = 0; x < cols; x++) {
          for (int y = 0; y < rows; y++) {

            totalCells++;

            if (grid[x][y].revealed == true && grid[x][y].bee == false) {
              revealed++;
            }
          }
        }
        /*System.out.println(totalCells);
         System.out.println(revealed);
         System.out.println(totalBees);
         System.out.println(totalCells - revealed == totalBees);*/
        if (grid[i][j].bee || totalCells - revealed == totalBees) {
          gameOver();
        }
        totalCells = 0;
        revealed = 0;
      }
    }
  }
}

void draw() {
  background(255);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].show();
    }
  }
}
