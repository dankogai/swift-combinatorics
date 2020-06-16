import BigInt
import Combinatorics

typealias BigPermutation = CombinatoricsIndex<BigInt>.Permutation

let p = BigPermutation(of:(0..<100))
print("p.count ==", p.count)
print("p.count[p.count - 1] ==", p[p.count - 1])
