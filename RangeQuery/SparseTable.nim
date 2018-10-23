import sequtils , bitops

type
  SparseTable*[T] = object
    ## Sparse Table Object.
    tab : seq[seq[T]]

proc buildSparseTable*[T](A : seq[T]) : SparseTable[T] =
  ## create Sparse Table. takes O(NlogN)
  var
    b = 0
    st : SparseTable[T] 
  while (1 shl b) <= A.len: inc(b)
  st.tab = newSeqWith(b , newSeq[T](1 shl b))
  for i , a in A.pairs:
    st.tab[0][i] = a
  for i in 1..<b:
    for j in 0..(1 shl b) - (1 shl i):
      st.tab[i][j] = min(st.tab[i - 1][j] , st.tab[i - 1][j + (1 shl (i - 1))])
  return st

proc get_interval*[T](st : SparseTable[T] , l , r : int) : T =
  ## get the minimum value in [l,r). takes O(logN)
  var b = countTrailingZeroBits(r - l)
  return min(st.tab[b][l] , st.tab[b][r - (1 shl b)])

