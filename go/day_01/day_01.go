package main

import (
	"fmt"
	"log"
	"strconv"

	"github.com/yurianxdev/advent-2020/utility"
)

func main() {
	data, err := utility.ReadInput("day_01", false)
	if err != nil {
		log.Fatalf("error reading input: %v", err)
	}
	var result int
	for i := range data {
		for j := 1; j < len(data); j++ {
			valI, _ := strconv.Atoi(data[i])
			valJ, _ := strconv.Atoi(data[j])

			if i != j && valI+valJ == 2020 {
				result = valI * valJ
			}
		}
	}

	fmt.Println(result)

	for i := range data {
		for j := 1; j < len(data); j++ {
			for m := 2; m < len(data); m++ {
				valI, _ := strconv.Atoi(data[i])
				valJ, _ := strconv.Atoi(data[j])
				valM, _ := strconv.Atoi(data[m])

				if i != j && i != m && j != m && valI+valJ+valM == 2020 {
					result = valI * valJ * valM
				}

			}
		}
	}

	fmt.Println(result)
}
