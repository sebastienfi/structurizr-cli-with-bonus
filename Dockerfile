# Use a multi-stage build to keep the final image clean and small
FROM eclipse-temurin:17.0.8.1_1-jre-jammy as builder

# Set the working directory
WORKDIR /build

# Install dependencies in a single layer and clean up
RUN apt-get update && \
    apt-get install -y unzip git graphviz jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install PlantUML
RUN wget https://downloads.sourceforge.net/project/plantuml/plantuml.jar -O /usr/local/bin/plantuml.jar && \
    echo '#!/bin/bash\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# Copy the Structurizr CLI zip
COPY structurizr-cli-*.zip /build/

# Unzip Structurizr CLI
RUN unzip structurizr-cli-*.zip && \
    mv structurizr-cli-*/* /build/ && \
    chmod +x structurizr.sh

# Final image
FROM eclipse-temurin:17.0.8.1_1-jre-jammy

# Create a non-root user
RUN useradd -m structurizr
USER structurizr

# Copy necessary files from builder stage
COPY --from=builder /build /usr/local/structurizr-cli
COPY --from=builder /usr/local/bin/plantuml.jar /usr/local/bin/plantuml.jar
COPY --from=builder /usr/local/bin/plantuml /usr/local/bin/plantuml

# Set the working directory
WORKDIR /usr/local/structurizr-cli

# Update PATH
ENV PATH /usr/local/structurizr-cli/:$PATH

# Setup Git
RUN git config --global user.name github-actions && \
    git config --global user.email github-actions@github.com

# Set the entry point
ENTRYPOINT ["./structurizr.sh"]
