import sequtils,queues

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

type
  PDEdge* = object
    ## Edge Object , edit this to add more information like distance.
    to : int
    cap : int
    cost : int
    rev : int
  Graph*[E] = seq[seq[E]]
  PrimalDual* = Graph[PDEdge]
    ## Graph Object.

proc newGraph*[E](n : int) : Graph[E] =
  ## create n size new Graph.
  var g : Graph[E] = newSeqWith(n , newSeq[E](0))
  return g

proc size*[E](g : Graph[E]) : int =
  ## size of Graph
  return g.len

proc addEdge(g : var PrimalDual , fr , to , cost , cap , rev_cap : int) =
  ## add Edge to Graph for Dinic
  g[fr].add(PDEdge(to : to , cost : cost , cap : cap , rev : g[to].len))
  g[to].add(PDEdge(to : fr , cost : -cost, cap : rev_cap , rev : g[fr].len - 1))

proc minimumCostFlow(g : var PrimalDual , s , t , F : int) : int =
  type P = tuple[d : int , v : int]
  var
    que = newPairingHeap[P](proc(x , y : P) : bool = x.d < y.d)
    prevv = newSeqWith(g.size , -1)
    preve = newSeqWith(g.size , -1)
    potential = newSeqWith(g.size, 0)
    res = 0
    f = F
  while f > 0:
    var dist = newSeqWith(g.size , (int)1e9)
    que.push((0 , s))
    dist[s] = 0
    while que.size > 0:
      var (d , v) = que.top
      que.pop
      if dist[v] < d: continue
      for i in 0..<g[v].len:
        var e = g[v][i]
        var next = dist[v] + e.cost + potential[v] - potential[e.to]
        if e.cap > 0 and dist[e.to] > next:
          dist[e.to] = next
          prevv[e.to] = v
          preve[e.to] = i
          que.push((dist[e.to] , e.to))
    if dist[t] == (int)1e9: return -1
    for v in 0..<g.size:
      potential[v] += dist[v]
    var d = f
    var vec = newSeq[int](0)
    var v = t
    while v != s:
      vec.add(v)
      v = prevv[v]
    for i in vec:
      d = min(d , g[prevv[i]][preve[i]].cap)
    f -= d
    res += d * potential[t]
    for i in vec:
      g[prevv[i]][preve[i]].cap -= d
      g[i][g[prevv[i]][preve[i]].rev].cap += d
  return res