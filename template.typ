// Import dependencies
#import "@preview/tablex:0.0.8": tablex, colspanx

// Heading stuff copied from https://github.com/aurghya-0/Project-Report-Typst and modified
#let buildMainHeader(mainHeadingContent) = {
  [
      // NTNU logo
      #align(right)[
        #move(
          dy: 12mm,
          image(
            "Images/ntnu_logo.png",
            height: 6mm,
          ) 
        )
      ]
      
      // Title
      #align(left)[
        #move(
          dy: 3.5mm,
          mainHeadingContent
        )
      ]

    // Line
    #line(length: 100%)
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent) = {
  [
    #smallcaps(mainHeadingContent)  #h(1fr)  #emph(secondaryHeadingContent) 
    #line(length: 100%)
  ]
}

#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader() = {
  // Set the text
  locate(loc => {
    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(selector(heading).after(loc), loc).find(headIt => {
     headIt.location().page() == loc.page() and headIt.level == 1
    })
    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading.body)
    }
    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level == 1
    }).last()
    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level > 1
    })
    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {previousSecondaryHeadingArray.last()} else {none}
    // Find if the last secondary heading exists and if it's after the last main heading
    if (lastSecondaryHeading != none and isAfter(lastSecondaryHeading, lastMainHeading)) {
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body)
    }
    
    return buildMainHeader(lastMainHeading.body)
  })
}

// Create the project front page
#let project(
  title: "", 
  author: "",
  course: "",
  groupName: "",
  groupNumber: 0,
  summary: "",
  bilag: 0,
  biblNr: "",
  teacher: "",
  semester: "vår 2020",
  body
) = {
  let bar

  // General document setup
  set document(
    author: author,
    title: title,
  )
  set page(
    paper: "a4",
    margin: (
      top: 2.5cm,
      bottom: 4cm,
      left: 2.5cm,
      right: 2.5cm
    )
  )
  set par(
    justify: true
  )
  set text(
    size: 12pt,
    font: "New Computer Modern"
  )

  // ----------------
  // -- First page --
  // ----------------
  [
    // Side bakgrunn
    #set page(background: image("Images/ntnu_front_page.svg"))

    #set place(dx: 65pt)
    #set text(20pt)

    // Tittel
    #place(
      dy: 150pt,
      text(
        size: 28pt,
        title
      )
    )

    // Rapportmal tekst
    #place(
      dy: 550pt,
      text(
        [
          Teknisk rapportmal \
          NTNU Studenter \
          Trondheim, #semester
        ]
      )
      
    )
  ]

  // -----------------
  // -- Second page --
  // -----------------
  pagebreak()
  // Show page numbers starting at page 2 and show custom page 2 heading
  set page(
    numbering: "1",
    header: [
      // NTNU logo
      #align(right)[
        #move(
          dy: 11mm,
          image(
            "Images/ntnu_logo.png",
            height: 6mm,
          ) 
        )
      ]
      // Title
      #align(left)[
        #move(
          dy: 3mm,
          [Prosjektoppgave #semester]
        )
      ]

      // Line
      #line(length: 100%)
    ]
  )
  // Show the table
  align(
    center,
    tablex(
      columns: (auto, auto, auto, auto, auto),
      inset: 2.5mm,
      
      // Author / Forfatter header
      colspanx(5)[
        *Kandidater (etternavn, fornavn):*\
        #author
      ],
  
      // Div info row
      [
        *DATO:*\
        #datetime.today().display()
      ],
      [
        *Fagkode:*\
        #course
      ],
      [
        *Gruppe (navn/nr)*\
        #groupName / #groupNumber
      ],
      [    
        *Sider / Bilag:*\
        // Fetch the page number from the end of the document
        #locate(loc => {
          let end = query(<DOCUMENT_END>, loc)  
          let endPageNumber = counter(page).final(loc).first()
          // Render the text
          [#endPageNumber / #bilag]
        })
      ],
      [
        *BIBL. NR:*\
        // Only show Bibl Nr if provided, else N/A
        #if biblNr == "" {
          [N/A]
        } else {
          [#biblNr]
        }
      ],
  
      // Faglærer row
      colspanx(5)[
        *FAGLÆRER(E):*\
        #teacher
      ],
  
      // Title row
      colspanx(5)[
        *TITTLEL:*\
        #title
      ],
  
      // Summary row
      colspanx(5)[
        *SAMMENDRAG:*\
        #include "Sections/00_Summary.typ"
      ]
    )
  )

  // -----------------------
  // -- Table of Contents --
  // -----------------------
  pagebreak()
  [
    #outline(
      title: "Innhold",
      depth: 3,
      indent: true
    )
  ]
  
  
  // ---------------
  // -- Main Body --
  // ---------------

  // Setup document before main body
  set page(header: getHeader())
  
  show heading.where(level: 1): it => [
    #set text(20pt)
    #block(counter(heading).display() + " " + smallcaps(it.body)) 
  ]

  show heading.where(level:2): it => [
    #set text(16pt)
    #block(counter(heading).display() + " " + smallcaps(it.body))
  ]

  show heading.where(level:3): it => [
    #set text(14pt)
    #block(counter(heading).display() + " " + smallcaps(it.body))
  ]

  show heading.where(level:4): it => [
    #set text(12pt)
    #block(smallcaps(it.body))
  ]

  show heading.where(level:5): it => [
    #set text(12pt)
    #block(smallcaps(it.body))
  ]
  set heading(numbering: "1.1")

  // The actual main body
  body
  
  // Label at the end of body for proper page count
  [
    <DOCUMENT_END>
  ]
}
