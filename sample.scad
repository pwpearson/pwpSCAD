
include <pwpSCAD/util.scad>
include <pwpSCAD/debug.scad>

/*
 * demo debugTap
 *
 */

$_debug = true;

function foo(x) =
  let(
   fnName = "foo",
   args = [x]
 )
 debugTap(x * x, str(fnName, parseArgsToString(args)));

x = 2;
y = foo(x);

echo(str("x: ", x, " y: ", y));

/********************************************************/
