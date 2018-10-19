# Matrix

## IDE

identity element of int for operator +
```nim
proc IDE*(T: typedesc[int]): int
```
## PRO

identity element of int for operator *
```nim
proc PRO*(T: typedesc[int]): int
```
## Matrix


```nim
Matrix*[T] = seq[seq[T]]
```
## newMatrix


```nim
proc newMatrix*[T](h, w: int): Matrix[T]
```
## `*`


```nim
proc `*`*[T](a, b: Matrix[T]): Matrix[T]
```
## `+`


```nim
proc `+`*[T](a, b: Matrix[T]): Matrix[T]
```
## `*`


```nim
proc `*`*[T](a: Matrix[T]; b: T): Matrix[T]
```
## `^`


```nim
proc `^`*[T](a: Matrix[T]; n: int): Matrix[T]
```
