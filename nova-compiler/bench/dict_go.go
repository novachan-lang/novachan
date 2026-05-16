package main

import (
	"fmt"
	"strconv"
)

func dictInsertLookup(n int) int64 {
	d := make(map[string]int64)
	d["init"] = 0
	for i := 0; i < n; i++ {
		d["key"+strconv.Itoa(i)] = int64(i) * int64(i)
	}
	var total int64
	for j := 0; j < n; j++ {
		total += d["key"+strconv.Itoa(j)]
	}
	return total
}

func main() {
	result := dictInsertLookup(10000)
	fmt.Println(result)
}
