library(shiny)
library(plotly)

shinyUI(fluidPage(title="Stat 585 Lab 4 Group 10",
                  tabsetPanel(
                    tabPanel("Temporal Visualization",
                             sidebarLayout(
                               sidebarPanel(
                                 sliderInput("bins",
                                             "Number of bins:",
                                             min = 1,
                                             max = 50,
                                             value = 30)
                               ),
                               
                               # Show a plot of the generated distribution
                               mainPanel(
                                 plotOutput("distPlot")
                               )
                             )
                    ),
                    tabPanel("Map of Story County Liquor Sales",
                             fluidPage(
                               sidebarPanel(
                                 selectInput(inputId = "analysis", "Pick Type of Analysis",
                                             c("Brand"= "brand", "Type" = "type")),
                                 uiOutput("aspect")
                                 
                                 
                               ),
                               mainPanel(
                                 plotlyOutput(outputId="map",height=700)
                                 
                               )
                             )
                    )
                  )
)
)
# Define UI for application that draws a histogram
# ui <- fluidPage(
# 
#   # Application title
#   titlePanel("Old Faithful Geyser Data"),
# 
#   # Sidebar with a slider input for number of bins
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("bins",
#                   "Number of bins:",
#                   min = 1,
#                   max = 50,
#                   value = 30)
#     ),
# 
#     # Show a plot of the generated distribution
#     mainPanel(
#       plotOutput("distPlot")
#     )
#   )
# )