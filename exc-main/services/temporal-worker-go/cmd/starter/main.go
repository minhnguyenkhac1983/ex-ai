package main

import (
	"context"
	"fmt"
	"os"

	wf "github.com/minhnguyenkhac1983/exc/services/temporal-worker-go/workflows"
	"go.temporal.io/sdk/client"
)

func main() {
	c, err := client.Dial(client.Options{HostPort: getenv("TEMPORAL_ADDRESS", "127.0.0.1:7233")})
	if err != nil {
		panic(err)
	}
	defer c.Close()

	runID, err := c.ExecuteWorkflow(context.Background(), client.StartWorkflowOptions{
		TaskQueue: getenv("TEMPORAL_TASK_QUEUE", "exc-default"),
		ID:        "hello-workflow-1",
	}, wf.HelloWorkflow, wf.HelloInput{Name: "exc"})
	if err != nil {
		panic(err)
	}
	fmt.Println("started:", runID.GetID())
}

func getenv(k, d string) string {
	if v, ok := os.LookupEnv(k); ok {
		return v
	}
	return d
}
