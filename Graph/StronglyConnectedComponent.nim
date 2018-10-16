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
  var rg = newGraph[E](g.size)
  for i in 0..<g.size:
    for e in g[i]:
      rg[e.to].add(Edge(to : i))
  var vis = newSeqWith(g.size , false)
  var vs : seq[int]
  
  for i in 0..<g.size:
    if not vis[i]: g.cssdfs(i,vs,vis)
  
  vis = newSeqWith(g.size,false)
  var res = newSeq[int](g.size)
  var k = 0
  for i in countdown(g.size - 1 , 0):
    if not vis[vs[i]]: 
      g.cssrdfs(vs[i],k,res,vis)
      inc(k)
  return res
  

