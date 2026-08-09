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
