/// factorial of n. generically written so it can accept BigInt and Such
public func factorial<T:SignedInteger>(_ n:T)->T {
    guard 0 <= n else { fatalError() }
    return n < 1 ? 1 : (1...Int(n)).reduce(T(1)){ $0 * T($1) }
}
/// number of permutations of n objects taken k at a time (nPk)
public func permutation<T:SignedInteger>(_ n:T, _ k:T)->T {
    if 0 == k { return 1 }
    if n <  k { return 0 }
    var (vp, vn, vk) = (T(1), n, k)
    while (0 < vk) {
        vp *= vn;
        vk -= 1
        vn -= 1
    }
    return vp
}
/// number of combinations of n objects taken k at a time (nCk)
public func combination<T:SignedInteger>(_ n:T, _ k:T)->T {
    if 0 == k { return 1 }
    if n == k { return 1 }
    if n <  k { return 0 }
    let l = Swift.min(k, n - k) // nCk == nC(n-k); the smaller shortens the loop
    var (result, i) = (T(1), T(0))
    while i < l {
        // result * (n - i) is divisible by (i + 1) because
        // the lhs == combination(n, i + 1) * (i + 1)
        result = result * (n - i) / (i + 1)
        i += 1
    }
    return result
}
extension SignedInteger {
    // cf. https://en.wikipedia.org/wiki/Factorial_number_system
    public func factoradic()->[Int] {
        guard 0 <= self else { fatalError() }
        var (q, r, i) = (self, Self(0), Int(1))
        var result = [Int]()
        repeat {
            (q, r) = q.quotientAndRemainder(dividingBy: Self(i))
            result.append(Int(r))
            i += 1
        } while q != 0
        return result.reversed()
    }
    // cf. https://en.wikipedia.org/wiki/Combinatorial_number_system
    public func combinadic(_ k:Self)->(_ i:Self)->[Int] {
        let n = self
        let count = combination(n, k);
        return { i in
            guard 0 <= i && i < count else { fatalError("Index out of range") }
            var digits:[Int] = []
            var (a, b) = (n, k)
            var x = count - 1 - i
            var c = count // == combination(a, b), maintained incrementally below
            for _ in 0..<Int(k) {
                // combination(a - 1, b) == combination(a, b) * (a - b) / a
                repeat {
                    c = c * (a - b) / a
                    a -= 1
                } while x < c
                digits.append(Int(n - 1 - a))
                x -= c
                // combination(a, b - 1) == combination(a, b) * b / (a - b + 1)
                // except when a == b - 1: combination(a, b) == 0 but combination(a, b - 1) == 1
                c = c == 0 ? 1 : c * b / (a - b + 1)
                b -= 1
            }
            return digits
        }
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
            self.count = permutation(Index(seed.count), self.size)
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            guard 1 < size else {
                return seed.isEmpty ? [] : [seed[Int(idx)]]
            }
            let skip   = factorial(Index(seed.count) - size)
            var digits = (idx * skip).factoradic()
            digits.insert(contentsOf:[Int](repeating:0, count:seed.count - digits.count), at:0)
            var source = seed
            var result = [SubElement]()
            for i in 0 ..< Int(size) {
                result.append(source.remove(at: digits[i]))
            }
            return result
        }
    }
    /// permutations of a multiset — duplicate elements yield each distinct ordering only once
    public struct UniquePermutation<SubElement:Hashable> : CombinatoricsType, Sequence {
        public let seed:[SubElement] // immutable
        public let size:Index
        public let count:Index
        let uniq:[SubElement] // distinct elements in order of first appearance
        let multiplicity:[Int] // how many times each appears in seed
        public init(seed:[SubElement], size:Index=0) {
            self.seed = seed
            self.size = 0 < size && size < seed.count ? size : Index(seed.count)
            var (uniq, mult, seen) = ([SubElement](), [Int](), [SubElement:Int]())
            for e in seed {
                if let i = seen[e] { mult[i] += 1 }
                else { seen[e] = uniq.count; uniq.append(e); mult.append(1) }
            }
            self.uniq = uniq
            self.multiplicity = mult
            self.count = Self.sequences(mult, Int(self.size))
        }
        /// number of distinct sequences of `slots` elements drawn from the multiset;
        /// D_t(s) = sum_j combination(s, j) * D_{t-1}(s - j) over j copies of type t
        static func sequences(_ counts:[Int], _ slots:Int)->Index {
            var h = [Index](repeating:0, count:slots + 1)
            h[0] = 1
            var filled = 0 // h[s] == 0 for filled < s
            for c in counts {
                let newFilled = Swift.min(slots, filled + c)
                var next = [Index](repeating:0, count:slots + 1)
                for s in 0...newFilled {
                    var sum = Index(0)
                    for j in Swift.max(0, s - filled)...Swift.min(c, s) {
                        sum += combination(Index(s), Index(j)) * h[s - j]
                    }
                    next[s] = sum
                }
                (h, filled) = (next, newFilled)
            }
            return h[slots]
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            var x = idx
            var counts = multiplicity
            var result = [SubElement]()
            for slots in stride(from:Int(size) - 1, through:0, by: -1) {
                for i in 0..<uniq.count where 0 < counts[i] {
                    counts[i] -= 1
                    let block = Self.sequences(counts, slots)
                    if x < block { result.append(uniq[i]); break }
                    x -= block
                    counts[i] += 1
                }
            }
            return result
        }
    }
    /// combination
    public struct Combination<SubElement> : CombinatoricsType, Sequence {
        public let seed:[SubElement] // immutable
        public let size:Index
        public let count:Index
        public let digits:(Index)->[Int]
        public init(seed:[SubElement], size:Index=0) {
            self.seed  = seed
            self.size  = 0 < size && size < seed.count ? size : Index(seed.count)
            self.count = combination(Index(seed.count), self.size)
            self.digits = Index(seed.count).combinadic(self.size)
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            // cf. https://en.wikipedia.org/wiki/Combinatorial_number_system
            var result:[SubElement] = []
            digits(idx).forEach{ result.append(seed[$0]) }
            return result
        }
    }
    /// permutations of several sizes in one sequence
    /// like CartesianProduct it DOES NOT CONFORM TO CombinatoricsType
    public struct Permutations<SubElement> : Sequence {
        public typealias Element = [SubElement]
        public let seed:[SubElement] // immutable
        public let count:Index
        let blocks:[(offset:Index, count:Index, at:(Index)->[SubElement])]
        public init(seed:[SubElement], sizes:[Int]) {
            self.seed = seed
            var blocks = [(offset:Index, count:Index, at:(Index)->[SubElement])]()
            var total = Index(0)
            for k in sizes {
                guard 0 <= k && k <= seed.count else { fatalError("size out of range") }
                if k == 0 {
                    blocks.append((offset:total, count:1, at:{ _ in [] }))
                } else {
                    let inner = Permutation<SubElement>(seed:seed, size:Index(k))
                    blocks.append((offset:total, count:inner.count, at:{ inner[$0] }))
                }
                total += blocks.last!.count
            }
            self.blocks = blocks
            self.count = total
        }
        public init<S:Sequence, Z:Sequence>(of source:S, sizes:Z) where S.Element == SubElement, Z.Element == Int {
            self.init(seed:Array(source), sizes:Array(sizes))
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            let block = blocks.last(where:{ $0.offset <= idx })!
            return block.at(idx - block.offset)
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
    /// combinations of several sizes in one sequence
    /// like CartesianProduct it DOES NOT CONFORM TO CombinatoricsType
    public struct Combinations<SubElement> : Sequence {
        public typealias Element = [SubElement]
        public let seed:[SubElement] // immutable
        public let count:Index
        let blocks:[(offset:Index, count:Index, at:(Index)->[SubElement])]
        public init(seed:[SubElement], sizes:[Int]) {
            self.seed = seed
            var blocks = [(offset:Index, count:Index, at:(Index)->[SubElement])]()
            var total = Index(0)
            for k in sizes {
                guard 0 <= k && k <= seed.count else { fatalError("size out of range") }
                if k == 0 {
                    blocks.append((offset:total, count:1, at:{ _ in [] }))
                } else {
                    let inner = Combination<SubElement>(seed:seed, size:Index(k))
                    blocks.append((offset:total, count:inner.count, at:{ inner[$0] }))
                }
                total += blocks.last!.count
            }
            self.blocks = blocks
            self.count = total
        }
        public init<S:Sequence, Z:Sequence>(of source:S, sizes:Z) where S.Element == SubElement, Z.Element == Int {
            self.init(seed:Array(source), sizes:Array(sizes))
        }
        public subscript(_ idx:Index)->[SubElement] {
            guard 0 <= idx && idx < count else { fatalError("Index out of range") }
            let block = blocks.last(where:{ $0.offset <= idx })!
            return block.at(idx - block.offset)
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
public typealias UniquePermutation  = CombinatoricsIndex<Int>.UniquePermutation
public typealias Permutations       = CombinatoricsIndex<Int>.Permutations
public typealias Combination        = CombinatoricsIndex<Int>.Combination
public typealias Combinations       = CombinatoricsIndex<Int>.Combinations
public typealias BaseN              = CombinatoricsIndex<Int>.BaseN
public typealias PowerSet           = CombinatoricsIndex<Int>.PowerSet
public typealias CartesianProduct   = CombinatoricsIndex<Int>.CartesianProduct
public typealias ProductSet         = CombinatoricsIndex<Int>.ProductSet
