library(shiny)
library(tidyverse)
library(plotly)
library(ggplot2)

county <- read_csv("../data/storyCountyMap.csv")
liquorSpatial <- read_csv("../data/liquor_cleanForSpatial.csv")
liquorTemporal <- read_csv("../data/liquor_cleanForTemporal.csv")

server <- function(input, output) {
  
  output$temporalPlot <- renderPlotly({
    if (input$responseVar=="Sale..Dollars."){
      plt <- liquorTemporal %>% group_by(year) %>% summarise(Total=sum(Sale..Dollars., na.rm = T)) %>% filter(year!=2019) %>% ggplot(aes(x=year, y=Total)) + geom_line()
      plt <- ggplotly(plt)
      return(plt) 
    }
    if (input$responseVar=="Bottles.Sold"){
      plt <- liquorTemporal %>% group_by(year) %>% summarise(Total=sum(Bottles.Sold, na.rm = T)) %>% filter(year!=2019) %>% ggplot(aes(x=year, y=Total)) + geom_line()
      plt <- ggplotly(plt)
      return(plt) 
    }
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