import sequtils

type
  Mini = object
    val : int
  Sumi = object
    val : int

proc IDE*(T : typedesc[Mini]) : Mini = return Mini(val : 1010101010)
proc IDE*(T : typedesc[Sumi]) : Sumi = return Sumi(val : 0)
proc MAKE*(l : int , x : Sumi , lazy : Sumi) : Sumi = return Sumi(val : x.val + lazy.val)
proc EFFECT*(mono : Mini , lazy : Sumi) : Mini = return Mini(val : mono.val + lazy.val)
proc THROW*(lazy : Sumi , down : Sumi) : Sumi =  return Sumi(val : lazy.val + down.val)
proc OPE*(x : Mini , y : Mini) : Mini = return Mini(val : min(x.val,y.val))

type
  LazySegment*[Monoid,Lazy] = object
    ## Lazy Segment Tree Object
    node * : seq[Monoid]
    lazy * : seq[Lazy]
    flag * : seq[bool]
    n : int

proc newLazySegment*[Monoid,Lazy](init : seq[Monoid]) : LazySegment[Monoid,Lazy] =
  ## create Lazy Segment Tree Object. takes O(N)
  var seg : LazySegment[Monoid,Lazy]
  seg.n = 1
  var sz = init.len
  while seg.n < sz: seg.n *= 2
  seg.node = newSeqWith(seg.n * 2 - 1,IDE(Monoid))
  seg.lazy = newSeqWith(seg.n * 2 - 1,IDE(Lazy))
  seg.flag = newSeqWith(seg.n * 2 - 1,false)
  for i in 0..<sz: seg.node[i + seg.n - 1] = init[i]
  for i in countdown(seg.n - 2 , 0): seg.node[i] = OPE(seg.node[i * 2 + 1] , seg.node[i * 2 + 2])
  return seg

proc eval[Monoid,Lazy](s : var LazySegment[Monoid , Lazy] , k : int , l : int) =
  if s.flag[k]:
    s.node[k] = EFFECT(s.node[k] , s.lazy[k])
    if l > 1:
      s.lazy[2 * k + 1] = THROW(s.lazy[k] , s.lazy[2 * k + 1])
      s.lazy[2 * k + 2] = THROW(s.lazy[k] , s.lazy[2 * k + 2])
      s.flag[2 * k + 1] = true
      s.flag[2 * k + 2] = true
    s.flag[k] = false
    s.lazy[k] = IDE(Lazy)

proc u_inter[Monoid,Lazy](s : var LazySegment[Monoid,Lazy] , a , b : int , x : Lazy , k : int , l : int, r : int) =
  s.eval(k,r - l)
  if r <= a or b <= l: return
  if a <= l and r <= b:
    s.lazy[k] = MAKE(r - l, x ,s.lazy[k])
    s.flag[k] = true
    s.eval(k,r - l)
  else:
    s.u_inter(a,b,x,k * 2 + 1 ,l,(l + r) div 2)
    s.u_inter(a,b,x,k * 2 + 2 ,(l + r) div 2,r)
    s.node[k] = OPE(s.node[k * 2 + 1] , s.node[k * 2 + 2])


proc update_inter*[Monoid,Lazy](s : var LazySegment[Monoid,Lazy] , a , b : int , x : Lazy) =
  ## update for interval. O(logN)
  s.u_inter(a,b,x,0,0,s.n)

proc g_inter[Monoid,Lazy](s : var LazySegment[Monoid,Lazy] , a , b : int , k : int , l : int, r : int) : Monoid =
  s.eval(k,r - l)
  if r <= a or b <= l: return IDE(Monoid)
  if a <= l and r <= b: return s.node[k]
  return OPE(s.g_inter(a,b,k * 2 + 1,l,(l + r) div 2),s.g_inter(a,b,k*2+2,(l + r) div 2,r))

proc get_inter*[Monoid,Lazy](s : var LazySegment[Monoid,Lazy] , a , b : int) : Monoid =
  ## fold for interval. O(logN)
  return s.g_inter(a,b,0,0,s.n)

# verify arc045-b

import strutils
import algorithm

var temp = stdin.readline.split.map(parseInt)

var
  N = temp[0]
  M = temp[1]
var seg = newLazySegment[Mini,Sumi](newSeqWith(N,Mini(val : 0)))

var s = newSeq[int](M)
var t = newSeq[int](M)

for i in 0..<M:
  temp = stdin.readline.split.map(parseInt)
  s[i] = temp[0]
  t[i] = temp[1]
  dec(s[i])
  dec(t[i])
  seg.update_inter(s[i] , t[i] + 1 , Sumi(val : 1))

var ans : seq[int] = @[]
for i in 0..<M:
  if seg.get_inter(s[i],t[i] + 1).val > 1:
    ans.add(i + 1)

echo ans.len
for i in ans: echo i
