float positionX, positionZ; 
int facing = 0;
int VISIBLE = 10;

boolean wrap = false;
boolean animate = false;
float angle = 0;

float startTime; // stores the time when any key has been pressed 
boolean wPressed; 
boolean sPressed; 
boolean aPressed; 
boolean dPressed; 

float nineDegree =1.5708;

PImage floorTexture, wallTexture, floorTexture2;
PImage exhibit1, exhibit2, exhibit3, exhibit4 ; 
PShape globeTex; 
PShape globeTex2; 

//exhibit locations 
int[][] firExLoc = new int[60][2];
int[][] secExLoc = new int[60][2];
int[][] thirExLoc= new int[60][2];
int[][] fourExLoc= new int[60][2];

//exhibit animation variables 
float ex1TranX = 0.0;
float ex1Xspeed = 0.01;
float ex2Angle = 0.0;
float ex3Angle =0.0;
float ex4Angle =0.0; 
float ex4TranX = 0.01;
float ex4XSpeed = 0.01;

//avatar animation variables
float avatarTrans = 0.0;
float avatarSpeed =0.01;

//Free look and move 
float freeX =0; 
float freeY =0;

//if mouseDragged 
boolean isDragged = false;

//turn light on 
boolean lightOn = false;


void setup() {
  size(800, 640, P3D);
  colorMode(RGB, 1);


//these four loops calculate the exhibit locations 
  int rowMul =-1; 
  int colMul = -1; 
  for (int i=0; i<60; i++) {
    colMul++; 
    if (i%6 == 0) {
      rowMul++;       
      colMul = 0;
    }   
    firExLoc[i][0] = (rowMul*6)-27; 
    firExLoc[i][1] = (colMul*10)-28;

    if (colMul>=3)
      firExLoc[i][1]++;
  }
  
  rowMul =-1; 
  colMul =-1; 
  for (int i=0; i<60; i++) {
    colMul++; 
    if (i%6 == 0) {
      rowMul++;       
      colMul = 0;
    }   
    secExLoc[i][0] = (rowMul*6)-27; 
    secExLoc[i][1] = (colMul*10)-23;

    if (colMul>=3)
      secExLoc[i][1]++;
  }


  rowMul =-1; 
  colMul =-1; 
  for (int i=0; i<60; i++) {
    colMul++; 
    if (i%6 == 0) {
      rowMul++;       
      colMul = 0;
    }   
    thirExLoc[i][0] = (rowMul*6)-24; 
    thirExLoc[i][1] = (colMul*10)-28;
    
    if (colMul>=3)
      thirExLoc[i][1]++;
  }


  rowMul =-1; 
  colMul =-1; 
  for (int i=0; i<60; i++) {
    colMul++; 
    if (i%6 == 0) {
      rowMul++;       
      colMul = 0;
    }   
    fourExLoc[i][0] = (rowMul*6)-24; 
    fourExLoc[i][1] = (colMul*10)-23;

    if (colMul>=3)
      fourExLoc[i][1]++;
  }


 frustum(-float(width)/height, float(width)/height, 1, -1, 2, 9);
 resetMatrix();

  textureMode(NORMAL);  
  floorTexture = loadImage("assets/floor.jpg");
  floorTexture2 = loadImage("assets/exhibitFloor.jpg");
  wallTexture = loadImage("assets/wall.jpg");
  exhibit1 = loadImage("assets/exhibit1.jpg");
  exhibit2 = loadImage("assets/exhibit2.jpg"); 
  exhibit3 = loadImage("assets/exhibit3.jpg");
  exhibit4 = loadImage("assets/exhibit4.jpg");
  textureWrap(REPEAT);

  noStroke();
  noFill();
  globeTex = createShape(SPHERE,0.4);
  globeTex.setTexture(exhibit3);
  globeTex2 = createShape(SPHERE, 0.45);
  globeTex2.setTexture(exhibit4);

}

