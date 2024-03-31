FROM registry.access.redhat.com/ubi9/openjdk-21:1.17-2.1705482269 as builder

LABEL authors="Naït Belkacem Ilyess"

# Start install as root
USER 0

# Create building directory
WORKDIR /build

#Copy project
COPY . .

# Compile project
RUN mvn package

FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.17-2.1705482271

# Install as root
USER 0

# Set the timezone
ENV TZ="Europe/Paris"
ENV LANGUAGE='en_US:en'

# Cody build project
WORKDIR /deployments
COPY  --from=builder /build/target/quarkus-app/ .

# Prepare for app execution
EXPOSE 8080
USER 1001

# Execute app
ENTRYPOINT [ "/opt/jboss/container/java/run/run-java.sh" ]