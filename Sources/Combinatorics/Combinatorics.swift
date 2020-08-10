// placeholder for static functions
public class Combinatorics {
    /// factorial of n. generically written so it can accept BigInt and Such
    public static func factorial<T:SignedInteger>(_ n:T)->T {
        guard 0 <= n else { fatalError() }
        return n < 1 ? 1 : (1...Int(n)).reduce(T(1)){ $0 * T($1) }
    }
    public static func permutation<T:SignedInteger>(_ n:T, _ k:T)->T {
        if 0 == k { return 1 }
        if n <  k { return 0 }
        var (vp, vn, vk) = (T(1), T(n), T(k))
        while (0 < vk) {
            vp *= vn;
            vk -= 1
            vn -= 1
        }
        return vp
    }
    public static func combination<T:SignedInteger>(_ n:T, _ k:T)->T {
        if 0 == k { return 1 }
        if n == k { return 1 }
        if n <  k { return 0 }
        return permutation(n, k) / permutation(k,k)
    }
    // cf. https://en.wikipedia.org/wiki/Factorial_number_system
    public static func factoradic<T:SignedInteger>(_ n:T, _ c:T)->[Int] {
        guard 0 <= n else { fatalError() }
        var (q, r, i) = (n, T(0), Int(1))
        var result = [Int](repeating:0, count:Int(c))
        repeat {
            (q, r) = q.quotientAndRemainder(dividingBy: T(i))
            result[i - 1] = Int(r)
            i += 1
        } while q != 0
        return result.reversed()
    }
    public static func combinadic<T:SignedInteger>(_ n:T, _ k:T, _ i:T)->[Int] {
        let count = combination(n, k);
        guard 0 <= i && i < count else { fatalError("Index out of range") }
        var digits:[Int] = []
        var (a, b) = (n, k)
        var x = count - 1 - i
        for _ in 0..<Int(k) {
            a -= 1
            while x < combination(a, b) { a -= 1 }
            digits.append(Int(n - 1 - a))
            x -= combination(a, b)
            b -= 1
        }
        return digits
    }
}
public protocol CombinatoricsType {
    associatedtype SubElement
    associatedtype Index:SignedInteger
    init(seed:[SubElement], size:Index)
    var count:Index { get }
    subscript(_:Index)->[SubElement]{ get }
}
extension CombinatoricsType {
    public typealias Element = [SubElement]
    public func makeIterator() -> AnyIterator<Element> {
        var idx:Index = -1
        return AnyIterator {
            idx += 1
            guard idx < self.count else { return nil }
            return self[idx]
        }
    }
    public init<S:Sequence>(of:S, size:Index=0) where S.Element == SubElement {
        self.init(seed:Array(of), size:size)
    }
    public init(_ source:SubElement...) {
        self.init(seed:source, size:64)
    }
}
/// This is to wrap Index
public struct CombinatoricsIndex<Index:SignedInteger> {
    /// permutation
    public struct Permutation<SubElement> : CombinatoricsType, Sequence {
        public let seed:[SubElement] // immutable
        public let size:Index
        public let count:Index
        public init(seed:[SubElement], size:Index=0) {
            self.seed  = seed
            self.size  = 0 < size && size < seed.count ? size : Index(seed.count)
            self.count = Combinatorics.permutation(Index(seed.count), self.size)
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            guard 1 < size else {
                return [seed[Int(idx)]]
            }
            let skip   = Combinatorics.factorial(Index(seed.count) - size)
            let digits = Combinatorics.factoradic(idx * skip, Index(seed.count))
            var source = seed
            var result = [SubElement]()
            for i in 0 ..< Int(size) {
                result.append(source.remove(at: digits[i]))
            }
            return result
        }
    }
    /// combination
    public struct Combination<SubElement> : CombinatoricsType, Sequence {
        public let seed:[SubElement] // immutable
        public let size:Index
        public let count:Index
        public init(seed:[SubElement], size:Index=0) {
            self.seed  = seed
            self.size  = 0 < size && size < seed.count ? size : Index(seed.count)
            self.count = Combinatorics.combination(Index(seed.count), self.size)
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            // cf. https://en.wikipedia.org/wiki/Combinatorial_number_system
            var result:[SubElement] = []
            let digits = Combinatorics.combinadic(Index(seed.count), size, idx)
            for d in digits {
                result.append(seed[d])
            }
            return result
        }
    }
    /// BaseN
    public struct BaseN<SubElement> : CombinatoricsType, Sequence {
        public let seed:[SubElement] // immutable
        public let size:Index
        public let count:Index
        public init(seed:[SubElement], size:Index=0) {
            self.seed  = seed
            self.size  = 0 < size ? size : Index(seed.count) // seed.count <= size is okay
            self.count =  (0..<Int(self.size)).reduce(Index(1)){ n,_ in n * Index(seed.count) }
        }
        public subscript<I:SignedInteger>(_ idx:I)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            var result = [SubElement]()
            var (q, r) = (Int(idx), 0)
            for _ in 0 ..< Int(size) {
                (q, r) = q.quotientAndRemainder(dividingBy: seed.count)
                result.append(seed[r])
            }
            return result
        }
    }
    /// Power Set
    public struct PowerSet<SubElement> : CombinatoricsType, Sequence {
        public let seed:[SubElement] // immutable
        public let count:Index
        public init(seed:[SubElement], size:Index=0) {
            self.seed  = seed
            self.count = (0..<seed.count).reduce(Index(1)){ n,_ in n * Index(2) }
        }
        public subscript<I:SignedInteger>(_ idx:I)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            var result = [SubElement]()
            for i in 0..<seed.count {
                if idx & (1 << i) != 0 { result.append(seed[i]) }
            }
            return result
        }
    }
    /// CartesianProduct
    /// is slightly but significantly different from the rest so it DOES NOT CONFORM TO CombinatoricsType
    public struct CartesianProduct<L, R>:Collection where L:Collection, R:Collection {
        public typealias Element = (L.Element, R.Element)
        public let lhs:L
        public let rhs:R
        public init(_ l:L, _ r:R) {
            (lhs, rhs) = (l, r)
        }
        public var count:Index { return Index(lhs.count) * Index(rhs.count) }
        public var startIndex:Index { return 0 }
        public var endIndex: Index  { return count }
        public func index(after i: Index) -> Index { return i + 1 }
        public subscript(_ idx:Index)->Element {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            let (l, r) = Int(idx).quotientAndRemainder(dividingBy: rhs.count)
            let lv = lhs[lhs.index(lhs.startIndex, offsetBy:l)]
            let rv = rhs[rhs.index(rhs.startIndex, offsetBy:r)]
            return (lv, rv)
        }
        public func makeIterator() -> AnyIterator<Element> {
            var idx = Index(-1)
            return AnyIterator {
                idx += 1
                guard idx < self.count else { return nil }
                return self[idx]
            }
        }
    }
    /// Cartesian product of single element type
    public struct ProductSet<SubElement>: Sequence where SubElement:Sequence  {
        public typealias Element = [SubElement.Element]
        public let seed:[[SubElement.Element]] // immutable
        public let count:Index
        public init(seed:[SubElement]) {
            guard !seed.isEmpty else { fatalError() }
            self.seed = seed.map{ Array($0) }
            self.count = self.seed.reduce(Index(1)){ $0 * Index($1.count) }
        }
        public init(_ source:SubElement...) {
            self.init(seed:source)
        }
        public subscript<I:SignedInteger>(_ idx:I)->[SubElement.Element] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            var result = [SubElement.Element]()
            var (q, r) = (Int(idx), 0)
            for i in 0..<Int(Index(seed.count)) {
                (q, r) = q.quotientAndRemainder(dividingBy: seed[i].count)
                let e = seed[i][r]
                result.append(e)
            }
            return result
        }
        public func makeIterator() -> AnyIterator<Element> {
            var idx = -1
            return AnyIterator {
                idx += 1
                guard idx < self.count else { return nil }
                return self[idx]
            }
        }
    }
}
public typealias Permutation        = CombinatoricsIndex<Int>.Permutation
public typealias Combination        = CombinatoricsIndex<Int>.Combination
public typealias BaseN              = CombinatoricsIndex<Int>.BaseN
public typealias PowerSet           = CombinatoricsIndex<Int>.PowerSet
public typealias CartesianProduct   = CombinatoricsIndex<Int>.CartesianProduct
public typealias ProductSet         = CombinatoricsIndex<Int>.ProductSet
