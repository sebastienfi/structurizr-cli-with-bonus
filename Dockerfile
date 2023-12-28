# Start from the structurizr/cli image
FROM structurizr/cli

# Install additional dependencies (Git, Graphviz, jq)
RUN apt-get update && \
    apt-get install -y git graphviz jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PlantUML
RUN wget https://downloads.sourceforge.net/project/plantuml/plantuml.jar -O /usr/local/bin/plantuml.jar && \
    echo '#!/bin/bash\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# Setup Git
RUN git config --global user.name github-actions && \
    git config --global user.email github-actions@github.com

# The working directory is already set in the structurizr/cli image, but you can set it again if needed
# WORKDIR /workspace
