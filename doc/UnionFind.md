# UnionFind

## newUnionFind

create new UnionFind Object.
```nim
proc newUnionFind*[T](n: int): UnionFind[T]
```
## root

root of x. amortized a(N)
```nim
proc root*[T](uf: var UnionFind[T]; x: int): int
```
## unite

unite x and y if x and y are already jointed, return (-1,-1) else return (par , chi) amortized a(N)
```nim
proc unite*[T](uf: var UnionFind[T]; x, y: int): tuple[par: int, chi: int]
```
## same

return true if x and y are jointed. amortized a(N)
```nim
proc same*[T](uf: var UnionFind[T]; x, y: int): bool
```
