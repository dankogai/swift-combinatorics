import BigInt
import Combinatorics

typealias BigPermutation = CombinatoricsIndex<BigInt>.Permutation

let p = BigPermutation(of:(0..<100))
print(p.count)
print(p[p.count - 1])
