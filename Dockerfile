# FROM adoptopenjdk/openjdk11:alpine-slim
FROM openjdk:17-alpine
ADD target/petclinic.war petclinic.war

RUN apk update && apk --no-cache add curl \
    && apk add busybox-extras \
    && apk add --no-cache tzdata \
    && apk add ttf-dejavu
    
ENV TZ Asia/Singapore
EXPOSE 8080 
ENTRYPOINT ["java","-Dspring.profiles.active=dev,docker","-war","/petclinic.war"]
