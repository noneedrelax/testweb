echo "Deploying to k8s"
kubectl apply -f k8s

kubectl set image deployments/client-deployment server=noneedrelax/testweb:${SHA}