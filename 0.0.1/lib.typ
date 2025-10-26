#import "utils.typ": *

#let LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

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

    // variables for the document
    let _ = counter("chcounter")
    let _ = counter("appendix")

    // generic text settings
    set text(
        font: "Helvetica",
        size: 11pt,
        hyphenate: false,
    )

    // make the title page
    titlepage(
      title,
      author,
      university,
      school,
      degree
    )

    // dedication
    if dedication != none {
        v(192pt)
        align(center)[
          #dedication
        ]
        pagebreak()
    }

    // set page layout
    set page(
        number-align: center, // left, center, right
        margin: 1.0in,
        numbering: "1",
    )

    // heading settings
    show heading.where(level: 1): heading => {
        set text(font: "Helvetica", size: 17pt, weight: "extrabold")
        set block(above: 1.5em, below: 2.0em) // more breathing room after H1
        set par(leading: 0.6em)
        heading
    }

    show heading.where(level: 2): heading => {
        set text(font: "Helvetica", size: 14pt)
        set block(above: 1.3em, below: 1.4em) // still distinct but tighter
        set par(leading: 0.6em)
        heading
    }

    show heading.where(level: 3): heading => {
        set text(font: "Helvetica", size: 12pt)
        set block(above: 1.3em, below: 1.0em) // closer to body text
        set par(leading: 0.6em)
        heading
    }

    show heading.where(level: 4): heading => {
        set text(font: "Helvetica", size: 11pt, weight: "bold", style: "italic")
        set block(above: 1.2em, below: 1.2em) // very tight, almost inline
        set par(leading: 0.6em)
        heading
    }

    // footnotes
    show footnote: set text(size: 9pt)

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
        leading: 1.25em,
        justify: true,
        spacing: 2.0em 
    )

    show bibliography: bib => {
        // reduce spacing in the bibliography since it looks
        // too spaced out with the default settings above
        set par(
            leading: 0.45em,
            spacing: 1.0em
        )
        bib
    }

    
    // table settings/style
    set table(
        stroke: (_, y) => (
            left: { 0pt },
            right: { 0pt },
            top: if y < 1 { stroke(1pt) } else if y == 1 { none } else { 0pt },
            bottom: if y < 1 { stroke(.5pt) } else { stroke(1pt) },
        ),
        align: (x, y) => (
            if x > 0 { center }
            else { left }
        ),
        inset: 5pt
    )


    // figure settings/style
    show figure.caption: set text(size: 10pt)

    // https://forum.typst.app/t/how-to-customize-the-styling-of-caption-supplements/976/2
    show figure.caption: it => context [
        *#it.supplement~#it.counter.display()#it.separator*#it.body
    ]

    // table settings/style
    show table: table => {
        set text(size: 10pt)
        set par(leading: 0.3em)
        table
    }

    // put table captions on top, fix supplement, align caption at center
    show figure.where(kind: table): set figure.caption(position: top)
    show figure.where(kind: table): set figure(supplement: "Table")
    show figure.caption.where(kind: table): set align(center)
    
    // outline for table of contents
    show outline.entry: set par(leading: 0.4em)
    show outline.entry.where(level: 1): set block(above: 1.2em)
    show outline.entry.where(level: 1): set text(weight: "bold")

    // figure list outline
    show outline
        .where(target: figure.where(kind: image))
        .or(outline.where(target: figure.where(kind: table))): it => {
            show outline.entry.where(level: 1): it => {
                set text(weight: "regular") // dont bold figure list
                set par(leading: 0.3em)
                set block(above: 0.6em)
                it
            }
            it
    }

    // table list outline
    show outline.where(target: figure.where(kind: table)): set par(leading: 0.6em)

    // equations
    set math.equation(numbering: "(1)")

    // bibliography settings
    show bibliography: set par(spacing: 0.6em)
    show bibliography: set text(size: 10pt)

    doc
}

// instantiate a new chapter. this lets us reset the counters for figures
#let chapter(
    title: none,
    doc
) = {
    // increment chapter counter
    let cnt = counter("chapter")
    cnt.step()

    // figure numbering so that the chapter is included (1.1, 1.2, 2.1, ...)
    set figure(
        numbering: (..num) => numbering("1.1", int(cnt.display()), num.pos().first())
    )
    context [= Chapter #cnt.display(): #title]
    doc
}

// instantiate a new chapter. this lets us reset the counters for figures
#let appendix(
    title: none,
    doc
) = {
    // increment chapter counter
    let cnt = counter("appendix")
    cnt.step()

    // figure numbering so that the appendix is included (A.1, A.2, ...)
    set figure(
        supplement: "Supplementary Figure",
        numbering: (..num) => numbering("A.1", int(cnt.display()), num.pos().first())
    )

    // table numbering
    show figure.where(kind: table): set figure(supplement: "Supplementary Table")

    context [= Appendix #LETTERS.at(int(cnt.display()) - 1): #title]
    doc
}

#let authors(
    authors: none,
    affiliations: none,
) = {
    set par(leading: 0.6em)
    set text(size: 10pt)
    block(width: 100%)[
        #authors.map(a => {
            if a.me [*#a.name*] else [#a.name]
            [#super(a.affiliations)]
        }).join(", ")\
    ]
    set text(size: 9pt)
    block(width: 100%)[
        #affiliations.enumerate().map((aff) => {
            let n = aff.at(0) + 1
            [#super([#n])]
            [#aff.at(1)]
        }).join("\n")
    ]
}

#let figure-caption-extended(
    caption: none
) = {
    set text(size: 10pt)
    set par(leading: 0.6em)
    block(
        inset: (right: 6pt, left: 6pt, top: -6pt),
        fill: rgb("#fafafa")
    )[
        #caption
    ]
}

#let informational-note(
    content
) = {
    set par(leading: 0.6em)
    set text(size: 10pt)
    set align(center)
    block(
        inset: 6pt,
        fill: rgb("#e3e3e3")
    )[
        *Note:* #content
    ]
}

#let todo(
    content
) = {
    set par(leading: 0.6em)
    set text(size: 12pt, fill: white)
    set align(center)
    block(
        inset: 12pt,
        fill: red
    )[
        *TODO:* #content
    ]
}