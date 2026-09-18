FROM ghcr.io/navikt/pdfgenrs:1.0.33

ENV RUST_LOG=trace

COPY templates /app/templates
COPY fonts /app/fonts
COPY data /app/data
COPY resources /app/resources
COPY lib /app/lib
