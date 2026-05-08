# Etapa 1: Construcción (Builder)
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Producción
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Usuario no root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=builder /build/target/*.jar app.jar

# Según el application.properties, este microservicio corre en el 8081
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
