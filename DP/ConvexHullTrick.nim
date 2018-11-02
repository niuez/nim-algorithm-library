import sequtils

proc IDE(T : typedesc[int]) : int = return int(-1e18)

type
  CHTLine[T] = ref object
    a : T
    b : T
    left : CHTLine[T]
    right : CHTLine[T]
  ConvexHullTrick*[T] = object
    ## object for Convex Hull Trick 
    MIN : T
    MAX : T
    root : CHTLine[T]

proc newCHTLine[T](a : T , b : T) : CHTLine[T] =
  var line = new CHTLine[T]
  line.a = a
  line.b = b
  line.left = nil
  line.right = nil
  return line

proc get[T](line : CHTLine[T] , x : T) : T  = return line.a * x + line.b

proc initConvexHullTrick*[T](mi , ma : T) : ConvexHullTrick[T] =
  ## create Convex Hull Trick Object. [mi , ma] is the defined range of line.
  return ConvexHullTrick[T](MIN : mi , MAX : ma , root : nil)

proc insert[T](p : var CHTLine[T] , l , r : T , line : var CHTLine[T]) : CHTLine[T] =
  if p == nil:
    return line
  if p.get(l) >= line.get(l) and p.get(r) >= line.get(r):
    return p
  if p.get(l) <= line.get(l) and p.get(r) <= line.get(r):
    p.a = line.a
    p.b = line.b
    return p
  var mid = T((l + r) / 2)
  if p.get(mid) < line.get(mid):
    swap(p.a , line.a)
    swap(p.b , line.b)
  if p.get(l) <= line.get(l):
    p.left = insert(p.left , l , mid , line)
  else:
    p.right = insert(p.right , mid , r , line)
  return p

proc get[T](p : CHTLine[T] , l , r , t : T) : T =
  if p == nil: return T.IDE
  var mid = T((l + r) / 2)
  if t <= mid: return max(p.get(t) , get(p.left , l , mid , t))
  else: return max(p.get(t) , get(p.right , mid , r , t))

proc add*[T](cht : var ConvexHullTrick[T] , a , b : T) =
  ## add line to cht. takes O(logN)
  var line = newCHTLine(a , b)
  cht.root = cht.root.insert(cht.MIN , cht.MAX , line)

proc get_max*[T](cht : ConvexHullTrick[T] , x : T) : T =
  ## get max value of lines. `max[i](l_i(x))`. takes O(logN)
  return cht.root.get(cht.MIN , cht.MAX , x)

import strutils


var
  N = stdin.readline.parseInt
  a = stdin.readline.split.map(parseInt)
  cht = initConvexHullTrick[int](0, N)

for i in 0..<N:
  cht.add(2 * i , - (a[i] + i * i))

for i in 0..<N:
  echo int(-cht.get_max(i) + i * i)

