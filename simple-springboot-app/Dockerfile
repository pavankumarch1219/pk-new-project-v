# ===== BUILD STAGE =====
# Use official Maven + JDK image — no mvnw needed, no stub issues
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /workspace/app

# Copy pom first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src src
RUN mvn clean package -Dmaven.test.skip=true -B

# ===== RUN STAGE =====
# Slim JRE-only image — smaller attack surface for Trivy
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Non-root user for Trivy/security compliance
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=build /workspace/app/target/*.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
