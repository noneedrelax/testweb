echo "name space is ${myNs}, SHA is  ${SHA}"
mkdir -p ./target/
cp $HOME/upload/testweb.war ./target/
docker build -t ${myNs}/testweb:latest -t ${myNs}/testweb:${SHA} ./
 
# update latest version
docker push ${myNs}/testweb:latest

docker push ${myNs}/testweb:${SHA}
