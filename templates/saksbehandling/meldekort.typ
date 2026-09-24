#import "/lib/saksbehandling/layout.typ": heading-1-size, heading-3-size

#let brødtekst-size = 12pt
#let liten-tekst-size = 9pt

#let sidemarg = 1.27cm
#let seksjon-gap = 16pt
#let avsnitt-gap = 8pt
#let uke-gap = 10pt
#let dag-innrykk = 6pt
#let logo-bredde = 36pt

#let data = json("/data/saksbehandling/meldekort.json")

#let overskrift(nivå, størrelse, innhold, over: seksjon-gap, under: uke-gap) = {
  show heading: it => block(above: over, below: under)[
    #set text(size: størrelse, weight: "bold")
    #it.body
  ]
  heading(level: nivå, innhold)
}

#let formater-ident(ident) = {
  let tekst = str(ident)
  if tekst.len() == 11 {
    tekst.slice(0, 6) + " " + tekst.slice(6)
  } else {
    tekst
  }
}

#let formater-timer(verdi) = {
  let tekst = str(verdi)
  if tekst.ends-with(".0") {
    tekst = tekst.slice(0, -2)
  }
  tekst.replace(".", ",")
}

#let dokumentoverskrift(data, uker) = {
  if uker.len() == 0 {
    "Registrering av meldeplikt " + str(data.at("meldeDato"))
  } else if data.at("korrigert", default: false) {
    "Korrigering av meldekort for " + str(data.at("meldeperiode").at("uker"))
  } else {
    "Meldekort for " + str(data.at("meldeperiode").at("uker"))
  }
}

#let seksjon(etikett, innhold) = {
  overskrift(2, heading-3-size, etikett)
  innhold
}

// Ukeblokken holdes samlet over sideskift. En uke er høyst sju dagslinjer og
// får alltid plass på en side, så den kan trygt flyttes i sin helhet.
#let ukeblokk(uke) = block(below: uke-gap, breakable: false)[
  #par[Uke #uke.at("ukenummer") #uke.at("fraOgMedDato") - #uke.at("tilOgMedDato")]
  #pad(left: dag-innrykk)[
    #for dag in uke.at("dager", default: ()) {
      par[#dag.at("dag"): #formater-timer(dag.at("timerArbeid")) timer]
    }
  ]
]

#let uker = data.at("meldekort", default: (:)).at("timerArbeidPerUkeIPerioden", default: ())
#let meldeperiode = data.at("meldeperiode")
#let tittel = dokumentoverskrift(data, uker)

// PDF/UA-1 krever dokumenttittel, alt-tekst på bilder og overskrifter uten
// nivåhopp. pdfgenrs håndhever standarden, så brudd stopper kompileringen.
#set document(title: tittel, description: tittel, author: "Nav")
#set page(
  paper: "a4",
  margin: (top: sidemarg, bottom: sidemarg, left: sidemarg, right: sidemarg),
  footer: context [
    #set text(size: liten-tekst-size)
    #h(1fr)
    side #counter(page).get().first() av #counter(page).final().first()
  ],
)
#set text(font: "Source Sans Pro", lang: "nb", size: brødtekst-size)
#set par(spacing: avsnitt-gap)

#image("/resources/navlogored.png", width: logo-bredde, alt: "Nav-logo")

#block(above: 10mm, below: 18pt)[
  #set text(size: liten-tekst-size)
  #par[Fødselsnummer: #formater-ident(data.at("ident"))]
  #par[Innsendt: #data.at("sendtInnDato")]
]

#overskrift(1, heading-1-size, tittel, over: 0pt)
#par(text(size: heading-3-size)[
  #meldeperiode.at("fraOgMedDato") - #meldeperiode.at("tilOgMedDato")
])

#seksjon("Meldedato", par(data.at("meldeDato")))

#if uker.len() > 0 {
  seksjon("Antall timer arbeidet", uker.map(ukeblokk).join())
  seksjon(
    "Sammenlagt for perioden",
    par[#formater-timer(data.at("sammenlagtArbeidIPerioden", default: 0)) timer arbeidet],
  )
}

#seksjon("Begrunnelse", par(data.at("begrunnelse", default: "")))
#seksjon("Utført av", par(data.at("utførtAv", default: "")))
