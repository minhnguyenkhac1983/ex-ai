package main

import (
	"log"
	"os"

	wf "github.com/minhnguyenkhac1983/exc/services/temporal-worker-go/workflows"
	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/worker"
)

func main() {
	c, err := client.Dial(client.Options{HostPort: getEnv("TEMPORAL_ADDRESS", "127.0.0.1:7233")})
	if err != nil {
		log.Fatalln("unable to create Temporal client", err)
	}
	defer c.Close()

	w := worker.New(c, getEnv("TEMPORAL_TASK_QUEUE", "exc-default"), worker.Options{})
	w.RegisterWorkflow(wf.HelloWorkflow)
	w.RegisterActivity(wf.SayHelloActivity)
	w.RegisterWorkflow(wf.WithdrawalWorkflow)

	err = w.Run(worker.InterruptCh())
	if err != nil {
		log.Fatalln("unable to start Worker", err)
	}
}

func getEnv(key, def string) string {
	if v, ok := os.LookupEnv(key); ok {
		return v
	}
	return def
}
