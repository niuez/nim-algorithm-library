type
  Mini = object
    val : int
proc IDE*(T : typedesc[Mini]) : Mini = return Mini(val : 1 shl 60)
proc OPE*(x : Mini , y : Mini) : Mini = return Mini(val : min(x.val,y.val))

type
  Maxi = object
    val : int
proc IDE*(T : typedesc[Maxi]) : Maxi = return Maxi(val : 1 shl 60)
proc OPE*(x : Maxi , y : Maxi) : Maxi = return Maxi(val : min(x.val,y.val))

type
  Sumi = object
    val : int
proc IDE*(T : typedesc[Sumi]) : Sumi = return Sumi(val : 0)
proc OPE*(x : Sumi , y : Sumi) : Sumi = return Sumi(val : x.val + y.val)


