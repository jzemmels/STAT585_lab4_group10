library(shiny)
library(tidyverse)
library(plotly)

county <- read_csv("../data/storyCountyMap.csv")
liquorSpatial <- read_csv("../data/liquor_cleanForSpatial.csv")

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$map <- renderPlotly({
    liquor_brandCounts <- liquorSpatial %>%
      group_by(lat,lon,brand) %>%
      summarise(count=n())
    
    plt <- county %>%
      ggplot(aes(x=long,y=lat)) +
      geom_path() +
      theme_bw() + 
      geom_point(data = filter(liquor_brandCounts,brand %in% input$brand),
                 aes(x=lon,y=lat,size=count,colour=brand))
    
    plt <- ggplotly(plt)
    return(plt)
  })
}