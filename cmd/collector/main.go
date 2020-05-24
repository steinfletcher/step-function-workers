package main

import (
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(collector)
}

// collector receives each worker's processed workload as input
func collector(input []int) (string, error) {
	var sum int
	for _, v := range input {
		sum+=v
	}
	return fmt.Sprintf("the result is %d", sum), nil
}
