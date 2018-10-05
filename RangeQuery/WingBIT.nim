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
    while depth <= bit.sz:
        if (left and depth) > 0:
            bit.lw[left] = bit.update_func(bit.lw[left],x)
            left = left + depth
        if (right and depth) > 0:
            bit.rw[right] = bit.update_func(bit.rw[right],x)
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
            al = bit.f(bit.lw[l] , al)
            l -= depth
        if (r and depth) > 0:
            ar = bit.f(ar , bit.rw[r])
            r -= depth
        depth = depth shl 1
    return bit.f(ar,al)