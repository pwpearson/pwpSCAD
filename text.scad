/*
 * Text - Text string routines
 * rick pearson 1-25-2020
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

include <pwpSCAD/debug.scad>
include <pwpSCAD/math.scad>

/*
 * fractionStr - generates the string representation of decimal value.
 *               generally expected to be used to display dimensions
 *               in feet, inches, and fractions of an inche
 *
 * ex: 5.128 generates the string 1' 5 1/8"
 */
function fractionStr(inchesDecimal) =
let(
  nothing = debugTap(inchesDecimal, "**** inches"),
  feetDecimal = inchesToFeet(inchesDecimal),
  feet_n_Inches = splitDecimal(feetDecimal), //[feet, inches]
  feet = debugTap(feet_n_Inches[0], "feet"),
  inchesDecimal = debugTap(round((feet_n_Inches[1] * 12) * 1000)/1000, "inchesDecimal"),
  inches_n_Fractions = splitDecimal(inchesDecimal), //[inches, fractions]
  inches = debugTap(inches_n_Fractions[0], "inches"),
  fractions = debugTap(inches_n_Fractions[1], "fractions"),
  nearest64th = debugTap(nearest(fractions, 64), "Nearest 64th"),
  reduction = debugTap(reduceFraction(nearest64th * 1000, 1000), "Reduction")
)
str(feet > 0 ? str(feet, (inches == 0 && reduction[0] == 0) ? "\'" : "\' ") : "",
    inches > 0 ? str(inches, (reduction[0] == 0) ? "\"": " ") : "",
    reduction[0] > 0 ? str(reduction[0], "/", reduction[1], "\"") : ""
);
