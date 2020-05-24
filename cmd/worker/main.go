package main

import (
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(worker)
}

// worker process the workload and returns the result as output
func worker(data []int) (int, error) {
	var sum int
	for _, v := range data {
		sum+=v
	}
	return sum, nil
}
