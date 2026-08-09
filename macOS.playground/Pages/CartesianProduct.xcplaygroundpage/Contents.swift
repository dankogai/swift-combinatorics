//: [Previous](@previous)
import Combinatorics
/*:
 # CartesianProduct

 The product of two `Collection`s — element types may differ,
 and you get tuples back.
 */
let suits = "♠️♦️❤️♣️"
let ranks = 1...13
let cards = CartesianProduct(suits, ranks)
cards.count   // 4 * 13 == 52
cards[0]      // ("♠️", 1)
cards[51]     // ("♣️", 13)
for (suit, rank) in cards.prefix(5) {
    print(suit, rank)
}
//: It is itself a `Collection`, so compose it for higher dimensions.
let cpcp = CartesianProduct(CartesianProduct("01", "abc"), "ATCG")
cpcp.count    // 2 * 3 * 4 == 24
cpcp.map{ "\($0.0.0)\($0.0.1)\($0.1)" }
/*:
 Nested tuples get unwieldy: `(T, T)` and `((T, T), T)` are different
 types, so an n-ary product cannot be written with tuples alone.  When
 all elements share one type, use [ProductSet](ProductSet) instead.

 [Next](@next)
 */
