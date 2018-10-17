# TreapArray

## IDE


```nim
proc IDE*(T: typedesc[int]): int
```
## OPE


```nim
proc OPE*(a: int; b: int): int
```
## newTreapArray

create new TreapArray
```nim
proc newTreapArray*[T](): TreapArray[T]
```
## insert

insert val at k. takes O(logN)
```nim
proc insert*[T](tree: var TreapArray[T]; k: int; val: T)
```
## erase

erase node at k. takes O(logN)
```nim
proc erase*[T](tree: var TreapArray[T]; k: int)
```
## merge

merge array. takes O(logN)
```nim
proc merge*[T](tree1: var TreapArray[T]; tree2: var TreapArray[T])
```
## split

split array to [0..k-1] and [k..N - 1]. takes O(logN)
```nim
proc split*[T](tree1: var TreapArray[T]; k: int): tuple[left: TreapArray[T],
    right: TreapArray[T]]
```
## at

node at k of array. takes O(logN)
```nim
proc at*[T](tree: TreapArray[T]; k: int): T
```
## set

update value at k to val. takes O(logN)
```nim
proc set*[T](tree: var TreapArray[T]; k: int; val: T)
```
## fold

fold interval. takes O(logN)
```nim
proc fold*[T](tree: var TreapArray[T]; left, right: int): T
```
