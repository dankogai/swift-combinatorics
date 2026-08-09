//: [Previous](@previous)
import Combinatorics
/*:
 # PowerSet

 All subsets of the seed, from the empty set up to the seed itself.
 */
let ps = PowerSet(of:"abc")
ps.count      // 2 ** 3 == 8
ps.map{ String($0) }  // ["", "a", "b", "ab", "c", "ac", "bc", "abc"]
for (i, sub) in ps.enumerated() {
    print("ps[\(i)] =", sub)
}
//: The index is a bitmask: element `i` contains `seed[j]` iff bit `j` of `i` is set.
let s = PowerSet(of:0..<4)
s.count       // 2 ** 4 == 16
s[0b0000]     // []
s[0b1010]     // [1, 3]
s[0b1111]     // [0, 1, 2, 3]
//: [Next](@next)
