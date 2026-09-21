#import "/lib/saksbehandling/mod.typ": brev

#let data = json("/data/saksbehandling/brev.json")

#brev(data)