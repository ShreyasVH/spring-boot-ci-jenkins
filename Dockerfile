FROM --platform=$BUILDPLATFORM maven:3.9.16-eclipse-temurin-26-alpine AS build
WORKDIR /app/
COPY . .
RUN mvn clean compile -DskipTests=true package

# ----------------------------------------------------------------

FROM eclipse-temurin:26.0.2_10-jre-jammy

WORKDIR /app/
ARG NAME=demo
ARG VERSION

COPY --from=build /app/target/${NAME}-${VERSION}.jar /app/demo.jar

ENTRYPOINT ["java", "-jar", "/app/demo.jar"]