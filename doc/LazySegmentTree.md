# LazySegmentTree

## IDE


```nim
proc IDE*(T: typedesc[Mini]): Mini
```
## IDE


```nim
proc IDE*(T: typedesc[Sumi]): Sumi
```
## MAKE


```nim
proc MAKE*(l: int; x: Sumi; lazy: Sumi): Sumi
```
## EFFECT


```nim
proc EFFECT*(mono: Mini; lazy: Sumi): Mini
```
## THROW


```nim
proc THROW*(lazy: Sumi; down: Sumi): Sumi
```
## OPE


```nim
proc OPE*(x: Mini; y: Mini): Mini
```
## LazySegment

Lazy Segment Tree Object
```nim
LazySegment*[Monoid, Lazy] = object
  node*: seq[Monoid]
  lazy*: seq[Lazy]
  flag*: seq[bool]
  n: int

```
## newLazySegment

create Lazy Segment Tree Object. takes O(N)
```nim
proc newLazySegment*[Monoid, Lazy](init: seq[Monoid]): LazySegment[Monoid, Lazy]
```
## update_inter

update for interval. O(logN)
```nim
proc update_inter*[Monoid, Lazy](s: var LazySegment[Monoid, Lazy]; a, b: int; x: Lazy)
```
## get_inter

fold for interval. O(logN)
```nim
proc get_inter*[Monoid, Lazy](s: var LazySegment[Monoid, Lazy]; a, b: int): Monoid
```
