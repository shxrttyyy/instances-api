FROM crystallang/crystal:0.35.1-alpine AS builder
WORKDIR /app
COPY ./shard.yml ./shard.yml
RUN shards install
COPY ./src/ ./src/
RUN crystal build ./src/instances.cr --release

FROM alpine:latest
RUN apk add --no-cache gc pcre libgcc
WORKDIR /app
RUN addgroup -g 1000 -S invidious && \
    adduser -u 1000 -S invidious -G invidious
COPY ./assets/ ./assets/
COPY --from=builder /app/instances .

EXPOSE 3000
USER invidious
CMD ["/app/instances"]
