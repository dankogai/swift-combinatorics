// placeholder for static functions
public class Combinatorics {
    /// factorial of n. generically written so it can accept BigInt and Such
    public static func factorial<T:SignedInteger>(_ n:T)->T {
        guard 0 <= n else { fatalError() }
        return n < 1 ? 1 : (1...Int(n)).reduce(T(1)){ $0 * T($1) }
    }
    public static func permutation<T:SignedInteger>(_ n:T, _ k:T)->T {
        guard k <= n else { return permutation(k, n) }
        guard 0 <= n else { fatalError() }
        return (Int(n - k + 1)...Int(n)).reduce(T(1)){ $0 * T($1) }
    }
    public static func combination<T:SignedInteger>(_ n:T, _ k:T)->T {
        guard k <= n else { return combination(k, n) }
        guard 0 <= n else { fatalError() }
        return permutation(k, n) / factorial(k)
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
    public init<S:Sequence>(of:S, size:Index=64) where S.Element == SubElement {
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
        public init(seed:[SubElement], size:Index=64) {
            guard 0 < size else { fatalError() }
            self.seed  = seed
            self.size  = Swift.min(size, Index(seed.count))
            self.count = Combinatorics.permutation(Index(seed.count), size)
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
        public let perm:Permutation<SubElement>
        public let count:Index
        public init(seed:[SubElement], size:Index=64) {
            perm  = Permutation(seed:seed, size:size)
            count = Combinatorics.combination(perm.size, Index(perm.seed.count))
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            // cf. https://en.wikipedia.org/wiki/Combinatorial_number_system
            func findIndex(_ n:Index)->Index {
                guard 2 < n else { return n }
                let p = n - 1
                let s = p & -p
                let r = p + s
                let t = r & -r
                let m = ((t / s) >> 1) - 1
                return r | m
            }
            return perm[findIndex(idx)]
        }
    }
    /// BaseN
    public struct BaseN<SubElement> : CombinatoricsType, Sequence {
        public let seed:[SubElement] // immutable
        public let size:Index
        public let count:Index
        public init(seed:[SubElement], size:Index=64) {
            guard 0 < size else { fatalError() }
            self.seed  = seed
            self.size  = Swift.min(size, Index(seed.count))
            self.count =  (0..<Int(size)).reduce(Index(1)){ n,_ in n * Index(seed.count) }
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
        public init(seed:[SubElement], size:Index=64) {
            guard 0 < size else { fatalError() }
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
    public struct CartesianProduct<SubElement>: Sequence where SubElement:Sequence  {
        public typealias Element = [SubElement.Element]
        public let seed:[[SubElement.Element]] // immutable
        public var size:Index { return Index(seed.count) }
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
            for i in 0..<Int(size) {
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
