# StronglyConnectedComponent

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
## stronglyConnectedComponect

get group number of each vertex. takesO(logN)
```nim
proc stronglyConnectedComponect*[E](g: Graph[E]): seq[int]
```
