package main

import "fmt"

func listBuildAndSum(n int) int64 {
	lst := make([]int64, 0, n)
	for i := 0; i < n; i++ {
		lst = append(lst, int64(i)*2+1)
	}
	var total int64
	for _, x := range lst {
		total += x
	}
	return total
}

func listFilterSum(n int) int64 {
	lst := make([]int64, 0, n)
	for i := 0; i < n; i++ {
		lst = append(lst, int64(i))
	}
	var total int64
	for _, x := range lst {
		if x%3 == 0 {
			total += x
		}
	}
	return total
}

func main() {
	r1 := listBuildAndSum(100000)
	r2 := listFilterSum(100000)
	fmt.Println(r1)
	fmt.Println(r2)
}
