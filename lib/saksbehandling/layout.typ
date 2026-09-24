#let page-margin-top = 0.878cm
#let page-margin-horizontal = 1.57cm
#let paragraph-leading = 0em
#let paragraph-spacing = 0cm
#let heading-1-size = 24pt
#let heading-2-size = 18pt
#let heading-3-size = 14pt
#let footer-outset = page-margin-horizontal - 0.3cm

#let spacing-gap = 16pt

// PDF/UA-1 krever en dokumenttittel, og Typst regner tom streng som manglende.
#let standard-dokumenttittel = "Brev fra Nav"

#let har-overskrift(verdi) = verdi != none and str(verdi).trim() != ""

// Størrelsen settes i stilkjeden, ikke på innholdet, slik at par.leading
// regnes ut fra overskriftens størrelse og flerlinjers overskrifter
// beholder luften mellom linjene.
#let overskrift-med-størrelse(nivå, størrelse, innhold) = {
  show heading: it => block(above: spacing-gap, below: spacing-gap)[
    #set text(size: størrelse, weight: "bold")
    #it.body
  ]
  heading(level: nivå, innhold)
}

#let dokument(data, body) = {
  let overskrift = data.at("overskrift", default: none)
  let dokumenttittel = if har-overskrift(overskrift) {
    str(overskrift).trim()
  } else {
    standard-dokumenttittel
  }
  let er-fnr = data.at("mottaker").at("identType") == "FNR"

  set document(
    title: dokumenttittel,
    description: dokumenttittel,
    author: "Nav",
  )
  set page(
    paper: "a4",
    margin: (
      top: page-margin-top,
      bottom: 0.636cm,
      left: page-margin-horizontal,
      right: page-margin-horizontal,
    ),
    footer: context [
      #set text(size: 9pt)
      #block(width: 100%, inset: (left: -footer-outset, right: -footer-outset))[
        #grid(
          columns: (1fr, auto),
          if er-fnr [Saksnummer #data.at("saksnummer")] else [],
          [Side #counter(page).get().first() av #counter(page).final().first()],
        )
      ]
    ],
  )
  set text(font: "Source Sans Pro", lang: "nb", size: 12pt)
  set par(spacing: spacing-gap)
  set list(indent: 20.35pt, body-indent: 0.5em, spacing: 7.5pt, tight: false)
  show heading: it => block(above: spacing-gap, below: spacing-gap, strong(it.body))

  body
}