void draw() {
  background(0, 0, 0);
  
 // changing view 
 // 1: normal 2: third person view 
  if(key =='1'){
    frustum(-float(width)/height, float(width)/height, 1, -1, 2, 9);
  } else if(key == '2'){
    frustum(-float(width)/height, float(width)/height, 1, -1, 1, 9);
  }
   
  angle %= 6.2832; 
 
  drawAvatar();
  
 if(wPressed)  
 {
  avatarTrans += avatarSpeed;
  
   if(avatarTrans >= 0.1 || avatarTrans<0)
   {
    avatarSpeed = avatarSpeed*-1; 
   }
 }


// view
rotateY(angle);  
translate(0, -1, 0);

//free look and move 
 rotateX(freeX);
 rotateY(freeY);
    
if(aPressed || dPressed){
 freeX =0;
 freeY =0;
}
   
  noStroke();
  noFill();

wsKeyPressed();
facingAngle();

translate(-positionX, 0, -positionZ);

 
// when 'l' key pressed, lights on  
if(lightOn){
  ambient(0.7,0.7,0.7);

 if(facing ==0){
     pointLight(0.8, 0.8, 0.8, positionX , -1, positionZ-3);
     directionalLight(0.7, 1, 0.7, positionX, 3, positionZ+20);
 }else if(facing ==1){    
     pointLight(0.8, 0.8, 0.8, positionX-3 , -1, positionZ);
     directionalLight(0.7, 1, 0.7, positionX+20, 3, positionZ+5);
 }else if(facing ==3){
     pointLight(0.8, 0.8, 0.8, positionX+3 , -1, positionZ);
     directionalLight(0.7, 1, 0.7, positionX-20, 3, positionZ);
 }else{
     pointLight(0.8, 0.8, 0.8, positionX , -1, positionZ+3);
     directionalLight(0.7, 1, 0.7, positionX, 2, positionZ-20);     
 }    
}//if


//print current facing and location 
if(facing == 0)
  println("front", positionX, positionZ);
else if(facing == 1)
  println("left", positionX, positionZ);
else if(facing == 2)
  println("behind", positionX, positionZ); 
else if(facing == 3)
  println("right", positionX, positionZ); 


//draw wall, visible floor, exhibit floor and exhibits 
for (int z = int(positionZ)-VISIBLE; z <= positionZ+VISIBLE; z++) {
   for (int x = int(positionX)-VISIBLE; x <= positionX+VISIBLE; x++) {

     //"wall"
      if (positionZ<=-10 && z==-30) {
        drawWallZ(wallTexture, 1, x, z);
      }
      if (positionZ>=10 && z==30) {
        drawWallZ(wallTexture, 1, x, z);
      }
      if (positionX<=-10 && x==-30) {
        drawWallX(wallTexture, 1, x, z);
      }
      if (positionX>=10 && x==30) {
        drawWallX(wallTexture, 1, x, z);
      }

     // "exhibit 1, 2, 3 ,4"
      if (abs(x % 5) == 3 && abs(z % 3) == 0) {

        for (int i=0; i<firExLoc.length; i++)
          if (z == firExLoc[i][0] && x == firExLoc[i][1]) {
            exhibitFloor(floorTexture2, 1, x, z);           
            pushMatrix();
            translate(x+0.5, 0.2, z);
            rotateY(ex2Angle);
            drawExhibit(exhibit2);
            popMatrix();
          }

        for (int i=0; i<secExLoc.length; i++)
          if (z == secExLoc[i][0] && x == secExLoc[i][1]) {
            exhibitFloor(floorTexture2, 1, x, z);
            pushMatrix();
            translate(x+(ex4TranX), 0.4, z);
            rotateZ(ex4Angle);
            shape(globeTex2);
            popMatrix();
          }

        for (int i=0; i<thirExLoc.length; i++)
          if (z == thirExLoc[i][0] && x == thirExLoc[i][1]) {      
            exhibitFloor(floorTexture2, 1, x, z);
            //fill(0.2, 0.7, 0.1);
            pushMatrix();
            translate(x+0.5, 0.40, z);
            rotateY(ex3Angle);
          
            shape(globeTex);
            popMatrix();         
          }

        for (int i=0; i<fourExLoc.length; i++)
          if (z == fourExLoc[i][0] && x == fourExLoc[i][1]) {
            exhibitFloor(floorTexture2, 1, x, z);
            pushMatrix();
            translate(x+0.5, 0.5+ex1TranX, z);
            rotateY(PI/4);          
            drawExhibit(exhibit1);
            popMatrix();
          }
    } else{
       drawFloor(floorTexture, 1, x, z);
      }
 
    }//for x
  }//for z
  
// exhibit animation
 ex1TranX+=ex1Xspeed;  
 if(ex1TranX >= 0.3 || ex1TranX <=-0.2){   
   ex1Xspeed = ex1Xspeed *-1;
 }  
 ex2Angle+=0.01;  
 ex3Angle+= 0.01;
 ex4Angle+=0.01;
 ex4TranX+= ex4XSpeed; 
 if(ex4TranX >= 1 || ex4TranX <=-0.5){
   ex4XSpeed = ex4XSpeed *-1;  
 }

}//draw 


