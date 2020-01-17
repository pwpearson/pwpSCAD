/*
 * rightTriangle by pwpearson
 * 01/06/2020
 *
 */

// use <BOSL/math.scad>
use <pwpSCAD/math.scad>
use <pwpSCAD/debug.scad>
use <pwpSCAD/util.scad>

$_debug = false;

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
function constCathetus1() = 0; //a
function constCathetus2() = 1; //b
function constHypot() = 2;     //hypot
function constAngle1() = 3;    //adjacent angle to a; opposite angle to b;
function constAngle2() = 4;    //opposite angle to a; adjacent angle to b;
function constHeight() = 5;    //height

constCathetus1 = constCathetus1();
constCathetus2 = constCathetus2();
constHypot = constHypot();
constAngle1 = constAngle1();
constAngle2 = constAngle2();
constHeight = constHeight();

errInvalidCombinationError = "This is an invalid combination of values for calculating the solution to a right triangle";
errtInvalidNumberOfArguments = "rightTriangleSolver expects only two arguments to be set";

/*
 * rightTriangleSolver (module entry point)
 * Given two arguments this module will solve for the other values.
 *
 * returns a list of right triangle values or undef.
 * args:
 *            a: Cathetus
 *            b: Other Cathetus
 *            c: hypotenuse
 *    alpha (α): angle opposite of Cathetus a; angle adjacent of Cathetus b
 *     beta (β): angle adjacent of Cathetus a; angle opposite of Cathetus b
 *            h: height of triangle
 *
 * this fuction expects two parameters to be set and only two. in the case where
 * more than two args are set the function will return undef.
 *
 * this function will also return undef for invalid combinations or argument pairs.
 *
 * invalid argument combinations:
 * alpha, beta: returns undef. it is not possible to solve a right triangle with two angles.
 *
 *
 * ex:
 *               β=53.13 +
 *                       ++
 *                       + +
 *                   a=3 +  + c=5
 *                       +   +
 *                       ++   +
 *                     𝛄 +++++++ α=36.87
 *                         b=4
 *                   h=2.4
 *
 *     rightTriagleSolver(a=3, b=4); => [3, 4, 5, 53.13, 36.87, 2.4]
 *     where: 3,4 - the length of the cathetuses
 *              5 - is the hypotenuse
 *          53.13 - is the adjacent angle to the cathetus with length 3
 *          36.87 - is the opposite angle to the cathetus with length 3
 *            2.4 - is the height of the triangle
 *
 */
function rightTriangleSolver(a = undef, b = undef, c = undef, alpha = undef, beta = undef, h = undef) =
    let(
      argVector = [ a, b, c, alpha, beta, h ],
      args = removeUndefFromVector(argVector),
      index = calcFuncIndexFromArgs(argVector),
      argCount = len(args)
    )
    argCount == 2 ? callFunction(index, args[0], args[1]) :
    $_debug ? echo("argVector: ", argVector) :
    invalidArgumentError(args[0], args[1], errInvalidNumberOfArguments);

/*
 * callFunction
 * resolves function to call based on index 'i'
 *
 * i: index of the function to call
 * w: arg1 to pass to function
 * z: arg2 to pass to function
 */
function callFunction(i, w, z) =
  // these are the sums of all valid 2 pair
  //argument combinations from rightTriagleSolver
  let(
    _ab = 3,
    _ac = 5,
    _bc = 6,
    _aAlpha = 9,
    _bAlpha = 10,
    _cAlpha = 12,
    _aBeta = 17,
    _bBeta = 18,
    _cBeta = 20,
    _alphaBeta = 24, //invalid combination
    _ah = 33,
    _bh = 34,
    _ch = 36,
    _alphaH = 40,
    _betaH = 48
  )
  $_debug         ? echo(str("function: ", i, " args: ", w, z)) :
  i == _ab        ? raCC(w, z)                   : //_a + _b
  i == _ac        ? raCHypot(w, z)               : //_a + _c
  i == _bc        ? raCHypot(w, z)               : //_b + _c
  i == _aAlpha    ? raCOA(w, z)                  : //_a + _alpha
  i == _bAlpha    ? raCAA(w, z)                  : //_b + _alpha
  i == _cAlpha    ? undefinedFunctionError(w, z) : //_c + _alpha
  i == _aBeta     ? raCAA(w, z)                  : //_a + _beta
  i == _bBeta     ? raCOA(w, z)                  : //_b + _beta
  i == _cBeta     ? undefinedFunctionError(w, z) : //_c + _beta
  i == _alphaBeta ? invalidArgumentError(w, z, errInvalidCombinationError) : //_alpha + _beta
  i == _ah        ? raCHeight(w, z)              : //_a + _h
  i == _bh        ? raCHeight(w, z)              : //_b + _h
  i == _ch        ? raHypotHeight(w, z)          : //_c + _h
  i == _alphaH    ? raAHeight(w, z)              : //_alpha + _h
  i == _betaH     ? raAHeight(w, z)              : //_beta + _h
  undefinedFunctionError(w, z, "");                // default

