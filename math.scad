/*
 * Math - Math routines
 * rick pearson 1-15-2020
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


$_debug = true;

// A really small value useful in comparing FP numbers. ie: abs(a-b)<EPSILON
epsilon = 1e-009;

/*
 * nan - not a number
 */
function NaN() = 0 / 0;

/*
 * Infinity
 */
inf = 1e200 * 1e200;

/*
 * trunc - truncates a number to it's rational part
 *
 * ex: trunc(5.5) == 5; trunc(-4.7) == -4;
 */
function trunc(n) =
  is_num(n) ?
    sign(n) == 1
      ? floor(n)
      : ceil(n)
    : NaN();

/*
 * sum the elements of a list.
 * skip undef elements
 *
 */
function sumV(v, i = 0, tot = undef) =
    i >= len(v) ? tot :
                  let(element = is_undef(v[i]) ? 0 : v[i])
                      sumV(v, i + 1, ((tot == undef) ? element : tot + element));

/*
 * gcd - greatest common denomiator
 *
 */
function gcd(a,b) =
  assert(is_num(a), "Parameter a is not numeric")
  assert(is_num(b), "Parameter b is not numeric")
  _gcd(a, b);

function _gcd(a, b) = b == 0 ? a : gcd(b,a%b);


/*
 * nearest - round x to the nearest n-th. Like nearest 1/16th, 1/32th, etc
 *
 * ie: echo(nearest(.138, 64)); // ECHO: 0.140625 ### 9/64
 *
 */
function nearest(x, n) =
  assert(is_num(x), "Parameter x is not numeric")
  assert(is_num(n), "Parameter n is not numeric")
  round(x * n)/n;

/*
 * splitDecimal - split a decimal into it's rational and decimal parts
 *                and returns them as a vector "[rational, fraction]"
 *
 * ie: echo(splitDecimal(4.6)); // ECHO: [4, 0.6]
 */
function splitDecimal(x) =
  assert(is_num(x), "Parameter x is not numeric")
  let(
    rationalPart = debugTap(trunc(x), "Rational"),
    decimalPart = debugTap(x - rationalPart, "Decimal")
  )
  [rationalPart, decimalPart];

/*
 * reduceFraction - reduce a fraction to it's lcd
 *
 */
function reduceFraction(dividend, divisor) =
  let(gcd = gcd(dividend, divisor))
  [dividend/gcd, divisor/gcd];

/*
 * convert feet to inches
 *
 */
function feetToInches(feet) = feet * 12;

/*
 * convert inches to feet
 *
 */
function inchesToFeet(inches) = inches/12;

/*
 * all_num - returns true if all elements are numberic, else false
 *
 * flattens nested lists to determine if all values are numeric.
 */
function all_num(list) =
  !is_list(list)
    ? false
    : len(list) == 0
      ? false
      : [ for (element = [for (i = list) each i]) if (!is_num(element)) false ][0] == undef ? true : false;


/*
 * compare equality using epsilon to adjust for precision descrepencies between values
 * aka, are the values equal within a given variance (epsilon)
 *
 */
/* function _eq(x, y) = ($_debug) ?
    echo(str("x: ", x, ", y: ", y, ", abs(x-y): ", abs(x - y))) abs(x - y) < epsilon :
    abs(x - y) < epsilon; */

function eq(x, y, _epsilon = epsilon) =
  let(
    // take the max episolon, either file level or argument level
    __epsilon = debugTap(max($epsilon, _epsilon), "epsilon"),
    diff = debugTap(abs(x -y), "diff(x, y)"),
    rslt = debugTap(diff <= __epsilon,
        str("(x, y): (", x, ",", y, ") epsilon: ", __epsilon))
  )
  rslt;
