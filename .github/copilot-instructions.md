# copilot-instructions.md

This file provides guidance to GitHub Copilot when working with code in this repository.

## Overview

This is an Envoy-based LLM model router implementation that serves as an egress API gateway for routing between different LLM providers (OpenAI, Gemini, etc.). The project consists of a single Envoy configuration file and Docker setup for containerized deployment.

## Core Components

- **envoy.yaml**: Main Envoy proxy configuration that defines routing rules, filters, and clusters
- **Dockerfile**: Multi-platform Docker image build using the official Envoy distroless image

## Development Commands

### Building and Running

```bash
# Build the Docker image
docker build -t agentic-layer/model-router-envoy .

# Run the container with required environment variables
docker run -p 10000:10000 -e OPENAI_API_KEY=your_key_here agentic-layer/model-router-envoy

# Run with docker-compose for easier environment management
docker run -p 10000:10000 --env-file .env agentic-layer/model-router-envoy
```

### Testing the Router

```bash
# Test the proxy endpoint (listens on port 10000)
curl -X POST http://localhost:10000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": "Hello"}]}'
```

## Architecture

The Envoy configuration implements:

1. **HTTP Connection Manager**: Handles incoming HTTP requests on port 10000
2. **Lua Filter**: Automatically injects OpenAI API key from environment variable into Authorization header
3. **Router Filter**: Routes requests to configured upstream clusters
4. **Cluster Configuration**: Defines upstream OpenAI API endpoint (api.openai.com:443) with TLS
5. **Host Rewriting**: Rewrites the host header to api.openai.com for proper API routing

## Key Configuration Details

- **Listener Port**: 10000 (configurable in envoy.yaml)
- **Upstream**: Currently configured for OpenAI API (api.openai.com)
- **TLS**: Enabled for upstream connections with SNI
- **Authentication**: API key injection via Lua filter from `OPENAI_API_KEY` environment variable
- **Access Logging**: Stdout logging enabled for request monitoring

## Environment Variables

- `OPENAI_API_KEY`: Required for OpenAI API authentication (injected by Lua filter)

## Deployment

The project includes a comprehensive GitHub Actions workflow that:
- Builds multi-platform Docker images (linux/amd64, linux/arm64)
- Publishes to GitHub Container Registry (ghcr.io)
- Signs images with cosign for security
- Supports both tag-based and manual workflow dispatch

## File Structure

```
.
├── envoy.yaml          # Main Envoy configuration
├── Dockerfile          # Container build definition
├── README.md           # Project documentation
├── .github/workflows/  # CI/CD pipeline
└── .gitignore         # Git ignore patterns
```

## Extending the Router

To add support for additional LLM providers:

1. Add new cluster definitions in `envoy.yaml` for the provider's API endpoint
2. Update the routing configuration to include path-based or header-based routing rules
3. Modify the Lua filter to handle different authentication methods as needed
4. Update environment variable requirements for additional API keys