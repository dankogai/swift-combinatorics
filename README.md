[![Swift 6.0](https://img.shields.io/badge/swift-6.0-brightgreen.svg)](https://swift.org)
[![MIT LiCENSE](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![CI via GitHub Actions](https://github.com/dankogai/swift-combinatorics/actions/workflows/swift.yml/badge.svg)](https://github.com/dankogai/swift-combinatorics/actions/workflows/swift.yml)

# swift-combinatorics

Combinatorics in Swift

## Synopsis

```swift
import Combinatorics

for chars in Permutation(of:"swift") {
    print(String(chars))
}
```

## Description

The following are random-accessible iterators with each element obtained via `[_:Int]`.  Bounds are checked and if they are out it `fatalError()`s.

```swift
let p = Permutation(0, 1, 2, 3)
p.count         // 24
p[0]            // [0, 1, 2, 3]
p[p.count - 1]  // [3, 2, 1, 0]
```

#### `init`s

They all support initializer of forms below.

```swift
Permutation(seed:[Element], size:Int=default)
Permutation(of:Sequence, size:Int=default)
Permutation(_ source:Element…)
```

The first one is the canonical initializer.  `size` specifies the size of array that the iterator returns, which defaults to `seed.count`.  The second form is for convenience in which case any `Sequence` is converted to `[Element]`. 

### `Permutation`

Returns an iterator that returns the permuted array.

```swift
var p = Permutation(of:"abcd")
p.count      // 24
p[p.count-1] // ["d","c","b","a"]
p.map { $0 } // [["a","b","c","d"]...["d","c","b","a"]]
p = Permutation(of:"abcd", size:2)
p.count      // 12
p[p.count-1] // ["d", "c"]
p.map { $0 } // [["a","b"] ... ["d","c"]]
```

### `UniquePermutation`

Permutations of a multiset: duplicate elements yield each distinct ordering only once.  `Element` must be `Hashable`.

````swift
let u = UniquePermutation(of:"aab")
u.count      // 3, not 3! == 6
u.map { String($0) } // ["aab", "aba", "baa"]
UniquePermutation(of:"mississippi").count // 34650, not 11! == 39916800
````

### `Combination`

Returns an iterator that returns the permuted array but arrays with same elements are treated as the same, regardless of the order.  Therefore you should not omit `size` or you get only one result.

````swift
var c = Combination(of:"abcd")
c.count      // 1
c[c.count-1] // ["a","b","c","d"]
c.map { $0 } // [["a","b","c","d"]]
c = Combination(of:"abcd", size:2)
c.count      // 6
c[c.count-1] // ["c","d"]
c.map { $0 } // [["a","b"],["a","c"],["a","d"],["b","c"], ["b","d"], ["c","d"]]
````

### `Permutations` and `Combinations`

Permutations and combinations of several sizes in one sequence, like swift-algorithms' `permutations(ofCount:)` and `combinations(ofCount:)` with ranges.  `sizes` accepts any sequence of `Int` — a range or an array — and size `0` contributes the single empty element.

````swift
let c = Combinations(of:"abcd", sizes:2...3)
c.count      // 4C2 + 4C3 == 10
c.map { String($0) } // ["ab","ac","ad","bc","bd","cd","abc","abd","acd","bcd"]
let p = Permutations(of:"abc", sizes:[1, 3])
p.count      // 3P1 + 3P3 == 9
````

### `BaseN`

Returns an iterator that returns the corresponding "digits".

````swift
var d = BaseN(of:0...3)
d.count      // 4 ** 4 == 256
d[d.count-1] // [3,3,3,3]
d.map { $0 } // [[0,0,0,0]...[3,3,3,3]]
d = BaseN(of:0...3, size:2)
d.count      // 16
d[d.count-1] // [3,3]
d.map { $0 } // [[0,0]...[3,3]]
````

### `PowerSet`

Returns an iterator that returns the element of the power set for each iteration.  `size` is fixed to `seed.count` where `seed` is the source sequence.

````swift
let s = PowerSet(of:0...3)
s.count // 2 ** 4 == 16
s.map { $0 } // [[],[0],[1],[0,1]...[0,1,2,3]]
````

### `CartesianProduct` and `ProductSet`

Returns an iterator that returns the element of the cartesian product for each iteration.

````swift
let suits = "♠️♦️❤️♣️"
let ranks =  1...13
let cp = CartesianProduct(suits, ranks)
cp.count // 52
cp.map { $0 } //[("♠️",1)...("♣️",13)]
````

Unlike other iterators `CartesianProduct` takes two `Collection`s and returns their Cartesian product in tuples. The type of their `.Element` do not have to match.

The iterator itself is also a collection so you can build multidimensional Cartesian products by successively applying multiplicands.

```swift
let cp = CartesianProduct("01", "abc")
let cpcp = CartesianProduct(cp, "ATCG")
cp.count // 24
cpcp.map{ $0 } // [(("0","a"),"A")...(("1","c"),"G")]
```

As you see `CartesianProduct` returns a tuple.  This is mathematically correct but harder to work with.  But in Swift `(T,T)` is a different type from `(T,T,T)` so you cannot write a function that returns tuples of different lengths.

To mitigate this, `Combinatorics` offers `ProductSet`.  The type of all elements must be identical but you get an array instead of tuple.

```swift
let ps = ProductSet([0,1],[2,4,6],[3,6,9,12],[4,8,12,16,20])
ps.count // 2 * 3 * 4 * 5 == 120
ps.map{ $0 } // [[0, 2, 3, 4] ... [1, 6, 12, 20]]
```


### Arithmetic Functions

This module also comes with the following arithmetic functions.

```swift
// T:SignedInteger
factorial<T>(_ n:T)->T             // factorial of n
permutation<T>(_ n:T, _ k:T)->T    // nPk
combination<T>(_ n:T, _ k:T)->T    // nCk
```

And `SignedInteger` is extended with the following methods.

```swift
n.factoradic()   // digits of n in the factorial number system
n.combinadic(k)  // (i)->[Int] that maps i to its combinadic digits for nCk
```

As you see they are generically defined so you can use not only `Int` but also `BigInt` where available.

### Using index other than `Int`

Under the hood, iterators above are defined as follows:

```swift
public typealias Permutation        = CombinatoricsIndex<Int>.Permutation
public typealias Combination        = CombinatoricsIndex<Int>.Combination
// …
public typealias ProductSet         = CombinatoricsIndex<Int>.ProductSet
```

Why? Because `Int` is often big enough for combinatorics.  Fortunately Swift allows you to generically define `subscript` its index does not have to be `Int`.  See [BigCombinatorics] to see how to use `BigInt` indices.

[BigCombinatorics]: BigCombinatorics/

## vs. swift-algorithms

Apple's [swift-algorithms] also covers combinatorics, via extension methods on `Collection`: `permutations(ofCount:)`, `uniquePermutations(ofCount:)`, `combinations(ofCount:)`, and `product(_:_:)`.  The two packages overlap, but they are built around different access models.

[swift-algorithms]: https://github.com/apple/swift-algorithms

|                            | swift-combinatorics | swift-algorithms |
|----------------------------|---------------------|------------------|
| access model               | random access by index: `p[i]` | sequential iteration only (`product` alone is random-access) |
| `count` without iterating  | always: `p.count` | `combinations`: yes; `permutations`: no |
| index type                 | any `SignedInteger`, including `BigInt` | `Int` |
| permutations               | `Permutation` | `permutations(ofCount:)` |
| combinations               | `Combination` | `combinations(ofCount:)` |
| several sizes at once      | `Permutations` / `Combinations` `(of:sizes:)` | `permutations` / `combinations` `(ofCount: 2...4)` |
| deduplicated permutations  | `UniquePermutation` | `uniquePermutations(ofCount:)` |
| cartesian product          | `CartesianProduct` (binary), `ProductSet` (n-ary) | `product(_:_:)` (binary; compose for more) |
| base-n / power set         | `BaseN`, `PowerSet` | — |
| arithmetic functions       | `factorial`, `permutation`, `combination`, `.factoradic()`, `.combinadic()` | — |

The defining difference is the first row.  In swift-algorithms, `PermutationsSequence` and `CombinationsSequence` conform only to `Sequence`: each element is generated from its predecessor, so you can reach the *i*-th element only by iterating past the first *i*.  Every iterator in this package is instead defined by its `subscript`, so you can jump straight to any element — sample a huge space at random, split an index range across threads, or resume where you left off.  Combined with `BigInt` indices, the space itself can be astronomically large (`Permutation` of 100 elements has 100! ≈ 9.3 × 10¹⁵⁷ entries) and still be indexed.

The flip side: generating an element from scratch costs more than generating it from its predecessor, so if all you ever do is enumerate front to back — or you want the lazy composition and deduplication swift-algorithms provides — swift-algorithms is a fine choice.  If you need to *index* the combinatorial space, this package is for you.

## Usage

### build

### REPL

```sh
$ swift run ~~repl
```

and in your repl,

```sh
  1> import Combinatorics
  2> Permutation(of:"swift").map{ String($0) }
$R0: [String] = 120 values {
  [0] = "swift"
  [1] = "switf"
  [2] = "swfit"
   // ...
  [119] = "tfiws"
}
```

### Xcode

No Xcode project is checked in — recent versions of Xcode open Swift packages directly.  Just open the package directory (or `Package.swift`) in Xcode.  `macOS.playground` is written as a manual.

### From Your SwiftPM-Managed Projects

Add the following to the `dependencies` section:

```swift
.package(
  url: "https://github.com/dankogai/swift-combinatorics.git", from: "0.0.1"
)
```

and the following to the `.target` argument:

```swift
.target(
  name: "YourSwiftyPackage",
  dependencies: ["Combinatorics"])
```

Now all you have to do is:

```swift
import Combinatorics
```

in your code.  Enjoy!

## Prerequisite

Swift 6.0 or better, macOS or Linux to build.

