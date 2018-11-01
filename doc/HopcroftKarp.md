# HopcroftKarp

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
## HopcroftKarp

maximum bipartite matching. takes O(V ^ 1/2 * E)
```nim
proc HopcroftKarp*[E](g: Graph[E]; A: int; B: int): seq[tuple[x: int, y: int]]
```
