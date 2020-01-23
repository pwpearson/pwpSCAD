/*
 *
 *
 */


include <MCAD/materials.scad>  // custom material colors
include <missile/missile.scad> // vector ops like head, tail, empty, reverse, etc
include <pwpSCAD/rightTriangleSolver.scad> // solves attributes for right triangles
include <pwpSCAD/util.scad>    // general purpose functions for pwpSCAD library

DOC_SCALING_FACTOR = 5;

include <Dimensional-Drawings/dimlines.scad>

DIM_LINE_WIDTH = .025 * DOC_SCALING_FACTOR;
DIM_SPACE = .1 * DOC_SCALING_FACTOR;
DIM_LINE_PAD = .5;

$_debug = true;

// small number used in comparisions and inversion object scaling to
// elimate or minimize rendering artifacts
epsilon = 1e-003;

// facings:

/*
 * newly created objects prior to translations
 * have default board() facing of
 * from origin (0,0,0)
 * +x axis == width
 * +y axis == length
 * +z axis == depth
 */

// used to position lap joints at the end of the board
 TOP_FRONT = 0;     //[0, 1, 1]                z |
 TOP_LEFT = 1;      //[-1, 1, 0]                 |   * y
 TOP_BACK = 2;      //[0, 1, -1]                 |  *
 TOP_RIGHT = 3;     //[1, 1, 0]                  | *
 BOTTOM_FRONT = 4;  //[0, -1, 1]                 |_________ x
 BOTTOM_LEFT = 5;   //[-1, -1, 0]
 BOTTOM_BACK = 6;   //[0, -1, -1]
 BOTTOM_RIGHT = 7;  //[1, -1, 0]

// used to position lap joints on a face but not necassarily at the end of the board
 FRONT = 8;
 LEFT = 9;
 BACK = 10;
 RIGHT = 11;
 TOP = 12;
 BOTTOM = 13;
/**************************************************************************************/

// alignment:
// for grooves, dado, mortis, etc
ALIGN_TOP = 0;
ALIGN_CENTER = 1;
ALIGN_BOTTOM = 2;

/**************************************************************************************/

// vector elements:
//    when a vector describes a board, lap joint, etc
/*
 * Vector object dimension elements
 * board = [ width, length, thickness]
 * lap joint = [depth, width, (height|length), angle, facing]
 */
WIDTH = 0;
HEIGHT = 1;
LENGTH = 1;
DEPTH = 2;
THICKNESS = 2;
ANGLE = 3;
FACING = 4;

/**************************************************************************************/

// lap joint points:
//   for internal use to position dimension lines
//   and inversion objects for difference()
BOTTOM_LEFT_POINT = 0;
TOP_LEFT_POINT = 1;
TOP_RIGHT_POINT = 2;
BOTTOM_RIGHT_POINT = 3;
EXTRUDE_DEPTH = 4;

/**************************************************************************************/


// joinery operations:
//   not all have been implemented
LAP_JOINT = 0; // maybe do specializations instead of different operations
CROSS_LAP = 1; // form of LAP JOINT
MITER = 2; // another form of LAP JOINT
MORTIS = 3;
TENON = 4;
MITRED_HALF = 5; // form of LAP JOINT
DOVETAIL_LAP = 6; // form of LAP JOINT
RABBET = 7;
GROOVE = 8; // with-grain; similiar to TRENCH (dado); [Through and Blind]
TRENCH = 9; // cross-grain; similiar to GROOVE; [Through and Blind]
HEEL_SEAT_CUT = 10; // angled cut out in material
PIN = 11;


/*
 * from wikipedia.org - woodworking joints
 *
 * LAP JOINT the end of a piece of wood is laid over and connected to another piece of wood
 *
 * CROSS LAP form of LAP JOINT
 *
 * MITER is similar to a butt joint, but both pieces have been bevelled
 *
 * MORTIS and TENON A stub (the tenon) will fit tightly into a hole cut for it (the mortise)
 *
 * MITRED HALF form of LAP JOINT
 *
 * DOVETAIL LAP form of LAP JOINT
 *
 * RABBET is a recess or groove cut into the edge
 *
 * THROUGH GROOVE passes all the way through the surface and its ends are open
 *
 * STOPPED GROOVE one or both of the ends finish before the groove meets edge of the surface
 *
 * THROUGH TRENCH/DADO involves cuts which run between both edges of the surface, leaving both ends open
 *
 * STOPPED or BLIND TRENCH/DADO ends before one or both of the cuts meets the edge of the surface
 *
 * HALF TRENCH/DADO is formed with a narrow dado cut into one part, coupled with a
 * rabbet of another piece. This joint tends to be used because of its ability
 * to hide unattractive gaps due to varying material thicknesses
 */


// all values are in inches;
eightFeet = 8 * 12;
fourFeet = 4 * 12;

