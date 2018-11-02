# ConvexHullTrick

## ConvexHullTrick

object for Convex Hull Trick 
```nim
ConvexHullTrick*[T] = object
  MIN: T
  MAX: T
  root: CHTLine[T]

```
## initConvexHullTrick

create Convex Hull Trick Object. [mi , ma] is the defined range of line.
```nim
proc initConvexHullTrick*[T](mi, ma: T): ConvexHullTrick[T]
```
## add

add line to cht. takes O(logN)
```nim
proc add*[T](cht: var ConvexHullTrick[T]; a, b: T)
```
## get_max

get max value of lines. <cite>max[i](l_i(x))</cite>. takes O(logN)
```nim
proc get_max*[T](cht: ConvexHullTrick[T]; x: T): T
```
