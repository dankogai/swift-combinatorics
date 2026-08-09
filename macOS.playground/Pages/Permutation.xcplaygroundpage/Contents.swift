//: [Previous](@previous)
import Combinatorics
/*:
 # Permutation

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
pFull.count           // 4! == 24
pFull[0]              // ["a", "b", "c", "d"]
pFull[pFull.count-1]  // ["d", "c", "b", "a"]
//: Any `Sequence` can seed it, and there is a variadic form too.
let pv = Permutation(1, 2, 3)
pv.count      // 3! == 6
pv.map{ $0 }
//: Random access — pick a random anagram directly, out of 13! candidates.
let anagram = Permutation(of:"combinatorics")
anagram.count // 13! == 6227020800
String(anagram[Int.random(in: 0..<anagram.count)])
//: [Next](@next)
