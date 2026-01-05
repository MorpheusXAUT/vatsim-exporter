FROM rust:latest AS build
WORKDIR /usr/src/vatsim-exporter
COPY Cargo.toml Cargo.lock ./
COPY src src
RUN cargo install --path .

FROM debian:bookworm-slim AS runner
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libssl-dev \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/local/cargo/bin/vatsim-exporter /usr/local/bin/vatsim-exporter
EXPOSE 9185
CMD ["vatsim-exporter"]