/*
reference

nominal   actual (inches)   actual (mm)
---------------------------------------
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

/*
 * defines the 2d polygon for the inverse of the lap joint. Basically the part to remove.
 *
 * uses the rightTriangleSover to calculate the vertices from the shoulder angle
 */
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

    pts = debugTap([bottomLeft, topLeft, topRight, bottomRight, lapThickness], fn2Str(fn, args))
  )
  assert( b < lapLength, "lap length not long enough for the desired angle")
  pts;

/*
 * returns the transformation required to place the inverseLap.
 *
 * note: this may not be just for inverse lap joints
 */
function _inverseLapTransformations(facing, width, length, thickness) =
  facing == TOP_FRONT    ? [[0, length, thickness], [0, 180, 180]] :
  facing == TOP_LEFT     ? [[0, length, 0], [0, -90, 180]] :
  facing == TOP_BACK     ? [[width, length, 0], [0, 0, 180]] :
  facing == TOP_RIGHT    ? [[width, length, thickness], [0, 90, 180]] :
  facing == BOTTOM_FRONT ? [[width, 0, thickness], [0, 180, 0]] :
  facing == BOTTOM_LEFT  ? [[0, 0, thickness], [0, 90, 0]] :
  facing == BOTTOM_BACK  ? [[0, 0, 0], [0, 0, 0]] :
  facing == BOTTOM_RIGHT ? [[width, 0, 0], [0, -90, 0]] :
  assert(false, str("Facing Transform not found for value: ", facing)) undef;

/*
 * defines the 3d object based off the 2d polygon points
 *
 */
module _inverseLap(points) {
  debug(str("init: inverseLap(", points, ")"));
  epsilon = 1e-002;

  debug(str("inverseLapWithAngle Points: ", points));

  epsilonAdjust = [[-epsilon, -epsilon], [-epsilon, epsilon], [epsilon, epsilon], [epsilon, -epsilon] ];

  color(Oak)
  mvrot(z = -epsilon)
  linear_extrude(height = points[EXTRUDE_DEPTH])
    polygon( points = take(points, 4) + epsilonAdjust, convexity = 1);
}
/******************************************************************************/
/*
 * _inverseCrossLap
 *
 */
function _inverseCrossLap(lapWidth, lapLength, lapDepth, lapAngle) =
  //assert()
  let(
    fn = "_inverseCrossLap",
    args = [lapWidth, lapLength, lapDepth, lapAngle],
    bottomLeft = [0,0],
    topLeft = [0, lapLength],
    topRight = [lapWidth, lapLegth],
    bottomRight = [lapWidth, 0],

    pts = debugTap([bottomLeft, topLeft, topRight, bottomRight, lapThickness], fn2Str(fn, args))
  )
  //assert()
  pts;

/******************************************************************************/

/******************************************************************************/
/*
 * _inverseTemplate
 *
 */
function _inverseTemplate(lapWidth, lapLength, lapDepth, lapAngle) =
  //assert()
  let(
    fn = "_inverseTemplate",
    args = [lapWidth, lapLength, lapDepth, lapAngle],
    bottomLeft = [0,0],
    topLeft = [0, 0],
    topRight = [0, 0],
    bottomRight = [0, 0],

    pts = debugTap([bottomLeft, topLeft, topRight, bottomRight, lapThickness], fn2Str(fn, args))
  )
  //assert()
  pts;

/******************************************************************************/

/*
 * Creates a board with specified dimensions and attempts to apply all operations
 *
 * NOTE: because this is a recursive module be aware that the more operations the worse the
 * performance will be. Modules do not support tail-recursion.
 *
 * NOTE: operations are done in reverse order. Overall this should not make any difference
 *       to the final result.
 *
 * width, length, thickness = board dimensions
 * op = [operation, [arg1, arg2, ..., argn]]
 *
 * op ex: [LAPJOINT, [3.5, 9.25, 1.25, 0, topFront]]
 *        will create a lap joint at the topFront of the board. With a width of 3.5,
 *        length fo 9.25, depth of 1.25, and angle of 0.
 */
module joinery(width, length, thickness, ops, dimPadding=0){
  if(!empty(ops))
    difference(){
      joinery(width, length, thickness, tail(ops), dimPadding);
        // apply current operation
        op = head(ops);
        type = op[0];
        args = op[1];
        desc = is_def(op[2]) ? op[2] : "";
        if(type == LAP_JOINT){

          lapWidth = args[WIDTH];
          lapLength = args[LENGTH];
          lapThickness = args[THICKNESS];
          shoulderAngle = args[ANGLE];
          facing = args[FACING];

// this is seems to have issues within a recursive call. Move to _inverseLapPoints
//          assert(abs(shoulderAngle) < 90, "shoulder angle of the lap has to be less than 90°");

          points = _inverseLapPoints(lapWidth, lapLength, lapThickness, shoulderAngle);
          facingTrans = _inverseLapTransformations(facing, width, length, thickness);

          translate(facingTrans[0]) rotate(facingTrans[1])
            _inverseLap(points);
        }
        else {
          echo(str("<b>Joinery Operation: ", op, " not supported.</b>"));
        }
    }
  else
    board(width, length, thickness, dimPadding);
}

