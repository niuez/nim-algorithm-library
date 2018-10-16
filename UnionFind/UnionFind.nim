import sequtils
type
  UnionFind[T]= object
    ## UnionFind Object.
    par : seq[int]
    rank : seq[int]

proc newUnionFind*[T](n : int) : UnionFind[T] =
  ## create new UnionFind Object.
  var uf : UnionFind[T]
  uf.par = newSeq[int](n)
  for i in 0..<n:
    uf.par[i] = i
  uf.rank = newSeqWith(n , 0)
  return uf

proc root*[T](uf : var UnionFind[T], x : int) : int =
  ## root of x. amortized a(N)
  if uf.par[x] == x:
    return x
  uf.par[x] = uf.root(uf.par[x])
  return uf.par[x]

proc unite*[T](uf : var UnionFind[T] , x , y : int) : tuple[par : int,chi : int] =
  ## unite x and y
  ## if x and y are already jointed, return (-1,-1)
  ## else return (par , chi) 
  ## amortized a(N)
  var a = uf.root(x)
  var b = uf.root(y)
  if a == b:
    return (-1,-1)
  var r,c : int
  if uf.rank[a] < uf.rank[b]:
    uf.par[a] = b
    r = b
    c = a
  else:
    uf.par[b] = a
    r = a
    c = b
    if uf.rank[a] == uf.rank[b]: uf.rank[a] += 1
  return (r , c)

proc same*[T](uf : var UnionFind[T] , x , y : int) : bool =
  ## return true if x and y are jointed. amortized a(N)
  return uf.root(x) == uf.root(y)

# verify https://atc001.contest.atcoder.jp/tasks/unionfind_a

import algorithm
import strutils

var temp = stdin.readline.split.map(parseInt)

var N = temp[0]
var Q = temp[1]

var uf = newUnionFind[int](N)

for i in 1..Q:
  temp = stdin.readline.split.map(parseInt)
  var p = temp[0]
  var a = temp[1]
  var b = temp[2]
  if p == 0:
    discard uf.unite(a,b)
  else:
    if uf.same(a , b):
      echo "Yes"
    else:
      echo "No"

