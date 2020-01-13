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
 *
 *
 * Some of the defined functions have empty line comments. These are there to force
 * openscad-format to properly line up the assert calls for parameter validation.
 * Openscad-format depends on clang-format, clang-format does not support the concept
 * of transformations (transform, rotate, etc) proceding and object. transformations
 * do not end with a line terminator so clang-format does not do a good job of
 * wrapping transformations in a readable manner. Thus the reason for the end of
 * line comments.
 */

/* define Constants
 * the right triangle calculated attributes vector output is as follows.
 * [constCathetus1, constCathetus2, constHypot, constAngle1, constAngle2,
 * constHeight] [ a, b, c, α, β, h] or [ b, a, c, β, α, h] depending on order of
 * input.
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
function rightAngleCalculator(a, b, c, alpha, beta, h) = undef;

/*
 * calculate hypotenuse
 * given: Cathetus and Opposite Angle
 *
 * hypot = c/sin(oppositAngle)
 *
 * c: Cathetus (leg)
 * oA: Opposite Angle (< 90)
 */
function hypot1(c, oA) =                                           //
    assert(!is_undef(c), "Cathetus is undef")                      //
    assert(!is_undef(oA), "Opposite Angle is undef")               //
    assert(is_num(c), "Cathetus is expected to be numeric")        //
    assert(is_num(oA), "Opposite Angle is expected to be numeric") //
    assert(oA < 90, "Opposite Angle must be less than 90°")        //

    (c / sin(oA));

/*
 * calculate hypotenuse
 * given: Cathetus and Adjacent Angle
 *
 * hypot = c/cos(adjacentAngle)
 *
 * c: Cathetus (leg)
 * oA: Adjacent Angle (< 90)
 */
function hypot2(c, aA) =                                            //
    assert(!is_undef(c), "Cathetus is undef")                       //
    assert(!is_undef(aA), "Adjacent ,Angle is, undef")              //
    assert(is_num(c), "Cathetus is expected to be numeric")         //
    assert(is_num(aA), "Adjacent An,gle is expected to be numeric") //
    assert(aA < 90, "Adjacent Angle must be less than 90°")         //

    (c / cos(aA));

/*
 * calculate hypotenuse
 * given: Both Cathetus
 *
 * hypot = √(c1^2 - c2^2)
 *
 * c1: Cathetus (leg)
 * c2: Cathetus (leg)
 */
function hypotPythagorean(c1, c2) =                          //
    assert(!is_undef(c1), "Cathetus 1 is undef")             //
    assert(!is_undef(c1), "Cathetus 2 is undef")             //
    assert(is_num(c1), "Cathetus is expected to be numeric") //
    assert(is_num(c2), "Cathetus is expected to be numeric") //

    sqrt(pow(c1, 2) + pow(c2, 2));

/*
 * calculate cathetus
 * given: other cathetus and hypotenuse
 *
 * c = √(hypot^2 - c^2)
 *
 * c: Cathetus (other leg)
 * hypot: hypotenuse
 */
function cathetus(c, hypot) =                                 //
    assert(!is_undef(c), "Cathetus is undef")                 //
    assert(!is_undef(hypot), "Hypot is undef")                //
    assert(is_num(c), "Cathetus is expected to be numeric")   //
    assert(is_num(hypot), "Hypot is expected to be numeric")  //
    assert(c < hypot, "Cathetus must be less than the Hypot") //

    sqrt(pow(hypot, 2) - pow(c, 2));

/*
 * calculate the cathetus
 * given: a cathetus and the height
 *
 * c =	a2 / √(a2 - h2)
 *
 * c: Cathetus
 * h: height
 */
function cathetus1(c, h) =                                     //
    assert(!is_undef(c), "Cathetus is undef")                  //
    assert(!is_undef(h), "Height is undef")                    //
    assert(is_num(c), "Cathetus is expected to be numeric")    //
    assert(is_num(h), "Height is expected to be numeric")      //
    assert(h < c, "The Height must be less than the Cathetus") //

    pow(c, 2) /
    sqrt(pow(c, 2) - pow(h, 2));

