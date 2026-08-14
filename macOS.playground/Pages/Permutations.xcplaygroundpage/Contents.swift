//: [Previous](@previous)
import Combinatorics
/*:
 # Permutations

 Permutations of several sizes in one sequence — the counterpart of
 swift-algorithms' `permutations(ofCount: 1...3)`.
 */
let p = Permutations(of:"abc", sizes:1...3)
p.count       // 3P1 + 3P2 + 3P3 == 3 + 6 + 6 == 15
p[0]          // ["a"]
p[3]          // ["a", "b"] — the first size-2 permutation
p[p.count-1]  // ["c", "b", "a"]
for (i, a) in p.enumerated() {
    print("p[\(i)] =", a)
}
//: `sizes` accepts any sequence of `Int` — it need not be contiguous.
let pp = Permutations(of:"abcd", sizes:[1, 3])
pp.count      // 4P1 + 4P3 == 4 + 24 == 28
pp[4]         // ["a", "b", "c"]
//: Size 0 contributes the single empty permutation.
let p0 = Permutations(of:"abc", sizes:0...1)
p0.count      // 1 + 3
p0[0]         // []
//: [Next](@next)
