# EdmondsBlossom

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
## EdmondsBlossom

Edmonds Blossom Alogrithm for maximum matching of general graphs. takes O(N^3)
```nim
proc EdmondsBlossom*[E](g: Graph[E]): int
```
