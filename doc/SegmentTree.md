# SegmentTree

## IDE


```nim
proc IDE*(T: typedesc[TT]): TT
```
## OPE


```nim
proc OPE*(x: TT; y: TT): TT
```
## newSegmentTree

create Segment Tree Object. takes O(N)
```nim
proc newSegmentTree*[Monoid](init: seq[Monoid]): SegmentTree[Monoid]
```
## update

update value to x. takes O(logN)
```nim
proc update*[Monoid](seg: var SegmentTree[Monoid]; k: int; x: Monoid)
```
## get_inter

fold for interval. takes O(logN)
```nim
proc get_inter*[Monoid](seg: SegmentTree[Monoid]; left: int; right: int): Monoid
```
## at

get value indexed i. O(1)
```nim
proc at*[Monoid](seg: SegmentTree[Monoid]; i: int): Monoid
```
