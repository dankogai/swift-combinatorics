/*:
 # swift-combinatorics

 Combinatorics in Swift.

 Every iterator in this module is **random-accessible**: elements are
 defined by `subscript`, so you can jump straight to the *i*-th element
 without generating its predecessors.
 */
import Combinatorics

for chars in Permutation(of:"swift") {
    print(String(chars))
}
//: Random access — no iteration needed to reach any element.
let p = Permutation(of:0..<10)
p.count      // 10! == 3628800
p[0]         // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
p[1234567]   // fetched directly, not by iterating 1234567 times
p[p.count-1] // [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
/*:
 Explore the pages — one per iterator:

 - [Permutation](Permutation)
 - [UniquePermutation](UniquePermutation)
 - [Permutations](Permutations)
 - [Combination](Combination)
 - [Combinations](Combinations)
 - [BaseN](BaseN)
 - [PowerSet](PowerSet)
 - [CartesianProduct](CartesianProduct)
 - [ProductSet](ProductSet)
 - [Arithmetic Functions](Arithmetic%20Functions) — `factorial`, `permutation`, `combination`, `factoradic`, `combinadic`

 [Next](@next)
 */
