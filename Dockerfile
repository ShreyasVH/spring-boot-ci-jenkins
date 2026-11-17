FROM --platform=$BUILDPLATFORM maven:3.10.0-eclipse-temurin-27-alpine AS build
WORKDIR /app/
COPY . .
RUN mvn clean compile -DskipTests=true package

# ----------------------------------------------------------------

FROM eclipse-temurin:27-jre-alpine

WORKDIR /app/
ARG NAME=demo
ARG VERSION

COPY --from=build /app/target/${NAME}-${VERSION}.jar /app/demo.jar

ENTRYPOINT ["java", "-jar", "/app/demo.jar"]