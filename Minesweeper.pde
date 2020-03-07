import de.bezier.guido.*;
int nRows = 20;
int nCols = 20;
int nMines = 50;
int count = 0;
int flagCount;
boolean isLose = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private MSButton reset;
float scale;

    PImage oneCell = loadImage("https://i.imgur.com/1EAQ64u.png");
    PImage twoCell = loadImage("https://i.imgur.com/GUeKBvk.png");
    PImage threeCell = loadImage("https://i.imgur.com/8gI7pLc.png");
    PImage fourCell = loadImage("https://i.imgur.com/K3j2AQc.png");
    PImage cellBlock = loadImage("https://i.imgur.com/CyLGDyD.png");
    PImage flagImage = loadImage("https://i.imgur.com/Eh6UTfT.png");
    PImage explodeImage = loadImage("https://i.imgur.com/pV5LWLE.png");
    PImage controlBoard = loadImage("https://i.imgur.com/oafIzyC.png");
    PImage smiley = loadImage("https://i.imgur.com/CbB2BVn.png");

int boardW = controlBoard.width;
int boardH = controlBoard.height;

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    flagCount = nMines;
    
    //your code to initialize buttons goes her
    buttons = new MSButton[nRows][nCols];
    reset = new MSButton(1,1);
    reset.setButton(287,14,32,32);
    reset.gridButton = false;

    for(int r = 0; r < nRows; r++)
    {
        for(int c = 0; c < nCols; c++)
        {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    setMines();
}
public void setMines()
{
    int counter = 0;
    int rR = (int)(Math.random()*nRows);
    int cC = (int)(Math.random()*nCols);
    MSButton target = buttons[rR][cC];
    
    while(counter < nMines || !mines.contains(target))
    {
        rR = (int)(Math.random()*nRows);
        cC = (int)(Math.random()*nCols);
        target = buttons[rR][cC];
        counter++;
        mines.add(target);
        //println(rR,cC,counter);
    }
    for(int i = 0; i<mines.size(); i++)
        {
            mines.get(i).clicked = false;
        }

}


public void draw ()
{
    background( 0 );
    scale = .58;
    image(controlBoard,0,0,(boardW*scale),(boardH*scale));
    if(reset.clicked)
    {
        clear();
        setup();
    }
    image(smiley, 287,14,32,32);

    if(isLose)
    {
        textMode(CENTER);
        fill(color(255,0,0));
        textSize(32);
        text(" YOU      LOST", 303,30);
    }
    textMode(CENTER);
    fill(color(255,0,0));
    textSize(20);
    text(flagCount, 42, 28);

    for(int row = 0; row < nRows; row ++)
    {
        for(int col = 0; col < nCols; col++)
        {
            if(buttons[row][col].isClicked() || buttons[row][col].flagged)
                count++;
        }
    }
    if(count == nRows*nCols)
    {
        textMode(CENTER);
        fill(color(0,255,0));
        textSize(32);
        text(" YOU      WIN", 303,30);
    }
    else 
    {
        count = 0;
    }

}

public boolean isValid(int r, int c)
{
    if(r < nRows  && r >= 0)
  {
    if(c < nCols && c >= 0)
      return true;
    return false;
  }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = -1; i <= 1; i ++)
    {
        for(int k = -1; k <= 1 ; k ++)
        {
            if(isValid(row + i, col + k) && mines.contains(buttons[row+i][col+k]) && !(row == 0 && col == 0) )
                numMines++;
        }
  }
  //println(numMines);
  return numMines;
}


public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, gridButton;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/nCols;
        height = 547/nRows;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height+62;
        myLabel = "";
        flagged = clicked = false;
        gridButton = true;
        Interactive.add( this ); 
    }

    // called by manager
    public void mousePressed ()
    {
        if(gridButton)
        {
            if(mouseButton == LEFT)
            {
                clicked = true;
            
                if(countMines(myRow,myCol) > 0 && !mines.contains(buttons[myRow][myCol]))
                {
                    setLabel(countMines(myRow,myCol));
                }
                else
                {
                    if(countMines(myRow,myCol) == 0)
                    {
                        if(isValid(myRow,myCol-1) && !buttons[myRow][myCol-1].isClicked())
                            buttons[myRow][myCol-1].mousePressed();
                        if(isValid(myRow,myCol+1) && !buttons[myRow][myCol+1].isClicked())
                            buttons[myRow][myCol+1].mousePressed();
                        if(isValid(myRow+1,myCol) && !buttons[myRow+1][myCol].isClicked())
                            buttons[myRow+1][myCol].mousePressed();
                        if(isValid(myRow-1,myCol) && !buttons[myRow-1][myCol].isClicked())
                            buttons[myRow-1][myCol].mousePressed();
                        if(isValid(myRow+1,myCol-1) && !buttons[myRow+1][myCol-1].isClicked())
                            buttons[myRow+1][myCol-1].mousePressed();
                        if(isValid(myRow-1,myCol+1) && !buttons[myRow-1][myCol+1].isClicked())
                            buttons[myRow-1][myCol+1].mousePressed();
                        if(isValid(myRow+1,myCol+1) && !buttons[myRow+1][myCol+1].isClicked())
                            buttons[myRow+1][myCol+1].mousePressed();
                        if(isValid(myRow-1,myCol-1) && !buttons[myRow-1][myCol-1].isClicked())
                            buttons[myRow-1][myCol-1].mousePressed();
                    }
                }
                

            }
            else if(mouseButton == RIGHT && !clicked && flagCount > 0)
            {
                if(flagged)
                    flagCount++;
                else
                    flagCount --;
                flagged = !flagged;
            }
            else  
            {
                
            }
        }
        else 
        {
            if(mouseButton == LEFT)
                clicked = true;    
        }
    }
    public void draw () 
    {  
                if (flagged)
                    {
                        image(flagImage,x,y,width,height);
                    }
                else if( clicked && mines.contains(this) )
                    { 
                        isLose = true;
                        image(explodeImage,x,y,width,height);
                        for(int i = 0; i<mines.size(); i++)
                        {
                            mines.get(i).clicked = true;
                        }

                    }
                else if(clicked)
                    {
                        fill(color(190,191,186));
                        stroke(123, 123, 123);
                        rect(x,y,width,height);
                        if(myLabel.equals("1"))
                            image(oneCell,x,y,width,height);
                        else if(myLabel.equals("2"))
                            image(twoCell,x,y,width,height);
                        else if(myLabel.equals("3"))
                            image(threeCell,x,y,width,height);
                        else if(myLabel.equals("4"))
                            image(fourCell,x,y,width,height);
                    }
                    else    
                        image(cellBlock,x,y,width,height);
           
        image(smiley, 287,14,32,32);
        
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void setButton(int xx, int yy, int wide, int tall)
    {
        x =xx;
        y = yy;
        width = wide;
        height = tall;
    }
}


