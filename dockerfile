# Stage 1: Build with Maven (cached dependencies)
FROM maven:3.8.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B  # Cache dependencies
COPY src ./src
RUN mvn package -DskipTests \
    -DargLine="--add-opens jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED"

# Stage 2: Lean Runtime Image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
