# mint

## inv_mod

Extended Euclidean Algorithm. takes O(loglogN)
```nim
proc inv_mod*(A, M: int): int
```
## nM

create new mint[M] with val.
```nim
proc nM*[M](val: int): mint[M]
```
## `$`


```nim
proc `$`*[M](m: mint[M]): string
```
## `+`


```nim
proc `+`*[M](a: mint[M]; b: mint[M]): mint[M]
```
## `-`


```nim
proc `-`*[M](a: mint[M]; b: mint[M]): mint[M]
```
## `*`


```nim
proc `*`*[M](a: mint[M]; b: mint[M]): mint[M]
```
## `/`

division on Z/MZ, takes O(loglogN)
```nim
proc `/`*[M](a: mint[M]; b: mint[M]): mint[M]
```
## `+`


```nim
proc `+`*[M](a: mint[M]; b: int): mint[M]
```
## `-`


```nim
proc `-`*[M](a: mint[M]; b: int): mint[M]
```
## `*`


```nim
proc `*`*[M](a: mint[M]; b: int): mint[M]
```
## `/`

division on Z/MZ, takes O(loglogN)
```nim
proc `/`*[M](a: mint[M]; b: int): mint[M]
```
## `+`


```nim
proc `+`*[M](a: int; b: mint[M]): mint[M]
```
## `-`


```nim
proc `-`*[M](a: int; b: mint[M]): mint[M]
```
## `*`


```nim
proc `*`*[M](a: int; b: mint[M]): mint[M]
```
## `/`

division on Z/MZ, takes O(loglogN)
```nim
proc `/`*[M](a: int; b: mint[M]): mint[M]
```
## `^`

power. takes O(logN)
```nim
proc `^`*[M](a: mint[M]; b: int): mint[M]
```
## IDE


```nim
proc IDE*(T: typedesc[MM]): MM
```
## PRO


```nim
proc PRO*(T: typedesc[MM]): MM
```
