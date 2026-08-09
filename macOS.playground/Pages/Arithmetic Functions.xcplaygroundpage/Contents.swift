//: [Previous](@previous)
import Combinatorics
/*:
 ## factorial, permutation, combination

 Top-level functions, generic over `SignedInteger` —
 use `BigInt` where `Int` is not enough.
 */
factorial(0)          // 1
factorial(10)         // 3628800
factorial(20)         // the largest factorial that fits in Int64
permutation(10, 5)    // 10P5 == 30240
permutation(10, 0)    // 1
combination(10, 5)    // 10C5 == 252
combination(52, 5)    // 2598960 — poker hands
combination(5, 7)     // 0 — you cannot take more than you have
//: `combination` is computed multiplicatively, so intermediates do not
//: overflow as long as the result fits:
combination(30, 15)   // 155117520; naive 30P15 / 15! would trap
combination(52, 26)   // 495918532948104
combination(52, 47) == combination(52, 5)  // nCk == nC(n-k)
/*:
 ## factoradic

 Digits of *n* in the
 [factorial number system](https://en.wikipedia.org/wiki/Factorial_number_system),
 most significant digit first.  The *i*-th digit from the right has
 place value *i*!, so the digit in that place ranges over 0...*i*.
 */
0.factoradic()      // [0]
1.factoradic()      // [1, 0]
23.factoradic()     // [3, 2, 1, 0] == 3*3! + 2*2! + 1*1! + 0*0!
349.factoradic()    // [2, 4, 2, 0, 1, 0]
//: `Permutation` uses it to find its n-th element: each factoradic digit
//: picks (and removes) one element from what remains of the seed.
let p = Permutation(of:"abcd")
23.factoradic()     // [3, 2, 1, 0] — take the last remaining element, 4 times
p[23]               // ["d", "c", "b", "a"]
/*:
 ## combinadic

 The [combinatorial number system](https://en.wikipedia.org/wiki/Combinatorial_number_system):
 `n.combinadic(k)` returns a function mapping an index to the `k`
 seed positions of the corresponding combination.
 */
let digits = 4.combinadic(2)      // for 4C2
(0..<6).map{ digits($0) }         // [[0,1], [0,2], [0,3], [1,2], [1,3], [2,3]]
//: `Combination` uses it the same way `Permutation` uses `factoradic`:
let c = Combination(of:"abcd", size:2)
c[4]                // ["b", "d"]
digits(4)           // [1, 3] — seed[1] and seed[3]
//: [Next](@next)
