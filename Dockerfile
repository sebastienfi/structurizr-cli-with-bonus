# Notes:
#   - about USER: GitHub Actions requires Docker actions to run as the default Docker user (root). This is because non-root users might not have access to the GITHUB_WORKSPACE directory. 
#   - about WORKDIR: GitHub recommends avoiding the use of the WORKDIR instruction in Dockerfiles for actions. This is because GitHub sets the working directory path in the GITHUB_WORKSPACE environment variable and mounts this directory at the specified location in the Docker image, potentially overwriting anything that was there. 
#   - about ENTRYPOINT: GitHub Actions recommend using an absolute path for the entrypoint. 

# Builder stage
FROM eclipse-temurin:17.0.8.1_1-jre-jammy as builder

# Install dependencies
RUN apt-get update && \
    apt-get install -y unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PlantUML
RUN wget https://downloads.sourceforge.net/project/plantuml/plantuml.jar -O /usr/local/bin/plantuml.jar && \
    echo '#!/bin/bash\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# Copy and setup Structurizr CLI
COPY structurizr-cli-*.zip /
RUN mkdir /structurizr-cli && \
    unzip structurizr-cli-*.zip -d /structurizr-cli && \
    chmod +x /structurizr-cli/structurizr.sh && \
    rm structurizr-cli-*.zip

### Final image ###
FROM eclipse-temurin:17.0.8.1_1-jre-jammy

# Install dependencies and clean up
RUN apt-get update && \
    apt-get install -y graphviz jq git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy necessary files from builder stage
COPY --from=builder /structurizr-cli /usr/local/structurizr-cli
COPY --from=builder /usr/local/bin/plantuml.jar /usr/local/bin/
COPY --from=builder /usr/local/bin/plantuml /usr/local/bin/

# Update PATH
ENV PATH /usr/local/structurizr-cli/:/usr/local/bin/:$PATH

# Setup Git configuration
RUN git config --global user.name github-actions && \
    git config --global user.email github-actions@github.com

# Set the entry point with an absolute path
ENTRYPOINT ["/usr/local/structurizr-cli/structurizr.sh"]
