import lists
type
    PairingNode*[T] = ref object
        ## Node of Pairing Heap
        elm* : T
        sub_node : DoublyLinkedList[PairingNode[T]]
    PairingHeap*[T] = object
        ## PairingHeap
        sz* : int
        root* : PairingNode[T]
        comp : proc(x : T , y : T) : bool

proc newPairingHeap*[T](comp : proc(x : T , y : T) : bool) : PairingHeap[T] =
    ## create PairingHeap. O(1)
    var heap : PairingHeap[T]
    heap.sz = 0
    heap.root = nil
    heap.comp = comp
    return heap

proc newPairingNode[T](elm : T) : PairingNode[T] =
    ## create PairingNode. O(1)
    var node = new PairingNode[T]
    node.elm = elm
    node.sub_node = initDoublyLinkedList[PairingNode[T]]()
    return node

proc merge[T](comp : proc(x : T,y : T) : bool,x : var PairingNode[T] , y : var PairingNode[T]) : PairingNode[T] =
    ## merge two pairing node. O(1)
    if y == nil:
        return x
    if x == nil:
        return y
    if comp(x.elm , y.elm):
        x.sub_node.prepend(y)
        return x
    else:
        y.sub_node.prepend(x)
        return y

proc mergeList[T](comp : proc(x : T,y : T) : bool,x : DoublyLinkedList[PairingNode[T]]) : PairingNode[T] =
    ## mergeList. amortized O(logN)
    var z = x.head
    var res : PairingNode[T]
    while z != nil and z.next != nil:
        z = z.next.next
    if z == nil:
        res = nil
        z = x.tail
    else:
        res = z.value
        z = z.prev
    while z != nil:
        var temp = merge(comp,z.value,z.prev.value)
        res = merge(comp,temp,res)
        z = z.prev.prev
    return res

proc top*[T](heap : PairingHeap[T]) : T =
    ## return the top value of pairing heap. O(1)
    return heap.root.elm

proc pop*[T](heap : var PairingHeap[T]) =
    ## pop the top value of pairing heap. amortized O(logN)
    heap.sz = heap.sz - 1
    heap.root = mergeList(heap.comp,heap.root.sub_node)

proc push*[T](heap : var PairingHeap[T] , x : T) =
    ## push x to pairing heap. O(1)
    heap.sz = heap.sz + 1
    var z = newPairingNode(x)
    heap.root = merge(heap.comp , z , heap.root)

proc size*[T](heap : PairingHeap[T]) : int =
    ## return the size of pairing heap. O(1)
    return heap.sz

proc empty*[T](heap : PairingHeap[T]) : bool =
    ## if the pairng heap is empty, return true. O(1)
    return heap.size == 0

proc meld*[T](heap1 : var PairingHeap[T] , heap2 : var PairingHeap[T]) =
    ## merge two pairng heap. amortized O(logN)
    heap2.sz = 0
    heap1.root = merge(heap1.comp , heap1.root , heap2.root)
    heap2.root = nil


# verify???

import random
import algorithm
import times

var que = newPairingHeap[int](proc(x : int ,y : int) : bool = return x < y)
var s : seq[int] = @[]
var n = 100000
for i in 1..n:
    var a = random(1000000000)
    que.push(a)
    s.add(a)
var que2 = newPairingHeap[int](proc(x : int ,y : int) : bool = return x < y)

for i in 1..n:
    var a = random(1000000000)
    que2.push(a)
    s.add(a)

sort(s,system.cmp)

que.meld(que2)

for i in 0..n * 2 - 1:
    echo s[i] , "=" , que.top
    assert s[i] == que.top
    que.pop



