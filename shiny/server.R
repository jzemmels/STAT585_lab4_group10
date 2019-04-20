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
  
  output$aspect <- renderUI({
    if(input$analysis == "brand"){
      selectInput(inputId = "brand",label = "Brand", multiple = TRUE,
                  choices = list("Absolut",
                                 "Bacardi",
                                 "Captain Morgan",
                                 "Crown Royal",
                                 "Fireball",
                                 "Hennessy",
                                 "Jack Daniels",
                                 "Jagermeister",
                                 "Jameson",
                                 "Kahlua",
                                 "Malibu",
                                 "Paramount",
                                 "Rumchata",
                                 "Smirnoff",
                                 "Southern Comfort",
                                 "Svedka",
                                 "Tanqueray",
                                 "Titos",
                                 "UV"),
                  selected = "Absolut"
      )
    }
    else{
      selectInput(inputId = "type", label = "Drink Type", multiple = TRUE,
                  choices = list("whiskey",
                                 "vodka",
                                 "brandy",
                                 "rum",
                                 "other"), selected = "whiskey")
    }
    
  })
  
  output$map <- renderPlotly({
    if(input$analysis=="brand"){
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
    }      
    if(input$analysis=="type"){
      liquor_typeCounts <- liquorSpatial %>%
        rename(type=category.type) %>%
        group_by(lat,lon,type) %>%
        summarise(count=n())
      
      plt <- county %>%
        ggplot(aes(x=long,y=lat)) +
        geom_path() +
        theme_bw() + 
        geom_point(data = filter(liquor_typeCounts, type %in% input$type),
                   aes(x=lon,y=lat,size=count,colour=type))
      plt <- ggplotly(plt)
      return(plt)
    }
  })
}