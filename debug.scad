/*
 * debug
 * rick pearson (pwpearson@gmail.com)
 * 1/14/2020
 *
 */

module debug(s)
{
  if ($_debug)
    echo(s);
}

function debug(s) =
  [ for (i = [1:1]) if ($_debug) echo(s) ];

function debugTap(o, s) = let(
  nothing = [ for (i = [1:1]) if ($_debug) echo(str(s, ": ", o)) ]) o;


//Test
/*
$_debug = true;
v = debugTap([1, 2, 3], "Vector: ");
assert(v == [1, 2, 3], "Failed debugTap");
*/
