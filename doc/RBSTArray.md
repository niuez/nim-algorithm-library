# RBSTArray

## IDE


```nim
proc IDE*(T: typedesc[int]): int
```
## OPE


```nim
proc OPE*(a: int; b: int): int
```
## RBSTArray

RBSTArray Object
```nim
RBSTArray*[T] = object
  root*: RBSTNode[T]

```
## newRBSTArray

create new RBSTArray.
```nim
proc newRBSTArray*[T](): RBSTArray[T]
```
## insert

insert val at k. takes O(logN)
```nim
proc insert*[T](tree: var RBSTArray[T]; k: int; val: T)
```
## erase

erase node at k. takes O(logN)
```nim
proc erase*[T](tree: var RBSTArray[T]; k: int)
```
## merge

merge array. takes O(logN)
```nim
proc merge*[T](tree1: var RBSTArray[T]; tree2: var RBSTArray[T])
```
## split

split array to [0..k-1] and [k..N - 1]. takes O(logN)
```nim
proc split*[T](tree1: var RBSTArray[T]; k: int): tuple[left: RBSTArray[T],
    right: RBSTArray[T]]
```
## at

node at k of array. takes O(logN)
```nim
proc at*[T](tree: RBSTArray[T]; k: int): T
```
## set

update value at k to val. takes O(logN)
```nim
proc set*[T](tree: var RBSTArray[T]; k: int; val: T)
```
## fold

fold interval. takes O(logN)
```nim
proc fold*[T](tree: var RBSTArray[T]; left, right: int): T
```
