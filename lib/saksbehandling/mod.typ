#import "innhold.typ": render-tekstbolker
#import "layout.typ": dokument, har-overskrift, heading-1-size, overskrift-med-størrelse
#import "mottaker.typ": mottakerblokk
#import "signatur.typ": signaturblokk

#let brev(data) = {
  let overskrift = data.at("overskrift", default: none)
  let vis-overskrift = har-overskrift(overskrift)

  dokument(data)[
    #image("/resources/navlogored.png", height: 56.25pt, alt: "Nav-logo")
    #v(23pt)

    #mottakerblokk(data)
    #v(57.1pt)

    #if vis-overskrift {
      overskrift-med-størrelse(1, heading-1-size, overskrift)
    }
    #render-tekstbolker(
      data.at("tekstbolker"),
      heading-nivå: if vis-overskrift { 2 } else { 1 },
    )
    #signaturblokk(data.at("signaturer"))
  ]
}
