import BigInt
import Combinatorics

typealias BigPermutation = CombinatoricsIndex<BigInt>.Permutation
typealias BigCombination = CombinatoricsIndex<BigInt>.Combination

let p = BigPermutation(of:(0..<100))
print("""
let p = BigPermutation(of:(0..<100))
p.count == \(p.count)
p.count[p.count - 1] == \(p[p.count - 1])
""")
let c = BigCombination(of:(0..<100), size:50)
print("""
let c = BigCombination(of:(0..<100))
c.count == \(c.count)
c.count[p.count - 1] == \(c[c.count - 1])
""")
