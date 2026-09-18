#let signatur(signaturdata) = stack(
  dir: ttb,
  spacing: 13.2pt,
  signaturdata.at("navn"),
  signaturdata.at("enhet"),
)

#let signaturblokk(signaturer) = {
  if signaturer.len() > 0 {
    block(width: 100%, breakable: false, above: 33.82pt, inset: (y: 3pt))[
      #block(below: 20.7pt)[Med vennlig hilsen]
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 10%,
        row-gutter: 12pt,
        ..signaturer.map(signatur),
      )
    ]
  }
}
