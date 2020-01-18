/*
 * util
 * rick pearson (pwpearson@gmail.com)
 * 1/14/2020
 */

// move and rotate
module mvrot(x = 0, y = 0, z = 0, rx = 0, ry = 0, rz = 0)
{
  translate([ x, y, z ]) rotate([ rx, ry, rz ]) children();
}

// stamp
module stamp(num, space = 0)
{
  for (i = [0:num - 1]) translate([ space * i, 0, 0 ]) children(0);
}

// creates a ruler with 12 inch alternating colors
// assumes scale of 1:1
module ruler(length)
{
  colors = [ "red", "white" ];

  for (i = [0:length])
  {
    color(colors[ceil(i % 2)]) move(x = i * 12) cube([ 12, 1, .1 ]);
  }
}

/*
 * removeUndefFromVector
 * returns a vector with undef elements removed
 *
 *
 */
function removeUndefFromVector(v) = [for (i = [0:len(v)]) each v[i]];


/*
 * bbox - bounding box
 *
 *
 *
 */
module bbox() {

  // a 3D approx. of the children projection on X axis
  module xProjection()
      translate([0,1/2,-1/2])
          linear_extrude(1)
              hull()
                  projection()
                      rotate([90,0,0])
                          linear_extrude(1)
                              projection() children();

  // a bounding box with an offset of 1 in all axis
  module bbx()
      minkowski() {
          xProjection() children(); // x axis
          rotate(-90)               // y axis
              xProjection() rotate(90) children();
          rotate([0,-90,0])         // z axis
              xProjection() rotate([0,90,0]) children();
      }

  // offset children() (a cube) by -1 in all axis
  module shrink()
    intersection() {
      translate([ 1, 1, 1]) children();
      translate([-1,-1,-1]) children();
    }

 shrink() bbx() children();
}

function fn2Str(name, args=[], rslt=undef) = str(name, parseArgsToString(args), is_undef(rslt) ? "" : str(": ", rslt));

function parseArgsToString(args, i=0, accum=undef) =
  i >= len(args) ? str("(", accum, ")") :
                  let (element = is_undef(args[i]) ? "" : args[i])
                  parseArgsToString(args, i + 1, is_undef(accum) ? element : str(accum, ", ", element));

echo(fn2Str("test", [1,2,3]));
echo(fn2Str("test2", [1,2,3], 6));
