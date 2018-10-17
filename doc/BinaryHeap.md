# BinaryHeap

## BinaryHeap

Binary Heap
```nim
BinaryHeap*[T] = object
  heap: seq[T]
  comp: proc (x: T; y: T): bool

```
## newBinaryHeap

create new Binary Heap. O(1)
```nim
proc newBinaryHeap*[T](comp: proc (x: T; y: T): bool): BinaryHeap[T]
```
## size

return Binary Heap size. O(1)
```nim
proc size*[T](bin: var BinaryHeap[T]): int
```
## empty

if Binary Heap is empty, return true. O(1)
```nim
proc empty*[T](bin: var BinaryHeap[T]): bool
```
## push

push x to Binary Heap. O(logN)
```nim
proc push*[T](bin: var BinaryHeap[T]; x: T)
```
## top

return the top value of Binary Heap. O(1)
```nim
proc top*[T](bin: var BinaryHeap[T]): T
```
## pop

poop the top value of Binary Heap.O(logN)
```nim
proc pop*[T](bin: var BinaryHeap[T])
```
