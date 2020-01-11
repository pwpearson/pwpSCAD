/*
 *
 *
 */
include <MCAD/materials.scad>

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

module lumber(dimension = twoByFour, length = eightFeet, trueCenter = false) {
  color(Pine) cube(concat(dimension, [length]), trueCenter);
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
