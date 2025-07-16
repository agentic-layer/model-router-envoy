FROM envoyproxy/envoy:distroless-v1.34-latest

COPY config/envoy.yaml /envoy.yaml

CMD ["-c", "/envoy.yaml"]
