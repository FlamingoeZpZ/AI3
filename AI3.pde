int gridSize = 10;
int gridCellSize = 20;
GridCell[][] cells;

ArrayList<GridCell> closed;
ArrayList<GridCell> open;

int maxIterations = 1000;
int currentIteration = 0;
boolean finishedPathfinding;

void setup()
{
  size(500, 500);
  background(255, 0, 0);
  
  cells = new GridCell[gridSize][gridSize];
  open = new ArrayList<GridCell>();
  closed = new ArrayList<GridCell>();
  
  for (int xOffset = 0; xOffset < gridSize; xOffset++)
  {
    for (int yOffset = 0; yOffset < gridSize; yOffset++)
    {
      boolean rng = random(1) >= 0.2;
      cells[xOffset][yOffset] = new GridCell(gridCellSize, xOffset * gridCellSize, 
        yOffset * gridCellSize, rng, false, false);
      cells[xOffset][yOffset].currentColour = rng ? color(255) : color(0);
    }
  }
  
  int endXIndex = (int)random(2, gridSize - 1);
  int endYIndex = (int)random(2, gridSize - 1);
  
  GridCell end = cells[endXIndex][endYIndex];
  end.isEnd = true;
  end.isTraversable = true;
  end.currentColour = color(0, 255, 0);
  
  GridCell start = cells[1][1];
  start.isStart = true;
  start.currentColour = color(0, 0, 255);
  open.add(start);
  
  GridCell current = start;
  current.SetFCost(0, null);
    
  while (currentIteration < maxIterations)
  {
    currentIteration ++;
    
    int lowestFCost = open.get(0).fCost;
    
    
    //Set current to lowest fCost
    //Iterate through all open nodes
    for (int i = 1; i < open.size(); i++)
    {
      //If the open node has a lower FCost
      if (open.get(i).fCost < lowestFCost)
      {
        //use that node and set it as best
        lowestFCost = open.get(i).fCost;
        current = open.get(i);
      }
    }
    
    //println(open.size());
    
    //Remove the current node from the open and add it to closed
    removeNodeFromOpen(current);
    closed.add(current);
   
    
    //println(open.size());
    
    //Check if the current is the end
    if (current.isEnd)
    {
      finishedPathfinding = true;
      break;
    }
    
    //current.currentColour = color(100, 200, 255);
    
    //Find the best distance
    int xIndex = current.xPos/current.size;
    int yIndex = current.yPos/current.size;
    
    //println("(" +  xIndex +  "," + yIndex + ")");
    
    //Gather the neighbouring cells
    GridCell[] neighbours = {
      //Go up? one, if it is not in bounds, null else choose cell
      yIndex + 1 >= gridSize ? null : cells[xIndex][yIndex + 1],
      //Go down
      yIndex - 1 < 0 ? null : cells[xIndex][yIndex - 1],
      //Go left
      xIndex - 1 < 0 ? null : cells[xIndex - 1][yIndex],
      //Go right
      xIndex + 1 >= gridSize ? null : cells[xIndex + 1][yIndex]
    };
    
    //Iterate through each neigbour
    for (int i = 0; i < neighbours.length; i++)
    {
      //Cache the currentNeighbour
      
      GridCell currentNeighbour = neighbours[i];
      if (currentNeighbour == null || //if it's null
        isNodeInClosed(currentNeighbour) || //or it's already visited
        !currentNeighbour.isTraversable) // or not traversable
      {
        continue;
      }
      
      int gCost = manhattanDistance(currentNeighbour, start);
      int hCost = manhattanDistance(currentNeighbour, end);
      int fCost = gCost + hCost;
      
      if (!isNodeInOpen(currentNeighbour) || currentNeighbour.fCost > fCost)
      {
        currentNeighbour.SetFCost(fCost, current);
        if (!isNodeInOpen(currentNeighbour))
        {
          open.add(currentNeighbour);
        }
      }
    }
    if(open.size() == 0)
    {
      return;
    }
    current = open.get(0);
  }
  current = end;
  
  if(!finishedPathfinding) return;
  
  while(!current.isStart)
  {
    current = current.from;
    current.currentColour = color(255,255,0);
  }
}

int manhattanDistance(GridCell a, GridCell b)
{
  int finalXIndex = abs(a.xPos/a.size - b.xPos/b.size);
  int finalYIndex = abs(a.yPos/a.size - b.yPos/b.size);
  
  return finalXIndex + finalYIndex;
}

void removeNodeFromOpen(GridCell cell)
{
  for(int i=0; i<open.size();i++)
  {
    //println(cell.xPos + " " + cell.yPos);
    //println(open.get(i).xPos + " " + open.get(i).yPos);
    
    boolean found = (cell.xPos == open.get(i).xPos) && (cell.yPos == open.get(i).yPos);
    if(found)
    {
      println("Removed");
      open.remove(i);
    }
    
    //println("Didn't find cell in open list");
  }
}

boolean isNodeInOpen(GridCell cell)
{
  for(int i=0; i<open.size();i++)
  {
    boolean found = (cell.xPos == open.get(i).xPos) && 
      (cell.yPos == open.get(i).yPos);
    if(found)
    {
      return true;
    }
  }
  return false;
}

boolean isNodeInClosed(GridCell cell)
{
  for(int i=0; i<closed.size();i++)
  {
    boolean found = (cell.xPos == closed.get(i).xPos) && 
      (cell.yPos == closed.get(i).yPos);
    if(found)
    {
      return true;
    }
  }
  return false;
}

void draw()
{
  for (int i = 0; i < gridSize; i++)
  {
    for (int v = 0; v < gridSize; v++)
    {
      cells[i][v].Render();
    }
  }
}
