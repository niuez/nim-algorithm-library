import sequtils , algorithm , future , sets

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

proc getRoot(mu , phi : seq[int] , x , y : int) : int =
  var
    N = mu.len
    vis = newSeqWith(N , false)
    i = x
    j = y
  while i != mu[i]:
    vis[i] = true
    vis[mu[i]] = true
    i = phi[mu[i]]
  vis[i] = true
  while j != mu[j]:
    if vis[j]: return j
    if vis[mu[j]]: return mu[j]
    j = phi[mu[j]]
  if vis[j]: return j
  return -1

proc getSUM(mu,phi : seq[int] , x , y : int) : seq[bool] =
  var
    N = mu.len
    vis = newSeqWith(N , false)
    i = x
  while i != mu[i]:
    vis[i] = true
    vis[mu[i]] = true
    i = phi[mu[i]]
  vis[i] = true
  i = y
  while i != mu[i]:
    vis[i] = true
    vis[mu[i]] = true
    i = phi[mu[i]]
  vis[i] = true
  return vis

proc EdmondsBlossom*[E](g : Graph[E]) : seq[tuple[x : int , y : int]] =
  ## Edmonds Blossom Alogrithm for maximum matching of general graphs.
  ## takes O(N^3)
  var
    N = g.size
    mu = newSeq[int](N)
    phi = newSeq[int](N)
    rho = newSeq[int](N)
    scanned = newSeqWith(N , false)
  for i in 0..<N:
    mu[i] = i
    phi[i] = i
    rho[i] = i
  while true:
    var x = -1
    for i in 0..<N:
      if not scanned[i] and (mu[i] == i or phi[mu[i]] != mu[i]):
        x = i
        break
    if x == -1:
      break
    scanned[x] = true
    for e in g[x]:
      var y = e.to
      if not ((mu[y] != y and phi[mu[y]] == mu[y] and phi[y] == y) or (rho[x] != rho[y] and (mu[y] == y or phi[mu[y]] != mu[y]))):
        continue
      if mu[y] != y and phi[mu[y]] == mu[y] and phi[y] == y:
        discard "grow"
        phi[y] = x
      elif getRoot(mu,phi,x,y) == -1:
        discard "augment"
        var i = x
        var ss = newSeq[int]()
        while i != mu[i]:
          var v = mu[i]
          ss.add(v)
          i = phi[mu[i]]
        i = y
        while i != mu[i]:
          var v = mu[i]
          ss.add(v)
          i = phi[mu[i]]
        reverse(ss)
        for v in ss:
          mu[phi[v]] = v
          mu[v] = phi[v]
        mu[x] = y
        mu[y] = x
        for j in 0..<N:
          phi[j] = j
          rho[j] = j
          scanned[j] = false
        break
      else:
        var
          r = getRoot(mu , phi , x , y)
          v = x
          now = false
        while v != r:
          if now:
            if rho[phi[v]] != r:
              phi[phi[v]] = v
            v = phi[v]
          else:
            v = mu[v]
          now = now xor true
        v = y
        while v != r:
          if now:
            if rho[phi[v]] != r:
              phi[phi[v]] = v
            v = phi[v]
          else:
            v = mu[v]
          now = now xor true
        if rho[x] != r: rho[x] = y
        if rho[y] != r: rho[y] = x
        var vis = getSUM(mu,phi,x,y)
        for i in 0..<N:
          if vis[rho[i]]: rho[i] = r
  var ans = newSeq[tuple[x : int , y : int]]()
  for i in 0..<N:
    if i < mu[i]:
      ans.add((i , mu[i]))
  return ans

import strutils
 
var
  temp = stdin.readline.split.map(parseInt)
  r = temp[0]
  c = temp[1]
  g = newGraph[Edge](r * c)
  C = newSeq[string](r)
  dx = @[1,-1,0,0]
  dy = @[0,0,1,-1]
  cnt = 0
for cc in C.mitems:
  cc = stdin.readline
  cnt += cc.count('.')
 
 
for i in 0..<r:
  for j in 0..<c:
    if ((i + j) and 1) == 1 or C[i][j] == '*': continue
    for di in 0..<4:
      var
        nx = i + dx[di]
        ny = j + dy[di]
      if 0 <= nx and nx < r and 0 <= ny and ny < c and C[nx][ny] == '.':
        g[i * c + j].add(Edge(to : nx * c + ny))
        g[nx * c + ny].add(Edge(to : i * c + j))
 
echo cnt - g.EdmondsBlossom().len
