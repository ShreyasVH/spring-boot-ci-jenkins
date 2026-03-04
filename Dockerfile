FROM maven AS build
WORKDIR /app/
COPY . .
RUN mvn clean compile -DskipTests=true package

# ----------------------------------------------------------------

FROM bellsoftcr/25-liberica-runtime-container:jdk-all-25.0.1-cds-slim-glibc

WORKDIR /app/
ARG NAME=demo
ARG VERSION

COPY --from=build /app/target/${NAME}-${VERSION}.jar /app/demo.jar

ENTRYPOINT ["java", "-jar", "/app/demo.jar"]