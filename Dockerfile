# FROM adoptopenjdk/openjdk11:alpine-slim
FROM openjdk:17-alpine
ADD target/Pos-0.0.1-SNAPSHOT.jar Pos-0.0.1-SNAPSHOT.jar

RUN apk update && apk --no-cache add curl \
    && apk add busybox-extras \
    && apk add --no-cache tzdata \
    && apk add ttf-dejavu
    
ENV TZ Asia/Singapore
EXPOSE 8080 
ENTRYPOINT ["java","-Dspring.profiles.active=dev,docker","-jar","/Pos-0.0.1-SNAPSHOT.jar"]
