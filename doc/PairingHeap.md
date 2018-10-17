# PairingHeap

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
