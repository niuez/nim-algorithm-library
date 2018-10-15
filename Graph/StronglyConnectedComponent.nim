import sequtils
type
  Edge* = object
    to : int
  Graph*[E] = object
    edges : seq[seq[Edge]]
    n : int

proc newGraph*[E](n : int) : Graph[E] =
  var g : Graph[E]
  g.edges = newSeqWith[seq[E]](n)
  g.n = n
  return g

proc `[]`*[E](g : var Graph[E] , k : int) : var seq[Edge] =
  return g.edges[k]

proc cssdfs[E](g : Graph[E] , v : int , vs : var seq[int] , vis : var seq[bool]) =
  vis[v] = true;
  for to in g[v]:
    if not vis[to]:
      g.cssdfs(to , vs , vis)
  vs.add(v)

proc cssrdfs[E](g : Graph[E] , v : int , k : int , res : var seq[int] , vis : var seq[bool]) =
  vis[v] = true
  res[v] = k
  for to in g[v]:
    if not vis[to]: g.cssrfds(to,k,res,vis)

proc stronglyConnectedComponect*[E](g : Graph[E]) : seq[int] =
  var rg = newGraph[E](g.n)
  for i in 0..<g.n:
    for e in g[i]:
      rg[e.to].add(Edge(to : i))
  var vis = newSeqWith(g.n , false)
  var vs : seq[int]
  
  for i in 0..<g.n:
    if not vis[i]: g.cssdfs(i,vs,vis)
  
  vis = newSeqWith(g.n,false)
  var res = newSeq[int](g.n)
  var k = 0
  for i in countdown(g.n - 1 , 0):
    if not vis[vs[i]]: 
      g.cssrdfs(vs[i],k,res,vis)
      inc(k)
  return res
  

