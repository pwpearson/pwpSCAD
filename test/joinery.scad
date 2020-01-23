

include <pwpSCAD/building-materials.scad>
use <pwpSCAD/util.scad>

joineryOps = [
  [LAPJOINT, [3.5, 9.25, 1.25, 0, topFront]],
  [LAPJOINT, [3.5, 9.25, 1.25, 25, bottomFront]],
  [LAPJOINT, [3.5, 9.25, 1.25, 0, topBack]]
];

joinery(
  width = 3.5,
  length = 38,
  thickness = 3.5,
  ops = joineryOps,
  dimPadding=0);
