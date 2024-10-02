# grpc-go-base-builder

This project provides a Docker-based build environment for Go projects, including tools for database migrations and testing.

## Project Structure

- `Dockerfile`: Defines the Docker image used for building and testing the Go project.
- `README.md`: Documentation for the project.

## Dockerfile Overview

The `Dockerfile` sets up a multi-stage build environment:

1. **Builder Stage**:
    - Based on `ubuntu:bionic`.
    - Installs necessary packages including `wget` and `gnupg-agent`.
    - Downloads and installs the `migrate` tool for database migrations.
    - Downloads and installs the `wait-for` script for synchronizing service dependencies.

2. **Final Stage**:
    - Based on `golang:1.22-alpine`.
    - Sets environment variables for `godog` and `goimports` versions.
    - Installs additional packages including `git`, `make`, and `bash`.
    - Installs Go tools: `gocover-cobertura`, `godog`, and `goimports`.
    - Copies the `migrate` and `wait-for` binaries from the builder stage.

## Usage

To build the Docker image, run:

```sh
docker buildx build --push --platform linux/amd64,linux/arm64 -t gitsid/grpc-go-base-builder:1.22 -t gitsid/grpc-go-base-builder:latest .