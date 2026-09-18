#let mottakerrad(etikett, verdi) = [
  #etikett: #verdi
]

#let mottakerblokk(data) = {
  let mottaker = data.at("mottaker")
  let identtype = mottaker.at("identType")
  let radavstand = 13.2pt
  let rader = ()

  if identtype == "FNR" {
    rader = (
      mottakerrad("Navn", mottaker.at("navn")),
      mottakerrad("Fødselsnummer", mottaker.at("ident")),
      mottakerrad("Dato", data.at("dato")),
      mottakerrad("Saksnummer", data.at("saksnummer")),
    )
  } else if identtype == "HPRNR" {
    rader = (
      mottakerrad("Til", mottaker.at("navn")),
      mottakerrad("HPR-nummer", mottaker.at("ident")),
      mottakerrad("Dato", data.at("dato")),
      mottakerrad("Vår referanse", data.at("saksnummer")),
    )
  } else {
    panic("Ukjent identType: " + str(identtype))
  }

  stack(dir: ttb, spacing: radavstand, ..rader)
}
