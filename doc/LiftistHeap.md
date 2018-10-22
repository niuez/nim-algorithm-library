# LiftistHeap

## COMP


```nim
proc COMP*(x, y: int): bool
```
## INF


```nim
proc INF*(t: typedesc[int]): int
```
## LiftistNode

Node of Liftist Heap
```nim
LiftistNode*[T] = ref object
  val*: T
  l: LiftistNode[T]
  r: LiftistNode[T]

```
## LiftistHeap

Liftist Heap Object
```nim
LiftistHeap*[T] = object
  root*: LiftistNode[T]

```
## newLiftistHeap

create new Liftist Heap Object
```nim
proc newLiftistHeap*[T](): LiftistHeap[T]
```
## meld

y Liftist Heap merge to x. amortized O(logN)
```nim
proc meld*[T](x, y: var LiftistHeap[T])
```
## push

the new Node that has value val push to x. amortized O(logN)
```nim
proc push*[T](x: var LiftistHeap[T]; val: T)
```
## top

the top value of Liftist Heap. takes O(1)
```nim
proc top*[T](x: LiftistHeap[T]): T
```
## snd

the second value of Liftist Heap. takes O(1)
```nim
proc snd*[T](x: LiftistHeap[T]): T
```
## pop

remove the top value of Liftist Heap. amortized O(logN)
```nim
proc pop*[T](x: var LiftistHeap[T])
```
## empty

if the Liftist Heap is empty, return true. takes O(1)
```nim
proc empty*[T](x: LiftistHeap[T]): bool
```
