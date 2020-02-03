/*
 * Assert - Assert/Test routines
 * rick pearson 1-27-2020
 * pwpearson@gmail.com
 *
 * MIT License
 *
 * Copyright (c) 2020 Rick Pearson
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*
 * creates an assert strings.
 *
 */
function _assertStr(subject, actual, expected) = str(subject, " - Actual: ", actual, " Expected: ", expected);
function _expectTrueStr(subject) = str("Expected ", subject, " to be True");
function _expectFalseStr(subject) = str("Expected ", subject, " to be False");

/***************************************************************************************************
 * test run routines - these routines will not assert and stop the application
 **************************************************************************************************/

/*
 * testRun - executes a set of test and returns list of responses
 *
 */
function testRun(subject, tests) =
  echo(str("**** Test: ", subject, " - run"))
  [for (test = tests) test];

/*
 * testResults - displays results of testRun
 *
 */
function testResults(subject, testResults) =
  [for (rslt = testResults)
    if (rslt[0] == true) echo(str("Passed - ", rslt[1]))
    else echo(str("FAILED - ", rslt()))
  ];

/*
 * testRun - executes a set of tests and displays results
 *
 * ex:
 * testRun("typeOf", [
 *   testCompare("typeOf(matrix)", typeOf(matrix), "x"),
 *   testCompare("typeOf(1)", typeOf(1), "numeric"),
 *   testCompare("typeOf(\"One]\")", typeOf("One"), "string"),
 *   testCompare("typeOf(true)", typeOf(true), "boolean"),
 *   testCompare("typeOf([1, 3])", typeOf([1, 3]), "list"),
 *   testCompare("typeOf(function (x) x * x)", typeOf(function (x) x * x), "function"),
 *   testCompare("typeOf(undef)", typeOf(undef),  "undef")
 * ]);
 */
module testRun(subject, testResults) { null = testResults(subject, testRun(subject, testResults)); }


function testExpectTrue(test, subject) = test == true ? [true, subject] : function () _expectTrueStr(subject);


function testExpectFalse(test, subject) = test == false ? [true, subject] : function () _expectFalseStr(subject);

function testCompare(subject, actual, expected) =
  actual == expected
  ? [true, subject]
  : function () _assertStr(subject, actual, expected);

/***************************************************************************************************
 * stand alone test routines - these will assert and stop the application
 **************************************************************************************************/

/*
 * assertFalse - Always fails and echo's s to console
 * use in braches of code that should never be reached.
 */
function assertFalse(s) = assert(false, s) undef;

/*
 * expectTrue - test assertion that expects the test to be true
 *
 */
function expectTrue(test, subject) = assert(test == true, _expectTrueStr(subject)) undef;

/*
 * expectTrue - module that wraps the expectTrue function
 *
 */
module expectTrue(test, subject) { null = expectTrue(test, subject); }

/*
 * expectFalse - test assertion that expects the test to be false
 *
 */
function expectFalse(test, subject) = assert(test == false, _expectFalseStr(subject)) undef;

/*
 * expectFalse - module that wraps the expectFalse function
 *
 */
module expectFalse(test, subject) { null = expectFalse(test, subject); }

/*
 * compare - test assertion that compares the actual value to the expected value.
 *          if the test fails a string is written to the console with the expected
 *          and actual values.
 *
 */
function compare(subject, actual, expected) = assert(actual == expected, _assertStr(subject, actual, expected)) undef;

/*
 * compare - moduel that wraps the compare function
 *
 */
module compare(subject, actual, expected) { null = compare(subject, actual, expected); }
