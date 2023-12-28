# Builder stage
FROM eclipse-temurin:17.0.8.1_1-jre-jammy as builder

# Set the working directory
WORKDIR /build

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
COPY structurizr-cli-*.zip /build/
RUN mkdir /build/structurizr-cli && \
    unzip structurizr-cli-*.zip -d /build/structurizr-cli && \
    chmod +x /build/structurizr-cli/structurizr.sh && \
    rm structurizr-cli-*.zip

### Final image ###
FROM eclipse-temurin:17.0.8.1_1-jre-jammy

# Install dependencies and clean up
RUN apt-get update && \
    apt-get install -y graphviz jq git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*


### Create a non-root user ###
RUN useradd -m structurizr
USER structurizr

# Copy necessary files from builder stage
COPY --from=builder /build /usr/local/structurizr-cli
COPY --from=builder /usr/local/bin/plantuml.jar /usr/local/bin/
COPY --from=builder /usr/local/bin/plantuml /usr/local/bin/

# Set the working directory and update PATH
WORKDIR /usr/local/structurizr-cli
ENV PATH /usr/local/structurizr-cli/:/usr/local/bin/:$PATH

# Setup Git configuration
RUN git config --global user.name github-actions && \
    git config --global user.email github-actions@github.com

# Set the entry point
ENTRYPOINT ["./structurizr.sh"]