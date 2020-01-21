

DOC_SCALING_FACTOR = 5;

include <Dimensional-Drawings/dimlines.scad>

DIM_LINE_WIDTH = .025 * DOC_SCALING_FACTOR;
DIM_SPACE = .1 * DOC_SCALING_FACTOR;
DIM_LINE_PAD = .5;


color("blue"){
  translate([0, 1, 0])
  line(length=5, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

  line(length=5, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false);

  translate([0, -1, 0])
  dimensions(10, line_width=DIM_LINE_WIDTH, loc=DIM_CENTER);
}
