package main

import "fmt"

func main() {
	var total int64
	for i := int64(0); i < 100; i++ {
		ch := make(chan int64, 1)
		go func(id int64) {
			ch <- id * id
		}(i)
		val := <-ch
		total += val
	}
	fmt.Println(total)
}
