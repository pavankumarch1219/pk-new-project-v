# ===== BUILD STAGE =====
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x mvnw && ./mvnw clean package -Dmaven.test.skip=true

# ===== RUN STAGE =====
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Non-root user for Trivy/security compliance
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=build /workspace/app/target/*.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
