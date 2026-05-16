package main

import "fmt"

func main() {
	ch := make(chan int64, 0)
	go func() {
		var i int64
		for i = 0; i < 10000; i++ {
			ch <- i
		}
		ch <- -1
	}()

	var total int64
	for {
		val := <-ch
		if val == -1 {
			break
		}
		total += val
	}
	fmt.Println(total)
}
