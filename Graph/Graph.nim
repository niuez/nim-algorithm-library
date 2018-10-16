import sequtils
type
  Edge* = object
    to : int
  Graph*[E] = object
    edges : seq[seq[Edge]]
    n : int

proc newGraph*[E](n : int) : Graph[E] =
  var g : Graph[E]
  g.edges = newSeqWith(n , newSeq[E](0))
  g.n = n
  return g

proc `[]`*[E](g : var Graph[E] , k : int) : var seq[Edge] =
  return g.edges[k]

proc `[]`*[E](g : Graph[E] , k : int) : seq[Edge] =
  return g.edges[k]
