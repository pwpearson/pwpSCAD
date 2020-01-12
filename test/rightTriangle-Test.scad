/*
 * Unit Tests for rightTriangle module
 * rick pearson (pwpearson@gmail.com)
 * 1/10/2020
 *
 */

 use <pwpSCAD/rightTriangle.scad>

 //A really small value useful in comparing FP numbers. ie: abs(a-b)<EPSILON
 epsilon = 1e-9;

 /*
  * there is an issue when doing tests with generated values that are not rational
  * numbers (float). OpenSCAD is loosely typed and all numeric values are floats.
  * In order to avoid floating point inaccuracies these tests will focus on
  * testing right triangles with lengths equal to rational numbers
  * (rational/integer triangles) and rational number angles. This should explain
  * some of the unusual test cases.
  */


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

// test sides

/*
 _raCOA = raCOA(10, 35);
 _raCOATestVector = [10, 14.28148, 17.43447, 35, 55, 8.19152];

 _raCAA = raCAA(10, 35);
 _raCAATestVector = [10, 7.00208, 12.2077, 35, 55, 5.73576];
*/

 // define constants
 constCathetus1 = constCathetus1();
 constCathetus2 = constCathetus2();
 constHypot = constHypot();
 constAngle1 = constAngle1();
 constAngle2 = constAngle2();
 constHeight = constHeight();

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
  // 3-4-5 triangle
  // a = 3; β = 36.87;
  triangle345 = raCOA(3, 36.87);
  echo("triangle345 a", triangle345);

  assert(triangle345[constCathetus1] == 3);
  assert(triangle345[constCathetus2] >= 3.9 && triangle345[constCathetus2] <= 4);
  assert(triangle345[constHypot] >= 4.9 && triangle345[constHypot] <= 5);
  assert(triangle345[constHeight] >= 2.39 && triangle345[constHeight] <= 2.41);
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
  // 3-4-5 triangle
  // a = 4; β = 53.13;
  triangle345 = raCOA(4, 53.13);
  echo("triangle345 b", triangle345);

  assert(triangle345[constCathetus1] == 4);
  assert(triangle345[constCathetus2] >= 3 && triangle345[constCathetus2] <= 3.01);
  assert(triangle345[constHypot] >= 5 && triangle345[constHypot] <= 5.01);
  assert(triangle345[constHeight] >= 2.39 && triangle345[constHeight] <= 2.41);
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
  triangle345 = raCC(3, 4);
  echo("triangle345 raCC", triangle345);

  assert(triangle345[constCathetus1] == 3);
  assert(triangle345[constCathetus2] == 4);
  assert(triangle345[constHypot] == 5);
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
  triangle345 = raCHypot( 3, 5);
  echo("triangle345 a raCHypot", triangle345);

  assert(triangle345[constCathetus1] == 3);
  assert(triangle345[constCathetus2] == 4);
  assert(triangle345[constHypot] == 5);
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
  triangle345 = raCHypot( 4, 5);
  echo("triangle345 b raCHypot", triangle345);

  assert(triangle345[constCathetus1] == 4);
  assert(triangle345[constCathetus2] == 3);
  assert(triangle345[constHypot] == 5);
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
  triangle345 = raCHeight( 3, 2.4);
  echo("triangle345 a raCHeight", triangle345);

  assert(triangle345[constCathetus1] == 3);
  assert(triangle345[constCathetus2] == 4);
  assert(triangle345[constHypot] == 5);
  assert(triangle345[constHeight] == 2.4);
}

test_raCHeight();
//negative test, c & h == undef; h >= c

// test angles
