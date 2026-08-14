//: [Previous](@previous)
import Combinatorics
/*:
 # UniquePermutation

 Permutations of a multiset — duplicate elements yield each
 distinct ordering only once.  `SubElement` must be `Hashable`.
 */
let u = UniquePermutation(of:"aab")
u.count       // 3, not 3! == 6
u.map{ String($0) }  // ["aab", "aba", "baa"]
Permutation(of:"aab").map{ String($0) }  // ["aab", "aab", "aba", "aba", "baa", "baa"]
//: `size` works like everywhere else.
let u2 = UniquePermutation(of:"aab", size:2)
u2.map{ String($0) }  // ["aa", "ab", "ba"]
//: Random access into all distinct anagrams of a word with many repeats.
let m = UniquePermutation(of:"mississippi")
m.count       // 11! / (4! * 4! * 2!) == 34650
String(m[0])
String(m[m.count - 1])
String(m[Int.random(in: 0..<m.count)])
//: [Next](@next)
