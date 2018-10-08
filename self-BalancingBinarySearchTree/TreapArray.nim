var seed = 314159'u64
var mask = 0xFFFFFFFFFFFFFFFF'u64

proc xorshift() : uint64 =
  seed = seed xor ((seed shl 13) and mask)
  seed = seed xor (seed shr 7)
  seed = seed xor ((seed shl 17) and mask)
  return seed

proc IDE*(T : typedesc[int]) : int = return 10101010
proc OPE*(T : typedesc[int] , a : T , b : T) : T = min(a , b)

type
  TreapNode[T] = ref object
    left,right : TreapNode[T]
    val : T
    sz : int
    ss : T
    pri : uint64
  TreapArray[T] = object
    root* : TreapNode[T]

proc newTreapNode[T](val : T) : TreapNode[T] = 
  var node = new TreapNode[T]
  node.val = val
  node.left = nil
  node.right = nil
  node.sz = 1
  node.ss = val
  node.pri = xorshift()
  return node

proc newTreapArray*[T]() : TreapArray[T] = 
  var tree : TreapArray[T]
  tree.root = nil
  return tree

proc size[T](node : TreapNode[T]) : int =
  if node == nil: return 0
  return node.sz

proc sum[T](node : TreapNode[T]) : T =
  if node == nil: 
    return IDE(T)
  return node.ss

proc fix[T](node : var TreapNode[T]) : TreapNode[T] =
  if node == nil : return nil
  node.sz = 1 + node.left.size + node.right.size
  node.ss = OPE(T , OPE(T , node.left.sum , node.val) , node.right.sum)
  return node

proc merge*[T](l : var TreapNode[T] , r : var TreapNode[T]) : TreapNode[T] =
  if l == nil : return r
  if r == nil : return l
  discard fix(l)
  discard fix(r)
  if l.pri > r.pri:
    l.right = merge(l.right , r)
    return fix(l)
  else:
    r.left = merge(l , r.left)
    return fix(r)

proc split*[T](node : var TreapNode[T] , k : int) : tuple[l : TreapNode[T],r : TreapNode[T]] =
  if node == nil: return (nil,nil)
  discard fix(node)
  if k <= node.left.size:
    var s = split(node.left , k)
    node.left = s.r
    return (s.l , fix(node))
  else:
    var s = split(node.right , k - node.left.size - 1)
    node.right = s.l
    return (fix(node) , s.r)

proc insert*[T](tree : var TreapArray[T] , k : int , val : T) =
  var s = split(tree.root , k)
  var z = newTreapNode(val)
  tree.root = merge(s.l , z)
  tree.root = merge(tree.root , s.r)
  discard fix(tree.root)

proc erase*[T](tree : var TreapArray[T] , k : int) =
  var t = split(tree.root , k + 1)
  var s = split(t.l , k)
  tree.root = merge(s.l , t.r)
  discard fix(tree.root)
  
proc merge*[T](tree1 : var TreapArray[T] , tree2 : var TreapArray[T]) =
  tree1.root = merge(tree1.root , tree2.root)
  tree2.root = nil

proc split*[T](tree1 : var TreapArray[T] , k : int) : tuple[left : TreapArray[T] , right : TreapArray[T]] =
  var s = tree1.root.split(k)
  var left = newTreapArray[T]() 
  var right = newTreapArray[T]()
  left.root = s.l
  right.root = s.r
  tree1.root = nil
  return (left,right)

proc find[T](tree : TreapArray[T] , k : int) : TreapNode[T] =
  var n = k
  var now = tree.root
  while now != nil :
    if now.left.size == n:
      return now
    if now.left.size < n:
      n -= now.left.size + 1
      now = now.right
    else:
      now = now.left
  return now

proc at*[T](tree : TreapArray[T], k : int) : T =
  return tree.find(k).val

proc update*[T](node : var TreapNode[T] , k : int , val : T) =
  if node == nil: return
  if node.left.size == k:
    node.val = val
  elif node.left.size < k:
    update(node.right , k - node.left.size - 1 , val)
  else:
    update(node.left , k , val)
  discard fix(node)

proc set*[T](tree : var TreapArray[T] , k : int , val : T) =
  update(tree.root , k , val)

proc query*[T](node : var TreapNode[T] , left , right : int) : T = 
  if node == nil: return IDE(T)
  var l = max(left , 0)
  var r = min(right , node.size)
  if l >= r: return IDE(T)
  if l == 0 and r == node.size: return node.sum
  var sz = node.left.size
  var res = IDE(T)
  if l <= sz and sz < r: res = node.val
  return OPE(T , OPE(T,query(node.left , l , r) , res) , query(node.right , l - sz - 1 , r - sz - 1))

proc fold*[T](tree : var TreapArray[T] , left , right : int) : T = 
  return query(tree.root , left , right)

# verify http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=1508

import algorithm
import strutils
import sequtils

var arr : TreapArray[int] = newTreapArray[int]()

var temp = stdin.readline.split.map(parseInt)

var n = temp[0]
var q = temp[1]


var a : array[202020,int]
for i in 0..<n:
  a[i] = stdin.readline.parseInt
  arr.insert(i,a[i])

for i in 0..<q:
  var A = stdin.readline.split.map(parseInt)
  var x = A[0]
  var y = A[1]
  var z = A[2]
  if x == 0:
    var s = arr.split(y)
    var t = s.right.split(z + 1 - y)
    var sz = t.left.root.size
    var u = t.left.split(sz - 1)
    u.right.merge(u.left)
    s.left.merge(u.right)
    s.left.merge(t.right)
    arr = s.left
  if x == 1:
    echo arr.fold(y , z + 1)
  if x == 2:
    arr.set(y,z)
