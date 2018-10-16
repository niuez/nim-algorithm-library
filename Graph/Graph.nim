import sequtils
type
  Edge* = object
    to : int
  Graph*[E] = seq[seq[E]]

proc newGraph*[E](n : int) : Graph[E] =
  var g : Graph[E] = newSeqWith(n , newSeq[E](0))
  return g

proc size*[E](g : Graph[E]) : int =
  return g.len