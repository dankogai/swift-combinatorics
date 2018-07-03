[![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)](https://swift.org)
[![MIT LiCENSE](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![build status](https://secure.travis-ci.org/dankogai/swift-combinatorics.png)](http://travis-ci.org/dankogai/swift-combinatorics)

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

````swift
var p = Permutation(of:"abcd")
p.count      // 24
p.map { $0 } // [["a","b","c","d"]...["d","c","b","a"]]
p = Permutation(of:"abcd", size:2)
p.count      // 12
p.map { $0 } // [["a","b"] ... ["d","c"]]
````

### `Combination`

Returns an iterator that returns the permuted array but arrays with same elements are treated as the same, regardless of the order.  Therefore you should not ommit `size` or you get only one result.

````swift
var c = Combination(of:"abcd")
c.count      // 1
c.map { $0 } // [["a","b","c","d"]]
c = Combination(of:"abcd", size:2)
c.count      // 6
c.map { $0 } // [["a","b"],["a","c"],["a","d"],["b","c"], ["b","d"], ["c","d"]]
````

### `BaseN`

Returns an iterator that returns the corresponding "digits".

````swift
var d = BaseN(of:0...3)
d.count // 4 ** 4 == 256
d.map { $0 } // [[0,0,0,0]...[3,3,3,3]]
d = BaseN(of:0...3)
d.count      // 16
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
let ranks =  1..13
let cp = CartesianProduct(suits, ranks)
cp.count // 52
cp.map { $0 } //[("♠️",1)...("♣️",13)]
````

Unlike other iterators `CartesianProduct` takes two `Collection`s and returns their Cartesian product in tuples. The type of their `.Element` do not have to match.

The iterator itself is also a collection so you can build multidimensional Cartesian products by succesively applying multiplicands.

```swift
let cp = CartesianProduct("01", "abc")
let cpcp = CartesianProduct(cp, "ATCG")
cp.count // 24
cpcp.map{ $0 } // [(("0","a"),"A")...(("1","c"),"G")]
```

As you see `CartesianProduct` returns a tuple.  This is mathmatically correct but harder to work with.  But in Swift `(T,T)` is a different type from `(T,T,T)` so you cannot write a function that returns tuples of different lengths.

To mitigate this, `Combinatorics` offers `ProductSet`.  The type of all elements must be identical but you get an array instead of tuple.

```swift
let ps = ProductSet([0,1],[2,4,6],[3,6,9,12],[4,8,12,16,20])
ps.count // 2 * 3 * 4 * 5 == 120
ps.map{ $0 } // [[0, 2, 3, 4] ... [1, 6, 12, 20]]
```


### Arithmetic Functions

This module also comes with followings arithmetic functions that are bundled in `Combinatorics` as static functions.

```swift
// T:SignedInteger
Combinatorics.factorial<T>(_ n:T)->T
Combinatorics.permutation<T>(_ n:T, _ k:T)->T
Combinatorics.combination<T>(_ n:T, _ k:T)->T
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

## Usage

### build

```sh
$ git clone https://github.com/dankogai/swift-combinatorics.git
$ cd swift-combinatorics # the following assumes your $PWD is here
$ swift build
```

### REPL

Simply

```sh
$ scripts/run-repl.sh
```

or

```sh
$ swift build && swift -I.build/debug -L.build/debug -lCombinatorics

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

Xcode project is deliberately excluded from the repository because it should be generated via `swift package generate-xcodeproj` . For convenience, you can

```sh
$ scripts/prep-xcode
```

And the Workspace opens up for you with Playground on top.  The playground is written as a manual.

### iOS and Swift Playground

Unfortunately Swift Package Manager does not support iOS.  To make matters worse Swift Playgrounds does not support modules.  But don't worry.  This module is so compact all you need is copy [Combinatorics.swift].

[Combinatorics.swift]: Sources/Combinatorics/Combinatorics.swift

In case of Swift Playgrounds just copy it under `Sources` folder.  If you are too lazy just run:


```sh
$ scripts/ios-prep.sh
```

and `iOS/Combinatorics.playground` is all set.  You do not have to `import Combinatorics` therein.

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

Swift 4.1 or better, OS X or Linux to build.

