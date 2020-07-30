#
# Shiny app for inspecting GWAS results
#

# To run within Aridhia workspace uncomment this:
#.libPaths("/home/workspace/R/3.6.3")

library(shiny)
library(qqman)
library(data.table)
library(CMplot)
library(manhattanly)
library(plotly)

# Define UI for the application
ui <- navbarPage("GWAS Results Analysis",
        tabPanel("Interactive Manhattan",
            plotlyOutput("interactive_manhattan")
         ),
         
        tabPanel("Manhattan plot",
                 
            sidebarLayout(
                # Wrap up all the parameter controls in a panel
                sidebarPanel(
                    
                    # Selector for rectangular/circular Manhattan plot
                    radioButtons("manhattan_type", "Plot type", c("Rectangular Manhattan"="rect", "Circular Manhattan"="circ")),
                    
                    # Color scheme
                    selectInput("colour_scheme", "Colour scheme:",
                                list('Grey', 'Blue', 'Blue & Orange', 'Earth', 'Rainbow')),
                    
                    # Options for rectangular Manhattan plot
                    conditionalPanel(condition = "input.manhattan_type == 'rect'",
                        # Chromosomes to plot
                        selectInput("chromosome", "Choose chromosome to plot:",
                                    list("All", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 
                                         14, 15, 16, 17, 18, 19, 20, 21, 22)),
                        # Point size
                        sliderInput(inputId = "point_size", 
                                    label = "Point size",
                                    min = 0.05, 
                                    max = 1, 
                                    step = 0.05,
                                    value = 1),
                        # Checkboxes for significance lines
                        checkboxInput(inputId = "suggest_line",
                                      label = "Suggestive line", 
                                      value = TRUE),
                        checkboxInput(inputId = "geno_line",
                                      label = "Genome-wide significance line", 
                                      value = TRUE),  
                        checkboxInput(inputId = "all_snps",
                                      label = "Annotate all significant SNPs", 
                                      value = TRUE),
                    ),
                    
                    # Options for circular Manhattan plot
                    conditionalPanel(condition = "input.manhattan_type == 'circ'",
                                     # Inward out outward plot
                                     radioButtons("circ_type", "Type", c("Inward plot"="inw", "Outward plot"="outw"), selected='outw'),
                    ),
                    
                ),
                # The mainPanel is the main part of the UI on the right.
                mainPanel(
                    # A caption will be displayed above the chart
                    h3(textOutput(outputId = "caption", container = span)),
                    
                    # The chart or plot
                    plotOutput("manhattan_plot")
                )
            )
        ),
        
        tabPanel("QQ Plot",
            sidebarLayout(
                sidebarPanel("QQ Plot",
                    checkboxInput(inputId = "qqplot_conf",
                                  label = "Include confidence interval", 
                                  value = FALSE),
                ),
                mainPanel(
                     plotOutput("qq_plot")
                )
            )
        ),
         
         tabPanel("SNP Density",
              sidebarLayout(
                  sidebarPanel(
                      radioButtons("plotTyp", "Plot type", c("SNP density"="p"))
                  ),
                  mainPanel(
                      plotOutput("snp_density")
                  )
              )
         )
)

# Define server logic for the application
server <- function(input, output) {

    # fix for mini_app greying-out after 10 min of inactivity
    autoInvalidate <- reactiveTimer(10000)
    observe({
        autoInvalidate()
        cat(".")
    })


    # Read in data
    data_dir <- '../gwas/output/load.assoc.logistic'
    gwas <- fread(data_dir, select = c('CHR', 'SNP', 'BP', 'P'))
    gwas_cm <- fread(data_dir, select = c('SNP', 'CHR', 'BP', 'P'))
    
    
    # Construct the plot if we have valid parameters
    output$manhattan_plot <- renderPlot({
        
        cols = switch(   
            input$colour_scheme,   
            "Grey"= c("grey30","grey60"),
            "Blue"= c("dodgerblue4", "deepskyblue"),  
            "Blue & Orange"=  c("blue4", "orange3"), 
            "Earth"= c("#d9bb9c", "#28231e", "#4b61ba", "#deb7a0", "#a87963"),
            "Rainbow"= c("#4197d8", "#f8c120", "#413496", "#495226",
                         "#d60b6f", "#e66519", "#d581b7", "#83d3ad", "#7c162c", "#26755d")
        )   
        
        if (input$manhattan_type == 'rect') {
        
            # Set suggestive and genome-wide line y values
            if (input$suggest_line) suggest_y <- -log10(1e-5) else suggest_y <- FALSE
            if (input$geno_line) geno_y <- -log10(5e-08) else geno_y <- FALSE
            if (input$all_snps) p_thresh <- 5e-08 else p_thresh <- FALSE
            
            if (input$chromosome == 'All') {
                
                manhattan(gwas, chr="CHR", bp="BP", snp="SNP", p="P",
                          cex = input$point_size,
                          ylim = c(0, 20), 
                          annotatePval = p_thresh,
                          annotateTop = FALSE,
                          col = cols, 
                          suggestiveline = suggest_y, 
                          genomewideline = geno_y)
            } else {
    
                manhattan(subset(gwas, chr="CHR", bp="BP", snp="SNP", p="P", CHR == input$chromosome),
                          cex = input$point_size, 
                          ylim = c(0, 20), 
                          annotatePval = p_thresh,
                          annotateTop = FALSE,
                          suggestiveline = suggest_y, 
                          genomewideline = geno_y)
            }
        } else {
            
            if (input$circ_type == 'outw') outward <- TRUE else outward <- FALSE
            
            CMplot(gwas_cm, plot.type="c", r=700, cir.legend=TRUE, 
                   col=cols, 
                   cir.band=1500, H=3000, cex=0.4, signal.cex=0.7,
                   threshold.lty=c(1,2), threshold.col=c("red","blue"), signal.line=1, signal.col=c("red","green"), threshold=c(5e-8, 1e-5),
                   outward=outward, cir.legend.col="black", cir.chr.h=700, chr.den.col="black", band=1,
                   chr.labels = paste("", c(1:24), sep=""), mar=c(0, 0, 0, 0),
                   file.output=FALSE)
        }
    })
    
    
    output$qq_plot <- renderPlot({
        
        #qq(gwas$P)
        CMplot(gwas_cm, plot.type="q", box=FALSE,file.output=FALSE, mar=c(2, 2, 2, 2), 
               main=NULL, cex.lab=1, ylim=c(0, 20), col='black',
               conf.int=input$qqplot_conf, conf.int.col=NULL, threshold.col="red", threshold.lty=2)
    })
    
    output$snp_density <- renderPlot({
        CMplot(gwas_cm, type="p", plot.type="d", bin.size=1e6, 
               chr.den.col=c("darkgreen", "yellow", "red"), file.output=FALSE)
    })
    
    output$interactive_manhattan <- renderPlotly({
        manhattanly(gwas, snp="SNP", point_size=5, col=c("#4197d8", "#f8c120", "#413496", "#495226",
                         "#d60b6f", "#e66519", "#d581b7", "#83d3ad", "#7c162c", "#26755d"))
    })
    
    
}

# Run the application
shinyApp(ui = ui, server = server)