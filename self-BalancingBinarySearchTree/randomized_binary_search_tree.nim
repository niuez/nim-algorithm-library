import random

var rbstRand = initRand(10101010)

type
  RBSTNode[T] = ref object
    left,right : RBSTNode[T]
    val : T
    sz : int
  RBSTArray[T] = object
    root* : RBSTNode[T]

proc newRBSTNode[T](val : T) : RBSTNode[T] = 
  var node = new RBSTNode[T]
  node.val = val
  node.left = nil
  node.right = nil
  node.sz = 1
  return node

proc newRBSTArray*[T]() : RBSTArray[T] = 
  var tree : RBSTArray[T]
  tree.root = nil
  return tree

proc node_size[T](node : RBSTNode[T]) : int =
  if node == nil: return 0
  return node.sz

proc node_update[T](node : var RBSTNode[T]) : RBSTNode[T] =
  if node == nil : return nil
  node.sz = 1 + node.left.node_size + node.right.node_size
  return node


proc merge*[T](l : var RBSTNode[T] , r : var RBSTNode[T]) : RBSTNode[T] =
  if l == nil : return r
  if r == nil : return l
  if rand(rbstRand,l.node_size + r.node_size - 1) < l.node_size:
    l.right = merge(l.right , r)
    return node_update(l)
  else:
    r.left = merge(l , r.left)
    return node_update(r)

proc split*[T](node : var RBSTNode[T] , k : int) : tuple[l : RBSTNode[T],r : RBSTNode[T]] =
  if node == nil: return (nil,nil)

  if k <= node.left.node_size:
    var s = split(node.left , k)
    node.left = s.r
    return (s.l , node_update(node))
  else:
    var s = split(node.right , k - node.left.node_size - 1)
    node.right = s.l
    return (node_update(node) , s.r)

proc insert*[T](tree : var RBSTArray[T] , k : int , val : T) =
  var s = split(tree.root , k)
  var z = newRBSTNode(val)
  tree.root = merge(s.l , z)
  tree.root = merge(tree.root , s.r)
  discard node_update(tree.root)

proc erase*[T](tree : var RBSTArray[T] , k : int) =
  var t = split(tree.root , k + 1)
  var s = split(t.l , k)
  tree.root = merge(s.l , t.r)
  node_update(tree.root)
  
proc merge*[T](tree1 : var RBSTArray[T] , tree2 : var RBSTArray[T]) =
  tree1.root = merge(tree1.root , tree2.root)
  tree2.root = nil

proc split*[T](tree1 : var RBSTArray[T] , k : int) : tuple[left : RBSTArray[T] , right : RBSTArray[T]] =
  var s = tree1.root.split(k)
  var left = newRBSTArray[T]() 
  var right = newRBSTArray[T]()
  left.root = s.l
  right.root = s.r
  return (left,right)

proc find[T](tree : RBSTArray[T] , k : int) : RBSTNode[T] =
  var n = k
  var now = tree.root
  while now != nil :
    if now.left.node_size == n:
      return now
    if now.left.node_size < n:
      n -= now.left.node_size + 1
      now = now.right
    else:
      now = now.left
  return now

proc at*[T](tree : RBSTArray[T], k : int) : var T =
  return tree.find(k).val
