//: [Previous](@previous)
import Combinatorics
/*:
 # Combination

 Like `Permutation`, but order does not matter — so specify `size`,
 or you get the single full-length combination.
 */
let c = Combination(of:"abcd", size:2)
c.count       // 4C2 == 6
c.map{ String($0) }  // ["ab", "ac", "ad", "bc", "bd", "cd"]
for (i, a) in c.enumerated() {
    print("c[\(i)] =", a)
}
let cFull = Combination(of:"abcd")
cFull.count   // 1
cFull[0]      // ["a", "b", "c", "d"]
//: Pick 6 numbers out of 43 — every possible lottery ticket has an index.
let lotto = Combination(of:1...43, size:6)
lotto.count             // 43C6 == 6096454
lotto[0]                // [1, 2, 3, 4, 5, 6]
lotto[lotto.count-1]    // [38, 39, 40, 41, 42, 43]
lotto[Int.random(in: 0..<lotto.count)]
//: Random access scales to spaces far too large to enumerate.
let big = Combination(of:0..<30, size:15)
big.count             // 30C15 == 155117520
big[77_558_760]       // the middle element, fetched directly
//: [Next](@next)
