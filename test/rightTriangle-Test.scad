/*
 * Unit Tests for rightTriangle module
 * rick pearson (pwpearson@gmail.com)
 * 1/10/2020
 *
 */

use <pwpSCAD/rightTriangle.scad>

_debug = false;

module debug(s)
{
  if (_debug)
    echo(s);
}

// A really small value useful in comparing FP numbers. ie: abs(a-b)<EPSILON
epsilon = 1e-003;

debug(str("epsilon: ", epsilon));

/*
 * Assume the following right triangle for the following tests
 *
 *         β +
 *           ++
 *           + +
 *           +  +
 *           +   +
 *           +    +
 *           +     +
 *           +      +
 *           +       +
 *         a +        + c
 *           +         +
 *           +          +
 *           +           +
 *           +            +
 *           ++++          +
 *           +  +           +
 *         𝛄 +++++++++++++++++ α
 *                   b
 *
 *       a and b are cathetus or legs,
 *       c is the hypotenuse,
 *       α and β are the angles,
 *       𝛄 is the right angle vertex
 *       h is a perpendicular line from c to the 90 degree vertex
 *       a is opposite of α
 *       b is opposite of β
 *       a is adjancent to β
 *       b is adjancent to α
 */

// define constants
constCathetus1 = constCathetus1();
constCathetus2 = constCathetus2();
constHypot = constHypot();
constAngle1 = constAngle1();
constAngle2 = constAngle2();
constHeight = constHeight();

function _eq(x, y) = (_debug) ?
    echo(str("x: ", x, ", y: ", y, ", abs(x-y): ", abs(x - y))) abs(x - y) < epsilon :
    abs(x - y) < epsilon;

targetVector345 = [ 3, 4, 5, 53.13, 36.87, 2.4 ];
targetVector435 = [ 4, 3, 5, 36.87, 53.13, 2.4 ];

/*
 *
 *
 * sv: source vector
 * tv: target vector
 */
module assertRightTriangleVectors(sv, tv)
{
  assert(!is_undef(sv), "Source Vector is undef");
  assert(!is_undef(tv), "Target Vector is undef");
  assert(len(sv) == 6, "Source Vector is expected to have 6 elements");
  assert(len(tv) == 6, "Target Vector is expected to have 6 elements");

  debug(str("assertRightTriangleVectors.sv: ", sv));
  debug(str("assertRightTriangleVectors.tv: ", tv));

  assert(_eq(sv[constCathetus1], tv[constCathetus1]),
         str("Cathetus1 - Actual: ", sv[constCathetus1], " Expected: ", tv[constCathetus1]));

  assert(_eq(sv[constCathetus2], tv[constCathetus2]),
         str("Cathetus2 - Actual: ", sv[constCathetus2], " Expected: ", tv[constCathetus2]));

  assert(_eq(sv[constHypot], tv[constHypot]),
         str("Hypot - Actual: ", sv[constHypot], " Expected: ", tv[constHypot]));

  assert(_eq(sv[constAngle1], tv[constAngle1]),
         str("Angle1 - Actual: ", sv[constAngle1], " Expected: ", tv[constAngle1]));

  assert(_eq(sv[constAngle2], tv[constAngle2]),
         str("Angle2 - Actual: ", sv[constAngle2], " Expected: ", tv[constAngle2]));

  assert(_eq(sv[constHeight], tv[constHeight]),
         str("Height - Actual: ", sv[constHeight], " Expected: ", tv[constHeight]));
}

/*
 * rightTriangle-Leg-plus-Opposite-Angel
 *
 *    β=53.13 +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α=36.87
 *              b=4
 *        h=2.4
 */
module test_raCOA_side_a()
{
  echo("**** test_raCOA_side_a - run");
  triangle345 = raCOA(c = 3, oA = 36.87);

  debug(str("triangle345 a", triangle345));

  assertRightTriangleVectors(triangle345, targetVector345);
}

test_raCOA_side_a();

/* rightTriangle-Other-Leg-plus-Angel
 *
 *    β=36.87 +
 *            ++
 *            + +
 *        a=4 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α=53.13
 *              b=3
 *        h=2.4
 */
module test_raCOA_side_b()
{
  echo("**** test_raCOA_side_b - run");
  triangle345 = raCOA(c = 4, oA = 53.13);
  debug(str("triangle345 b", triangle345));

  assertRightTriangleVectors(triangle345, targetVector435);
}

test_raCOA_side_b();

/*
 * rightTriangle-Leg-plus-Opposite-Angel
 *
 *    β=53.13 +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α=36.87
 *              b=4
 *        h=2.4
 */
module test_raCAA()
{
  echo("**** test_raCAA - run");
  triangle345 = raCAA(c = 3, aA = 53.13);
  debug(str("triange345 ", triangle345));

  assertRightTriangleVectors(triangle345, targetVector345);
}

test_raCAA();

/* rightTriangle-both-legs
 * straight up Pythagorean
 *
 *    β=53.13 +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α=36.87
 *              b=4
 *        h=2.4
 */
module test_raCC()
{
  echo("**** test_raCC - run");
  triangle345 = raCC(c1 = 3, c2 = 4);
  debug(str("triangle345 raCC", triangle345));

  assertRightTriangleVectors(triangle345, targetVector345);
}

test_raCC();

/* rightTriangle-cathetus-hypotenuse
 *
 *    β=53.13 +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α=36.87
 *              b=4
 *        h=2.4
 */
module test_raCHypot_a()
{
  echo("**** test_raCHpot_a - run");
  triangle345 = raCHypot(c = 3, hypot = 5);
  debug(str("triangle345 a raCHypot", triangle345));

  assertRightTriangleVectors(triangle345, targetVector345);
}

test_raCHypot_a();

/*
 *
 *    β=36.87 +
 *            ++
 *            + +
 *        a=4 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α=53.13
 *              b=3
 *        h=2.4
 */
module test_raCHypot_b()
{
  echo("**** test_raCHypot_b - run");
  triangle345 = raCHypot(c = 4, hypot = 5);
  debug(str("triangle345 b raCHypot", triangle345));

  assertRightTriangleVectors(triangle345, targetVector435);
}

test_raCHypot_b();

/*
 *
 *    β=53.13 +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α=36.87
 *              b=4
 *        h=2.4
 */
module test_raCHeight()
{
  echo("**** test_raCHeight - run");
  triangle345 = raCHeight(c = 3, h = 2.4);
  debug(str("triangle345 a raCHeight", triangle345));

  assertRightTriangleVectors(triangle345, targetVector345);
}

test_raCHeight();
