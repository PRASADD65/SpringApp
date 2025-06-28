FROM openjdk:21-jdk-slim AS build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        maven \
        git \
        ca-certificates \
        curl \
        gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pom.xml ./
COPY src ./src/

RUN mvn clean package -DskipTests

FROM openjdk:21-jdk-slim

COPY --from=build /app/target/SpringApp-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 80

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
