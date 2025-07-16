FROM envoyproxy/envoy:distroless-v1.34-latest

COPY envoy.yaml /envoy.yaml

CMD ["-c", "/envoy.yaml"]
