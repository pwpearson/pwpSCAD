
use <pwpSCAD/util.scad>
include <pwpSCAD/board.scad>
include <pwpSCAD/math.scad>
include <pwpSCAD/text.scad>

$_debug = true;

v = [1, 2, 3, 4];

echo(take(v, 3));
echo(take(v, 2));

echo(take(v, 4));
echo(take(v, 5));

echo("### fraction string: ", fractionStr(8.5));    //8 1/2
echo("### fraction string: ", fractionStr(12));     //12
echo("### fraction string: ", fractionStr(12.125)); //12 1/8
echo("### fraction string: ", fractionStr(8.138));
echo("### fraction string: ", fractionStr(16));
echo("### fraction string: ", fractionStr(17.128));
/*
x = reduceFraction(4, 8);
echo(str("4/8 reduces to: ", x[0], "/", x[1]));
y = reduceFraction(8, 32);
echo(str("8/32 reduces to: ", y[0], "/", y[1]));
w = reduceFraction(9, 32);
echo(str("9/32 reduces to: ", w[0], "/", w[1]));

echo("8/32 gcd: ", gcd(8,32));
echo("9/32 gcd: ", gcd(9,32)); */

x = [1, 2, 3, 4];
y = [1, "two", 3, 4];
w = [true, true, true];
z = [true, false, true];

echo(str("x: ", x));
echo(str("y: ", y));

echo([for (i = x) is_num(i) == true]);
echo([for (i = y) is_num(i)]);

echo(str("sumV(w)", sumV(w)));
echo(str("sumV(z)", sumV(z)));

echo(str("[]"), [] == true);
echo(str("[true]"), [true] == true);

echo(str("bits-x ", sumV([for (i = x) if (is_num(i)) 1 else 0]) == len(x)));
echo(str("bits-y ", sumV([for (i = y) if (is_num(i)) 1 else 0]) == len(y)));

echo(str("is_num(x)", is_num(x)));

echo(nearest(.138, 64));

echo(fractionStr(0.140625));

echo(splitDecimal(4.6));

echo(reductFraction(10/64))
