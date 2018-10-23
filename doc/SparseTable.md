# SparseTable

## SparseTable

Sparse Table Object.
```nim
SparseTable*[T] = object
  tab: seq[seq[T]]

```
## buildSparseTable

create Sparse Table. takes O(NlogN)
```nim
proc buildSparseTable*[T](A: seq[T]): SparseTable[T]
```
## get_interval

get the minimum value in [l,r). takes O(logN)
```nim
proc get_interval*[T](st: SparseTable[T]; l, r: int): T
```