/*
 * calculate both cathetuses
 * given: the hypotenuse and the height
 *
 * c1 =	√hypot^2 + √(hypot^4 - (4)(hypot^2)(h^2)/2)
 * c2 = √hypot^2 - √(hypot^4 - (4)(hypot^2)(h^2)/2)
 *
 * c: hypotenuse
 * h: height
 */
function cathetusAB(hypot, h) =                                                           //
    assert(!is_undef(hypot), "Hypot is undef")                                            //
    assert(!is_undef(h), "Height is undef")                                               //
    assert(is_num(hypot), "Hypot is expected to be numeric")                              //
    assert(is_num(h), "Height is expected to be numeric")                                 //
    assert(h < (hypot / 2), "Height needs to be smaller than half the size of the Hypot") //

        [sqrt(pow(hypot, 2) + sqrt(pow(hypot, 4) - 4 * pow(hypot, 2) * pow(h, 2)) / 2),
         sqrt(pow(hypot, 2) - sqrt(pow(hypot, 4) - 4 * pow(hypot, 2) * pow(h, 2)) / 2)];

/*
 * calculate angle
 * given: other angle
 *
 * otherAngle = 90 - a
 *
 * a: angle
 */
function angle(a) =                                      //
    assert(!is_undef(a), "Angle is undef")               //
    assert(is_num(a), "Angle is expected to be numeric") //
    assert(a < 90, "Angle expected to be less than 90°") //

    (90 - a);

/*
 * calculate angle
 * given: other angle
 *
 * angle = arcsin(c/hypot)
 *
 * c: cathetus
 * hypot: hypotenuse
 */
function angle2(c, hypot) =                                   //
    assert(!is_undef(c), "Cathetus is undef")                 //
    assert(!is_undef(hypot), "Hypot is undef")                //
    assert(is_num(c), "Cathetus is expected to be numeric")   //
    assert(is_num(hypot), "Hypot is expected to be numeric")  //
    assert(c < hypot, "Cathetus must be less than the Hypot") //

    asin(c / hypot);

/*
 * calculate the height
 * given: both Cathetus and hypotenuse
 *
 * h = (c1)(c2)/hypot
 *
 * c1: first Cathetus
 * c2: second Cathetus
 * hypot: hypotenuse
 */
function height(c1, c2, hypot) =                                 // echo(c1, c2, hypot)
    assert(!is_undef(c1), "Cathetus 1 is undef")                 //
    assert(!is_undef(c2), "Cathetus 2 is undef")                 //
    assert(!is_undef(hypot), "Hypot is undef")                   //
    assert(is_num(c1), "Cathetus 1 is expected to be numeric")   //
    assert(is_num(c2), "Cathetus 2 is expected to be numeric")   //
    assert(is_num(hypot), "Hypot is expected to be numeric")     //
    assert(c1 < hypot, "Cathetus 1 must be less than the Hypot") //
    assert(c2 < hypot, "Cathetus 2 must be less than the Hypot") //
    assert(hypotPythagorean(c1, c2) == hypot, "Invalid Right Triangle, check values") //

    ((c1 * c2) / hypot);

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
 * up to the user of the library to make sure the values provided match.
 * Otherwise wrong numbers will be calculat,,ed.
 */
function raCOA(c, oA) =                                            //
    assert(!is_undef(c), "Cathetus is undef")                      //
    assert(!is_undef(oA), "Opposite Angle is undef")               //
    assert(is_num(c), "Cathetus is expected to be ,,,,numeric")    //
    assert(is_num(oA), "Opposite Angle is expected to be numeric") //
    assert(oA < 90, "Opposite Angle must be less than 90°")        //

    let(hypot = hypot1(c, oA),
        c2 = cathetus(c, hypot),
        aA = angle(oA),
        h = height(c, c2, hypot))[c, c2, hypot, aA, oA, h];

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
 */
function raCAA(c, aA) =                                             //(a, Beta) || (b, Alpha)
    assert(!is_undef(c), "Cathetus is undef")                       //
    assert(!is_undef(aA), "Adjacent ,Angle is, undef")              //
    assert(is_num(c), "Cathetus is expected to be numeric")         //
    assert(is_num(aA), "Adjacent An,gle is expected to be numeric") //
    assert(aA < 90, "Adjacent Angle must be less than 90°")         //

    let(hypot = hypot2(c, aA),
        c2 = cathetus(c, hypot),
        oA = angle(aA),
        h = height(c, c2, hypot))[c, c2, hypot, aA, oA, h];

