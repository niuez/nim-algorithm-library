# Dinic

## DinicEdge

Edge Object , edit this to add more information like distance.
```nim
DinicEdge* = object
  to: int
  cap: int
  rev: int

```
## Graph


```nim
Graph*[E] = seq[seq[E]]
```
## Dinic

Graph Object.
```nim
Dinic* = Graph[DinicEdge]
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
## max_flow

get max_flow of g. taks O(V^2 E)
```nim
proc max_flow*(g: var Dinic; s, t: int): int
```
