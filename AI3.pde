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
      cells[xOffset][yOffset] = new GridCell(gridCellSize, xOffset * gridCellSize, 
        yOffset * gridCellSize, random(0, 1) > 0.0, false, false);
      cells[xOffset][yOffset].currentColour = random(0, 1) > 0.0 ? color(255) : color(0);
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
  
  println("First");
  
  while (currentIteration < maxIterations)
  {
    currentIteration ++;
    int lowestFCost = open.get(0).fCost;
    //Set current to lowest fCost
    for (int i = 0; i < open.size(); i++)
    {
      if (open.get(i).fCost < lowestFCost)
      {
        lowestFCost = open.get(i).fCost;
        current = open.get(i);
      }
    }
    
    //println(open.size());

    removeNodeFromOpen(current);
    closed.add(current);
    
    //println(open.size());
    
    if (current.isEnd)
    {
      print("Finished pathfinding");
      finishedPathfinding = true;
      break;
    }
    
    //current.currentColour = color(100, 200, 255);
    
    int xIndex = current.xPos/current.size;
    int yIndex = current.yPos/current.size;
    
    GridCell[] neighbours = {
      yIndex + 1 >= gridSize ? null : cells[xIndex][yIndex + 1],
      yIndex - 1 < 0 ? null : cells[xIndex][yIndex - 1],
      xIndex - 1 < 0 ? null : cells[xIndex - 1][yIndex],
      xIndex + 1 >= gridSize ? null : cells[xIndex + 1][yIndex]
    };
    
    for (int i = 0; i < 4; i++)
    {
      GridCell currentNeighbour = neighbours[i];
      if (currentNeighbour == null || 
        isNodeInClosed(currentNeighbour) || 
        !currentNeighbour.isTraversable)
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
          println("Added new node to open");
          open.add(currentNeighbour);
        }
      }
    }
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
