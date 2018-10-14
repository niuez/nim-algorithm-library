import sequtils

type TT = tuple[a : float64 , b : float64]
proc IDE*(T : typedesc[TT]) : TT = return (1.0,0.0)
proc OPE*(x : TT , y : TT) : TT = return (y.a * x.a , y.a * x.b + y.b)

type
    SegmentTree[Monoid] = object
        node * : seq[Monoid]
        n * : int

proc newSegmentTree*[Monoid](init : seq[Monoid]) : SegmentTree[Monoid] =
    var seg : SegmentTree[Monoid]
    seg.n = 1
    var sz = init.len
    while seg.n < sz: seg.n = seg.n shl 1
    seg.node = newSeqWith(seg.n * 2, Monoid.IDE)
    for i in 0..<sz: seg.node[i + seg.n] = init[i]
    for i in countdown(seg.n - 2 , 0): seg.node[i] = OPE(seg.node[i * 2] , seg.node[i * 2 + 1])
    return seg

proc update*[Monoid](seg : var SegmentTree[Monoid] , k : int , x : Monoid) =
    var i = k + seg.n
    seg.node[i] = x
    while i > 1:
        i = i shr 1
        seg.node[i] = OPE(seg.node[i * 2] , seg.node[i * 2 + 1])

proc get_inter*[Monoid](seg : SegmentTree[Monoid] , left : int , right : int) : Monoid=
    var L = Monoid.IDE
    var R = Monoid.IDE
    var l = left + seg.n
    var r = right + seg.n
    while l <= r:
        if (l and 1) == 1:
            L = OPE(L , seg.node[l])
            inc(l)
        if (r and 1) == 0:
            R = OPE(seg.node[r] , R)
            dec(r)
        l = l shr 1
        r = r shr 1
    return OPE(L , R)

proc at*[Monoid](seg : SegmentTree[Monoid] , i : int) : Monoid =
    return seg.node[i + seg.n]

import algorithm
import strutils

var temp = stdin.readLine.split.map(parseInt)
 
var N = temp[0]
var M = temp[1]
 
var p : array[101010,int64]
var a : array[101010,float64]
var b : array[101010,float64]
 
var se : seq[int64] = @[]
 
for i in 0..<M:
  var temp2 = stdin.readLine.split
  p[i] = temp2[0].parseInt
  a[i] = temp2[1].parseFloat
  b[i] = temp2[2].parseFloat
  se.add(p[i])
sort(se,system.cmp)
 
 
var seg = newSegmentTree[TT](newSeqWith(M + 1000,TT.IDE))
 
var mr : float64 = 1.0
var ir : float64 = 1.0
for i in 0..<M:
  p[i] = lowerBound(se,p[i]) + 1
  seg.update((int)p[i],(a[i] , b[i]))
  var tup : TT = seg.get_inter(1,M)
  var rrr : float64 = tup.a + tup.b
  mr = max(mr,rrr)
  ir = min(ir,rrr)
echo ir.formatFloat
echo mr.formatFloat