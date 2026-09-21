FROM ghcr.io/navikt/pdfgenrs:1.0.39

ENV RUST_LOG=trace

COPY templates /app/templates
COPY fonts /app/fonts
COPY data /app/data
COPY data /app/resources