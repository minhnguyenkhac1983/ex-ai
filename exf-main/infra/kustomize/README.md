### Kustomize overlays

Thư mục `dev/` chứa kustomization cho môi trường phát triển (namespaces, Kafka, Postgres, deployments tối thiểu, ingress).

Lệnh tham khảo
```
kustomize build dev | kubectl apply -f -
```

Kiểm tra ingress
- Cập nhật hosts: `127.0.0.1 dev.exf.local`
- Truy cập: `http://dev.exf.local/oms` (trading-oms), `http://dev.exf.local/md` (market-data)


