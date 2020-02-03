
use <pwpSCAD/util.scad>
include <pwpSCAD/board.scad>
include <pwpSCAD/math.scad>
include <pwpSCAD/text.scad>
include <pwpSCAD/assert.scad>
include <pwpSCAD/type.scad>

$_debug = false;

v = [1, 2, 3, 4];
v2 = [1, true, 2, [3, 4], "string"];

testRun("all_num()", [
  testExpectTrue(all_num(v), "all_num(v)"),
  testExpectFalse(all_num(v2), "all_num(v2)")
]);


matrix = [
  [1, 2],
  [3, 4],
  [5, 6]
];

matrix2 = [
  [1, 2],
  [3, [4]],
  [5, 6]
];

matrix3 = [
  [1, 2],
  [3, 4, 4],
  [5, 6]
];

testRun("is_matrix()", [
  testExpectTrue(is_matrix(matrix), "matrix 1"),
  testExpectFalse(is_matrix(matrix2), "matrix 2"),
  testExpectFalse(is_matrix(matrix3), "matrix 3")
]);

testRun("typeOf", [
  testCompare("typeOf(matrix)", typeOf(matrix), "matrix"),
  testCompare("typeOf(1)", typeOf(1), "numeric"),
  testCompare("typeOf(\"One]\")", typeOf("One"), "string"),
  testCompare("typeOf(true)", typeOf(true), "boolean"),
  testCompare("typeOf([1, 3])", typeOf([1, 3]), "list"),
  testCompare("typeOf(function (x) x * x)", typeOf(function (x) x * x), "function"),
  testCompare("typeOf(undef)", typeOf(undef),  "undef")
]);

testRun("is_keyValuePair", [
  testExpectTrue(is_keyValuePair([1, [1, 2]]), "kvp 1"),
  testExpectTrue(is_keyValuePair([1, "one"]), "kvp 2"),
  testExpectTrue(is_keyValuePair([1, 2]), "kvp 3"),
  testExpectTrue(is_keyValuePair([1, function (x) x * x]), "kvp 4"),
  testExpectFalse(is_keyValuePair([true, "one"]), "kvp 5"),
  testExpectFalse(is_keyValuePair([undef, 2]), "kvp 6")
]);

listKvP = [
  [1, [1, 2]],
  [2, [2, 3]],
  [3, [4, 5]]
];

listKvP2 = [
  [1, "one"],
  [2, "two"],
  [3, "three"]
];

listKvP3 = [
  [1, 2],
  [2, "two"],
  [3, true]
];

testRun("is_listOfKeyValues", [
  testExpectTrue(is_listOfKeyValues(listKvP), "listKvP 1"),
  testExpectTrue(is_listOfKeyValues(listKvP2), "listKvP 2"),
  testExpectFalse(is_listOfKeyValues(listKvP3), "listKvP 3"),
  testExpectTrue(is_listOfKeyValues(listKvP3, false), "listKvP 3; ignore consistency check")
]);
