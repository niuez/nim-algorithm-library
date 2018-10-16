import sequtils,math
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


type LowestCommonAncestor = object
  n : int
  log2_n : int
  parent : seq[seq[int]]
  depth : seq[int]

proc initLowestCommonAncestor*[E](g : Graph[E]) : LowestCommonAncestor =
  var lca : LowestCommonAncestor
  lca.n = g.n
  lca.log2_n = ((int)log2((float)lca.n) + 2)
  lca.parent = newSeqWith(lca.log2_n , newSeqWith(lca.n,0))
  lca.depth = newSeqWith(lca.n , 0)
  var dfs : proc(v , f , d : int)
  dfs = proc(v,f,d : int) =
    lca.parent[0][v] = f
    lca.depth[v] = d
    for e in g[v]:
      if e.to != f: dfs(e.to , v , d + 1)
  dfs(0,-1,0)
  for k in 0..<lca.log2_n-1:
    for v in 0..<lca.n:
      if lca.parent[k][v] < 0: lca.parent[k + 1][v] = -1
      else: lca.parent[k + 1][v] = lca.parent[k][lca.parent[k][v]]
  return lca
proc getLowestCommonAncestor*(lca : LowestCommonAncestor,a : int , b : int) : tuple[parent : int , depth : int]=
  var
    u = a
    v = b
  if lca.depth[u] > lca.depth[v]: swap(u,v)
  for k in 0..<lca.log2_n:
    if (((lca.depth[v] - lca.depth[u]) shr k) and 1) == 1:
      v = lca.parent[k][v]
  if u == v: return (u , lca.depth[u])
  for k in countdown(lca.log2_n - 1 , 0):
    if lca.parent[k][u] != lca.parent[k][v]:
      u = lca.parent[k][u]
      v = lca.parent[k][v]
  u = lca.parent[0][u]
  return (u , lca.depth[u])


proc dist*(lca : LowestCommonAncestor , a : int , b : int) : int =
  return lca.depth[a] + lca.depth[b] - lca.getLowestCommonAncestor(a , b).depth * 2



