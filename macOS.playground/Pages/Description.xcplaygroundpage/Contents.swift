//: [Previous](@previous)

import Combinatorics

Combinatorics.factorial(1)
Combinatorics.permutation(10, 5)
Combinatorics.combination(10, 5)

let p = Permutation(of:"abcd", size:2)
p.count
for (i, a) in p.enumerated() {
    print("p[\(i)] =", a)
}

let c = Combination(of:"abcd", size:2)
c.count

for (i, a) in c.enumerated() {
    print("c[\(i)] =", a)
}

let bn = BaseN(of:"abcd", size:2)
bn.count
for (i, a) in bn.enumerated() {
    print("bn[\(i)] =", a)
}

let ps = PowerSet(of:"abcd")
ps.count
for (i, a) in ps.enumerated() {
    print("ps[\(i)] =", a)
}
