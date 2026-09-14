#let data = json("/data/innsikt/vurderinger.json")

#show terms.item: it => block(width: 100%)[
  #text(weight: "semibold")[#it.term:]
  #h(0.3em)
  #it.description
]

#let wrap-cell(value) = {
    if value.match(regex("^\\d{2}\\.\\d{2}\\.\\d{4} \\d{2}:")) != none {
        return value.split(" ").map(wrap-cell).join(linebreak())
    }
    value.replace(regex("[^\\s]{12,}"), match => {
        // Allow identifiers to wrap without inserting visible hyphens into their values.
        if match.text.match(regex("[0-9_]")) != none {
            match.text.clusters().join("\u{200b}")
        } else {
            match.text
        }
    })
}

#set document(title: data.at("tittel", default: "ingen tittel"))
#set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
    header: [
        #set text(size: 9pt, fill: rgb("#4b5563"))
        #block(width: 100%, inset: (bottom: 6pt), stroke: (bottom: 0.5pt + rgb("#b1b5b9")))[
            #data.at("tittel")
        ]
    ],
    footer: context [
        #set text(size: 9pt, fill: rgb("#4b5563"))
        #h(1fr)
        Side  #counter(page).display("1/1", both:true)
    ],
)
#set text(font: "Source Sans Pro", lang: "nb", size: 11pt)
#show heading.where(level: 2): set block(above: 24pt)

#let render(elem) = [
    #if elem.at("type") == "avsnitt" [
        #elem.at("avsnitt")
        #parbreak()
    ] else if elem.at("type") == "overskrift" [
        #if elem.at("nivå") == none [
            #strong(elem.at("overskrift"))
            #parbreak()
        ] else [
            #heading(
                level: elem.at("nivå"),
                numbering: "1.1 ",
                elem.at("overskrift"))
        ]
    ] else if elem.at("type") == "liste" [
        #for (key, value) in elem.at("liste") [
            / #key: #value
        ]
    ] else if elem.at("type") == "tabell" [
        #set text(size: 9pt, hyphenate: true)
        #table(
            columns: (1.5fr,) + (1fr,) * (elem.at("kolonner").len() - 1),
            align: left + top,
            inset: (x: 4pt, y: 5pt),
            stroke: 0.4pt + rgb("#c6c8ca"),
            fill: (_, y) => if calc.odd(y) { rgb("#f7f7f7") },
            table.header(..elem.at("kolonner").map(kolonne =>
                table.cell(fill: rgb("#e9ecef"), text(weight: "semibold", wrap-cell(kolonne)))
            )),
            ..elem.at("rader").flatten().map(wrap-cell),
         )
    ]
]

#for elem in data.at("body") [
    #render(elem)
]