# PrimalDual

## PairingNode

Node of Pairing Heap
```nim
PairingNode*[T] = ref object
  elm*: T
  sub_node: DoublyLinkedList[PairingNode[T]]

```
## PairingHeap

PairingHeap
```nim
PairingHeap*[T] = object
  sz*: int
  root*: PairingNode[T]
  comp: proc (x: T; y: T): bool

```
## newPairingHeap

create PairingHeap. O(1)
```nim
proc newPairingHeap*[T](comp: proc (x: T; y: T): bool): PairingHeap[T]
```
## top

return the top value of pairing heap. O(1)
```nim
proc top*[T](heap: PairingHeap[T]): T
```
## pop

pop the top value of pairing heap. amortized O(logN)
```nim
proc pop*[T](heap: var PairingHeap[T])
```
## push

push x to pairing heap. O(1)
```nim
proc push*[T](heap: var PairingHeap[T]; x: T)
```
## size

return the size of pairing heap. O(1)
```nim
proc size*[T](heap: PairingHeap[T]): int
```
## empty

if the pairng heap is empty, return true. O(1)
```nim
proc empty*[T](heap: PairingHeap[T]): bool
```
## meld

merge two pairng heap. amortized O(logN)
```nim
proc meld*[T](heap1: var PairingHeap[T]; heap2: var PairingHeap[T])
```
## PDEdge

Edge Object , edit this to add more information like distance.
```nim
PDEdge* = object
  to: int
  cap: int
  cost: int
  rev: int

```
## Graph


```nim
Graph*[E] = seq[seq[E]]
```
## PrimalDual

Graph Object.
```nim
PrimalDual* = Graph[PDEdge]
```
## newGraph

create n size new Graph.
```nim
proc newGraph*[E](n: int): Graph[E]
```
## size

size of Graph
```nim
proc size*[E](g: Graph[E]): int
```
