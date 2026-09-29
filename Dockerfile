FROM ghcr.io/navikt/pdfgenrs:1.0.42

ENV RUST_LOG=trace
ENV COMPILE_TIMEOUT_SECONDS=60

COPY templates /app/templates
COPY fonts /app/fonts
COPY data /app/data
COPY resources /app/resources
COPY lib /app/lib
