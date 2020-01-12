/*
 * rightTriangle by pwpearson
 * 01/06/2020
 *
 */

include <missile/missile.scad>


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

/* define Constants
 * the right triangle calculated attributes vector output is as follows.
 * [constCathetus1, constCathetus2, constHypot, constAngle1, constAngle2, constHeight]
 * [ a, b, c, α, β, h] or
 * [ b, a, c, β, α, h] depending on order of input.
 */
function constCathetus1() = 0;
function constCathetus2() = 1;
function constHypot() = 2;
function constAngle1() = 3;
function constAngle2() = 4;
function constHeight() = 5;

constCathetus1 = constCathetus1();
constCathetus2 = constCathetus2();
constHypot = constHypot();
constAngle1 = constAngle1();
constAngle2 = constAngle2();
constHeight = constHeight();

/*
 *
 *
 */
 function rightAngleCalculator(a, b, c, alpha, beta, h) = 1;

/*
 * calculate hypotenuse
 * given: Cathetus and Opposite Angle
 *
 * c: Cathetus (leg)
 * oA: Opposite Angle (< 90)
 */
 function hypot1( c, oA) = c / sin(oA);

 /*
  * calculate hypotenuse
  * given: Cathetus and Adjacent Angle
  *
  * c: Cathetus (leg)
  * oA: Adjacent Angle (< 90)
  */
 function hypot2( c, aA) = c / cos(aA);

 /*
  * calculate hypotenuse
  * given: Both Cathetus
  *
  * c1: Cathetus (leg)
  * c2: Cathetus (leg)
  */
 function hypotPythagorean( c1, c2 ) = sqrt(pow(c1, 2) + pow(c2, 2));

/*
 * calculate cathetus
 * given: other cathetus and hypotenuse
 *
 * c: Cathetus (other leg)
 * hypot: hypotenuse
 */
 function cathetus( c, hypot ) = //echo(c, hypot)
    sqrt(pow(hypot, 2) - pow(c, 2));
// hypot > c

 /*
  * calculate the cathetus
  * given: a cathetus and the height
  *
  * c =	a2 / √(a2 - h2)
  *
  * c: Cathetus
  * h: height
  */
 function cathetus1( c, h ) =
    pow(c, 2)/sqrt(pow(c, 2) - pow(h, 2));
// h < c
/*
 * calculate angle
 * given: other angle
 *
 * a: angle
 */
 function angle( a ) = 90 - a;
//a < 90

 /*
  * calculate angle
  * given: other angle
  *
  * c: cathetus
  * hypot: hypotenuse
  */
 function angle2( c, hypot ) = asin(c/hypot);
//hypot > c

/*
 * calculate the height
 * given: both Cathetus and hypotenuse
 *
 * c1: first Cathetus
 * c2: second Cathetus
 * hypot: hypotenuse
 */
 function height( c1, c2, hypot ) = //echo(c1, c2, hypot)
    (c1 * c2)/hypot;

/*
 * (R)ight (A)ngle (C)athetus (O)pposite (A)ngle
 * calculates the attributes of a right triangle given
 * a cathetus and the opposite angle (a && alpha) || (b && beta)
 *
 * c: Cathetus
 * oA: Opposite Angle
 *
 * expected values should be [a, α] or [b, β]
 *
 * because there is no way to verify a valid set from an invalid set it is
 * up to the user of the library to make sure the values provided match. Otherwise
 * wrong numbers will be calculated.
 */
 function raCOA(c = undef, oA = undef) =
    (c == undef) ? undef :
    (oA == undef) ? undef :
    let(
      hypot = hypot1(c, oA),
      c2 = cathetus(c, hypot),
      aA = angle(oA),
      h = height(c, c2, hypot)
    )
    [c, c2, hypot, oA, aA, h];


/*
 * (R)ight (A)ngle (C)athetus (A)djacent (A)ngle
 * calculates the attributes of a right triangle given
 * a cathetus and the adjacent angle (a && beta) || (b && alpha)
 *
 * c: Cathetus
 * aA: Adjacent Angle
 *
 * expected values should be [a, β] or [b, α]
 *
 * because there is no way to verify a valid set from an invalid set it is
 * up to the user of the library to make sure the values provided match. Otherwise
 * wrong numbers will be calculated.
 */
 function raCAA( c, aA ) = //(a, Beta) || (b, Alpha)
    (c == undef) ? undef :
    (aA == undef) ? undef :
    let(
      hypot = hypot2(c, aA),
      c2 = cathetus( c, hypot),
      oA = angle(aA),
      h = height(c, c2, hypot)
    )
    [c, c2, hypot, aA, oA, h];


/*
 * (R)ight (A)ngle (C)athetus + (C)athetus
 * calculates the attributes of a right triangle given
 * both cathetus's
 *
 * c1: Cathetus
 * c2: Cathetus
 */
 function raCC( c1, c2 ) = // ( both Cathetus )
   (c1 == undef) ? undef :
   (c2 == undef) ? undef :
   let(
      hypot = hypotPythagorean( c1, c2 ),
      oA = asin(c1/hypot),
      aA = asin(c2/hypot),
      h = height(c1, c2, hypot)
   )
   [c1, c2, hypot, aA, oA, h];

/*
 * (R)ight (A)ngle (C)athetus + (Hypot)enuse
 * calculates the attributes of a right triangle given
 * a cathetus and the hypotenuse
 *
 * c: cathetus
 * hypot: hypotenuse
 */
 function raCHypot( c, hypot ) = // ( Cathetus, hypotenuse)
    (c == undef) ? undef :
    (hypot == undef) ? undef :
    let(
      c2 = cathetus( c, hypot),
      oA = angle2( c, hypot ),
      aA = angle2( c2, hypot ),
      h = height( c, c2, hypot )
    )
    [c, c2, hypot, aA, oA, h];

/*
 * (R)ight (A)ngle (C)athetus + (H)eight
 * calculates the attributes of a right trigangle given
 * a cathetus and the height of the trigangle
 *
 * c: cathetus
 * h: height
 */
 function raCHeight( c, h ) =
  (h >= c) ? echo(" h has to be less than c") undef :
  (c == undef) ? undef :
  (h == undef) ? undef :
  let(
    hypot = cathetus1( c, h ),
    c2 = cathetus( c, hypot ),
    oA = angle2( c, hypot ),
    aA = angle( oA )
  )
  [c, c2, hypot, aA, oA, h];

/*
 * (R)ight (A)ngle (Hypot)enuse + (H)eight
 * calculates the attributes of a right trigangle given
 * the hypotenuse and the height of the trigangle
 *
 * hypot: hypotenuse
 * h: height
 */
 function raHypotHeight( hypot, h ) =
   (c == undef) ? undef :
   (h == undef) ? undef :
   let(
     c1 = undef,
     c2 = undef,
     oA = undef,
     aA = undef
   )
   [c1, c2, hypot, aA, oA, h];

/*
 * (R)ight (A)ngle (A)ngle + (H)eight
 * calculates the attributes of a right trigangle given
 * an angle and the height of the trigangle
 *
 * a: angle
 * h: height
 */
 function raAHeight( a, h ) =
   (c == undef) ? undef :
   (h == undef) ? undef :
   let(
     hypot = undef,
     c1 = undef,
     c2 = undef,
     aA = undef
   )
   [c1, c2, hypot, aA, a, h];