void drawExhibit(PImage exh){   
  scale(0.35);
  noStroke();
  beginShape(QUADS);
  texture(exh);
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();    
}


void drawFloor(PImage tex, float m, int x, int z) {
  
  if(lightOn){
    emissive(0.04424f, 0.04136f, 0.04136f);
    ambient(0.1745f, 0.01175f, 0.01175f);
    specular(0.227811f, 0.526959f, 0.826959f);
    shininess(95.8f);
  }
  
  boolean isExihArea1 = false; 
  boolean isExihArea2 = false; 
  boolean isExihArea3 = false; 
  boolean isExihArea4 = false; 
  
  for (int i=0; i<firExLoc.length; i++) {
    if (firExLoc[i][0] == z && (firExLoc[i][1]- x == - 1))
      isExihArea1 = true; 
    if (secExLoc[i][0] == z && (secExLoc[i][1]- x == - 1))  
      isExihArea2 = true; 
    if (thirExLoc[i][0] == z && (thirExLoc[i][1]- x == - 1))  
      isExihArea3 = true;     
    if (fourExLoc[i][0] == z && (fourExLoc[i][1]- x == - 1))  
      isExihArea4 = true;
  }
  
  //only draw blankfloor where != exhibit floor location 
  if (!isExihArea1 && !isExihArea2 && !isExihArea3 && !isExihArea4) {
    noStroke();
    beginShape(QUADS);
    texture(tex);
    vertex(x-0.5, 0, z-0.5, 0, m);
    vertex(x+0.5, 0, z-0.5, m, m);
    vertex(x+0.5, 0, z+0.5, m, 0);
    vertex(x-0.5, 0, z+0.5, 0, 0);
    endShape();
  }
}


void exhibitFloor(PImage tex, float m, int x, int z) {
  
  if(lightOn){
    emissive(0.11424f, 0.24136f, 0.24136f);
    ambient(0.1745f, 0.01175f, 0.01175f);
    specular(0.727811f, 0.626959f, 0.626959f);
    shininess(76.8f);
  }
  
  noStroke();
  beginShape(QUADS);
  texture(tex);
  vertex(x-0.5, 0, z-0.5, 0, m);
  vertex(x+1.5, 0, z-0.5, m, m);
  vertex(x+1.5, 0, z+0.5, m, 0);
  vertex(x-0.5, 0, z+0.5, 0, 0);
  endShape();
}

void drawWallZ(PImage tex, float m, int x, int z) {
  noStroke();    
  beginShape(QUADS);
  texture(tex);
  vertex(x-0.5, 5, z+0.5, 0, m);
  vertex(x+0.5, 5, z+0.5, m, m);
  vertex(x+0.5, 0, z+0.5, m, 0);
  vertex(x-0.5, 0, z+0.5, 0, 0);
  endShape();
}

void drawWallX(PImage tex, float m, int x, int z) {

  noStroke();
  beginShape(QUADS);
  texture(tex);
  vertex(x, 5, z+0.5, 0, m);
  vertex(x, 5, z-0.5, m, m);
  vertex(x, 0, z-0.5, m, 0);
  vertex(x, 0, z+0.5, 0, 0);
  endShape();
}


void wsKeyPressed() {
  if (wPressed) {

    if (millis()<startTime + 1000)
      if (facing ==0) {
        positionZ = positionZ-0.02;
      } else if (facing ==1) {  
        positionX = positionX -0.02;
      } else if (facing==2) {
        positionZ = positionZ +0.02;
      } else if (facing==3) {
        positionX = positionX + 0.02;
      }

    if (millis()>=startTime +1000) {
      positionX = (int)positionX; 
      positionZ = (int)positionZ;
      wPressed = false;
    }
  }


  if (sPressed) {  
    if (millis()<startTime + 1000)
      if (facing ==0 )
        positionZ = positionZ + 0.02; 
      else if (facing ==1)  
        positionX = positionX + 0.02; 
      else if (facing==2)
        positionZ = positionZ - 0.02;
      else if (facing==3)
        positionX = positionX -0.02;


    if (millis()>=startTime +1000) { 
      positionX = (int)positionX; 
      positionZ = (int)positionZ;
      sPressed = false;
    }
  }
}//wsKeyPressed


