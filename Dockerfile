# Start writing your Dockerfile easily
FROM tomcat:9.0.24-jdk8-corretto

MAINTAINER Tony_Liang

WORKDIR '/app'

COPY target/testweb.war ./
COPY conf/testweb.xml /usr/local/tomcat/conf/Catalina/localhost/testweb.xml
COPY conf/filter.properties ./