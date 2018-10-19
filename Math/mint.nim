type
  mint[M : static[int]] = object
    val : int

proc inv_mod*(A , M : int) : int =
  ## Extended Euclidean Algorithm. takes O(loglogN)
  var
    a = A
    b = M
    x = 1
    u = 0
  while b > 0:
    var q = a div b
    var tmp = u
    u = x - q * u
    x = tmp
    tmp = b
    b = a - q * b
    a = tmp
  return (A + M) mod M    

proc nM*[M](val : int) : mint[M] =
  ## create new mint[M] with val.
  return mint[M](val : (val mod M + M) mod M)

proc `$`*[M](m : mint[M]) : string = return m.val.intToStr
proc `+`*[M](a : mint[M] , b : mint[M]) : mint[M] = 
  return mint[M](val : (a.val + b.val) mod M)
proc `-`*[M](a : mint[M] , b : mint[M]) : mint[M] = 
  return mint[M](val : (a.val - b.val + M) mod M)
proc `*`*[M](a : mint[M] , b : mint[M]) : mint[M] = 
  return mint[M](val : (a.val * b.val) mod M)
proc `/`*[M](a : mint[M] , b : mint[M]) : mint[M] = 
  ## division on Z/MZ, takes O(loglogN)
  return mint[M](val : (a.val * inv_mod(b.val , M)) mod M)

proc `+`*[M](a : mint[M] , b : int) : mint[M] = 
  return mint[M](val : (a.val + b) mod M)
proc `-`*[M](a : mint[M] , b : int) : mint[M] = 
  return mint[M](val : (a.val - b + M) mod M)
proc `*`*[M](a : mint[M] , b : int) : mint[M] = 
  return mint[M](val : (a.val * b) mod M)
proc `/`*[M](a : mint[M] , b : int) : mint[M] = 
  ## division on Z/MZ, takes O(loglogN)
  return mint[M](val : (a.val * inv_mod(b , M)) mod M)

proc `+`*[M](a : int , b : mint[M]) : mint[M] = 
  return mint[M](val : (a + b.val) mod M)
proc `-`*[M](a : int , b : mint[M]) : mint[M] = 
  return mint[M](val : (a - b.val + M) mod M)
proc `*`*[M](a : int , b : mint[M]) : mint[M] = 
  return mint[M](val : (a * b.val) mod M)
proc `/`*[M](a : int , b : mint[M]) : mint[M] = 
  ## division on Z/MZ, takes O(loglogN)
  return mint[M](val : (a * inv_mod(b.val , M)) mod M)
proc `^`*[M](a : mint[M] , b : int) : mint[M] =
  ## power. takes O(logN)
  var
    ans = nM[M](1)
    c = a
    r = b
  while r > 0:
    if (r and 1) == 1: ans *= c
    c = c * c
    r = r shr 1
  return ans

type MM = mint[(int)(1e9 + 7)]

proc IDE*(T : typedesc[MM]) : MM = return MM(val : 0)
proc PRO*(T : typedesc[MM]) : MM = return MM(val : 1)