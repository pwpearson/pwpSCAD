

include <pwpSCAD/building-materials.scad>
use <pwpSCAD/util.scad>

degrees = 25;
yObject = 0;
yText = 40;
facingVector = ["topFront", "topLeft", "topBack", "topRight", "bottomFront", "bottomLeft", "bottomBack", "bottomRight"];
loopDetails = [ for (i=[0:7]) [i,[facingVector[i], [i*30, yObject], [(i*30) + 15, yObject], [i*30, yText], [(i*30)+15, yText]]]];
echo("loopDetails: ", loopDetails);

for( detail = loopDetails){
  echo("Detail: ", detail);
  display(detail[1][1], detail[1][2], detail[0], detail[1][0], degrees, detail[1][3], detail[1][4]);
}

module display(locPos=[0, 0], locNeg=[0, 0], facing=0, facingStr="", degrees=0, textPos=[0, 0], textNeg=[0, 0]) {
  echo(str("**** ", facingStr, " - positive ", degrees, " angle"));
  //text
  color("black") mvrot(x=textPos[0], y=textPos[1], rz=55)
  linear_extrude(.1) text(text=str(facingStr, "(", facing, ") ; ", degrees), size=1);
  //object
  translate(locPos)
  boardWithLap(width = 3.5,
               length = 38,
               thickness = 3.5,
               lapWidth = 3.5,
               lapLength = 9.25,
               lapThickness = 1.25,
               shoulderAngle = degrees,
               facing=facing,
               dimPadding=2);

  //text
  echo(str("**** ", facingStr, " - negative ", degrees, " angle"));
  color("black") mvrot(x=textNeg[0], y=textNeg[1], rz=55)
  linear_extrude(.1) text(text=str(facingStr, "(", facing, ") ; ", -degrees), size=1);
  //object
  translate(locNeg)
  boardWithLap(width = 3.5,
               length = 38,
               thickness = 3.5,
               lapWidth = 3.5,
               lapLength = 9.25,
               lapThickness = 1.25,
               shoulderAngle = -degrees,
               facing=facing,
               dimPadding=2);
}
/*
$_debug = true;

echo("**** negative 25 degree angle");
color("black")
mvrot(y=40, rz=55)
linear_extrude(.1)
text(text="topFront; -25 degrees", size=1);
boardWithLap(width = 3.5,
             length = 38,
             thickness = 3.5,
             lapWidth = 3.5,
             lapLength = 9.25,
             lapThickness = 1.25,
             shoulderAngle = -25,
             facing=topFront,
             dimPadding=2);
*/

/*
echo("**** positive 25 degree angle");
color("black")
mvrot(x= 15,y=40, rz=55)
linear_extrude(.1)
text(text="topFront; 25 degrees", size=1);
mvrot(x = 15)
boardWithLap(width = 3.5,
           length = 38,
           thickness = 3.5,
           lapWidth = 3.5,
           lapLength = 9.25,
           lapThickness = 1.25,
           shoulderAngle = 25,
           facing=topFront,
           dimPadding=2);


echo("**** positive 25 degree angle; bottom front");
color("black")
mvrot(x= 30,y=40, rz=55)
linear_extrude(.1)
text(text="bottomFront; 25 degrees", size=1);
mvrot(x = 30)
boardWithLap(width = 3.5,
            length = 38,
            thickness = 3.5,
            lapWidth = 3.5,
            lapLength = 9.25,
            lapThickness = 1.25,
            shoulderAngle = 25,
            facing=bottomFront,
            dimPadding=2);

echo("**** topBack");
color("black")
mvrot(x= 45,y=40, rz=55)
linear_extrude(.1)
text(text="(tbd) topBack; 25 degrees", size=1);
mvrot(x = 45)
boardWithLap(width = 3.5,
            length = 38,
            thickness = 3.5,
            lapWidth = 3.5,
            lapLength = 9.25,
            lapThickness = 1.25,
            shoulderAngle = 25,
            facing=topFront,
            dimPadding=2);

echo("**** just below threashold for lap length assert");
color("black")
mvrot(x= 60,y=40, rz=55)
linear_extrude(.1)
text(text="just below threashold for lap", size=1);
color("black")
mvrot(x=62, y=40, rz=55)
linear_extrude(.1)
text(text="length assert; 69 degrees", size=1);
mvrot(x = 60)
boardWithLap(width = 3.5,
            length = 38,
            thickness = 3.5,
            lapWidth = 3.5,
            lapLength = 9.25,
            lapThickness = 1.25,
            shoulderAngle = 69,
            facing=topFront,
            dimPadding=2);

// assert that 90 degrees is too much
//mvrot(x = 20)
//boardWithLap(width = 3.5,
//            length = 38,
//            thickness = 3.5,
//            lapWidth = 3.5,
//            lapLength = 9.25,
//            lapThickness = 1.25,
//            shoulderAngle = 90,
//            location=topFront);



echo("**** square shoulder or anlge == 0");
color("black")
mvrot(x= 75,y=40, rz=55)
linear_extrude(.1)
text(text=" topFront; 0 degrees", size=1);
mvrot(x = 75)
boardWithLap(width = 3.5,
            length = 38,
            thickness = 3.5,
            lapWidth = 3.5,
            lapLength = 9.25,
            lapThickness = 1.25,
            shoulderAngle = 0,
            facing=topFront,
            dimPadding=2);

*/
