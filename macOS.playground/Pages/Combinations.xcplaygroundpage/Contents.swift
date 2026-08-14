//: [Previous](@previous)
import Combinatorics
/*:
 # Combinations

 Combinations of several sizes in one sequence — the counterpart of
 swift-algorithms' `combinations(ofCount: 2...3)`.
 */
let c = Combinations(of:"abcd", sizes:2...3)
c.count       // 4C2 + 4C3 == 6 + 4 == 10
c.map{ String($0) }  // ["ab", "ac", "ad", "bc", "bd", "cd", "abc", "abd", "acd", "bcd"]
for (i, a) in c.enumerated() {
    print("c[\(i)] =", a)
}
//: `sizes:0...n` is the power set, grouped by size.
let ps = Combinations(of:"abcd", sizes:0...4)
ps.count      // 2 ** 4 == 16
ps[0]         // []
ps[ps.count-1]  // ["a", "b", "c", "d"]
//: `sizes` accepts any sequence of `Int` — it need not be contiguous.
let odd = Combinations(of:"abcde", sizes:[1, 3, 5])
odd.count     // 5C1 + 5C3 + 5C5 == 5 + 10 + 1 == 16
//: [Next](@next)
