type
    BinaryHeap*[T] = object
        ## Binary Heap
        heap : seq[T]
        comp : proc(x : T , y : T) : bool

proc newBinaryHeap*[T](comp : proc(x : T, y : T) : bool) : BinaryHeap[T] =
    ## create new Binary Heap. O(1)
    var bin : BinaryHeap[T]
    bin.comp = comp
    bin.heap = @[]
    return bin

proc size*[T](bin : var BinaryHeap[T]) : int =
    ## return Binary Heap size. O(1)
    return bin.heap.len

proc empty*[T](bin : var BinaryHeap[T]) : bool =
    ## if Binary Heap is empty, return true. O(1)
    return bin.size == 0

proc push*[T](bin : var BinaryHeap[T] , x : T) =
    ## push x to Binary Heap. O(logN)
    bin.heap.add(x)
    var idx = bin.heap.len() - 1
    while idx > 0:
        var par : int = (idx - 1) div 2
        if bin.comp(bin.heap[idx],bin.heap[par]):
            swap(bin.heap[par],bin.heap[idx])
        idx = par

proc top*[T](bin : var BinaryHeap[T]) : T =
    ## return the top value of Binary Heap. O(1)
    return bin.heap[0]

proc pop*[T](bin : var BinaryHeap[T]) =
    ## poop the top value of Binary Heap.O(logN)
    if bin.empty():
        return
    swap(bin.heap[0],bin.heap[bin.heap.len - 1])  
    discard bin.heap.pop()
    var i : int = 0
    while i * 2 + 1 < bin.size:
        var next = i
        if i * 2 + 1 < bin.size and bin.comp(bin.heap[i * 2 + 1],bin.heap[next]):
            next = i * 2 + 1
        if i * 2 + 2 < bin.size and bin.comp(bin.heap[i * 2 + 2],bin.heap[next]):
            next = i * 2 + 2
        if next == i:
            break
        swap(bin.heap[i],bin.heap[next])
        i = next