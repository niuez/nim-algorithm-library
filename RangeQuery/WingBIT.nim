import algorithm
type
    WingBIT[Monoid] = object
        rw : seq[Monoid]
        lw : seq[Monoid]
        ide : Monoid
        sz : int
        update_func : proc(node : Monoid , x : Monoid) : Monoid
        f : proc(x : Monoid , y : Monoid) : Monoid
proc newWingBIT*[Monoid](n : int , ide : Monoid,
    update_func : proc(node : Monoid , x : Monoid) : Monoid , 
    f : proc(x : Monoid , y : Monoid) : Monoid) : WingBIT[Monoid] =
    var bit : WingBIT[Monoid]
    bit.rw = @[]
    bit.lw = @[]
    bit.sz = 1
    while bit.sz < n: bit.sz = bit.sz * 2
    bit.rw.setLen(bit.sz + 1)
    bit.lw.setLen(bit.sz + 1)
    bit.rw.fill(ide)
    bit.lw.fill(ide)
    bit.ide = ide
    bit.update_func = update_func
    bit.f = f
    return bit

proc update*[Monoid](bit : var WingBIT[Monoid] , k : int , x : Monoid) =
    var depth = 1
    var right = k
    var left = bit.sz + 1 - k
    if (right and depth) > 0:
        bit.rw[right] = bit.update_func(bit.rw[right],x)
        right = right + depth
    if (left and depth) > 0:
        bit.lw[left] = bit.update_func(bit.lw[left],x)
        left = left + depth
    depth = 2
    while depth <= bit.sz:
        var dd = depth shr 1
        if (left and depth) > 0:
            bit.lw[left] = bit.f(bit.rw[bit.sz - left + dd],bit.lw[left - dd])
            left = left + depth
        if (right and depth) > 0:
            bit.rw[right] = bit.f(bit.rw[right - dd],bit.lw[bit.sz - right + dd])
            right = right + depth
        depth = depth shl 1

proc get_inter*[Monoid](bit : WingBIT[Monoid] , left : int , right : int) : Monoid =
    var al = bit.ide
    var ar = bit.ide
    var depth = 1
    var l = bit.sz + 1 - left
    var r = right
    while bit.sz + 1 - l <= r:
        if (l != bit.sz) and ((l and depth) > 0):
            al = bit.f(al,bit.lw[l])
            l -= depth
        if (r and depth) > 0:
            ar = bit.f(bit.rw[r],ar)
            r -= depth
        depth = depth shl 1
    return bit.f(ar,al)

# verify arc008 - d

import strutils
import sequtils

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

type TT = tuple[a : float64 , b : float64]
proc ffunc(x : TT,y : TT) : TT=
    return (y.a * x.a , y.a * x.b + y.b)

proc uupdate(x : TT,y : TT) : TT=
    return y

var ran = newWingBIT(M + 1000,(1.0,0.0),uupdate,ffunc)

var mr : float64 = 1.0
var ir : float64 = 1.0
for i in 0..<M:
    p[i] = lowerBound(se,p[i]) + 1
    ran.update((int)p[i],(a[i],b[i]))
    var tup : TT = ran.rw[ran.sz]
    var rrr : float64 = tup.a + tup.b
    mr = max(mr,rrr)
    ir = min(ir,rrr)
echo ir.formatFloat
echo mr.formatFloat
    