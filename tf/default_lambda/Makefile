build-lambdas:
	GOOS=linux GOARCH=amd64 go build -o function .
	zip -j function.zip function
