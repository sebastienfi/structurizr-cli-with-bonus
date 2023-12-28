FROM eclipse-temurin:17.0.8.1_1-jre-jammy

WORKDIR /usr/local/structurizr-cli/
ENV PATH /usr/local/structurizr-cli/:$PATH

# Install additional dependencies (Git, Graphviz, jq)
RUN apt-get update && \
    apt-get install -y unzip git graphviz jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PlantUML
RUN wget https://downloads.sourceforge.net/project/plantuml/plantuml.jar -O /usr/local/bin/plantuml.jar && \
    echo '#!/bin/bash\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

COPY build/distributions/structurizr-cli-*.zip ./
RUN unzip /usr/local/structurizr-cli/structurizr-cli-*.zip && chmod +x structurizr.sh

# Setup Git
RUN git config --global user.name github-actions && \
    git config --global user.email github-actions@github.com

WORKDIR /usr/local/structurizr/

