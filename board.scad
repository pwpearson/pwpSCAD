/*
 * board - create custom and dimensional lumber
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

include <pwpSCAD/math.scad>
include <pwpSCAD/debug.scad>

// all values are in inches;

 /*
 reference for dimensional lumber

 nominal   actual (inches)   actual (mm)
 ---------------------------------------
 1 x 2	    3/4 x 1 1/2	      19 x 38
 1 x 3	    3/4 x 2 1/2	      19 x 64
 1 x 4	    3/4 x 3 1/2	      19 x 89
 1 x 6	    3/4 x 5 1/2	      19 x 140
 1 x 8	    3/4 x 7 1/4	      19 x 184
 1 x 10	    3/4 x 9 1/4	      19 x 235
 1 x 12	    3/4 x 11 1/4	    19 x 286

 2 x 2	    1 1/2 x 1 1/2	    38 x 38
 2 x 3	    1 1/2 x 2 1/2	    38 x 64
 2 x 4	    1 1/2 x 3 1/2	    38 x 89
 2 x 6	    1 1/2 x 5 1/2	    38 x 140
 2 x 8	    1 1/2 x 7 1/4	    38 x 184
 2 x 10	    1 1/2 x 9 1/4	    38 x 235
 2 x 12	    1 1/2 x 11 1/4	  38 x 286

 4 x 4	    3 1/2 x 3 1/2	    89 x 89
 */

 /* vector elements:
  *    when a vector describes a board
  *
  * Vector object dimension elements
  * board = [ width, length, thickness]
  */
 WIDTH = 0;         // +x-axis
 HEIGHT = 1;        // +y-axis
 LENGTH = HEIGHT;   // +y-axis
 DEPTH = 2;         // +z-axis
 THICKNESS = DEPTH; // +z-axis

 // actual size (inches); dimensional lumber
 ONE_BY_TWO    = [ 0.75, 1.5 ];
 ONE_BY_FOUR   = [ 0.75, 3.5 ];
 ONE_BY_SIX    = [ 0.75, 5.5 ];
 ONE_BY_EIGHT  = [ 0.75, 7.25 ];
 ONE_BY_TEN    = [ 0.75, 9.25 ];
 ONE_BY_TWELVE = [ 0.75, 11.25 ];

 TWO_BY_TWO    = [ 1.5, 1.5 ];
 TWO_BY_FOUR   = [ 1.5, 3.5 ];
 TWO_BY_SIX    = [ 1.5, 5.5 ];
 TWO_BY_EIGHT  = [ 1.5, 7.25 ];
 TWO_BY_TEN    = [ 1.5, 9.25 ];
 TWO_BY_TWELVE = [ 1.5, 11.25 ];

 FOUR_BY_FOUR = [ 3.5, 3.5 ];

 // all values are in inches;
 EIGHT_FEET = feetToInches(8);
 FOUR_FEET = feetToInches(4);

 SHEET = [ FOUR_FEET, EIGHT_FEET ];

 // constants
 DEPTH2X4 = TWO_BY_FOUR[DEPTH];
 WIDTH2X4 = TWO_BY_FOUR[WIDTH];

 HALF_WIDTH2X4 = WIDTH2X4/2;

 DEPTH2X6 = TWO_BY_SIX[DEPTH];
 WIDTH2X6 = TWO_BY_SIX[WIDTH];

 DEPTH2X8 = TWO_BY_EIGHT[DEPTH];
 WIDTH2X8 = TWO_BY_EIGHT[WIDTH];

 DEPTH2X10 = TWO_BY_TEN[DEPTH];
 WIDTH2X10 = TWO_BY_TEN[WIDTH];

 DEPTH4X4 = FOUR_BY_FOUR[DEPTH];
 WIDTH4X4 = FOUR_BY_FOUR[WIDTH];

function getBoardVector(width,length, thickness) =
 assert(is_def(width), "Width not defined")
 assert(is_def(length), "Length not defined")
 assert(is_def(thickness), "Thickness not defined")
 [width, length, thickness];

/*
 * defines a board which is the basis for all this files operations
 */
module board(width, length, thickness, dimPadding=0){
  cube([width, length, thickness]);

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
  cube([ thickness, width, length ]);
}

// one off's that may or may not stay in this file.

/*
 * Standard Interior Wall
 * default
 */
module interiorHouseWall(length, height, width = 4.5) {
 cube([length, width, height], false);
}
