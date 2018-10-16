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

proc lowlink*[E](g : Graph[E]) : seq[tuple[a : int , b : int]] =
  var 
    bridge : seq[tuple[a : int , b : int]] = @[]
    n = g.n
    used = newSeqWith(n , false)
    ord = newSeqWith(n , 0)
    low = newSeqWith(n , 0)
    dfs : proc(v , K , f : int) : int
  dfs = proc(v , K , f : int) : int =
    var k = K
    used[v] = true
    ord[v] = k
    low[v] = ord[v]
    inc(k)
    for e in g[v]:
      if not used[e.to]:
        k = dfs(e.to , k , v)
        low[v] = min(low[v] , low[e.to])
        if ord[v] < low[e.to]: bridge.add((min(v , e.to) , max(v , e.to)))
      elif e.to != f: low[v] = min(low[v] , ord[e.to])
    return k
  discard dfs(0,0,-1)
  return bridge