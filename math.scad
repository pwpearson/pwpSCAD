/*
 * math
 * rick pearson (pwpearson@gmail.com)
 * 1/15/2020
 *
 */

/*
 * NaN
 *
 *
 */
function NaN() = 0 / 0;

/*
 * sum the elements of a list.
 * skip undef elements
 *
 */
function sumV(v, i = 0, tot = undef) =
    i >= len(v) ? tot :
                  let(element = is_undef(v[i]) ? 0 : v[i])
                      sumV(v, i + 1, ((tot == undef) ? element : tot + element));
