/*
 * Joinery - Woodworking joinery operations for Boards.scad
 * rick pearson 1-24-2020
 * pwpearson@gmail.com
 *
 * MIT License
 *
 * Copyright (c) 2020 Rick Pearson
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


include <missile/missile.scad> // vector ops like head, tail, empty, reverse, etc
include <pwpSCAD/rightTriangleSolver.scad> // solves attributes for right triangles
include <pwpSCAD/util.scad>    // general purpose functions for pwpSCAD library
include <pwpSCAD/board.scad>   // defines custom and dimentinal lumber material.
include <pwpSCAD/debug.scad>   // debug functions

DOC_SCALING_FACTOR = 5;

include <Dimensional-Drawings/dimlines.scad>

DIM_LINE_WIDTH = .025 * DOC_SCALING_FACTOR;
DIM_SPACE = .1 * DOC_SCALING_FACTOR;
DIM_LINE_PAD = .5;

$_debug = true;

// small number used in comparisions and inversion object scaling to
// elimate or minimize rendering artifacts
epsilon = 1e-002;

// used to adjust the inversion objections before they are differenced with the "board" object.
// if we don't do this we end up with display artifacts that make it look like the object has not
// been properly differenced.
epsilonAdjust = [[-epsilon, -epsilon], [-epsilon, epsilon], [epsilon, epsilon], [epsilon, -epsilon] ];

// facings:

/*
 * newly created objects prior to translations
 * have default board() facing as follows:
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
 BOTTOM_LEFT = 5;   //[-1, -1, 0]              (0,0)
 BOTTOM_BACK = 6;   //[0, -1, -1]
 BOTTOM_RIGHT = 7;  //[1, -1, 0]

function is_EndFacing(x) = (x >= TOP_FRONT && x <= BOTTOM_RIGHT);

// used to position lap joints on a face but not necassarily at the end of the board
 FRONT = 8;
 LEFT = 9;
 BACK = 10;
 RIGHT = 11;
 TOP = 12;
 BOTTOM = 13;

function is_Facing(x) = (x >= FRONT && x <= BOTTOM);

/**************************************************************************************/

// alignment:
// for grooves, dado, mortis, etc
ALIGN_TOP = 0;
ALIGN_CENTER = 1;
ALIGN_BOTTOM = 2;

function is_Alignment(x) = (x >= ALIGN_TOP && x <= ALIGN_BOTTOM);
/**************************************************************************************/

/* vector elements:
 *    when a vector describes a board, lap joint, etc
 *    redefines the values in board.scad in order to add angle and facing
 *
 * Vector object dimension elements
 * board = [ width, length, thickness]
 * lap joint = [depth, width, (height|length), angle, facing]
 */
WIDTH = 0;         // +x-axis
HEIGHT = 1;        // +y-axis
LENGTH = HEIGHT;   // +y-axis
DEPTH = 2;         // +z-axis
THICKNESS = DEPTH; // +z-axis
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

function is_Joinery(x) = (x >= LAP_JOINT && x <= PIN);

function lapJointOp(width, length, thickness, angle, facing, desc="") =
  assert(is_EndFacing(facing), "Not a valid facing.")
  assert(abs(angle) < 90, "Angle has to be less than 90 degrees")
  assert(is_def(width), "Width not defined")
  assert(is_def(length), "Length not defined")
  assert(is_def(thickness), "Thickness not defined")
  [LAP_JOINT, [width, length, thickness, angle, facing], desc];

function crossLapOp(length, depth, face, alignment, offset, from) =
  [length, depth, face, alignment, offset, from];


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

/*
operation args:

lap joint: [op [width, length, thickness, angle, facing], descrition];
cross lap: [op [length, depth, alignment, offset, from, face], description]

*/

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
    tangle = debugTap(rightTriangleSolver(a = lapWidth, beta = shoulderAngle), str(fn, " tangle: ")),
    b = is_def(tangle) ? tangle[1] :0,

    bottomLeft = [0,0],
    topLeft = shoulderAngle >= 0 ? [0, lapLength] : [0, lapLength - b],
    topRight = shoulderAngle > 0 ? [lapWidth, lapLength - b] : [lapWidth, lapLength],
    bottomRight = [lapWidth, 0],

    pts = debugTap([bottomLeft, topLeft, topRight, bottomRight, lapThickness], fn2Str(fn, args))
  )
  assert( b < lapLength, "lap length not long enough for the desired angle")
  pts;

  // this is seems to have issues within a recursive call. Move to _inverseLapPoints
  //          assert(abs(shoulderAngle) < 90, "shoulder angle of the lap has to be less than 90°");


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
  assertFalse(str("Facing Transform not found for value: ", facing));

