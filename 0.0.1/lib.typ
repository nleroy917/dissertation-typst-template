#import "utils.typ": *

#let titlepage(
  title,
  author,
  university,
  school,
  degree
) = {
    [
      #set text(size: 14pt)
      #set align(center)
      #stack(
        dir: ttb,
        spacing: 64pt,
        text(size: 16pt)[
            #upper([*#title*])
        ],
        [by],
        [#author],
        [A DISSERTATION],
        [
            Submitted to the #school\
            #university
        ],
        [
            In partial fulfillment of the requirements\
            for the degree of            
        ],
        [#degree],
        [
            #month-year-time-stamp()
        ]
      )
    ]
    pagebreak()
}

#let dissertation(
    title: none,
    author: "",
    university: "",
    school: "",
    degree: "",
    dedication: none,
    doc
) = {

    //
    // text settings
    // 
    set text(
        font: "Helvetica",
        size: 12pt,
        hyphenate: false,
    )

    // TITLE PAGE
    titlepage(
      title,
      author,
      university,
      school,
      degree
    )

    // DEDICATION
    if dedication != none {
        v(192pt)
        align(center)[
          #dedication
        ]
        pagebreak()
    }

    //
    // set page layout
    // 
    set page(
        number-align: center, // left, center, right
        margin: 0.5in,
        numbering: "1",
    )

    //
    // heading settings
    // 
    show heading.where( level: 1 ): set text(
        font: "Helvetica",
        size: 24pt,
        weight: "extrabold"
    )
    show heading.where( level: 2 ): set text(
        font: "Helvetica",
        size: 20pt,
    )
    show heading.where( level: 3 ): set text(
        font: "Helvetica",
        size: 12pt,
    )
    show heading.where( level: 4 ): set text(
        font: "Helvetica",
        size: 10pt,
        weight: "regular",
    )

    // counter reset after each chapter
    show heading.where(level: 1): it => {
        counter(math.equation).update(0)
        counter(figure.where(kind: image)).update(0)
        counter(figure.where(kind: table)).update(0)
        counter(figure.where(kind: raw)).update(0)
        it
    }

    // fix for citation superscript issue
    set super(typographic: false)

    // paragraph settings
    set par(
        leading: 5pt,
        justify: true,
        spacing: 1.2em,
        first-line-indent: 1.2em,    
    )

    
    // table settings/style
    show table.cell.where(y: 0): strong
    set table(
        stroke: (x, y) => if y == 0 {
            (bottom: 0.7pt + black)
        },
        align: (x, y) => (
            if x > 0 { center }
            else { left }
        )
    )

    //
    // figure settings/style
    // 
    show figure.caption: set text(size: 10pt)
    show figure.caption: set align(left)
    // https://forum.typst.app/t/how-to-customize-the-styling-of-caption-supplements/976/2
    show figure.caption: it => context [
        *#it.supplement~#it.counter.display()#it.separator*#it.body
    ]

    // put table captions on top
    show figure.where(kind: table): set figure.caption(position: top)

    // outline for table of contents
    show outline.entry.where(level: 1): set outline.entry(fill: none)
    show outline.entry.where(level: 1): set block(above: 1.2em)
    show outline.entry.where(level: 1): set text(weight: "bold")

    doc
}

// instantiate a new chapter. this lets us reset the counters for figures
#let chapter(
    title: none,
    number: 0,
    doc
) = {
    // figure numbering so that the chapter is included (1.1, 1.2, 2.1, ...)
    set figure(
        supplement: [Figure],
        numbering: (..num) => numbering("1.1", number, num.pos().first())
    )
    [= #title]
    doc
}