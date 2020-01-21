[TOC]

## pwpSCAD library

### Right Triangle Solver

File: `rightTriangleSolver.scad`

There are many functions in this module that can be reused however they are intented to support the main function called `rightTriangleSolver`

#### Description
Given two arguments this module will solve for the other values.

Returns a list of right triangle values or undef. `[a, b, c, alpha, beta, h]`; see sample solution below.

```
args:
           a: Cathetus
           b: Other Cathetus
           c: hypotenuse
   alpha (⍺): angle opposite of Cathetus a; angle adjacent of Cathetus b
    beta (𝜷): angle adjacent of Cathetus a; angle opposite of Cathetus b
           h: height of triangle
```

This fuction expects two parameters to be set and only two. In the case where
more than two args are set the function will return undef.

This function will also return undef for invalid combinations or argument pairs.

##### Invalid argument combinations:

*alpha, beta:* returns undef. It is not possible to solve a right triangle with two angles.


##### Sample Solution
```
ex:
            ⍺ = 53.13 +
                      ++
                      + +
                  a=3 +  + c=5
                      +   +
                      ++   +
                      +++++++ 𝜷 = 36.87
                        b=4
                  h=2.4
                  
rightTriagleSolver(a=3, b=4); => [3, 4, 5, 53.13, 36.87, 2.4]

where: 3,4 - the length of the cathetuses
         5 - is the hypotenuse
     53.13 - is the adjacent angle to the cathetus with length 3
     36.87 - is the opposite angle to the cathetus with length 3
       2.4 - is the height of the triangle
```

#### Other Functions

##### funtions that directly support the funciton rightTriangleSover()
* **_callFunction(i, w, z):** function resolver; takes function index (i) and args (w, z) and calls associated function
* **_calcFuncIndexFromArgs(v):** calculates the function index based on given arguments
* **_invalidArgumentError(arg1, arg2, s):** generates *invalid arguments* error string and sends to the console; **returns:** `undef`;
* **_undefinedFunctionError(arg1, arg2, s):** generates *undefined function* error string and sends it to the console; **returns:** `undef`;

##### primitive functions; used by the complex functions below.
Most of these functions return a singlue numeric value.

* **_hypot1(c, oA):** calculates the hypotenuse given a cathetus and it's opposite angle.
* **_hypot2(c, aA):** calculates the hypotenuse given a cathetus and it's adjacent angle.
* **_hypotPythagorean(c1, c2):** calculates the hypotenuse using Pythagorean's Theorem given both cathetuses.
* **_cathetus(c, hypot):** calculate a cathetus given the other cathetus and the hypotenuse.
* **_cathetus1(c, h):** calculate a cathetus given the other catetus and the height of the right triangle.
* **_cathetusAB(hypot, h):** calculate both cathetuses given the hypotenuse and the height of the right triangle.
* **_cathetusAFromHeightAngle(a, h):** calculate the cathetus given an angle and the height of the right triangle.
* **_cathetusBFromHeightAngle(a, h):** calculate the other catetus given the same angle (as above) and the height of the triangle.
* **_angle(a):** calculate the other angle given an angle.
* **_angle2(c, hypot):** calculate the opposite angle given a cathetus and hypotenuse.
* **_height(c1, c2, hypot):** calculate the height given both cathetuses and the hypotenuse.

##### complex functions; returns rightTriangle solution given specific arguments.
All these functions return a list in the form of [a, b, c, alpha, beta, h]; 

* **_raCOA(c, oA):** returns right triangle solution; given cathetus and opposite angle.
* **_raCAA(c, aA):** returns right triangle solution; given cathetus and adjacent angle.
* **_raCC(c1, c2):** returns right triangle solution; given both cathetuses.
* **_raCHypot(c, hypot):** return right triangle solution; given a cathetus and hypotenuse.
* **_raCHeight(c, h):** return right triangle solution; given a cathetus and height of the right triangle.
* **_raHypotAngle(hypot, a):** return right triangle solution; given the hypotenuse and an angle.
* **_raHypotHeight(hypot, h):** return right triangle solution; given the hypotenuse and the height of the right triangle.
* **_raAHeight(a, h):** return the right triangle solution; given an angle and the height of the right triangle.

### Util (tbd)
Utility functions

### Debug (tbd)
Debug functions

### Math (tbd)
Math functions

### Building-Materials (tbd)
Generates building material for woodworking models.