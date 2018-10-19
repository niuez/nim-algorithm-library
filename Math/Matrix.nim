import sequtils

proc IDE*(T : typedesc[int]) : int = return 0 ## identity element of int for operator +

proc PRO*(T : typedesc[int]) : int = return 1 ## identity element of int for operator *

type Matrix*[T] = seq[seq[T]]

proc newMatrix*[T](h , w : int) : Matrix[T] =
    var mat : Matrix[T] = newSeqWith(h,newSeqWith(w , IDE(T)))
    return mat

proc `*`*[T](a , b : Matrix[T]) : Matrix[T] =
    var res = newMatrix[T](a.len , b[0].len)
    for i in 0..<a.len:
        for k in 0..<b.len:
            for j in 0..<b[0].len:
                res[i][j] = res[i][j] + a[i][k] * b[k][j]
    return res

proc `+`*[T](a , b : Matrix[T]) : Matrix[T] =
    var res = a
    for i in 0..<res.len:
        for j in 0..<res[0].len:
            res[i][j] += b[i][j]
    return res


proc `*`*[T](a : Matrix[T] , b : T) : Matrix[T] =
    var res = a
    for i in 0..<res.len:
        for j in 0..<res[0].len:
            res[i][j] += b
    return res

proc `^`*[T](a : Matrix[T] , n : int) : Matrix[T] =
    var 
        A = a
        res = newMatrix[T](a.len , a[0].len)
        r = n
    for i in 0..<res.len: res[i][i] = PRO(T)

    while r > 0:
        if (r and 1) == 1: res = res * A
        A = A * A
        r = r shr 1
    return res

# verify https://yukicoder.me/problems/no/718