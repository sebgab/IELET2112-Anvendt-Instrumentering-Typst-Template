#import "template.typ": *
#set text(lang: "nob")

// Create the front page
#show: project.with(
  title: "Tittel",
  author: "Nordmann, Ola",
  course: "IELET2112",
  groupName: "My Group",
  groupNumber: 10,
  bilag: 0,
  teacher: " ",
  semester: "vår 2024"
)

// Include and display all the subpages
#include "Sections/01_Introduction.typ"
#include "Sections/02_Theory.typ"
#include "Sections/03_Hardware.typ"
#include "Sections/04_Software.typ"
#include "Sections/05_Experiments_and_results.typ"
#include "Sections/06_Conclusions.typ"
#include "Sections/07_Feedback.typ"
#include "Sections/08_References.typ"
#include "Sections/09_Attachments.typ"
