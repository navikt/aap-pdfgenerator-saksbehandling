#import "innhold.typ": render-tekstbolker
#import "layout.typ": dokument
#import "mottaker.typ": mottakerblokk
#import "signatur.typ": signaturblokk

#let brev(data) = {
  let overskrift = data.at("overskrift", default: none)

  dokument(data)[
    #image("/resources/navlogored.png", height: 56.25pt, alt: "Nav-logo")
    #v(23pt)

    #mottakerblokk(data)
    #v(57.1pt)

    #if overskrift != none {
      heading(level: 1, overskrift)
    }
    #render-tekstbolker(data.at("tekstbolker"))
    #signaturblokk(data.at("signaturer"))
  ]
}
