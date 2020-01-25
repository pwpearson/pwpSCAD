
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
