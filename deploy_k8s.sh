echo "Deploying to k8s"
kubectl apply -f k8s

kubectl set image deployments/webapp-deployment testweb=noneedrelax/testweb:${SHA}