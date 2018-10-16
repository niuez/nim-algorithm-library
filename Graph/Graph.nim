import sequtils
type
  Edge* = object
    ## Edge Object , edit this to add more information like distance.
    to : int
  Graph*[E] = seq[seq[E]]
    ## Graph Object.

proc newGraph*[E](n : int) : Graph[E] =
  ## create n size new Graph.
  var g : Graph[E] = newSeqWith(n , newSeq[E](0))
  return g

proc size*[E](g : Graph[E]) : int =
  ## size of Graph
  return g.len