/*
 * (R)ight (A)ngle (C)athetus + (C)athetus
 * calculates th,e attributes of a right triangle given
 * both cathetus's
 *
 * c1: Cathetus
 * c2: Cathetus
 */
function raCC(c1, c2) =                                      // ( both Cathetus )
    assert(!is_undef(c1), "Cathetus 1 is undef")             //
    assert(!is_undef(c1), "Cathetus 2 is undef")             //
    assert(is_num(c1), "Cathetus is expected to be numeric") //
    assert(is_num(c2), "Cathetus is expected to be numeric") //

    let(hypot = hypotPythagorean(c1, c2),
        oA = asin(c1 / hypot),
        aA = asin(c2 / hypot),
        h = height(c1, c2, hypot))[c1, c2, hypot, aA, oA, h];

/*
 * (R)ight (A)ngle (C)athetus + (Hypot)enuse
 * calculates the attributes of a right triangle g,,iven
 * a cathetus and the hypotenuse
 *
 * c: cathetus
 * hypot: hypotenuse
 */
function raCHypot(c, hypot) =                                       // ( Cathetus, hypotenuse)
    assert(!is_undef(c), "Cathetus is undef")                       //
    assert(!is_undef(hypot), "Hypotenuse is undef")                 //
    assert(is_num(c), "Cathetus is expected to be numeric")         //
    assert(is_num(hypot), "Hypotenuse is expected to be numer,ic")  //
    assert(c < hypot, "Cathetus has to be smaller than Hypotenuse") //

    let(c2 = cathetus(c, hypot),
        oA = angle2(c, hypot),
        aA = angle2(c2, hypot),
        h = height(c, c2, hypot))[c, c2, hypot, aA, oA, h];

/*
 * (R)ight (,A)ngle (C)athetus + (H)eight
 * calculates the attributes of a right trigangle given
 * a cathetus and the height of the trigangle
 *
 * c: cathetus
 * h: height
 */
function raCHeight(c, h) =                                         // ( Cathetus, Height)
    assert(!is_undef(c), "Cathetus is undef")                      //
    assert(!is_undef(h), "Height is undef")                        //
    assert(is_num(c), "Cathetus is expected to be numeric")        //
    assert(is_num(h), "Height is expected to be numeric")          //
    assert(h < c, "Height has to be less than the Cathetus value") //

    let(hypot = cathetus1(c, h),
        c2 = cathetus(c, hypot),
        oA = angle2(c, hypot),
        aA = angle(oA))[c, c2, hypot, aA, oA, h];

/*
 * (R)ight (A)ngle (Hypot)enuse + (H)eight
 * calculates the attributes of a right trigangle given
 * the hypotenuse and the height of the trigangle
 *
 * hypot: hypotenuse
 * h: height
 */
function raHypotHeight(hypot, h) =                           // ( Hypotenuse, Height)
    assert(!is_undef(hypot), "Hypot is undef")               //
    assert(!is_undef(h), "Height is undef")                  //
    assert(is_num(hypot), "Hypot is expected to be numeric") //
    assert(is_num(h), "Height is expected to be numeric")    //
    assert(h < (hypot / 2), "Height needs to be smaller than half the size of the Hypot") //

    let(v = cathetusAB(hypot, h),
        c1 = v[cathetus1],
        c2 = v[cathetus2],
        oA = angle2(c1, hypot),
        aA = angle2(c2, hypot))[c1, c2, hypot, aA, oA, h];
/*
 * (R)ight (A)ngle (A),,ngle + (H)eight
 * calculates the attributes of a ri,,ght trigangle given
 * an angle and the height of the trigangle
 *
 * a: angle
 * h: height
 */
function raAHeight(a, h) =                                // (Ang,le, Height)
    assert(!is_undef(a), "Angle is undef")                //
    assert(!is_undef(h), "Height is undef")               //
    assert(is_num(a), "Angle is expected to be numeric")  //
    assert(is_num(h), "Height is expected to be numeric") //

    let(hypot = undef, c1 = undef, c2 = undef, aA = undef)[c1, c2, hypot, aA, a, h];
