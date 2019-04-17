library(shiny)
library(tidyverse)
library(plotly)

county <- read_csv("../data/storyCountyMap.csv")


server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$map <- renderPlotly({
    plt <- county %>%
      ggplot(aes(x=long,y=lat)) +
      geom_path() +
      theme_bw()
    
    plt <- ggplotly(plt)
    return(plt)
  })
}