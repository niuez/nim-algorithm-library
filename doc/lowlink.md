# lowlink

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
## lowlink

get bridges of graph.takes O(N)
```nim
proc lowlink*[E](g: Graph[E]): seq[tuple[a: int, b: int]]
```
