
type pii = tuple[cost : int , idx : int]

proc COMP*(x , y : int) : bool = return x < y
proc COMP*(x , y : pii) : bool = return x.cost < y.cost
proc INF*(t : typedesc[int]) : int = return (int)(1e18)
proc INF*(t : typedesc[pii]) : pii = return (int.INF , -1)

type
  LiftistNode*[T] = ref object
    ## Node of Liftist Heap
    val* : T
    l : LiftistNode[T]
    r : LiftistNode[T]
  LiftistHeap*[T] = object
    ## Liftist Heap Object
    root* : LiftistNode[T]

proc newLiftistNode[T](val : T) : LiftistNode[T] =
  var n = new LiftistNode[T]
  n.val = val
  n.l = nil
  n.r = nil
  return n

proc newLiftistHeap*[T]() : LiftistHeap[T] = return LiftistHeap[T](root : nil) ## create new Liftist Heap Object

proc merge[T](x , y : var LiftistNode[T]) : LiftistNode[T] =
  if x == nil: return y
  if y == nil: return x
  if not COMP(x.val , y.val): swap(x , y)
  x.r = merge(x.r , y)
  swap(x.l , x.r)
  return x

proc value[T](x : LiftistNode[T]) : T =
  if x == nil: return T.INF
  return x.val

proc meld*[T](x , y : var LiftistHeap[T]) =
  ## y Liftist Heap merge to x. amortized O(logN)
  x.root = merge(x.root , y.root)
  y.root = nil

proc push*[T](x : var LiftistHeap[T] , val  : T) =
  ## the new Node that has value val push to x. amortized O(logN)
  var n = newLiftistNode(val)
  x.root = merge(x.root , n)


proc top*[T](x : LiftistHeap[T]) : T =
  ## the top value of Liftist Heap. takes O(1)
  return x.root.value

proc snd*[T](x : LiftistHeap[T]) : T =
  ## the second value of Liftist Heap. takes O(1)
  if x.root == nil: return T.INF
  if COMP(x.root.l.value, x.root.r.value): return x.root.l.value
  return x.root.r.value

proc pop*[T](x : var LiftistHeap[T]) =
  ## remove the top value of Liftist Heap. amortized O(logN)
  x.root = merge(x.root.l , x.root.r)

proc empty*[T](x : LiftistHeap[T]) : bool = return x.root == nil ## if the Liftist Heap is empty, return true. takes O(1)

import sequtils

proc hu_tucker*(w : seq[int] , N : int) : int =
  ## Hu-Tucker Algorithm. takes O(NlogN)
  ## this algorithm calc minimum sum[0..N-1](w[i] * depth[i]) on binary tree.
  var que = newLiftistHeap[pii]()
  var hpq = newSeqWith(N , newLiftistHeap[int]())
  var rig = newSeqWith(N , 0)
  var lef = newSeqWith(N , 0)
  var cst = newSeqWith(N , 0)
  var A = w
  A.add(0)
  for i in 0..<N-1:
    rig[i] = i + 1
    lef[i] = i - 1
    cst[i] = w[i] + w[i + 1]
    que.push((cst[i] , i))
  var res = 0
  for k in 0..<N:
    var
      c : int
      i : int
    while true:
      c = que.top.cost
      i = que.top.idx
      echo c , " " , i
      que.pop
      if rig[i] == -1 or cst[i] != c: continue
      break
    var
      ml = false
      mr = false
    if w[i] + hpq[i].top == c:
      hpq[i].pop
      ml = true
    elif w[i] + w[rig[i]] == c:
      ml = true
      mr = true
    elif hpq[i].top + hpq[i].snd == c:
      hpq[i].pop
      hpq[i].pop
    else:
      hpq[i].pop
      mr = true
    res += c
    hpq[i].push(c)
    
    if ml: A[i] = int.INF
    if mr: A[rig[i]] = int.INF

    if ml and i > 0:
      var j = lef[i]
      hpq[j].meld(hpq[i])
      rig[j] = rig[i]
      rig[i] = -1
      lef[rig[j]] = j
      i = j
    if mr and rig[i] + 1 < N:
      var j = rig[i]
      hpq[i].meld(hpq[j])
      rig[i] = rig[j]
      rig[j] = -1
      lef[rig[i]] = i
    cst[i] = A[i] + A[rig[i]]
    cst[i] = min(cst[i] , min(A[i] , A[rig[i]]) + hpq[i].top)
    cst[i] = min(cst[i] , hpq[i].top + hpq[i].snd)
    que.push((cst[i] , i))
  return res

import strutils

var N = stdin.readline.parseInt
var w = stdin.readline.split.map(parseInt)

echo hu_tucker(w , N)
