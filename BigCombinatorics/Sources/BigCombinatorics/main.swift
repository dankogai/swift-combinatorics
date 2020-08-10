import BigInt
import Combinatorics

typealias BigPermutation = CombinatoricsIndex<BigInt>.Permutation
typealias BigCombination = CombinatoricsIndex<BigInt>.Combination

let p = BigPermutation(of:(0..<100))
print("p.count ==", p.count)
print("p.count[p.count - 1] ==", p[p.count - 1])
let c = BigCombination(of:(0..<100), size:50)
print("c.count ==", c.count)
print("c.count[c.count - 1] ==", c[c.count - 1])
