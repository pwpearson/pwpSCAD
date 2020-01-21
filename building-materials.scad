/*
 *
 *
 */


include <MCAD/materials.scad>
include <pwpSCAD/rightTriangleSolver.scad>
use <pwpSCAD/util.scad>

DOC_SCALING_FACTOR = 5;

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

epsilon = 1e-003;

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


function _inverseLapPoints(lapWidth, lapLength, lapThickness, shoulderAngle) =
  let(
    fn = "_inverseLapPoints",
    args = [lapWidth, lapLength, lapThickness, shoulderAngle],
    tangle = debugTap(rightTriangleSolver(a = lapWidth, beta = shoulderAngle), "tangle: "),
    b = is_def(tangle) ? tangle[1] :0,

    bottomLeft = [0,0],
    topLeft = shoulderAngle >= 0 ? [0, lapLength] : [0, lapLength - b],
    topRight = shoulderAngle > 0 ? [lapWidth, lapLength - b] : [lapWidth, lapLength],
    bottomRight = [lapWidth, 0],

    rslt = debugTap([bottomLeft, topLeft, topRight, bottomRight], fn2Str(fn, args))
  )
  assert( b < lapLength, "lap length not long enough for the desired angle")
  rslt;

module _inverseLap(points, lapThickness) {
  debug(str("init: inverseLap(", points, ")"));
  epsilon = 1e-002;

  debug(str("inverseLapWithAngle Points: ", points));

  epsilonAdjust = [[-epsilon, -epsilon], [-epsilon, epsilon], [epsilon, epsilon], [epsilon, -epsilon] ];

  color(Oak)
  mvrot(z = -epsilon)
  linear_extrude(height = lapThickness)
    polygon( points = points + epsilonAdjust, convexity = 1);
}

 topFront = 0;
 topLeft = 1;
 topBack = 2;
 topRight = 3;
 bottomFront = 4;
 bottomLeft = 5;
 bottomBack = 6;
 bottomRight = 7;

module boardWithLap(width, length, thickness, lapWidth, lapLength, lapThickness, shoulderAngle=0, location=0, dimPadding=0){
  assert(abs(shoulderAngle) < 90, "shoulder angle of the lap has to be less than 90°");

  epsilon = 1e-01;
  points = _inverseLapPoints(lapWidth, lapLength, lapThickness, shoulderAngle);

  bottomLeft = 0;
  topLeft = 1;
  topRight = 2;
  bottomRight = 3;

  tranTopFront = [[0, length, thickness], [0, 180, 180]];
  tranBottomFront = [[width, 0, thickness], [0, 180, 0]];

  trans = location == topFront ? tranTopFront :
          location == bottomFront ? tranBottomFront :
          undef;

  // currently coded for Facing: Front-Top
  difference() {
    board(width, length, thickness, dimPadding * 2);
      translate(trans[0]) rotate(trans[1])
        _inverseLap(points, lapThickness);
  }

  if(dimPadding > 0) {
    lenLeftSide = norm(points[topLeft] - points[bottomLeft]);
    lenRightSide = norm(points[topRight] - points[bottomRight]);
    color("green")
    translate(trans[0]) rotate(trans[1]){
      //left height
      mvrot(x=points[bottomLeft][0] - dimPadding - .2 , y=points[bottomLeft][1], z=lapThickness)
      //mvrot(x=-3)
      line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

      mvrot(x=points[topLeft][0] - dimPadding - .2 , y=points[topLeft][1], z=lapThickness)
      //mvrot(x=-3, y=points[topLeft][1])
      line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

      mvrot(x=-dimPadding * .8, y=lenLeftSide, z=lapThickness, rx=180, rz=-90)
      dimensions(lenLeftSide, line_width=DIM_LINE_WIDTH, loc=DIM_LEFT);

      //right height
      //mvrot(x=lapWidth + .2, y=points[bottomRight][1])
      mvrot(x=3, z=lapThickness)
      line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

      //mvrot(x=lapWidth + .2, y=points[topRight][1])
      mvrot(x=3, y=points[topRight][1], z=lapThickness)
      line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

      mvrot(x=dimPadding + lapWidth * .8, y=lenRightSide, z=lapThickness, rx=180, rz=-90)
      dimensions(lenRightSide, line_width=DIM_LINE_WIDTH, loc=DIM_LEFT);

      //angle
      //°mvrot(x=width/2, y=lapLength, z=-2, rx=180, rz=-90)
      mvrot(y=lenLeftSide, z= lapThickness, rx=190)
      leader_line(angle=85, radius=0, angle_length=lapLength, horz_line_length=0, direction=DIM_RIGHT,
      line_width=DIM_LINE_WIDTH, text=str(shoulderAngle, "deg"), do_circle=false);

    }
  }
}

module board(width, length, thickness, dimPadding=0){
  color(Pine) cube([width, length, thickness]);

  color("blue")
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

    mvrot(x=0, y=0, z=thickness + dimPadding * .80, rx=0)
    dimensions(width, line_width=DIM_LINE_WIDTH, loc=DIM_LEFT);

    //thickness
    mvrot(x=width + DIM_LINE_PAD, y=0, z=0, ry=0)
    line(length=dimPadding * .90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=width + DIM_LINE_PAD, y=0, z=thickness, ry=0)
    line(length=dimPadding *.90, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
    left_arrow=false, right_arrow=false);

    mvrot(x=width + dimPadding * .80, y=0, z=thickness, rx=0, ry=90)
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
