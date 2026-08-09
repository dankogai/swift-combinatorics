//: [Previous](@previous)
import Combinatorics
/*:
 ## Permutation

 All orderings of `size` elements drawn from the seed.
 */
let p = Permutation(of:"abcd", size:2)
p.count       // 4P2 == 12
p[0]          // ["a", "b"]
p[p.count-1]  // ["d", "c"]
for (i, a) in p.enumerated() {
    print("p[\(i)] =", a)
}
//: Omit `size` to permute all elements.
let pFull = Permutation(of:"abcd")
pFull.count       // 4! == 24
pFull[0]          // ["a", "b", "c", "d"]
pFull[pFull.count-1]  // ["d", "c", "b", "a"]
/*:
 ## Combination

 Like `Permutation`, but order does not matter — so specify `size`,
 or you get the single full-length combination.
 */
let c = Combination(of:"abcd", size:2)
c.count       // 4C2 == 6
c.map{ String($0) }  // ["ab", "ac", "ad", "bc", "bd", "cd"]
let cFull = Combination(of:"abcd")
cFull.count   // 1
cFull[0]      // ["a", "b", "c", "d"]
//: Random access scales to spaces far too large to enumerate.
let big = Combination(of:0..<30, size:15)
big.count             // 30C15 == 155117520
big[77_558_760]       // the middle element, fetched directly
/*:
 ## BaseN

 All `size`-digit numbers written in base `seed.count`,
 least significant digit first.
 */
let bn = BaseN(of:"01", size:4)
bn.count      // 2 ** 4 == 16
bn.map{ String($0) }
let dna = BaseN(of:"ATCG", size:3)
dna.count     // 4 ** 3 == 64
dna[63]       // ["G", "G", "G"]
/*:
 ## PowerSet

 All subsets of the seed, from the empty set up to the seed itself.
 */
let ps = PowerSet(of:"abc")
ps.count      // 2 ** 3 == 8
ps.map{ String($0) }  // ["", "a", "b", "ab", "c", "ac", "bc", "abc"]
/*:
 ## CartesianProduct

 The product of two `Collection`s — element types may differ,
 and you get tuples back.
 */
let suits = "♠️♦️❤️♣️"
let ranks = 1...13
let cards = CartesianProduct(suits, ranks)
cards.count   // 4 * 13 == 52
cards[0]      // ("♠️", 1)
cards[51]     // ("♣️", 13)
//: It is itself a `Collection`, so compose it for higher dimensions.
let cpcp = CartesianProduct(CartesianProduct("01", "abc"), "ATCG")
cpcp.count    // 2 * 3 * 4 == 24
cpcp.map{ "\($0.0.0)\($0.0.1)\($0.1)" }
/*:
 ## ProductSet

 An n-ary Cartesian product over a single element type —
 arrays instead of nested tuples.
 */
let pset = ProductSet([0,1], [2,4,6], [3,6,9,12])
pset.count    // 2 * 3 * 4 == 24
pset[0]       // [0, 2, 3]
pset.map{ $0 }
//: [Next](@next)
