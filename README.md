# Envoy based LLM model router

This is an Envoy based LLM model router implementation. This is an egress API gateway
meant to route between different LLM providers, such as OpenAI or Gemini.

## Setup

```bash
# in order for the proxy to work we have to manually create a Kubernetes secret
# that contains an OPENAI_API_KEY environment variable
kubectl create secret generic openai-api-key --from-literal=OPENAI_API_KEY=$OPENAI_API_KEY
kubectl apply -f kustomize/local/

# to test the proxy, issue the following curl command
curl http://openai.127.0.0.1.sslip.io:10000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
     "model": "gpt-4o-mini",
     "messages": [{"role": "user", "content": "Say this is a test!"}],
     "temperature": 0.7
   }'
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the Apache v2.0 open source license, read the `LICENSE` file for details.