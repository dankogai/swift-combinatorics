//: [Previous](@previous)

let p = Permutation(of:"abcd", size:2)
p.count
let ap = p.map{ $0 }
ap

let c = Combination(of:"abcd", size:2)
c.count
let ac = c.map{ $0 }
ac

let bn = BaseN(of:"abcd", size:2)
bn.count
let abn = bn.map{ $0 }
abn

let ps = PowerSet(of:"abcd")
ps.count
let aps = ps.map{ $0 }
aps

//: [Next](@next)
