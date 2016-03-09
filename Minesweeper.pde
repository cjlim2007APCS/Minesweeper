

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i=0;i<NUM_ROWS;i++) {
        for (int j=0;j<NUM_COLS;j++) {
            buttons[i][j] = new MSButton(i,j);
        }
    }
    for (int b=0; b<(int)(Math.sqrt(NUM_ROWS*NUM_COLS))*2; b++)
    setBombs();
}
public void setBombs()
{
    int x = (int)(Math.random()*20);
    int y = (int)(Math.random()*20);
    if (bombs.contains(buttons[x][y])==false) {
        bombs.add(buttons[x][y]);
    } else {
        setBombs();
    }
}

public void draw ()
{
    background( 0 );
    if(isWon()) {
        displayWinningMessage();
        noLoop();
    }
}
public boolean isWon()
{
    int win=0;
    for (int i=0;i<NUM_ROWS;i++)
        for (int j=0;j<NUM_COLS;j++)
            if((buttons[i][j].isMarked()==true&&bombs.contains(buttons[i][j])==true) || buttons[i][j].isClicked()==true && !(buttons[i][j].isMarked()==true&&bombs.contains(buttons[i][j])==false))
                win++; 
    if (win==(NUM_ROWS*NUM_COLS)) {
        return true;
    }

    return false;
}
public void displayLosingMessage()
{
    for (int i=0;i<NUM_ROWS;i++)
        for (int j=0;j<NUM_COLS;j++)
            if(bombs.contains(buttons[i][j])==true)
                buttons[i][j].clicked=true;
    String loseMessage="you lose";
    for(int i=0; i<loseMessage.length();i++)
        buttons[10][i+6].setLabel(loseMessage.substring(i,i+1));
    noLoop();
}
public void displayWinningMessage()
{
    String winMessage="you win";
    for(int i=0; i<winMessage.length();i++)
        buttons[10][i+6].setLabel(winMessage.substring(i,i+1));
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc;
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (keyPressed==true && buttons[r][c].isMarked()==false) {
            buttons[r][c].marked=true;
        } else if (keyPressed==true && buttons[r][c].isMarked()==true){
            buttons[r][c].marked=false;
        } else if (bombs.contains(this)&&buttons[r][c].isMarked()==false) {
            displayLosingMessage();
        }
        if (countBombs(r,c)==0) {
            for(int y=-1;y<=1;y++) {
                for(int x=-1;x<=1;x++) {
                    if((x!= 0 || y!= 0) && isValid(x+r,y+c) && buttons[x+r][y+c].isClicked()==false  && buttons[x+r][y+c].isMarked()==false)
                        buttons[x+r][y+c].mousePressed();
                    }
                }
        } else {
            setLabel(str(countBombs(r,c)));
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) )
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r>=0&&r<=NUM_ROWS-1&&c>=0&&c<=NUM_COLS-1) {
            return true;
        } else {
            return false;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int tea = -1; tea <= 1; tea++) {
            for (int eggplant = -1; eggplant <= 1; eggplant++) {
                if (isValid(row+eggplant,col+tea)&&bombs.contains(buttons[row+eggplant][col+tea]))
                    numBombs++;
            }
        }
        return numBombs;
    }
}



