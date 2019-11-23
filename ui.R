library(shiny)
library(shinydashboard)

shinyUI(
    dashboardPage(
        dashboardHeader(title = "ColorPanel"),
        dashboardSidebar(
            sidebarMenu(id = "tabs",
                menuItem("Examples", tabName = "examples"),
                menuItem("Color picker", tabName = "colorPicker"),
                selectInput("colorPanelName", "Name:",
                            c("Nature Publishing Group" = "npg",
                              "American Association for the Advancement of Science" = "aaas",
                              "The New England Journal of Medicine" = "nejm",
                              "Lancet Journal" = "lancet",
                              "The Journal of the American Medical Association" = "jama",
                              "Journal of Clinical Oncology" = "jco",
                              "UCSC Genome Browser chromosome colors" = "ucscgb",
                              "D3.js" = "d3",
                              "LocusZoom" = "locuszoom",
                              "Integrative Genomics Viewer" = "igv",
                              # "Catalogue Of Somatic Mutations in Cancers" = "cosmic"),
                              "University of Chicago" = "uchicago",
                              "Star Trek" = "startrek",
                              "Tron Legacy" = "tron",
                              "Futurama" = "futurama",
                              "Rick and Morty" = "rickandmorty",
                              "The Simpsons" = "simpsons"
                              # "GSEA GenePattern" = "gsea",
                              # "Material Design" = "material"
                            )
                ),
                uiOutput("paletteTypes"),
                sliderInput("alpha",
                            "Transparency level:",
                            min = 0, max = 1,
                            value = 1, step = 0.05),
                uiOutput("colorCount"),
                actionButton("generate", "Generate")
                )
            ),
        dashboardBody(
            tabItems(
                tabItem(tabName = "examples",
                        box(width = 12,
                        sliderInput("sampleRange", 
                                    "Number Range:",
                                    min = 2, max = 25, step = 1, value = c(8, 11))),
                        uiOutput("colorPanelIntro"),
                ),
                tabItem(tabName = "colorPicker",
                        uiOutput("colorBoxes")
                )
            )
        )
    )
)