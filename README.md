# swift-combinatorics
Combinatorics in Swift

[![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)](https://swift.org)
[![MIT LiCENSE](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![build status](https://secure.travis-ci.org/dankogai/swift-combinatorics.png)](http://travis-ci.org/dankogai/swift-combinatorics)


## Synopsis

```swift
import Combinatorics

for chars in Permutation(of:"swift") {
    print(String(chars))
}
```

## Description

The following are random-accessible iterators with each element obtained via `[index]` where `index` is a `SignedInteger`.

### `Permutation`

### `Combination`

### `BaseN`

### `PowerSet`

### `CartesianProduct`

### Arithmetic Functions

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
import JSON
```

in your code.  Enjoy!

## Prerequisite

Swift 4.1 or better, OS X or Linux to build.

