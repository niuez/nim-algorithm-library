import sequtils , algorithm , queues

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

proc Karp_bfs[E](g : Graph[E] , A : int , used : var seq[bool] , match : seq[int]) : seq[int] =
  var
    dist = newSeqWith(A , -1)
    que = initQueue[int]()
  for i in 0..<A:
    if not used[i]:
      que.enqueue(i)
      dist[i] = 0
  while que.len > 0:
    var v = que.dequeue
    for e in g[v]:
      var m = match[e.to]
      if m >= 0 and dist[m] == -1:
        dist[m] = dist[v] + 1
        que.enqueue(m)
  return dist

proc Karp_dfs[E](g : Graph[E] , v : int , vis : var seq[bool] , match : var seq[int] , dist : var seq[int] , used : var seq[bool]) : bool =
  vis[v] = true
  for e in g[v]:
    var m = match[e.to]
    if m < 0 or ((not vis[m]) and dist[m] == dist[v] + 1 and g.Karp_dfs(m , vis, match, dist , used)):
      match[e.to] = v
      used[v] = true
      return true
  return false

proc HopcroftKarp*[E](g : Graph[E] , A : int , B : int) : seq[tuple[x : int , y : int]] =
  ## maximum bipartite matching. takes O(V ^ 1/2 * E)
  var
    n = g.size
    match = newSeqWith(n , -1)
    used = newSeqWith(n , false)
  while true:
    var
      dist = g.Karp_bfs(A,used,match)
      OK = true
      vis = newSeqWith(n , false)
    for i in 0..<A:
      if not used[i] and g.Karp_dfs(i , vis , match , dist , used):
        OK = false
    if OK: break
  var ans : seq[tuple[x : int , y : int]] = @[]
  for i in A..<B:
    if match[i] != -1: ans.add((match[i] , i))
  return ans

import algorithm, tables, sets, lists, queues, intsets, critbits, sequtils, strutils, math, future
 
var input : seq[string] = @[]
var in_cnt = 0
 
proc gs() : string =
  if input.len == in_cnt:
    in_cnt = 0
    input = stdin.readline.split
  in_cnt += 1
  return input[in_cnt - 1]
 
proc gi() : int =
  return gs().parseInt
proc gf() : float =
  return gs().parseFloat
 
var N = gi()
 
var
  a = newSeq[int](N)
  b = a
  c = a
  d = a
for i in 0..<N:
  a[i] = gi()
  b[i] = gi()
for i in 0..<N:
  c[i] = gi()
  d[i] = gi()
 
var g = newGraph[Edge](N * 2)
 
for i in 0..<N:
  for j in 0..<N:
    if a[i] < c[j] and b[i] < d[j]:
      g[i].add(Edge(to : j + N))

echo g.HopcroftKarp(N , N + N).len
