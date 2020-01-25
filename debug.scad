/*
 * Debug - Debug utilites
 * rick pearson 1/14/2020
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

$_debug = false;

/*
 * debug module - echo string (s) to console if
 *                $_debug is true.
 *
 */
module debug(s)
{
  if ($_debug)
    echo(s);
}

/*
 * debug function - echo string (s) to console if
 *                  $_debug is true.
 * use like a trace.
 */

function debug(s) =
  [ for (i = [1:1]) if ($_debug) echo(s) ];

/*
 * Assert False - Always fails and echo's s to console
 * use in braches of code that should never be reached.
 */
function assertFalse(s) = assert(false, s) undef;



/*
 * Similar to Ruby's Tap function.
 * This function encapsulates the echo to console
 * side-effect and returns the object (o). The logging
 * to the console only happens if the $_debug flag is set
 * to true.
 *
 * o: the object to be written to console and passed back
 * s: string value to be prefixed to the object when logged to console
 *
 * returns: o
 *
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * ex:
 *
 * function foo(x) =
 *   let(
 *    fnName = "foo",
 *    args = [x],
 *    rslt = debugTap(x * x, str(fnName, parseArgsToString(args)))
 *  )
 *  rslt;
 *
 * OR:
 *
 * function foo(x) =
 *   let(
 *    fnName = "foo",
 *    args = [x]
 *  )
 *  debugTap(x * x, str(fnName, parseArgsToString(args)));
 *
 */
function debugTap(o, s) = let(
  nothing = [ for (i = [1:1]) if ($_debug) echo(str(s, ": ", o)) ]) o;
