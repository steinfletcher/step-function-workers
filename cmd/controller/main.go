package main

import (
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(controller)
}

// controller creates workloads that will be distributed to workers
func controller() ([][]int, error) {
	return [][]int{
		{1, 2, 3, 4},    // workload 1
		{5, 6, 7, 8},    // workload 2
		{9, 10, 11, 12}, // workload 3
	}, nil
}
