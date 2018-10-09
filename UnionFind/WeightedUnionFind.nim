import sequtils
type
  WeightedUnionFind = object
    par : seq[int]
    rank : seq[int]
    val : seq[int64]

proc newWeightedUnionFind*(n : int) : WeightedUnionFind =
  var uf : WeightedUnionFind
  uf.par = newSeq[int](n)
  for i in 0..<n:
    uf.par[i] = i
  uf.rank = newSeqWith(n , 0)
  uf.val = newSeq[int64](n)
  return uf

proc root*(uf : var WeightedUnionFind, x : int) : int =
  if uf.par[x] == x:
    return x
  var parent = uf.root(uf.par[x])
  uf.val[x] += uf.val[uf.par[x]]
  uf.par[x] = parent
  return uf.par[x]

proc weight*(uf : var WeightedUnionFind , x : int) : int64 =
  discard uf.root(x)
  return uf.val[x]

proc unite*(uf : var WeightedUnionFind , x , y : int , wei : int64) : tuple[par : int,chi : int] =
  ## |x->y| = w
  var a = uf.root(x)
  var b = uf.root(y)
  var w = wei + uf.weight(x) - uf.weight(y)
  if a == b:
    return (-1,-1)
  var r,c : int
  if uf.rank[a] < uf.rank[b]:
    uf.par[a] = b
    r = b
    c = a
    w = -w
  else:
    uf.par[b] = a
    r = a
    c = b
    if uf.rank[a] == uf.rank[b]: uf.rank[a] += 1
  uf.val[c] = w
  return (r , c)

proc same*(uf : var WeightedUnionFind , x , y : int) : bool =
  return uf.root(x) == uf.root(y)

proc diff(uf : var WeightedUnionFind , x , y : int) : tuple[issame : bool , weight : int64] =
  ## |x->y|
  if not uf.same(x , y):
    return (false , 0'i64)
  return (true , uf.weight(y) - uf.weight(x))

#verify arc080 d

import algorithm
import strutils

var temp = stdin.readline.split.map(parseInt)
var 
  N = temp[0]
  M = temp[1]

var uf = newWeightedUnionFind(N)
for i in 1..M:
  temp = stdin.readline.split.map(parseInt)
  var
    L = temp[0]
    R = temp[1]
    D = temp[2]
  dec(L)
  dec(R)
  var p = uf.diff(R,L)
  if p.issame and p.weight != D:
    echo "No"
    quit(0)
  discard uf.unite(L , R , D)
echo "Yes"

