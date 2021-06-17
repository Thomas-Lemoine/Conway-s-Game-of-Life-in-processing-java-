int rows, cols;
float gap_x, gap_y;
int[][] grid;
int lastClickCol, lastClickRow;
boolean runGameOfLife;

void setup(){
  size(800,800);
  background(0);
  cols = 200;
  rows = 200;
  gap_x = (float) width / cols;
  gap_y = (float) height / rows;
  grid = new int[cols][rows];
}

void updateGrid(){
  int[][] numNeighbors = new int[cols][rows];
  //first, each node's #neighbors
  for(int col = 0; col<cols; col++){
    for(int row = 0; row<rows; row++){
      numNeighbors[col][row] = numAliveNeighbors(grid, col, row);
    }
  }   
for(int col = 0; col < cols; col++){
    for(int row = 0; row < rows; row++){
      if ((grid[col][row] == 1) && (numNeighbors[col][row] == 2 || numNeighbors[col][row] == 3)){
        grid[col][row] = 1;
      }else if((grid[col][row] == 0) && (numNeighbors[col][row] == 3)) grid[col][row] = 1;
      else grid[col][row] = 0;
    }
  }
}

int numAliveNeighbors(int[][] grid, int col, int row){
  boolean someOutOfBounds = false;
  int neighborsAlive = 0;
  for(int i = -1; i<=1; i++){
    for(int j = -1; j<=1; j++){
      if(!(i == 0 && j == 0) && !(isOutOfBounds(i+col, j+row))){
        neighborsAlive = neighborsAlive + grid[col+i][row+j];
      }
      if (isOutOfBounds(i+col, j+row)) someOutOfBounds = true;
    }
   
  }
 if (someOutOfBounds){

   if ((col == 0) && (row == 0)){
     neighborsAlive += grid[cols-1][rows-1];
     neighborsAlive += grid[cols-1][0];
     neighborsAlive += grid[cols-1][1];
     neighborsAlive += grid[0][rows-1];
     neighborsAlive += grid[1][rows-1];
   }
   else if ((col == 0) && (row == rows - 1)){
     neighborsAlive += grid[cols-1][0];
     neighborsAlive += grid[cols-1][rows-1];
     neighborsAlive += grid[cols-1][rows-2];
     neighborsAlive += grid[0][0];
     neighborsAlive += grid[1][0];
   }
   else if ((col == cols - 1) && (row == 0)){
     neighborsAlive += grid[0][rows-1];
     neighborsAlive += grid[cols-1][rows-1];
     neighborsAlive += grid[cols-2][rows-1];
     neighborsAlive += grid[0][0];
     neighborsAlive += grid[0][1];
   }
   else if ((col == cols - 1) && (row == rows - 1)){
     neighborsAlive += grid[0][0];
     neighborsAlive += grid[cols-1][0];
     neighborsAlive += grid[cols-2][0];
     neighborsAlive += grid[0][rows-1];
     neighborsAlive += grid[0][rows-2];
   }
   else if (col == 0){
     neighborsAlive += grid[cols-1][row-1];
     neighborsAlive += grid[cols-1][row];
     neighborsAlive += grid[cols-1][row+1];
   }
   else if (col == cols - 1){
     neighborsAlive += grid[0][row-1];
     neighborsAlive += grid[0][row];
     neighborsAlive += grid[0][row+1];
   }
   else if (row == 0){
     neighborsAlive += grid[col-1][rows-1];
     neighborsAlive += grid[col][rows-1];
     neighborsAlive += grid[col+1][rows-1];
   }
   else if (row == rows - 1){
     neighborsAlive += grid[col-1][0];
     neighborsAlive += grid[col][0];
     neighborsAlive += grid[col+1][0];
   }
 }
return neighborsAlive;
}

boolean isOutOfBounds(int col_neighbor, int row_neighbor) {
  return (col_neighbor < 0 || col_neighbor > cols-1 || row_neighbor < 0 || row_neighbor > rows-1);
}

void draw(){
  noStroke();
  background(255);
  if (runGameOfLife){
  updateGrid();
  }
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      fill(updateColor(grid[col][row]));
      rect(col*gap_x, row*gap_y, gap_x, gap_y);
    }
  }
}

void mouseDragged(){
  colRowFromClick();
  if (colRowInRange()){
    if (mouseButton == LEFT){
      grid[lastClickCol][lastClickRow] = 1;
    }else if (mouseButton == RIGHT){
      grid[lastClickCol][lastClickRow] = 0;
    }
  }
}

void mousePressed(){
  colRowFromClick();
  if (colRowInRange()){
    if (mouseButton == LEFT){
      grid[lastClickCol][lastClickRow] = 1;
    }else if (mouseButton == RIGHT){
      grid[lastClickCol][lastClickRow] = 0;
    }
  }
}

void keyPressed(){
  if(key==' '){
    runGameOfLife = runGameOfLife ? false : true;
  }
}

void colRowFromClick(){
  lastClickCol = (int)((float)mouseX/gap_x);
  lastClickRow = (int)((float)mouseY/gap_y); 
}

boolean colRowInRange(){
  return (!((lastClickCol < 0) || (lastClickCol >= cols) || (lastClickRow < 0) || (lastClickRow >= rows)));
}


color updateColor(int state){
  if (state == 0){
    return color(64);
  }else {
    return color(255);
  }
}
