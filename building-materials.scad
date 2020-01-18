/*
 *
 *
 */
include <MCAD/materials.scad>
include <pwpSCAD/rightTriangleSolver.scad>
use <pwpSCAD/util.scad>

// Vector object dimension elements
// [depth, width, (height|length), angle]
DEPTH = 0;
WIDTH = 1;
HEIGHT = 2;
LENGTH = 2;
ANGLE = 3;
OFF_SET = 4;

// all values are in inches;
eightFeet = 8 * 12;
fourFeet = 4 * 12;

_epsilon_diff = 1e-004;

/*
reference

nominal   actual (inches)   actual (mm)
---------------------------------
1 x 2	    3/4 x 1 1/2	      19 x 38
1 x 3	    3/4 x 2 1/2	      19 x 64
1 x 4	    3/4 x 3 1/2	      19 x 89
1 x 6	    3/4 x 5 1/2	      19 x 140
1 x 8	    3/4 x 7 1/4	      19 x 184
1 x 10	  3/4 x 9 1/4	      19 x 235
1 x 12	  3/4 x 11 1/4	    19 x 286

2 x 2	    1 1/2 x 1 1/2	    38 x 38
2 x 3	    1 1/2 x 2 1/2	    38 x 64
2 x 4	    1 1/2 x 3 1/2	    38 x 89
2 x 6	    1 1/2 x 5 1/2	    38 x 140
2 x 8	    1 1/2 x 7 1/4	    38 x 184
2 x 10	  1 1/2 x 9 1/4	    38 x 235
2 x 12	  1 1/2 x 11 1/4	  38 x 286

4 x 4	3   1/2 x 3 1/2	      89 x 89
*/

// actual size (inches); dimensional lumber
oneByTwo    = [ 0.75, 1.5 ];
oneByFour   = [ 0.75, 3.5 ];
oneBySix    = [ 0.75, 5.5 ];
oneByEight  = [ 0.75, 7.25 ];
oneByTen    = [ 0.75, 9.25 ];
oneByTwelve = [ 0.75, 11.25 ];

twoByTwo    = [ 1.5, 1.5 ];
twoByFour   = [ 1.5, 3.5 ];
twoBySix    = [ 1.5, 5.5 ];
twoByEight  = [ 1.5, 7.25 ];
twoByTen    = [ 1.5, 9.25 ];
twoByTwelve = [ 1.5, 11.25 ];

fourByFour  = [ 3.5, 3.5 ];

sheet = [ fourFeet, eightFeet ];

// constants
depth2x4 = twoByFour[DEPTH];
width2x4 = twoByFour[WIDTH];

halfWidth2x4 = width2x4/2;

depth2x6 = twoBySix[DEPTH];
width2x6 = twoBySix[WIDTH];

depth2x8 = twoByEight[DEPTH];
width2x8 = twoByEight[WIDTH];

depth2x10 = twoByTen[DEPTH];
width2x10 = twoByTen[WIDTH];

depth4x4 = fourByFour[DEPTH];
width4x4 = fourByFour[WIDTH];

/******************************************************************************/

// rightTriangleSolver(a = undef, b = undef, c = undef, alpha = undef, beta = undef, h = undef)
module inverseLap(lapWidth, lapLength, lapThickness, shoulderAngle) {

  tangle = rightTriangleSolver(a = lapWidth, beta = shoulderAngle);
  echo(tangle);
  a = tangle[0];
  b = tangle[1];

  // polygon points of inverse lap
  origin = [0 - _epsilon_diff, 0 - _epsilon_diff];
  topLeftPos = [0 - _epsilon_diff, lapLength + _epsilon_diff];
  topRightPos = [lapWidth + _epsilon_diff, lapLength - b + _epsilon_diff];
  topLeftNeg = [0 - _epsilon_diff, lapLength - b + _epsilon_diff];
  topRightNeg = [lapWidth + _epsilon_diff, lapLength + _epsilon_diff];
  bottomRight = [lapWidth + _epsilon_diff , 0 - _epsilon_diff];

  points = shoulderAngle > 0 ?
    [origin, topLeftPos, topRightPos, bottomRight] :
    [origin, topLeftNeg, topRightNeg, bottomRight];

  echo(points);

  mvrot(z = -_epsilon_diff)
  linear_extrude(height = lapThickness)
    polygon( points = points, convexity = 1);
}

front = 0;
back = 1;
top = 0;
bottom = 1;

module boardWithLap(width, length, thickness, lapWidth, lapLength, lapThickness, shoulderAngle, location){

  // currently coded for Facing: Front-Top
  difference() {
    board(width, length, thickness);
    mvrot(y = length, z = thickness, rx = 180)
    # inverseLap(lapWidth, lapLength, lapThickness, shoulderAngle);
  }
}

module board(width, length, thickness){
  color(Pine) cube([width, length, thickness]);
}

module lumber(dimension = twoByFour, length = eightFeet, trueCenter = false) {
  board(dimension[WIDTH], length, dimension[DEPTH]);
}

module oneByFour(length = eightFeet, trueCenter = false) {
  lumber(oneByFour, length, trueCenter);
}

module oneBySix(length = eightFeet, trueCenter = false) {
  lumber(oneBySix, length, trueCenter);
}

module twoByTwo(length = eightFeet, trueCenter = false) {
  lumber(twoByTwo, length, trueCenter);
}

module twoByFour(length = eightFeet, trueCenter = false) {
  lumber(twoByFour, length, trueCenter);
}

module twoBySix(length = eightFeet, trueCenter = false) {
  lumber(twoBySix, length, trueCenter);
}

module twoByTen(length = eightFeet, trueCenter = false) {
  lumber(twoByTen, length, trueCenter);
}

module fourByFour(length = eightFeet, trueCenter = false) {
  lumber(fourByFour, length, trueCenter);
}

module mdfSheet(length = eightFeet, width = fourFeet, thickness = 0.5,
                trueCenter = false) {
  color(FiberBoard) cube([ thickness, width, length ], trueCenter);
}

/*
 * Standard Interior Wall
 * default
 */
module interiorHouseWall(length, height, width = 4.5) {
 cube([length, width, height], false);
}
