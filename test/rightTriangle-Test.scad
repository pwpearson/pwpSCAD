/*
 * Unit Tests for rightTriangle module
 * rick pearson (pwpearson@gmail.com)
 * 1/10/2020
 *
 */

use <pwpSCAD/rightTriangle.scad>

_debug = false;

module debug(s) {
  if (_debug)
    echo(s);
}

// A really small value useful in comparing FP numbers. ie: abs(a-b)<EPSILON
epsilon = 1e+009;

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

function _eq(x, y) = abs(x - y) < epsilon;
/*
 * rightTriangle-Leg-plus-Opposite-Angel
 *
 *          β +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α
 *              b=4
 *        h=2.4
 */
module test_raCOA_side_a() {
  echo("**** test_raCOA_side_a");
  // 3-4-5 triangle
  // a = 3; β = 36.87;
  triangle345 = raCOA(3, 36.87);

  debug(str("triangle345 a", triangle345));

  assert(triangle345[constCathetus1] == 3);
  assert(_eq(triangle345[constCathetus2], 4),
         str("Actual value ", triangle345[constCathetus2]));
  assert(_eq(triangle345[constHypot], 5));
  assert(_eq(triangle345[constHeight], 2.4))
      assert(_eq(triangle345[constAngle2], 53.13));
}

test_raCOA_side_a();

/* rightTriangle-Other-Leg-plus-Angel
 *
 *          β +
 *            ++
 *            + +
 *        a=4 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α
 *              b=3
 *        h=2.4
 */
module test_raCOA_side_b() {
  echo("**** test_raCOA_side_b");
  // 3-4-5 triangle
  // a = 4; β = 53.13;
  triangle345 = raCOA(4, 53.13);
  debug(str("triangle345 b", triangle345));

  assert(triangle345[constCathetus1] == 4);
  assert(_eq(triangle345[constCathetus2], 3));
  assert(_eq(triangle345[constHypot], 5));
  assert(_eq(triangle345[constAngle1], 53.13));
  assert(_eq(triangle345[constAngle2], 36.87));
  assert(_eq(triangle345[constHeight], 2.4));
}

test_raCOA_side_b();

/* rightTriangle-both-legs
 * straight up Pythagorean
 *
 *          β +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α
 *              b=4
 *        h=2.4
 */
module test_raCC() {
  echo("**** test_raCC");
  triangle345 = raCC(3, 4);
  debug(str("triangle345 raCC", triangle345));

  assert(triangle345[constCathetus1] == 3);
  assert(triangle345[constCathetus2] == 4);
  assert(triangle345[constHypot] == 5);
  assert(_eq(triangle345[constAngle1], 36.87));
  assert(_eq(triangle345[constAngle2], 53.13));
  assert(triangle345[constHeight] == 2.4);
}

test_raCC();

/* rightTriangle-cathetus-hypotenuse
 *
 *          β +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α
 *              b=4
 *        h=2.4
 */
module test_raCHypot_a() {
  echo("**** test_raCHpot");
  triangle345 = raCHypot(3, 5);
  debug(str("triangle345 a raCHypot", triangle345));

  assert(triangle345[constCathetus1] == 3);
  assert(triangle345[constCathetus2] == 4);
  assert(triangle345[constHypot] == 5);
  assert(_eq(triangle345[constAngle1], 36.87));
  assert(_eq(triangle345[constAngle2], 53.13));
  assert(triangle345[constHeight] == 2.4);
}

test_raCHypot_a();

/*
 *
 *          β +
 *            ++
 *            + +
 *        a=4 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α
 *              b=3
 *        h=2.4
 */
module test_raCHypot_b() {
  echo("**** test_raCHypot_b");
  triangle345 = raCHypot(4, 5);
  debug(str("triangle345 b raCHypot", triangle345));

  assert(triangle345[constCathetus1] == 4);
  assert(triangle345[constCathetus2] == 3);
  assert(triangle345[constHypot] == 5);
  assert(_eq(triangle345[constAngle1], 53.13));
  assert(_eq(triangle345[constAngle2], 36.87));
  assert(triangle345[constHeight] == 2.4);
}

test_raCHypot_b();

/*
 *
 *          β +
 *            ++
 *            + +
 *        a=3 +  + c=5
 *            +   +
 *            ++   +
 *          𝛄 +++++++ α
 *              b=4
 *        h=2.4
 */
module test_raCHeight() {
  echo("**** test_raCHeight");
  triangle345 = raCHeight(3, 2.4);
  debug(str("triangle345 a raCHeight", triangle345));

  assert(triangle345[constCathetus1] == 3);
  assert(triangle345[constCathetus2] == 4);
  assert(triangle345[constHypot] == 5);
  assert(_eq(triangle345[constAngle1], 36.87));
  assert(_eq(triangle345[constAngle2], 53.13));
  assert(triangle345[constHeight] == 2.4);
}

test_raCHeight();
