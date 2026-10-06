# aap-pdfgenerator-saksbehandling

## Kjør lokalt

Start Docker og kjør fra prosjektroten:

```bash
bash run_local_dev.sh
```

Åpne denne URL-en i nettleseren for malen du vil se:

```text
http://localhost:8089/api/v1/genpdf/<mappe>/<mal>
```

`<mappe>/<mal>` tilsvarer filen `templates/<mappe>/<mal>.typ`, uten filendelsen.
For eksempel:

<http://localhost:8089/api/v1/genpdf/saksbehandling/meldekort>

Stopp applikasjonen med `Ctrl+C` i terminalen.

## Endre testdata

Rediger `data/<mappe>/<mal>.json` for malen du bruker, for eksempel
`data/saksbehandling/meldekort.json`. Bruk bare syntetiske data.

Lagre filen, start applikasjonen på nytt og last inn URL-en igjen for å se
PDF-en med de nye dataene. Du trenger ikke å bygge et nytt Docker-image.
