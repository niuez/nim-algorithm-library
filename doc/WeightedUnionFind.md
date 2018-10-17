# WeightedUnionFind

## newWeightedUnionFind

create WeightUnionFind object
```nim
proc newWeightedUnionFind*(n: int): WeightedUnionFind
```
## root

root of x. amortized a(N) 
```nim
proc root*(uf: var WeightedUnionFind; x: int): int
```
## weight

get weight of x. amortized a(N)
```nim
proc weight*(uf: var WeightedUnionFind; x: int): int64
```
## unite

x---w---&gt;y
```nim
proc unite*(uf: var WeightedUnionFind; x, y: int; wei: int64): tuple[par: int, chi: int]
```
## same

return true if x and y are jointed. amortized a(N)
```nim
proc same*(uf: var WeightedUnionFind; x, y: int): bool
```
