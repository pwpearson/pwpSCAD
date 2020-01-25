

include <pwpSCAD/joinery.scad>
include <pwpSCAD/util.scad>

$_debug = true;

// see images/lap_joints_sample.png
// [ LAP_JOINT, [width, length, depth, shoulder angle]]

/* joineryOps = [
  [LAP_JOINT, [3.5, 9.25, 1.25, 0, TOP_FRONT]],
  [LAP_JOINT, [3.5, 9.25, 1.25, 25, BOTTOM_FRONT]],
  [LAP_JOINT, [3.5, 9.25, 1.25, 0, TOP_BACK]]
];

joinery(
  width = 3.5,
  length = 38,
  thickness = 3.5,
  ops = joineryOps,
  dimPadding=0); */

/**********************************************************/

// see images/cross_lap.png
// [CROSS_LAP, [length, depth, alignment, offset, from, face], description]

// length: how wide top to bottom for cut, [ board width]

// depth: how deep is the cut, [half - board depth.]

// face: FRONT, LEFT, BACK, RIGHT, [FRONT]

// alignment: TOP, BOTTOM, or CENTER of cut, [BOTTOM]

// offset: how many inches measured from the "from" arg

// from: offset is relative to TOP or BOTTOM

// description: optional

/*
cross lap: [op [length, depth, alignment, face, offset, from], description]
                 0       1      2           3       4     5
*/


joineryCrossLapOps = [
  [CROSS_LAP, [3.5, 1.5, BOTTOM, 20, BOTTOM, FRONT], "CROSS_LAP Operation 1"],
];   // op     len  dep   align  of  from     face     desc

joinery(
  width = 3.5,
  length = 38,
  thickness = 3.5,
  ops = joineryCrossLapOps,
  dimPadding=2);
