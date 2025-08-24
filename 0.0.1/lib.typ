#import "utils.typ": *

#let maketitle(title) = {
    block(width: 100%)[
        #set align(left)
        = #title
    ]
}

#let maketitlepage(
  title,
  author,
  university,
  school,
  degree
) = {
    [
      #set text(size: 16pt)
      #set align(center)
      #stack(
        dir: ttb,
        spacing: 64pt,
        text(size: 18pt)[
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
            #monthYearTimeStamp()
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
    doc
) = {

    // TITLE PAGE
    maketitlepage(
      title,
      author,
      university,
      school,
      degree
    )

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
        size: 18pt,
        weight: "extrabold"
    )
    show heading.where( level: 2 ): set text(
        font: "Helvetica",
        size: 16pt,
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

    //
    // text settings
    // 
    set text(
        font: "Helvetica",
        size: 12pt,
        hyphenate: false,
    )


    // fix for citation superscript issue
    set super(typographic: false)

    // paragraph settings
    set par(
        leading: 5pt,
        justify: true,
        spacing: 0.6em,
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
    show figure.caption: set text(size: 8pt)
    show figure.caption: set align(left)
    // https://forum.typst.app/t/how-to-customize-the-styling-of-caption-supplements/976/2
    show figure.caption: it => context [
        *#it.supplement~#it.counter.display()#it.separator*#it.body
    ]
    show figure.where(
        kind: table
    ): set figure.caption(position: top)
    set figure(
        supplement: [Fig.],
    )
    
    doc
}