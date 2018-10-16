import algorithm
 
type TT = tuple[a : float64 , b : float64]
proc IDE*(T : typedesc[TT]) : TT = return (1.0,0.0)
proc OPE*(x : TT , y : TT) : TT = return (y.a * x.a , y.a * x.b + y.b)
 
type
  WingBIT[Monoid] = object
    ##  WingBIT object
    rw : seq[Monoid]
    lw : seq[Monoid]
    sz : int
proc newWingBIT*[Monoid](n : int) : WingBIT[Monoid] =
  ## create WingBIT object. takes O(N)
  var bit : WingBIT[Monoid]
  bit.rw = @[]
  bit.lw = @[]
  bit.sz = 1
  while bit.sz < n: bit.sz = bit.sz * 2
  bit.rw.setLen(bit.sz + 1)
  bit.lw.setLen(bit.sz + 1)
  bit.rw.fill(IDE(Monoid))
  bit.lw.fill(IDE(Monoid))
  return bit
 
proc update*[Monoid](bit : var WingBIT[Monoid] , k : int , x : Monoid) =
  ## update value to x. takes O(logN)
  var depth = 1
  var right = k
  var left = bit.sz + 1 - k
  if (right and depth) > 0:
    bit.rw[right] = x
    right = right + depth
  if (left and depth) > 0:
    bit.lw[left] = x
    left = left + depth
  depth = 2
  while depth <= bit.sz:
    var dd = depth shr 1
    if (left and depth) > 0:
      bit.lw[left] = OPE(bit.rw[bit.sz - left + dd],bit.lw[left - dd])
      left = left + depth
    if (right and depth) > 0:
      bit.rw[right] = OPE(bit.rw[right - dd],bit.lw[bit.sz - right + dd])
      right = right + depth
    depth = depth shl 1
 
proc get_inter*[Monoid](bit : WingBIT[Monoid] , left : int , right : int) : Monoid =
  ## fold for interval. takes O(logN)
  var al = IDE(Monoid)
  var ar = IDE(Monoid)
  var depth = 1
  var l = bit.sz + 1 - left
  var r = right
  while bit.sz + 1 - l <= r:
    if (l != bit.sz) and ((l and depth) > 0):
      al = OPE(al,bit.lw[l])
      l -= depth
    if (r and depth) > 0:
      ar = OPE(bit.rw[r],ar)
      r -= depth
    depth = depth shl 1
  return OPE(ar,al)

proc at*[Monoid](bit : WingBIT[Monoid] , k : int) : Monoid =
  ## get value indexed i. O(1)
  if k and 1 == 1:
    return bit.right[k]
  else:
    return bit.left[bit.sz + 1 - k]
 
proc `[]`*[Monoid](bit : var WingBIT[Monoid] , k : int) : Monoid =
  return bit.at(k)
 
proc `[]`*[Monoid](bit : var WingBIT[Monoid] , l : int , r : int) : Monoid =
  return bit.get_inter(l,r)
 
proc `[]=`*[Monoid](bit : var WingBIT[Monoid] , k : int , x : Monoid) =
  bit.update(k , x)
 
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
 
 
var ran = newWingBIT[TT](M + 1000)
 
var mr : float64 = 1.0
var ir : float64 = 1.0
for i in 0..<M:
  p[i] = lowerBound(se,p[i]) + 1
  ran[(int)p[i]] = (a[i] , b[i])
  var tup : TT = ran[1,M]
  var rrr : float64 = tup.a + tup.b
  mr = max(mr,rrr)
  ir = min(ir,rrr)
echo ir.formatFloat
echo mr.formatFloat
