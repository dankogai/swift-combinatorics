import Testing
@testable import Combinatorics

@Suite struct ArithmeticTests {
    @Test func testFactorial() {
        #expect(factorial(0) == 1)
        #expect(factorial(1) == 1)
        #expect(factorial(10) == 3628800)
    }
    @Test func testPermutation() {
        #expect(permutation(10, 0) == 1)
        #expect(permutation(10, 5) == 30240)
        #expect(permutation(5, 7) == 0)
    }
    @Test func testCombination() {
        #expect(combination(10, 0) == 1)
        #expect(combination(10, 5) == 252)
        #expect(combination(10, 10) == 1)
        #expect(combination(5, 7) == 0)
        // results fit in Int but would overflow via permutation(n, k) / permutation(k, k)
        #expect(combination(30, 15) == 155117520)
        #expect(combination(52, 26) == 495918532948104)
    }
    @Test func testFactoradic() {
        #expect(0.factoradic() == [0])
        #expect(1.factoradic() == [1, 0])
        #expect(23.factoradic() == [3, 2, 1, 0])
        #expect(349.factoradic() == [2, 4, 2, 0, 1, 0])
    }
}

@Suite struct IteratorTests {
    @Test func testPermutation() {
        let p = Permutation(of:"abcd")
        #expect(p.count == 24)
        #expect(p[0]  == ["a","b","c","d"])
        #expect(p[p.count - 1] == ["d","c","b","a"])
        #expect(Set(p.map{ String($0) }).count == 24)
        let p2 = Permutation(of:"abcd", size:2)
        #expect(p2.count == 12)
        #expect(p2[0] == ["a","b"])
        #expect(Set(p2.map{ String($0) }).count == 12)
    }
    @Test func testCombination() {
        let c = Combination(of:"abcd", size:2)
        #expect(c.count == 6)
        #expect(c.map{ String($0) } == ["ab","ac","ad","bc","bd","cd"])
        // default size yields the single full-length combination
        let cd = Combination(of:"abcd")
        #expect(cd.count == 1)
        #expect(cd[0] == ["a","b","c","d"])
        let big = Combination(of:0..<30, size:15)
        #expect(big.count == 155117520)
        #expect(big[0] == Array(0..<15))
        #expect(big[big.count - 1] == Array(15..<30))
    }
    @Test func testUniquePermutation() {
        let u = UniquePermutation(of:"aab")
        #expect(u.count == 3) // not 3! == 6
        #expect(u.map{ String($0) } == ["aab", "aba", "baa"])
        let u2 = UniquePermutation(of:"aab", size:2)
        #expect(u2.count == 3)
        #expect(u2.map{ String($0) } == ["aa", "ab", "ba"])
        // same orderings as Permutation, each exactly once
        let d = UniquePermutation(of:"aabbc")
        #expect(d.count == 30) // 5! / (2! * 2!)
        let strings = d.map{ String($0) }
        #expect(Set(strings).count == 30)
        #expect(Set(strings) == Set(Permutation(of:"aabbc").map{ String($0) }))
        // no duplicates: degenerates to plain permutation counts
        #expect(UniquePermutation(of:"abc").count == 6)
        #expect(UniquePermutation(of:"mississippi").count == 34650) // 11! / (4! * 4! * 2!)
    }
    @Test func testPermutations() {
        let p = Permutations(of:"abc", sizes:1...3)
        #expect(p.count == 15) // 3P1 + 3P2 + 3P3 == 3 + 6 + 6
        #expect(p[0] == ["a"])
        #expect(p[3] == ["a", "b"])
        #expect(p[p.count - 1] == ["c", "b", "a"])
        #expect(Array(p.map{ String($0) }.prefix(3)) == ["a", "b", "c"])
        let pp = Permutations(of:"abcd", sizes:[1, 3]) // sizes need not be contiguous
        #expect(pp.count == 28) // 4P1 + 4P3 == 4 + 24
        #expect(pp[4] == ["a", "b", "c"])
    }
    @Test func testCombinations() {
        let c = Combinations(of:"abcd", sizes:2...3)
        #expect(c.count == 10) // 4C2 + 4C3
        #expect(c.map{ String($0) } == ["ab","ac","ad","bc","bd","cd","abc","abd","acd","bcd"])
        // sizes 0...n is the power set grouped by size
        let ps = Combinations(of:"abcd", sizes:0...4)
        #expect(ps.count == 16)
        #expect(ps[0] == [])
        #expect(Set(ps.map{ String($0) }) == Set(PowerSet(of:"abcd").map{ String($0) }))
    }
    @Test func testBaseN() {
        let bn = BaseN(of:"ab", size:2)
        #expect(bn.count == 4)
        #expect(bn.map{ String($0) } == ["aa","ba","ab","bb"])
    }
    @Test func testPowerSet() {
        let ps = PowerSet(of:"ab")
        #expect(ps.count == 4)
        #expect(ps.map{ String($0) } == ["","a","b","ab"])
    }
    @Test func testCartesianProduct() {
        let cp = CartesianProduct("ab", 0..<2)
        #expect(cp.count == 4)
        #expect(cp.map{ "\($0.0)\($0.1)" } == ["a0","a1","b0","b1"])
    }
    @Test func testProductSet() {
        let ps = ProductSet([0,1],[2,4,6])
        #expect(ps.count == 6)
        #expect(ps[0] == [0,2])
    }
}
