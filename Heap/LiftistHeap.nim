proc COMP*(x , y : int) : bool = return x < y
proc INF*(t : typedesc[int]) : int = return (int)(1e18)

type
  LiftistNode*[T] = ref object
    ## Node of Pairing Heap
    val* : T
    l : LiftistNode[T]
    r : LiftistNode[T]
  LiftistHeap*[T] = object
    root* : LiftistNode[T]

proc newLiftistNode*[T](val : T) : LiftistNode[T] =
  var n = new LiftistNode[T]
  n.val = val
  n.l = nil
  n.r = nil
  return n

proc newLiftistHeap*[T]() : LiftistHeap[T] = return LiftistHeap[T](root : nil)

proc merge[T](x , y : var LiftistNode[T]) : LiftistNode[T] =
  if x == nil: return y
  if y == nil: return x
  if not COMP(x.val , y.val): swap(x , y)
  x.r = merge(x.r , y)
  swap(x.l , x.r)
  return x

proc meld*[T](x , y : var LiftistHeap[T]) =
  x.root = merge(x.root , y.root)
  y.root = nil

proc push*[T](x : var LiftistHeap[T] , val  : T) =
  var n = newLiftistNode(val)
  x.root = merge(x.root , n)

proc value[T](x : LiftistNode[T]) : T =
  if x == nil: return T.INF
  return x.val

proc top*[T](x : LiftistHeap[T]) : T =
  return x.root.value

proc snd*[T](x : LiftistHeap[T]) : T =
  if x.root == nil: return T.INF
  if COMP(x.root.l.value, x.root.r.value): return x.root.l.value
  return x.root.r.value

proc pop*[T](x : var LiftistHeap[T]) =
  x.root = merge(x.root.l , x.root.r)

proc empty*[T](x : LiftistHeap[T]) : bool = return x.root == nil

