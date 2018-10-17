# LowestCommonAncestor

## Edge

Edge Object , edit this to add more information like distance.
```nim
Edge* = object
  to: int

```
## Graph

Graph Object.
```nim
Graph*[E] = seq[seq[E]]
```
## newGraph

create n size new Graph.
```nim
proc newGraph*[E](n: int): Graph[E]
```
## size

size of Graph
```nim
proc size*[E](g: Graph[E]): int
```
## LowestCommonAncestor

LowestCommonAncestor Object depth of x is distance from x to root(default 0) 
```nim
LowestCommonAncestor* = object
  n: int
  log2_n: int
  parent: seq[seq[int]]
  depth*: seq[int]

```
## initLowestCommonAncestor

create LowestCommonAncestor instance. takes O(NlonN) for doubling
```nim
proc initLowestCommonAncestor*[E](g: Graph[E]; root = 0): LowestCommonAncestor
```
## getLowestCommonAncestor

get LCA. takes O(lonN)
```nim
proc getLowestCommonAncestor*(lca: LowestCommonAncestor; a: int; b: int): tuple[
    parent: int, depth: int]
```
## dist

get distance from a to b. takes O(logN)
```nim
proc dist*(lca: LowestCommonAncestor; a: int; b: int): int
```