/*
 *
 *
 */
module boardWithLap(width, length, thickness, lapWidth=undef, lapLength=undef, lapThickness=undef, shoulderAngle=0, facing=TOP_FRONT, dimPadding=0){
  echo("<b>boardWithLap has been DEPRECATED, Use the joinery method</b>");
  assert(abs(shoulderAngle) < 90, "shoulder angle of the lap has to be less than 90°");

  echo(str("lapWidth: ", lapWidth, " lapLength: ", lapLength, " lapThickness: ", lapThickness));

  lapWidth = is_undef(lapWidth) ? width : lapWidth;
  lapLength = is_undef(lapLength) ? width : lapLength;
  lapThickness = is_undef(lapThickness) ? thickness/2 : lapThickness;

  points = _inverseLapPoints(lapWidth, lapLength, lapThickness, shoulderAngle);
  facingTrans = _inverseLapTransformations(facing, width, length, thickness);

  difference() {
    board(width, length, thickness, dimPadding * 2);
      translate(facingTrans[0]) rotate(facingTrans[1])
        _inverseLap(points, lapThickness);
  }

  if(dimPadding > 0)
    _lapJointDimensions(facingTrans, points, dimPadding, lapWidth, lapLength, lapThickness, shoulderAngle);
}

/*
 * Todo: Generalize this so all forms of joinery can display their dimensions
 *
 */
module _lapJointDimensions(facingTrans, points, dimPadding, lapWidth, lapLength, lapThickness, shoulderAngle){
// dimension lines for the lap joint; have to be done after the difference()
  lenLeftSide = norm(points[TOP_LEFT_POINT] - points[BOTTOM_LEFT_POINT]);
  lenRightSide = norm(points[TOP_RIGHT_POINT] - points[BOTTOM_RIGHT_POINT]);
  color("green")
  translate(facingTrans[0]) rotate(facingTrans[1]){
    //left height
    mvrot(x=points[BOTTOM_LEFT_POINT][0] - dimPadding - .2 , y=points[BOTTOM_LEFT_POINT][1], z=lapThickness)
    line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

    mvrot(x=points[TOP_LEFT_POINT][0] - dimPadding - .2 , y=points[TOP_LEFT_POINT][1], z=lapThickness)
    line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

    mvrot(x=-dimPadding * .8, y=lenLeftSide, z=lapThickness, rx=180, rz=-90)
    dimensions(lenLeftSide, line_width=DIM_LINE_WIDTH, loc=DIM_LEFT);

    //right height
    mvrot(x=3, z=lapThickness)
    line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

    mvrot(x=3, y=points[TOP_RIGHT_POINT][1], z=lapThickness)
    line(length=dimPadding, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

    mvrot(x=dimPadding + lapWidth * .8, y=lenRightSide, z=lapThickness, rx=180, rz=-90)
    dimensions(lenRightSide, line_width=DIM_LINE_WIDTH, loc=DIM_LEFT);

    //angle
    mvrot(
      x=sign(shoulderAngle) >=0 ? 0 : lapWidth,
      y=max(lenLeftSide, lenRightSide),
      z= lapThickness,
      rx=190
    )

    leader_line(
      angle=sign(shoulderAngle) >=0 ? 80 : 100,
      radius=0,
      angle_length=lapLength+1,
      horz_line_length=0,
      direction=DIM_RIGHT,
      line_width=DIM_LINE_WIDTH,
      text=str(shoulderAngle, "deg"),
      do_circle=false
    );
  }
}

/*
 * defines a board which is the basis for all this files operations
 */
module board(width, length, thickness, dimPadding=0){
  color(Pine) cube([width, length, thickness]);

  // dimension lines for the board
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

/******************************************************************************/
// dimension lumber short-cut modules
//   currently dimension lumber created with these short-cuts
//   are not implicitly support by joinery(). To use dimension
//   lumber with joinery you will have to explicitly define the
//   board either with the reference data above or using the
//   pre-defined constants.

module lumber(dimension = twoByFour, length = eightFeet) {
  board(dimension[WIDTH], length, dimension[THICKNESS]);
}

module oneByFour(length = eightFeet) {
  lumber(oneByFour, length);
}

module oneBySix(length = eightFeet) {
  lumber(oneBySix, length);
}

module twoByTwo(length = eightFeet) {
  lumber(twoByTwo, length);
}

module twoByFour(length = eightFeet) {
  lumber(twoByFour, length);
}

module twoBySix(length = eightFeet) {
  lumber(twoBySix, length);
}

module twoByTen(length = eightFeet) {
  lumber(twoByTen, length);
}

module fourByFour(length = eightFeet) {
  lumber(fourByFour, length);
}

module mdfSheet(length = eightFeet, width = fourFeet, thickness = 0.5) {
  color(FiberBoard) cube([ thickness, width, length ]);
}

// one off's that may or may not stay in this file.

/*
 * Standard Interior Wall
 * default
 */
module interiorHouseWall(length, height, width = 4.5) {
 cube([length, width, height], false);
}