/*
 * calcFuncIndexFromArgs
 * assign values to each existing arg positon and sum them.
 *
 * each arg that is not undef is assigned a number based on a 2^i progression;
 * where i is the arg position. These values are then summed. The result is used
 * as an index into the callFunction.
 *
 * i.e. given: the arg list is [3, 4, undef, undef, undef, undef] and
 *             the arg positional values list is [1, 2, 4, 8, 16, 32]
 *       then: the function index would be 3.
 *
 *
 */
function calcFuncIndexFromArgs(v) =
  let( argPositonalValues = [ for (i = [0:5]) pow(2, i) ] )
  sumV([for (i = [0:len(v)]) if (!is_undef(v[i])) argPositonalValues[i]]);

/*
 * invalidArgumentError
 * echoes error to console and returns undef
 *
 */
function invalidArgumentError(arg1, arg2, s) =
    echo(str("Invalid argument arg1: ", arg1, " arg2: ", arg2, " Msg: ", s)) undef;

/*
 * undefinedFunctionError
 * echoes error to console and returns undef
 *
 */
function undefinedFunctionError(arg1, arg2, s) =
    echo(str("No function defined for arg1 ", arg1, " arg2: ", arg2, " Msg: ", s)) undef;

/*****************************************************************************************/
// primitive functions

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
 * c =  a2 / √(a2 - h2)
 *
 * c: Cathetus
 * h: height
 */
function cathetus1(c, h) =                                     //
    assert(!is_undef(c), "Cathetus is undef")                  //
    assert(!is_undef(h), "Height is undef")                    //
    assert(is_num(c), "Cathetus is expected to be ,numeric")    //
    assert(is_num(h), "Height is expected to be numeric")      //
    assert(h < c, "The Height must be less than the Cathetus") //

    (pow(c, 2) / sqrt(pow(c, 2) - pow(h, 2)));

/*
 * calculate both cathetuses
 * given: the hypotenuse and the height
 *
 * c1 =  √hypot^2 + √(hypot^4 - (4)(hypot^2)(h^2)/2)
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

        [sqrt((pow(hypot, 2) - sqrt((pow(hypot, 4) - (4 * pow(hypot, 2) * pow(h, 2))))) / 2),
         sqrt((pow(hypot, 2) + sqrt((pow(hypot, 4) - (4 * pow(hypot, 2) * pow(h, 2))))) / 2)];

/*
 *
 *
 *
 *
 *
 */
function cathetusAFromHeightAngle(a, h) =                 //
    assert(!is_undef(a), "Angle is, undef")               //
    assert(!is_undef(h), "Height is undef")               //
    assert(is_num(a), "Angle is expected to be numeric")  //
    assert(is_num(h), "Height is expected to be numeric") //

    (h / cos(a));

/*
 *
 *
 *
 *
 *
 */
function cathetusBFromHeightAngle(a, h) =                 //
    assert(!is_undef(a), "Angle is, undef")               //
    assert(!is_undef(h), "Height is undef")               //
    assert(is_num(a), "Angle is expected to be numeric")  //
    assert(is_num(h), "Height is expected to be numeric") //

    (h / sin(a));

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

/*****************************************************************************************/
// compound functions; these solve based on a given set of args

/*
 * (R)i,ght (A)ngle (C)athetus (O)pposite (A)ngle
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
 * Otherwise wrong numbers will be calculat,,,,,ed.
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
    assert(!is_undef(hypot), ",Hypot is undef")               //
    assert(!is_undef(h), "Height is undef")                  //
    assert(is_num(hypot), "Hypot is expected to be numeric") //
    assert(is_num(h), "Height is expected to be numeric")    //
    assert(h < (hypot / 2), "Height needs to be smaller than half the size of the Hypot") //

    let(v = cathetusAB(hypot, h),
        c1 = v[constCathetus1],
        c2 = v[constCathetus2],
        oA = angle2(c1, hypot),
        aA = angle2(c2, hypot))[c1, c2, hypot, aA, oA, h];
/*
 * (R)ight (A)ngle (A)ngle + (H)eight
 * calculates the attributes of a ri,,ght trigangle given
 * an angle and the height of the trigangle
 *
 * a: angle
 * h: height
 */
function raAHeight(a, h) =                                // (Angle, Height)
    assert(!is_undef(a), "Angle is undef")                //
    assert(!is_undef(h), "Height is undef")               //
    assert(is_num(a), "Angle is expected to be numeric")  //
    assert(is_num(h), "Height is expected to be numeric") //

    let(c1 = cathetusAFromHeightAngle(a, h),
        aA = angle(a),
        c2 = cathetusBFromHeightAngle(a, h),
        hypot = hypotPythagorean(c1, c2))[c1, c2, hypot, aA, a, h];
