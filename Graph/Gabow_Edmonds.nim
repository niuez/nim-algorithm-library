import sequtils , queues
type
  Edge* = object
    ## Edge Object , edit this to add more information like distance.
    to : int
  GEEdge = object
    to : int
    num : int
  Graph*[E] = seq[seq[E]]
    ## Graph Object.
  Edm = object
    mate : seq[int]
    label : seq[int]
    first : seq[int]
    g : Graph[GEEdge]
    edges : seq[tuple[x : int , y : int]]

proc newGraph*[E](n : int) : Graph[E] =
  ## create n size new Graph.
  var g : Graph[E] = newSeqWith(n , newSeq[E](0))
  return g

proc size*[E](g : Graph[E]) : int =
  ## size of Graph
  return g.len

proc initGE[E](g : Graph[E]) : Edm =
  var edm : Edm
  edm.mate = newSeqWith(g.size + 1 , 0)
  edm.label = newSeqWith(g.size + 1, -1)
  edm.first = newSeqWith(g.size + 1,0)
  edm.g = newGraph[GEEdge](g.size + 1)
  edm.edges = @[]
  var cnt = g.size + 1 
  for i in 0..<g.size:
    for e in g[i]:
      edm.g[i + 1].add(GEEdge(to : e.to + 1 , num: cnt))
      edm.edges.add((i + 1 , e.to + 1))
      #echo cnt , "=" , edm.edges[cnt - edm.g.size]
      inc(cnt)
  return edm

proc eval_first(edm : var Edm , x : int) : int =
  if edm.label[edm.first[x]] < 0:
    # nonouter
    return edm.first[x]
  else:
    # outer -> next
    edm.first[x] = eval_first(edm , edm.first[x])
    return edm.first[x]

proc rematch(edm : var Edm ; v , w : int) =
  #echo "R " , v , " " , w
  var t = edm.mate[v]
  edm.mate[v] = w
  if edm.mate[t] != v: return
  if edm.label[v] < edm.g.size:
    #echo v , "-> " ,edm.label[v]
    edm.mate[t] = edm.label[v]
    rematch(edm,edm.label[v] , t)
  else:
    var (x , y) = edm.edges[edm.label[v] - edm.g.size]
    #echo edm.label[v] , " " , (x , y)
    rematch(edm , x , y)
    rematch(edm , y , x)
  return

proc assignLabel(edm : var Edm ; x , y , num : int) =
  #echo "L " , x , " " , y
  # L0
  var
    r = edm.eval_first(x)
    s = edm.eval_first(y)
    join = 0
  if r == s: return
  edm.label[r] = -num
  edm.label[s] = -num
  while true:
    # L1
    if s != 0: swap(r , s)
    # L2
    r = edm.eval_first(edm.label[edm.mate[r]])
    if edm.label[r] == -num: 
      join = r
      break
    edm.label[r] = -num
  # L3 L4
  var v = edm.first[x]
  while v != join:
    edm.label[v] = num
    edm.first[v] = join
    v = edm.first[edm.label[edm.mate[v]]]
  v = edm.first[y]
  while v != join:
    edm.label[v] = num
    edm.first[v] = join
    v = edm.first[edm.label[edm.mate[v]]]
  # L5
  return

proc augument_check(edm : var Edm , u : int) : bool =
  #echo "start " , u
  edm.first[u] = 0
  edm.label[u] = 0
  var que = initQueue[int]()
  que.enqueue(u)
  while que.len > 0:
    var x = que.dequeue
    # E3
    for e in edm.g[x]:
      var y = e.to
      # E4
      if edm.mate[y] == 0 and y != u:
        edm.mate[y] = x
        #echo "rematch" , (x , y)
        rematch(edm , x , y)
        return true
      # E5
      elif edm.label[y] >= 0:
        assignLabel(edm , x , y ,e.num)
      # E6
      elif edm.label[edm.mate[y]] < 0:
        edm.label[edm.mate[y]] = x
        edm.first[edm.mate[y]] = y
        que.enqueue(edm.mate[y])
  return false


proc GabowEdmonds*[E](g : Graph[E]) : seq[tuple[x : int , y : int]] =
  ## unweighted maximum matching of general graphs. takes O(VElogV)
  # E0
  var edm = g.initGE()
  var N = g.size

  # E1
  for i in 1..N:
    if edm.mate[i] != 0: continue
    if augument_check(edm , i):
      # E7
      edm.label[0] = -1
      edm.label.fill(-1)
  var ans : seq[tuple[x : int , y : int]] = @[]
  for i in 1..N:
    if i < edm.mate[i]:
      ans.add((i , edm.mate[i]))
  return ans

# verify

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
      g[j + N].add(Edge(to : i))
      g[i].add(Edge(to : j + N))
      
echo g.GabowEdmonds().len