void facingAngle() {

  if (aPressed) {

    if (millis() < startTime+2000) {
      angle -=0.02;

      if (angle<= 0) {      
        if (facing ==1 && angle <-1.56) {
          angle = -1.5708; 
          aPressed = false;
        }

        if (facing ==2 && angle < -3.14) {
          angle = -3.1416; 
          aPressed = false;
        }

        if (facing ==3 && angle < -4.7) {
          angle = -4.7124; 
          aPressed = false;
        }

        if (facing ==0 && angle <-6.25) {
          angle = 0.0;
          aPressed = false;
        }
      } else {

        if (facing ==0 && angle <0.015) {
          angle = 0.0; 
          aPressed = false;
        }

        if (facing ==3 && angle <1.56) {
          angle = 1.5708; 
          aPressed = false;
        }

        if (facing ==2 && angle < 3.16) {
          angle = 3.1416; 
          aPressed = false;
        }
      }

      if (millis() >= startTime+2000)
        aPressed = false;
    }
  }//aPressed

  if (dPressed) {

    if (millis() < startTime+2000) {
      angle +=0.02;

      if (angle >= 0) {
        if (facing ==3 && angle > 1.56) {
          angle = 1.5708; 
          dPressed = false;
        }

        if (facing ==2 && angle > 3.13) {
          angle = 3.1416; 
          dPressed = false;
        }

        if (facing ==1 && angle > 4.7) {
          angle = 4.7124; 
          dPressed = false;
        }

        if (facing ==0 && angle > 6.2) {
          angle = 0.0;
          dPressed = false;
        }
      } else {
        
        if (facing ==2 && angle > -3.13) {
          angle = -3.1416; 
          dPressed = false;
        }

        if (facing ==1 && angle > -1.56) {
          angle = -1.5708; 
          dPressed = false;
        }

        if (facing ==0 && angle > -0.015) {
          angle = 0.0;
          dPressed = false;
        }
      }

      if (millis() >= startTime+2000)
        dPressed = false;
    }
  }//dpressed
}



