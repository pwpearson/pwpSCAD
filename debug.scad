/*
 * debug
 * rick pearson (pwpearson@gmail.com)
 * 1/14/2020
 *
 */

$_debug = false;

module debug(s)
{
  if ($_debug)
    echo(s);
}

function debug(s) =
  [ for (i = [1:1]) if ($_debug) echo(s) ];



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
