Param()
Write-Host "Setting up dev environment..."
Write-Host "Install kubectl/kustomize if missing, then apply dev overlay"
Write-Host "kustomize build infra/kustomize/dev | kubectl apply -f -"