void keyPressed() {
  switch (key) {

  case 'w':
    startTime =millis(); 
    if ((positionZ > -26 || angle != 0.0) && (positionZ < 26 || (angle != 3.1416 && angle != -3.1416))
      &&(positionX>-27 || (angle!= -1.5708 && angle!= 4.7124) ) && (positionX< 27|| (angle != 1.5708 &&angle != -4.7124 )) ) 
    {

      boolean isExihArea1 = false; 
      boolean isExihArea2 = false; 
      boolean isExihArea3 = false; 
      boolean isExihArea4 = false;

      boolean isExihArea5 = false; 
      boolean isExihArea6 = false; 
      boolean isExihArea7 = false; 
      boolean isExihArea8 = false; 

      boolean isExihAreaA = false; 
      boolean isExihAreaB = false; 
      boolean isExihAreaC = false; 
      boolean isExihAreaD = false; 
      
      boolean isExihAreaE = false; 
      boolean isExihAreaF = false; 
      boolean isExihAreaG = false; 
      boolean isExihAreaH = false; 

      for (int i=0; i<firExLoc.length; i++) {
        if (firExLoc[i][0] == positionZ && (firExLoc[i][1]- positionX) == -3)
          isExihArea1 = true; 
        if (secExLoc[i][0] == positionZ && (secExLoc[i][1]- positionX) == -3)
          isExihArea2 = true; 
        if (thirExLoc[i][0] == positionZ && (thirExLoc[i][1]- positionX)== -3)  
          isExihArea3 = true;     
        if (fourExLoc[i][0] == positionZ && (fourExLoc[i][1]- positionX) == -3)  
          isExihArea4 = true; 

        if (firExLoc[i][0] == positionZ && (firExLoc[i][1]- positionX) == 2)
          isExihArea5 = true; 
        if (secExLoc[i][0] == positionZ && (secExLoc[i][1]- positionX) == 2)
          isExihArea6 = true; 
        if (thirExLoc[i][0] == positionZ && (thirExLoc[i][1]- positionX)== 2)  
          isExihArea7 = true;     
        if (fourExLoc[i][0] == positionZ && (fourExLoc[i][1]- positionX) == 2)  
          isExihArea8 = true; 

        if ((firExLoc[i][1] == positionX ||firExLoc[i][1]+1 == positionX) && 
            ((firExLoc[i][0]- positionZ) == -2 ||(firExLoc[i][0]- positionZ) == -1 ))
            isExihAreaA = true; 
        if ((secExLoc[i][1] == positionX||secExLoc[i][1]+1 == positionX) && 
            ((secExLoc[i][0]- positionZ) == -2||(secExLoc[i][0]- positionZ) == -1 ))
            isExihAreaB = true; 
        if ((thirExLoc[i][1] == positionX||thirExLoc[i][1]+1 == positionX) && 
            ((thirExLoc[i][0]- positionZ)== -2 ||(thirExLoc[i][0]- positionZ) == -1 )) 
            isExihAreaC = true;     
        if ((fourExLoc[i][1] == positionX||fourExLoc[i][1]+1 == positionX) &&
            ((fourExLoc[i][0]- positionZ) == -2||(thirExLoc[i][0]- positionZ) == -1 ))  
            isExihAreaD = true;
            
         if ((firExLoc[i][1] == positionX ||firExLoc[i][1]+1 == positionX) && 
            ((firExLoc[i][0]- positionZ) == 2 ||(firExLoc[i][0]- positionZ) == 1 ))
            isExihAreaE = true; 
        if ((secExLoc[i][1] == positionX||secExLoc[i][1]+1 == positionX) && 
            ((secExLoc[i][0]- positionZ) == 2||(secExLoc[i][0]- positionZ) == 1 ))
            isExihAreaF = true; 
        if ((thirExLoc[i][1] == positionX||thirExLoc[i][1]+1 == positionX) && 
            ((thirExLoc[i][0]- positionZ)== 2 ||(thirExLoc[i][0]- positionZ) == 1 )) 
            isExihAreaG = true;     
        if ((fourExLoc[i][1] == positionX||fourExLoc[i][1]+1 == positionX) &&
            ((fourExLoc[i][0]- positionZ) == 2||(thirExLoc[i][0]- positionZ) == 1 ))  
            isExihAreaH = true;   
            
      }      

      if (facing ==1 &&( isExihArea1 || isExihArea2 || isExihArea3 || isExihArea4)) {
        wPressed = false;
      } else if (facing ==3 &&( isExihArea5 || isExihArea6 || isExihArea7 || isExihArea8))
      {
        wPressed = false;
      } else if (facing ==0 &&( isExihAreaA || isExihAreaB || isExihAreaC || isExihAreaD)) {
        wPressed = false;
      }else if (facing ==2 &&( isExihAreaE || isExihAreaF || isExihAreaG || isExihAreaH)) {     
       wPressed = false;
      }
       else {
        wPressed = true;
      }
    }
    break;

  case 'a':
    startTime =millis(); 
    aPressed =true;
    facing = (facing + 1) % 4;
    break;

  case 's':
    startTime =millis(); 
    if ((positionZ < 26 || angle != 0.0) && (positionZ > -26 || (angle != 3.1416 && angle != -3.1416))
      &&(positionX>-27 ||(angle != -4.7124 && angle !=1.5708)) && (positionX< 27|| (angle != 4.7124 && angle != -1.5708)))
    {
     boolean isExihArea1 = false; 
      boolean isExihArea2 = false; 
      boolean isExihArea3 = false; 
      boolean isExihArea4 = false;

      boolean isExihArea5 = false; 
      boolean isExihArea6 = false; 
      boolean isExihArea7 = false; 
      boolean isExihArea8 = false; 

      boolean isExihAreaA = false; 
      boolean isExihAreaB = false; 
      boolean isExihAreaC = false; 
      boolean isExihAreaD = false; 
      
      boolean isExihAreaE = false; 
      boolean isExihAreaF = false; 
      boolean isExihAreaG = false; 
      boolean isExihAreaH = false; 

      for (int i=0; i<firExLoc.length; i++) {
        if (firExLoc[i][0] == positionZ && (firExLoc[i][1]- positionX) == -3)
          isExihArea1 = true; 
        if (secExLoc[i][0] == positionZ && (secExLoc[i][1]- positionX) == -3)
          isExihArea2 = true; 
        if (thirExLoc[i][0] == positionZ && (thirExLoc[i][1]- positionX)== -3)  
          isExihArea3 = true;     
        if (fourExLoc[i][0] == positionZ && (fourExLoc[i][1]- positionX) == -3)  
          isExihArea4 = true; 

        if (firExLoc[i][0] == positionZ && (firExLoc[i][1]- positionX) == 2)
          isExihArea5 = true; 
        if (secExLoc[i][0] == positionZ && (secExLoc[i][1]- positionX) == 2)
          isExihArea6 = true; 
        if (thirExLoc[i][0] == positionZ && (thirExLoc[i][1]- positionX)== 2)  
          isExihArea7 = true;     
        if (fourExLoc[i][0] == positionZ && (fourExLoc[i][1]- positionX) == 2)  
          isExihArea8 = true; 

        if ((firExLoc[i][1] == positionX ||firExLoc[i][1]+1 == positionX) && 
            ((firExLoc[i][0]- positionZ) == -2 ||(firExLoc[i][0]- positionZ) == -1 ))
            isExihAreaA = true; 
        if ((secExLoc[i][1] == positionX||secExLoc[i][1]+1 == positionX) && 
            ((secExLoc[i][0]- positionZ) == -2||(secExLoc[i][0]- positionZ) == -1 ))
            isExihAreaB = true; 
        if ((thirExLoc[i][1] == positionX||thirExLoc[i][1]+1 == positionX) && 
            ((thirExLoc[i][0]- positionZ)== -2 ||(thirExLoc[i][0]- positionZ) == -1 )) 
            isExihAreaC = true;     
        if ((fourExLoc[i][1] == positionX||fourExLoc[i][1]+1 == positionX) &&
            ((fourExLoc[i][0]- positionZ) == -2||(thirExLoc[i][0]- positionZ) == -1 ))  
            isExihAreaD = true;
            
         if ((firExLoc[i][1] == positionX ||firExLoc[i][1]+1 == positionX) && 
            ((firExLoc[i][0]- positionZ) == 2 ||(firExLoc[i][0]- positionZ) == 1 ))
            isExihAreaE = true; 
        if ((secExLoc[i][1] == positionX||secExLoc[i][1]+1 == positionX) && 
            ((secExLoc[i][0]- positionZ) == 2||(secExLoc[i][0]- positionZ) == 1 ))
            isExihAreaF = true; 
        if ((thirExLoc[i][1] == positionX||thirExLoc[i][1]+1 == positionX) && 
            ((thirExLoc[i][0]- positionZ)== 2 ||(thirExLoc[i][0]- positionZ) == 1 )) 
            isExihAreaG = true;     
        if ((fourExLoc[i][1] == positionX||fourExLoc[i][1]+1 == positionX) &&
            ((fourExLoc[i][0]- positionZ) == 2||(thirExLoc[i][0]- positionZ) == 1 ))  
            isExihAreaH = true;   
            
      }      

      if (facing ==3 &&( isExihArea1 || isExihArea2 || isExihArea3 || isExihArea4)) {
        sPressed = false;
      } else if (facing ==1 &&( isExihArea5 || isExihArea6 || isExihArea7 || isExihArea8))
      {
        sPressed = false;
      } else if (facing ==2 &&( isExihAreaA || isExihAreaB || isExihAreaC || isExihAreaD)) {
        sPressed = false;
      }else if (facing ==0 &&( isExihAreaE || isExihAreaF || isExihAreaG || isExihAreaH)) {     
       sPressed = false;
      }
       else {
        sPressed = true;
      }
    }
    break;

  case 'd':
    startTime =millis(); 
    dPressed = true; 
    facing = (facing + 3) % 4;
    break;
    
   case 'l':
   lightOn = !lightOn;
   break;

  }
}

