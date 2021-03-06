library(shiny)
library(tidyverse)
library(plotly)
library(ggplot2)

county <- read_csv("../data/storyCountyMap.csv")
liquorSpatial <- read_csv("../data/liquor_cleanForSpatial.csv")
liquorTemporal <- read_csv("../data/liquor_cleanForTemporal.csv")

server <- function(input, output) {
  
  output$Unit <- renderUI({
    if(input$responseVar == "Sale..Dollars."){
      radioButtons(inputId = "unit_of_time",label = "Unit of Time",
                  choices = list("week",
                                 "month",
                                 "quarter",
                                 "year")
      )}
    else{
      radioButtons(inputId = "unit_of_time",label = "Unit of Time",
                  choices = list("week",
                                 "month",
                                 "quarter",
                                 "year")
      )
      }
  })
  
   output$temporalPlot <- renderPlotly({
#      plt <- liquorTemporal %>% group_by(year) %>% 
#        summarise(Total=sum(Sale..Dollars., na.rm = T)) %>% 
#        filter(year!=2019) %>% 
#        ggplot(aes(x=year, y=Total)) + geom_line() + ylab("Total sales in dollars")
#      plt <- ggplotly(plt)
#      return(plt) 
###########################################
     if (input$responseVar=="Sale..Dollars."){
      if (input$unit_of_time=="week"){
        liquorTemporal$week=factor(liquorTemporal$week, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))
        plt <- liquorTemporal %>% group_by(year) %>% filter(Sale..Dollars.<=200) %>%
          ggplot(aes(x=week, y=Sale..Dollars.)) + geom_boxplot() + ylab("Sale in dollars, filtered extreme value") + facet_wrap(~year, ncol = 2)
        plt <- ggplotly(plt)
        return(plt) 
      }
      else if (input$unit_of_time=="month"){
        plt <- liquorTemporal %>% group_by(year) %>% filter(Sale..Dollars.<=200) %>%
          ggplot(aes(x=as.factor(month), y=Sale..Dollars.)) + geom_boxplot() + ylab("Sale in dollars, filtered extreme value") + xlab("month") + facet_wrap(~year, ncol = 2)
        plt <- ggplotly(plt)
        return(plt) 
      }
      else if (input$unit_of_time=="quarter"){
        plt <- liquorTemporal %>% group_by(year) %>% filter(Sale..Dollars.<=200) %>%
          ggplot(aes(x=as.factor(quarter), y=Sale..Dollars.)) + geom_boxplot() + ylab("Sale in dollars, filtered extreme value") + xlab("quarter") + facet_wrap(~year, ncol = 2)
        plt <- ggplotly(plt)
        return(plt) 
      }
      else {      
        plt <- liquorTemporal %>% group_by(year) %>% 
        summarise(Total=sum(Sale..Dollars., na.rm = T)) %>% 
        filter(year!=2019) %>% 
        ggplot(aes(x=year, y=Total)) + geom_line() + ylab("Total Sale in dollars")
      plt <- ggplotly(plt)
      return(plt) 
      }
     }
     
###########################################
    if (input$responseVar=="Bottles.Sold"){
#      plt <- liquorTemporal %>% group_by(year) %>% 
#        summarise(Total=sum(Bottles.Sold, na.rm = T)) %>% 
#        filter(year!=2019) %>% 
#        ggplot(aes(x=year, y=Total)) + geom_line() + ylab("Total bottles sold")
#      plt <- ggplotly(plt)
#      return(plt) 
      if (input$unit_of_time=="week"){
        liquorTemporal$week=factor(liquorTemporal$week, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))
        plt <- liquorTemporal %>% group_by(year) %>%
          ggplot(aes(x=week, y=Bottles.Sold)) + geom_boxplot() + ylab("Bottles sold") + facet_wrap(~year, ncol = 2)
        plt <- ggplotly(plt)
        return(plt) 
      }
      else if (input$unit_of_time=="month"){
        
        plt <- liquorTemporal %>% group_by(year) %>%
          ggplot(aes(x=as.factor(month), y=Bottles.Sold)) + geom_boxplot() + ylab("Bottles sold") + xlab("month") + facet_wrap(~year, ncol = 2)
        plt <- ggplotly(plt)
        return(plt) 
      }
      else if (input$unit_of_time=="quarter"){
        plt <- liquorTemporal %>% group_by(year) %>%
          ggplot(aes(x=as.factor(quarter), y=Bottles.Sold)) + geom_boxplot() + ylab("Bottle sold") + xlab("quarter") + facet_wrap(~year, ncol = 2)
        plt <- ggplotly(plt)
        return(plt) 
      }
      else {
        plt <- liquorTemporal %>% group_by(year) %>% 
          summarise(Total=sum(Bottles.Sold, na.rm = T)) %>% 
          filter(year!=2019) %>% 
          ggplot(aes(x=year, y=Total)) + geom_line() + ylab("Total bottles sold")
      plt <- ggplotly(plt)
      return(plt) }
    }
  })
  
  output$aspect <- renderUI({
    if(input$analysis == "brand"){
      selectInput(inputId = "brand",label = "Brand", multiple = TRUE,
                  choices = list("Absolut",
                                 "Bacardi",
                                 "Captain Morgan",
                                 # "Crown Royal",
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
      # spatialPlotHeight <<- length(input$brand)
    }
    else{
      selectInput(inputId = "type", label = "Drink Type", multiple = TRUE,
                  choices = list("whiskey",
                                 "vodka",
                                 "brandy",
                                 "rum",
                                 "other"), 
                  selected = "whiskey")
      # spatialPlotHeight <<- length(input$type)
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
                   aes(x=lon,y=lat,size=count,colour=count)) +
        facet_wrap(~brand,ncol=1)
      plt <- ggplotly(plt,height=500*length(input$brand))
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
                   aes(x=lon,y=lat,size=count,colour=count)) +
        facet_wrap(~type,ncol=1)
      
      plt <- ggplotly(plt,height=500*length(input$type))
      return(plt)
    }
  })
}