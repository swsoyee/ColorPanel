library(shiny)
library(ggsci)
library(scales)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    selectionListMax <- list(
        "npg-nrc" = 10,
        "aaas-default" = 10,
        "nejm-default" = 8,
        "d3-category10" = 10,
        "d3-category20" = 20,
        "d3-category20b" = 20,
        "d3-category20c" = 20,
        "lancet-lanonc" = 9,
        "jama-default" = 7,
        "jco-default" = 10,
        "ucscgb-default" = 26,
        "locuszoom-default" = 7,
        "igv-default" = 51,
        "igv-alternating" = 2,
        "uchicago-default" = 9,
        "uchicago-light" = 9,
        "uchicago-dark" = 9,
        "startrek-uniform" = 7,
        "tron-legacy" = 7,
        "futurama-planetexpress" = 12,
        "rickandmorty-schwifty" = 12,
        "simpsons-springfield" = 16
    )
    # According to the name has been selected, update the palette types selection.
    observeEvent(input$colorPanelName, {
        selectionList <- list(
            "npg" = c("Nature Reviews Cancer" = "nrc"),
            "lancet" = c("Lancet Oncology" = "lanonc"),
            "d3" = c(
                "Category 10" = "category10",
                "Category 20" = "category20",
                "Category 20b" = "category20b",
                "Category 20c" = "category20c"
            ),
            "igv" = c("Default" = "default", "Alternating" = "alternating"),
            # "cosmic" = c("Hallmarks Light" = "hallmarks_light",
            #              "Hallmarks Dark" = "hallmarks_dark",
            #              "Signature Substitutions" = "signature_substitutions")
            "uchicago" = c(
                "Default" = "default",
                "Light" = "light",
                "Dark" = "dark"
            ),
            "startrek" = c("Uniform" = "uniform"),
            "tron" = c("Legacy" = "legacy"),
            "futurama" = c("Planet Express" = "planetexpress"),
            "rickandmorty" = c("Schwifty" = "schwifty"),
            "simpsons" = c("Spring Field" = "springfield")
        )
        
        if (input$colorPanelName %in% names(selectionList)) {
            output$paletteTypes <- renderUI({
                selectInput("paletteTypes",
                            "Palette Types:",
                            choices = selectionList[[input$colorPanelName]])
            })
        } else {
            output$paletteTypes <- renderUI({
                selectInput("paletteTypes",
                            "Palette Types:",
                            choices = c("Default" = "default"))
            })
        }
        
    })
    
    observeEvent(input$paletteTypes, {
        output$colorCount <- renderUI({
            sliderInput(
                "colorCount",
                "Color(s):",
                min = 1,
                max = selectionListMax[[paste0(input$colorPanelName, "-", input$paletteTypes)]],
                value = selectionListMax[[paste0(input$colorPanelName, "-", input$paletteTypes)]],
                step = 1
            )
        })
    })
    
    observeEvent(input$generate, {
        colors <- do.call(
            paste0("pal_", input$colorPanelName),
            list(input$paletteTypes, input$alpha)
        )(input$colorCount)
        colorButtons <- lapply(1:length(colors), function(i) {
            box(
                width = 12,
                actionButton(
                    inputId = paste0("colorGroupAdd", i),
                    label = "+"
                ),
                actionButton(
                    inputId = paste0("colorGroupRemove", i),
                    label = "-"
                ),
                actionButton(
                    inputId = paste0("colorGroup", i),
                    label = colors[i],
                    style = paste("color: #fff; background-color:", colors[i], ";")
                ),
                uiOutput(paste0("colorGroupAppend", i))
            )
        })
        output$colorBoxes <- renderUI(do.call(fluidPage, c(
            list(id = "colorPage"), colorButtons
        )))
        updateTabItems(session, "tabs", "colorPicker")
    })
    
    # Copy text
    # observeEvent(input$clipbtn, clipr::write_clip(input$copytext))
    
    # Add sub color
    # observeEvent(sapply(1:input$colorCount, function(i){
    #     input[[paste0("colorGroupAdd", i)]]
    #     }), {
    #         sapply(1:input$colorCount, function(i){
    #         output[[paste0("colorGroupAppend", i)]] <- renderUI({
    #             tagList(
    #                 actionButton(
    #                     inputId = paste0("subColor", i),
    #                     label = "Yes"
    #                 ),
    #             )
    #         })
    #     })
    # })
    
    output$colorPanelIntro <- renderUI({
        colorSample <- lapply(1:length(selectionListMax), function(i) {
            output[[names(selectionListMax[i])]] <- renderPlot({
                info <- strsplit(names(selectionListMax[i]), "-")[[1]]
                colorPal <-
                    do.call(paste0("pal_", info[1]), list(info[2]))(selectionListMax[[i]])
                op <- par(mar = c(0.5, 0, 0, 0), bg = '#ecf0f5')
                plot(
                    c(0, length(colorPal)),
                    c(0, 1),
                    type = "n",
                    xlab = "",
                    ylab = "",
                    ann = F,
                    bty = "n",
                    xaxt = "n",
                    yaxt = "n"
                )
                i <- 0:(length(colorPal) - 1)
                rect(0 + i, 0, 1 + i, 1, col = colorPal, lwd = 0)
            })
            if (selectionListMax[i] %in% seq(input$sampleRange[1], input$sampleRange[2]) ||
                (input$sampleRange[2] == 25 && selectionListMax[i] > 25)) {
                tagList(
                    tags$h5(
                        tags$code(names(selectionListMax[i])),
                        "(",
                        selectionListMax[i],
                        ")"
                    ),
                    plotOutput(names(selectionListMax[i]), height = 30)
                )
            }
        })
        
    })
})
