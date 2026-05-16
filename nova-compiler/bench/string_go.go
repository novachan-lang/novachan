package main

import (
	"fmt"
	"strings"
)

func stringWork(n int) int {
	result := ""
	for i := 0; i < n; i++ {
		result += "hello"
	}
	return len(result)
}

func stringSearch(n int) int {
	s := "the quick brown fox jumps over the lazy dog"
	count := 0
	for i := 0; i < n; i++ {
		if strings.Contains(s, "fox") {
			count++
		}
		if strings.HasPrefix(s, "the") {
			count++
		}
		if strings.HasSuffix(s, "dog") {
			count++
		}
	}
	return count
}

func main() {
	r1 := stringWork(1000)
	r2 := stringSearch(100000)
	fmt.Println(r1)
	fmt.Println(r2)
}
