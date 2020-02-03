/*
 * Type - Type routines
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
 * lookup2 - lookup value n in tableValues and return first matching value.
 *
 * works with decimal keys and string values unlike built-in lookup fn.
 *
 * ex:
 *
 * fractions = [
 * [0.015625, "1/64\""],
 * [0.03125, "1/32\""],
 * [0.046875, "3/64\""]]
 *
 * echo(lookup2(0.015625, fractions)); ECHO: "1/64""
 */
 function lookup2(n, tableValues) =
  assert(is_matrix(tableValues, 0),
    "Parameter tableValues is not a matrix or the dimension does not match expected dimension")
  [ for (value = tableValues) if(n == value[0]) value[1] ][0];

/*
 * is_matrix of 'n' dimension; if n=0 then any dimentions is valid so long as each row
 * has the same length. does not verify consistency of content.
 *
 */
function is_matrix(matrix, n=0) =
  let(
    isListOfLists = (is_list(matrix) && is_list(matrix[0])),
    width = isListOfLists ? len(matrix[0]) : 0
  )
  !isListOfLists
    ? false
    : [
      for (v = matrix)
      for (element = v)
        // verify there are no sub-lists
        if (is_list(element))
          debugTap(false, "Error: matrix element is a list; return")
        else
          // verify the width of matrix is
          if (n > 0 && n != width)
            debugTap(false, "Error: matrix dimension does not match expected dimension: return")
          else
            // verify that all the rows have the same length
            if (len(v) != width)
              debugTap(false, "Error: matrix rows are not equal lengths; return")
      ] [0] == undef ? true : false;


/*
 * is value type of numeric, boolean, or string
 *
 */
function is_value(value) = is_num(value) || is_bool(value) || is_string(value);

/*
 * returns the type of value as a string
 *
 */
function typeOf(value) =
  is_matrix(value)
    ? "matrix"
      : is_listOfKeyValues(value)
        ? "listOfKvp"
        : is_num(value)
          ? "numeric"
          : is_bool(value)
            ? "boolean"
            : is_string(value)
              ? "string"
              : is_list(value)
                ? "list"
                : is_function(value)
                  ? "function"
                  : "undef";


/*
 * is the list a list of key value pairs
 * in the form of '[key, value]' where key is expected to be
 * a value type of numeric or string; value can be a value type
 * or a list of values and lists.
 */
function is_listOfKeyValues(list, consistentTypes = true) =
  let(
    firstIsKeyValue = is_keyValuePair(list[0]),
    keyType = firstIsKeyValue ? typeOf(list[0][0]) : undef,
    valueType = firstIsKeyValue ? typeOf(list[0][1]) : undef
  )
  is_list(list)
    ? (consistentTypes
      ? [ for (kvp = list) if (!(is_keyValuePair(kvp) && typeOf(kvp[0]) == keyType && typeOf(kvp[1]) == valueType)) false ]
      : [ for (kvp = list) if (!is_keyValuePair(kvp)) false ])[0] == undef ? true : false
    : false;

/*
 * test if list is a key value pair
 *
 */
function is_keyValuePair(keyValuePair) =
  let(
    isList = is_list(keyValuePair),
    hasTwoElements = isList ? len(keyValuePair) == 2 : false,
    key = hasTwoElements ? keyValuePair[0] : undef,
    keyType = isList ? typeOf(key) : undef,
    value = hasTwoElements ? keyValuePair[1] : undef,
    valueType = isList ? typeOf(value) : undef
  )
  is_list(keyValuePair)
    ? (keyType == "numeric" || keyType == "string")
    : false;
