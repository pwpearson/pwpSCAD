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

/*
 * NaN - define not-a-number
 *
 *
 */
function NaN() = 0 / 0;

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
function gcd(a,b) = b == 0 ? a : gcd(b,a%b);


/*
 * nearest - round x to the nearest n-th. Like nearest 1/16th, 1/32th, etc
 *
 * ie: echo(nearest(.138, 64)) // ECHO:
 *
 */
function nearest(x, n) = round(x * n)/n;

/*
 * splitDecimal - split a decimal into it's rational and decimal parts
 *
 */
function splitDecimal(x) =
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
