/*
 *
 *
 */


include <MCAD/materials.scad>
include <pwpSCAD/rightTriangleSolver.scad>
use <pwpSCAD/util.scad>

DOC_SCALING_FACTOR = 10;

include <Dimensional-Drawings/dimlines.scad>

DIM_LINE_WIDTH = .025 * DOC_SCALING_FACTOR;
DIM_SPACE = .1 * DOC_SCALING_FACTOR;
DIM_LINE_PAD = .5;

$_debug = true;

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

_epsilon = 1e-009;

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
module _inverseLap(lapWidth, lapLength, lapThickness, shoulderAngle=0, dimPadding=0) {
  debug(str("init: inverseLapWithAngle(",[lapWidth, lapLength, lapThickness, shoulderAngle], ")"));

  tangle = rightTriangleSolver(a = lapWidth, beta = shoulderAngle);
  debug(str("tangle: ", tangle));
  b = is_def(tangle) ? tangle[1] : 0;

  assert( b < lapLength, "lap length not long enough for the desired angle");

  // used to add buffer around polygon to eliminate artifacts
  epsilon = 1e-003;

  // 2d-polygon points of inverse lap
  origin = [0, 0] + [-epsilon, -epsilon];

  bottomRight = [lapWidth, 0] + [epsilon, -epsilon];

  topLeft = shoulderAngle >= 0 ?
    [0, lapLength] + [-epsilon, epsilon] :    //shoulderAngle is 0 or positive
    [0, lapLength - b] + [-epsilon, epsilon]; //shoulderAngle is negative

  topRight = shoulderAngle > 0 ?
    [lapWidth, lapLength - b] + [epsilon, epsilon] : //shoulderAngle is postive
    [lapWidth, lapLength] + [epsilon, epsilon];      //shoulderAngle is 0 or negative

  points = [origin, topLeft, topRight, bottomRight];

  debug(str("inverseLapWithAngle Points: ", points));

  color(Oak)
  mvrot(z = -epsilon)
  linear_extrude(height = lapThickness)
    polygon( points = points, convexity = 1);
}

front = 0;
back = 1;
top = 0;
bottom = 1;
left = 0;
right = 1;

module boardWithLap(width, length, thickness, lapWidth, lapLength, lapThickness, shoulderAngle=0, location, dimPadding=0){
  assert(abs(shoulderAngle) < 90, "shoulder angle of the lap has to be less than 90");

  // currently coded for Facing: Front-Top
  difference() {
    board(width, length, thickness, dimPadding * 1.5);
    mvrot(y = length, z = thickness, rx = 180)
      _inverseLap(lapWidth, lapLength, lapThickness, shoulderAngle, dimPadding);
  }
}

function lapJoint(width, length, thickness, shoulderAngle=0, location) =
  ["lap-joint", [width, length, thickness, shoulderAngle, location]];

module board(width, length, thickness, dimPadding=0){
  color(Pine) cube([width, length, thickness]);

  if(dimPadding > 0){
    // length
    mvrot(x=-DIM_LINE_PAD, y=0, z=width/2, rz=180)
    line(length=dimPadding * .90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=-DIM_LINE_PAD, y=length, z=width/2, rz=180)
    line(length=dimPadding *.90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=-dimPadding * .80, y=0, z=width/2, rz=90)
    dimensions(length, line_width=DIM_LINE_WIDTH, loc=DIM_CENTER);

    //width
    mvrot(x=0, y=0, z=thickness + DIM_LINE_PAD, ry=-90)
    line(length=dimPadding * .90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=width, y=0, z=thickness + DIM_LINE_PAD, ry=-90)
    line(length=dimPadding *.90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=0, y=0, z=thickness + dimPadding * .80, rx=-90)
    dimensions(width, line_width=DIM_LINE_WIDTH, loc=DIM_LEFT);

    //thickness
    mvrot(x=width + DIM_LINE_PAD, y=0, z=0, ry=0)
    line(length=dimPadding * .90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=width + DIM_LINE_PAD, y=0, z=thickness, ry=0)
    line(length=dimPadding *.90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=width + dimPadding * .80, y=0, z=thickness, rx=-90, ry=90)
    dimensions(width, line_width=DIM_LINE_WIDTH, loc=DIM_LEFT);

  }
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