/*
 * defines the 3d object based off the 2d polygon points
 *
 */
module _inverseLap(points) {
  debug(str("init: inverseLap(", points, ")"));

  mvrot(z = -epsilon)
  linear_extrude(height = points[EXTRUDE_DEPTH])
    polygon( points = take(points, 4) + epsilonAdjust, convexity = 1);
}
/******************************************************************************/
/*
 * _inverseCrossLap
 *
 */
function _inverseCrossLapPoints(lapWidth, lapLength, lapThickness, lapAngle) =
  //assert()
  let(
    fn = "_inversCrossLap",
    args = [lapWidth, lapLength, lapThickness, lapAngle],
    tangle = debugTap(rightTriangleSolver(a=lapWidth, beta=lapAngle), str(fn, " tangle: ")),
    b = is_def(tangle ? tangle[1] : 0),

    bottomLeft = [0,0],
    topLeft = [0, lapLength],
    topRight = [lapWidth, lapLength],
    bottomRight = [lapWidth, 0],

    pts = debugTap([bottomLeft, topLeft, topRight, bottomRight, lapThickness], fn2Str(fn, args))
  )
  //assert()
  pts;

function _inverseCrossLapTransformations(facing, length, depth, align, offset, from) =
  facing == FRONT ? [[0, 0, depth], [0, 180, 0]] :
  facing == LEFT ? [[0, 0, 0], [0, 0, 0]] :
  facing == BACK ? [[0, 0, 0], [0, 0, 0]] :
  facing == RIGHT ? [[0, 0, 0], [0, 0, 0]] :
  assertFalse(str("Facing Transform not found for value: ", facing));

module _inverseCrossLap(points){
  debug(str("init: inverseCrossLap(", points, ")"));

  mvrot(z = -epsilon)
  linear_extrude(height = points[EXTRUDE_DEPTH])
    polygon( points = take(points, 4) + epsilonAdjust, convexity = 1);
}

/******************************************************************************/


/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/*
 * _inverseTemplate
 *
 */
function _inverseTemplate(lapWidth, lapLength, lapThickness, lapAngle) =
  //assert()
  let(
    fn = "_inverseTemplate",
    args = [lapWidth, lapLength, lapThickness, lapAngle],
    bottomLeft = [0,0],
    topLeft = [0, 0],
    topRight = [0, 0],
    bottomRight = [0, 0],

    pts = debugTap([bottomLeft, topLeft, topRight, bottomRight, lapThickness], fn2Str(fn, args))
  )
  //assert()
  pts;

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
$dimension = undef;

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
          //args(width, length, thickness, angle, facing)
          lapWidth = args[WIDTH];
          lapLength = args[LENGTH];
          lapThickness = args[THICKNESS];
          shoulderAngle = args[ANGLE];
          facing = args[FACING];

          points = _inverseLapPoints(lapWidth, lapLength, lapThickness, shoulderAngle);
          facingTrans = _inverseLapTransformations(facing, width, length, thickness);

          $dimension = [facingTrans, points, dimPadding, lapWidth, laplength, lapDepth, shoulderAngle];

          translate(facingTrans[0]) rotate(facingTrans[1])
            _inverseLap(points);
        }

        if(type == CROSS_LAP){
          //args([width], length, depth, [angle], facing, alignment, offset, from)
          lapWidth = width;
          lapLength = args[0];
          lapDepth = args[1];
          lapThickness = lapDepth;
          shoulderAngle = 0;
          facing = args[3];

          alignment = args[2];
          offset = args[4];
          from = args[5];




          points = _inverseCrossLapPoints(width, lapLength, lapDepth, shoulderAngle);
          facingTrans = _inverseCrossLapTransformations(facing, lapLength, lapDepth, alignment, offset, from) ;

          $dimension = [facingTrans, points, dimPadding, lapWidth, laplength, lapDepth, shoulderAngle];

          translate(facingTrans[0]) rotate(facingTrans[1])
          #  _inverseCrossLap(points);
        }

        else {
          echo(str("Joinery Operation: ", op, " not supported."));
        }
    }

  else
    board(width, length, thickness, dimPadding + 2);

  if (dimPadding > 0) _lapJointDimensions($dimension[0], $dimension[1], $dimension[2], $dimension[3], $dimension[4], $dimension[5], $dimension[6]);

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
