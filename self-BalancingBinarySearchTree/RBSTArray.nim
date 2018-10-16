var seed = 91'u64
var mask = 0xFFFFFFFFFFFFFFFF'u64

proc xorshift() : uint64 =
  seed = seed xor ((seed shl 13) and mask)
  seed = seed xor (seed shr 7)
  seed = seed xor ((seed shl 17) and mask)
  return seed

proc IDE*(T : typedesc[int]) : int = return 10101010
proc OPE*(a : int , b : int) : int = min(a , b)

type
  RBSTNode[T] = ref object
    left,right : RBSTNode[T]
    val : T
    sz : int
    ss : T
  RBSTArray*[T] = object
    ## RBSTArray Object
    root* : RBSTNode[T]

proc newRBSTNode[T](val : T) : RBSTNode[T] = 
  var node = new RBSTNode[T]
  node.val = val
  node.left = nil
  node.right = nil
  node.sz = 1
  node.ss = val
  return node

proc newRBSTArray*[T]() : RBSTArray[T] =
  ## create new RBSTArray.
  var tree : RBSTArray[T]
  tree.root = nil
  return tree

proc size[T](node : RBSTNode[T]) : int =
  if node == nil: return 0
  return node.sz

proc sum[T](node : RBSTNode[T]) : T =
  if node == nil: 
    return IDE(T)
  return node.ss

proc fix[T](node : var RBSTNode[T]) : RBSTNode[T] =
  if node == nil : return nil
  node.sz = 1 + node.left.size + node.right.size
  node.ss = OPE(OPE(node.left.sum , node.val) , node.right.sum)
  return node

proc merge[T](l : var RBSTNode[T] , r : var RBSTNode[T]) : RBSTNode[T] =
  if l == nil : return r
  if r == nil : return l
  discard fix(l)
  discard fix(r)
  if xorshift() mod (uint64)(l.size + r.size) < (uint64)l.size:
    l.right = merge(l.right , r)
    return fix(l)
  else:
    r.left = merge(l , r.left)
    return fix(r)

proc split[T](node : var RBSTNode[T] , k : int) : tuple[l : RBSTNode[T],r : RBSTNode[T]] =
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

proc insert*[T](tree : var RBSTArray[T] , k : int , val : T) =
  ## insert val at k. takes O(logN)
  var s = split(tree.root , k)
  var z = newRBSTNode(val)
  tree.root = merge(s.l , z)
  tree.root = merge(tree.root , s.r)
  discard fix(tree.root)

proc erase*[T](tree : var RBSTArray[T] , k : int) =
  ## erase node at k. takes O(logN)
  var t = split(tree.root , k + 1)
  var s = split(t.l , k)
  tree.root = merge(s.l , t.r)
  discard fix(tree.root)
  
proc merge*[T](tree1 : var RBSTArray[T] , tree2 : var RBSTArray[T]) =
  ## merge array. takes O(logN)
  tree1.root = merge(tree1.root , tree2.root)
  tree2.root = nil

proc split*[T](tree1 : var RBSTArray[T] , k : int) : tuple[left : RBSTArray[T] , right : RBSTArray[T]] =
  ## split array to [0..k-1] and [k..N - 1]. takes O(logN)
  var s = tree1.root.split(k)
  var left = newRBSTArray[T]() 
  var right = newRBSTArray[T]()
  left.root = s.l
  right.root = s.r
  tree1.root = nil
  return (left,right)

proc find[T](tree : RBSTArray[T] , k : int) : RBSTNode[T] =
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

proc at*[T](tree : RBSTArray[T], k : int) : T =
  ## node at k of array. takes O(logN)
  return tree.find(k).val

proc update[T](node : var RBSTNode[T] , k : int , val : T) =
  if node == nil: return
  if node.left.size == k:
    node.val = val
  elif node.left.size < k:
    update(node.right , k - node.left.size - 1 , val)
  else:
    update(node.left , k , val)
  discard fix(node)

proc set*[T](tree : var RBSTArray[T] , k : int , val : T) =
  ## update value at k to val. takes O(logN)
  update(tree.root , k , val)

proc query[T](node : var RBSTNode[T] , left , right : int) : T = 
  if node == nil: return IDE(T)
  var l = max(left , 0)
  var r = min(right , node.size)
  if l >= r: return IDE(T)
  if l == 0 and r == node.size: return node.sum
  var sz = node.left.size
  var res = IDE(T)
  if l <= sz and sz < r: res = node.val
  return OPE(OPE(query(node.left , l , r) , res) , query(node.right , l - sz - 1 , r - sz - 1))

proc fold*[T](tree : var RBSTArray[T] , left , right : int) : T =
  ## fold interval. takes O(logN)
  return query(tree.root , left , right)

# verify http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=1508

import algorithm
import strutils
import sequtils

var arr : RBSTArray[int] = newRBSTArray[int]()

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
