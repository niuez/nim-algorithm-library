import random

var rbstRand = initRand(10101010)

proc IDE*(T : typedesc[bool]) : bool = return false
proc OPE*(T : typedesc[bool]) : proc(a , b : bool) : bool = return proc (a , b : bool) : bool = a or b


type
  RBSTNode[T] = ref object
    left,right : RBSTNode[T]
    val : T
    sz : int
    ss : T
  RBSTArray[T] = object
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
  node.ss = OPE(T)(OPE(T)(node.left.sum , node.ss) , node.right.sum)
  return node

proc merge*[T](l : var RBSTNode[T] , r : var RBSTNode[T]) : RBSTNode[T] =
  if l == nil : return r
  if r == nil : return l
  discard fix(l)
  discard fix(r)
  if rand(rbstRand,l.size + r.size - 1) < l.size:
    l.right = merge(l.right , r)
    return fix(l)
  else:
    r.left = merge(l , r.left)
    return fix(r)

proc split*[T](node : var RBSTNode[T] , k : int) : tuple[l : RBSTNode[T],r : RBSTNode[T]] =
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
  var s = split(tree.root , k)
  var z = newRBSTNode(val)
  tree.root = merge(s.l , z)
  tree.root = merge(tree.root , s.r)
  discard fix(tree.root)

proc erase*[T](tree : var RBSTArray[T] , k : int) =
  var t = split(tree.root , k + 1)
  var s = split(t.l , k)
  tree.root = merge(s.l , t.r)
  discard fix(tree.root)
  
proc merge*[T](tree1 : var RBSTArray[T] , tree2 : var RBSTArray[T]) =
  tree1.root = merge(tree1.root , tree2.root)
  tree2.root = nil

proc split*[T](tree1 : var RBSTArray[T] , k : int) : tuple[left : RBSTArray[T] , right : RBSTArray[T]] =
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
  return tree.find(k).val

proc update*[T](node : var RBSTNode[T] , k : int , val : T) =
  if node == nil: return
  if node.left.size == k:
    node.val = val
  elif node.left.size < k:
    update(node.right , k - node.left,size - 1)
  else:
    update(node.left , k)
  discard fix(node)

proc set*[T](tree : var RBSTArray[T] , k : int , val : T) =
  update(tree.root , k , val)
