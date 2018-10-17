# WingBIT

## IDE


```nim
proc IDE*(T: typedesc[TT]): TT
```
## OPE


```nim
proc OPE*(x: TT; y: TT): TT
```
## newWingBIT

create WingBIT object. takes O(N)
```nim
proc newWingBIT*[Monoid](n: int): WingBIT[Monoid]
```
## update

update value to x. takes O(logN)
```nim
proc update*[Monoid](bit: var WingBIT[Monoid]; k: int; x: Monoid)
```
## get_inter

fold for interval. takes O(logN)
```nim
proc get_inter*[Monoid](bit: WingBIT[Monoid]; left: int; right: int): Monoid
```
## at

get value indexed i. O(1)
```nim
proc at*[Monoid](bit: WingBIT[Monoid]; k: int): Monoid
```
## `[]`


```nim
proc `[]`*[Monoid](bit: var WingBIT[Monoid]; k: int): Monoid
```
## `[]`


```nim
proc `[]`*[Monoid](bit: var WingBIT[Monoid]; l: int; r: int): Monoid
```
## `[]=`


```nim
proc `[]=`*[Monoid](bit: var WingBIT[Monoid]; k: int; x: Monoid)
```
