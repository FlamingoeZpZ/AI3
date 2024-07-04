int gridSize = 10;
int gridCellSize = 20;
GridCell[][] cells;

ArrayList<GridCell> closed;
ArrayList<GridCell> open;

void setup()
{
  size(500, 500);
  background(255, 0, 0);
  
  cells = new GridCell[gridSize][gridSize];
  visited = new ArrayList<GridCell>();
  
  for (int xOffset = 0; xOffset < gridSize; xOffset++)
  {
    for (int yOffset = 0; yOffset < gridSize; yOffset++)
    {
      cells[xOffset][yOffset] = new GridCell(gridCellSize, xOffset * gridCellSize, 
        yOffset * gridCellSize, random(0, 1) > 0.2, false, false);
      cells[xOffset][yOffset].currentColour = random(0, 1) > 0.2 ? color(255) : color(0);
    }
  }
  
  int xIndex = (int)random(2, gridSize - 1);
  int yIndex = (int)random(2, gridSize - 1);
    
  cells[xIndex][yIndex].isEnd = true;
  cells[xIndex][yIndex].isTraversable = true;
  cells[xIndex][yIndex].currentColour = color(0, 255, 0);
  
  cells[1][1].isStart = true;
  cells[1][1].currentColour = color(0, 0, 255);
  visited.add(cells[1][1]);
  
  //pathfind(1, 1, 1, 1, xIndex, yIndex);
}

int manhattanDistance(int xIndex1, int yIndex1, int xIndex2, int yIndex2)
{
  int finalXIndex = abs(xIndex1 - xIndex2);
  int finalYIndex = abs(yIndex1 - yIndex2);
  
  return finalXIndex + finalYIndex;
}

boolean isNodeInVisited(int xIndex, int yIndex)
{
  for(int i=0; i<visited.size();i++)
  {
    boolean found = (xIndex == visited.get(i).xPos/gridCellSize) && 
      (yIndex == visited.get(i).yPos/gridCellSize);
    if(found)
    {
      return true;
    }
  }
  return false;
}

void pathfind(int xIndex, int yIndex, int startXIndex, int startYIndex, 
  int destXIndex, int destYIndex)
{
  if ((xIndex == destXIndex) && (yIndex == destYIndex))
  {
    print("Finished pathfinding");
    return;
  }
  
  cells[xIndex][yIndex].currentColour = color(100);
  
  GridCell[] neighbours = {
    yIndex + 1 >= gridSize ? null : cells[xIndex][yIndex + 1],
    yIndex - 1 < 0 ? null : cells[xIndex][yIndex - 1],
    xIndex - 1 < 0 ? null : cells[xIndex - 1][yIndex],
    xIndex + 1 >= gridSize ? null : cells[xIndex + 1][yIndex]
  };
  
  int lowestFCost = Integer.MAX_VALUE;
  int lowestFCostXIndex = 0;
  int lowestFCostYIndex = 0;
  
  for (int i = 0; i <neighbours.length; i++)
  {
    if (neighbours[i] == null) 
    {
      continue;
    }
    GridCell currentNeighbour = neighbours[i];
    int currentNeighbourXIndex = currentNeighbour.xPos/gridCellSize;
    int currentNeighbourYIndex = currentNeighbour.yPos/gridCellSize;
    
    if (isNodeInVisited(currentNeighbourXIndex, currentNeighbourYIndex))
    {
      continue;
    }
    
    int gCost = manhattanDistance(currentNeighbourXIndex, currentNeighbourYIndex, 
      startXIndex, startYIndex);
    int hCost = manhattanDistance(currentNeighbourXIndex, currentNeighbourYIndex, 
      destXIndex, destYIndex);
    int fCost = gCost + hCost;
    
    currentNeighbour.SetFCost(fCost);
    visited.add(currentNeighbour);
    
    if (fCost < lowestFCost)
    {
      lowestFCost = fCost;
      lowestFCostXIndex = currentNeighbourXIndex;
      lowestFCostYIndex = currentNeighbourYIndex;
    }
  }
  
  pathfind(lowestFCostXIndex, lowestFCostYIndex, 
    startXIndex, startYIndex, destXIndex, destYIndex);
  println("Took step");
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
