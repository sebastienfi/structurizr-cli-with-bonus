# Introduction

This Docker image extends the `structurizr/cli` image, including additional tools such as Git, Graphviz, jq, and PlantUML, ideal for advanced diagram generation and version control in Structurizr projects including documentation-as-code. The image is automatically built and published using a GitHub Actions workflow.

## Why do I need this?

This image is used as a container for the GitHub Action `sebastienfi/structurizr-gen-images` which allows you to generate images for your views automatically for each PR which modifies the `workspace.dsl` file. The generated images are committed into the PR. [Read more about this action](#). A second action `sebastienfi/structurizr-pr-comment` makes a comment on the pull request with the generated images.

You can also build on top of it your own action, or use it locally to generate images without having to install PlantUML or Graphviz yourself.

## Getting the Image

The image is automatically built and published to the GitHub Container Registry. You can pull the image using the following command:

```bash
docker pull ghcr.io/sebastienfi/structurizr-cli-with-bonus:latest
```

Alternatively, to build the image locally:

```bash
git clone git@github.com:sebastienfi/structurizr-cli-with-bonus.git
cd structurizr-cli-with-bonus
docker build -t my-structurizr-image .
```

## How to Use the Image

Run a container based on the image:

```bash
docker run -it --rm -v $(pwd):/workspace ghcr.io/sebastienfi/structurizr-cli-with-bonus:latest
```

This command runs the container interactively, removes it after exit, and mounts the current directory to the container's workspace.

## Included Tools

- **jq**: A lightweight and flexible command-line JSON processor.
- **Git**: For version control of your Structurizr projects.
- **Graphviz**: Enables graph-based diagram representations.
- **PlantUML**: Supports UML diagram generation within Structurizr.


## Contributing

If you have suggestions for improving this Docker image, please submit an issue or pull request to the repository.
