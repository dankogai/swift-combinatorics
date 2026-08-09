//: [Previous](@previous)
import Combinatorics
/*:
 # ProductSet

 An n-ary Cartesian product over a single element type —
 arrays instead of nested tuples.
 */
let pset = ProductSet([0,1], [2,4,6], [3,6,9,12])
pset.count    // 2 * 3 * 4 == 24
pset[0]       // [0, 2, 3]
pset.map{ $0 }
//: Every fixed-course menu, one per index.
let menu = ProductSet(["soup", "salad"], ["pasta", "steak", "fish"], ["cake", "gelato"])
menu.count    // 2 * 3 * 2 == 12
for course in menu {
    print(course.joined(separator: " + "))
}
//: [Next](@next)
