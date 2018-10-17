# SplayTreeMap

## SplayNode

Node for Splay Tree
```nim
SplayNode*[Key, T] = ref object
  left*: SplayNode[Key, T]
  right*: SplayNode[Key, T]
  parent*: SplayNode[Key, T]
  key*: Key
  value*: T
  size*: int

```
## SplayTree

Self-Balancing Binary Search Tree
```nim
SplayTree*[Key, T] = object
  root*: SplayNode[Key, T]
  comp*: proc (x: Key; y: Key): bool

```
## newSplayTree

Create new Splay Tree. O(1)
```nim
proc newSplayTree*[Key, T](comp: proc (x: Key; y: Key): bool): SplayTree[Key, T]
```
## splay

Splaying operation of node x. amortized O(logN)
```nim
proc splay*[Key, T](sp_tree: var SplayTree[Key, T]; x: var SplayNode[Key, T])
```
## find

if the node with the key exists, splay it and return true. else splay the last node and return false. amortized O(logN)
```nim
proc find*[Key, T](sp_tree: var SplayTree[Key, T]; key: Key): bool
```
## insert

insert the node with key and val. if find the node with the key, do nothing. amortized O(logN)
```nim
proc insert*[Key, T](sp_tree: var SplayTree[Key, T]; key: Key; val: T)
```
## erase

erase the node with the key. amortized O(logN)
```nim
proc erase*[Key, T](sp_tree: var SplayTree[Key, T]; key: Key): bool
```
## size

size of Splay Tree. O(1) 
```nim
proc size*[Key, T](sp_tree: SplayTree[Key, T]): int
```
## nth_node

return the nth node's key of key. if it doesn't exist, return nil. amortized O(logN)
```nim
proc nth_node*[Key, T](sp_tree: SplayTree[Key, T]; n: int): ref int
```
