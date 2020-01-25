/*
 * Util - Utility functions
 * rick pearson 1-14-2020
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
 * take - take the first n number of elements from list or vector
 *
 *
 *
 */
function take(v, n) = n <= len(v) ? [for (i = [0:n-1]) v[i]] : v;


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

//echo(fn2Str("test", [1,2,3]));
//echo(fn2Str("test2", [1,2,3], 6));

function is_def(a) = !is_undef(a);
