package workflows

import (
	"context"
	"time"

	"go.temporal.io/sdk/activity"
	"go.temporal.io/sdk/workflow"
)

type HelloInput struct {
	Name string
}

func HelloWorkflow(ctx workflow.Context, in HelloInput) (string, error) {
	ctx = workflow.WithActivityOptions(ctx, workflow.ActivityOptions{
		StartToCloseTimeout: time.Second * 10,
	})

	var out string
	err := workflow.ExecuteActivity(ctx, SayHelloActivity, in.Name).Get(ctx, &out)
	if err != nil {
		return "", err
	}
	return out, nil
}

func SayHelloActivity(ctx context.Context, name string) (string, error) {
	activity.RecordHeartbeat(ctx, name)
	if name == "" {
		name = "world"
	}
	return "hello, " + name, nil
}

// Withdrawal workflow skeleton for item #9
type WithdrawalRequest struct {
	UserID      string
	AssetSymbol string
	Address     string
	Amount      float64
}

func WithdrawalWorkflow(ctx workflow.Context, req WithdrawalRequest) (string, error) {
	ao := workflow.ActivityOptions{StartToCloseTimeout: time.Minute}
	ctx = workflow.WithActivityOptions(ctx, ao)
	// TODO: implement AML/KYT check, 2-man approval, treasury sign, broadcast, ledger
	return "withdrawal_accepted", nil
}
