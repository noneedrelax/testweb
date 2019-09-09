echo "name space is ${myNs}, SHA is  ${SHA}"
docker build -t ${myNs}/testweb:latest -t ${myNs}/multi-client:${SHA} ./
 
# update latest version
docker push ${myNs}/testweb:latest

docker push ${myNs}/testweb:${SHA}
