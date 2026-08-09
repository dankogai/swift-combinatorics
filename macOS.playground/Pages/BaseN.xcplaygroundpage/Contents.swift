//: [Previous](@previous)
import Combinatorics
/*:
 # BaseN

 All `size`-digit numbers written in base `seed.count`,
 least significant digit first.
 */
let bn = BaseN(of:"01", size:4)
bn.count      // 2 ** 4 == 16
bn.map{ String($0) }
//: Every 3-letter codon over the DNA alphabet.
let dna = BaseN(of:"ATCG", size:3)
dna.count     // 4 ** 3 == 64
dna[0]        // ["A", "A", "A"]
dna[63]       // ["G", "G", "G"]
for codon in dna.prefix(8) {
    print(String(codon))
}
//: `size` may exceed `seed.count` — digits just repeat.
let oct = BaseN(of:0...7, size:3)
oct.count     // 8 ** 3 == 512
oct[511]      // [7, 7, 7]
//: [Next](@next)