void drawAvatar(){
  pushMatrix();
  noStroke();
  translate(0,-0.7+avatarTrans,-1);
  fill(0.7,0.1,0.5);
  box(0.1,0.3,0.1);
  
  pushMatrix();
  translate(-0.15,0,0);
  rotateZ(0.8);
  fill(0.7,0.1,0.5);
  box(0.3,0.05,0.05);
  popMatrix();
  
  pushMatrix();
  translate(+0.15,0,0);
  rotateZ(-0.8);
  fill(0.7,0.1,0.5);
  box(0.3,0.05,0.05);
  popMatrix();

  pushMatrix();
  translate(-0.15,-0.2,0);
  rotateZ(0.8);
  fill(0.7,0.1,0.5);
  box(0.3,0.05,0.05);
  popMatrix();
  
  pushMatrix();
  translate(+0.15,-0.2,0);
  rotateZ(-0.8);
  fill(0.7,0.1,0.5);
  box(0.3,0.05,0.05);
  popMatrix();

  pushMatrix();
  translate(0,0.27,0);
  fill(0.2,0.3,0.6);
  sphere(0.10);
  popMatrix();
  popMatrix();
  
}

void mouseDragged() {
  float smooth = 0.0015;
  freeX += (pmouseY-mouseY) * smooth;
  freeY += (pmouseX-mouseX) * smooth;
  isDragged = true;
}

void mouseReleased(){
  isDragged = false; 
}