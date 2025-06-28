# Stage 1: Build the application
FROM openjdk:21-jdk-slim AS build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        maven \
        git \
        ca-certificates \
        curl \
        gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pom.xml ./
COPY src ./src/

RUN mvn clean install -DskipTests

# Stage 2: Final runtime image
FROM openjdk:21-jdk-slim

ARG APP_ARTIFACT_ID="techeazy-devops"
ARG APP_VERSION="0.0.1-SNAPSHOT"

COPY --from=build /app/target/${APP_ARTIFACT_ID}-${APP_VERSION}.jar /app/app.jar

EXPOSE 80

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
