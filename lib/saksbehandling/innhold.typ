#import "layout.typ": har-overskrift, heading-2-size, heading-3-size, overskrift-med-størrelse

#let linjeskift(tekst) = {
  str(tekst).split("\n").join(linebreak())
}

#let har-kant-whitespace(tekst, kant) = {
  let mønster = if kant == "start" { regex("^\\s") } else { regex("\\s$") }
  str(tekst).match(mønster) != none
}

#let render-tekstsegment(segment) = {
  let innhold = linjeskift(segment.at("tekst"))
  let formatteringer = segment.at("formattering")
  let støttede-formatteringer = ("FET", "KURSIV", "UNDERSTREK")

  for formattering in formatteringer {
    if formattering not in støttede-formatteringer {
      panic("Ukjent formattering: " + str(formattering))
    }
  }

  if "FET" in formatteringer {
    innhold = strong(innhold)
  }
  if "KURSIV" in formatteringer {
    innhold = emph(innhold)
  }
  if "UNDERSTREK" in formatteringer {
    innhold = underline(innhold)
  }

  innhold
}

#let render-avsnitt(blokk) = {
  let segmenter = blokk.at("innhold")
  let resultat = []

  for (indeks, segment) in segmenter.enumerate() {
    if indeks > 0 {
      let forrige = segmenter.at(indeks - 1).at("tekst")
      let gjeldende = segment.at("tekst")
      if not har-kant-whitespace(forrige, "slutt") and not har-kant-whitespace(gjeldende, "start") {
        resultat += [ ]
      }
    }
    resultat += render-tekstsegment(segment)
  }

  par(resultat)
}

#let render-liste(blokk) = {
  let punkter = blokk.at("innhold").map(render-tekstsegment)
  list(..punkter)
}

#let render-blokk(blokk) = {
  let blokktype = blokk.at("type")

  if blokktype == "AVSNITT" {
    render-avsnitt(blokk)
  } else if blokktype == "LISTE" {
    render-liste(blokk)
  } else {
    panic("Ukjent blokktype: " + str(blokktype))
  }
}

#let render-innhold(innhold, heading-nivå) = {
  let overskrift = innhold.at("overskrift", default: none)

  if har-overskrift(overskrift) {
    overskrift-med-størrelse(heading-nivå, heading-3-size, overskrift)
  }
  for blokk in innhold.at("blokker") {
    render-blokk(blokk)
  }
}

#let render-tekstbolk(tekstbolk, etter-innhold: false, heading-nivå: 2) = {
  let overskrift = tekstbolk.at("overskrift", default: none)
  let vis-overskrift = har-overskrift(overskrift)
  let heading-nivå-for-barn = if vis-overskrift { heading-nivå + 1 } else { heading-nivå }

  if vis-overskrift {
    if etter-innhold {
      v(10pt, weak: false)
    }
    overskrift-med-størrelse(heading-nivå, heading-2-size, overskrift)
  }
  for innhold in tekstbolk.at("innhold") {
    render-innhold(innhold, heading-nivå-for-barn)
  }
}

#let render-tekstbolker(tekstbolker, heading-nivå: 2) = {
  for (indeks, tekstbolk) in tekstbolker.enumerate() {
    render-tekstbolk(tekstbolk, etter-innhold: indeks > 0, heading-nivå: heading-nivå)
  }
}
