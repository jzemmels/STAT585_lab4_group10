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
<<<<<<< HEAD
                             )
                    ),
                    tabPanel("Spatial Visualization",
                             sidebarPanel(
                               sliderInput("bins",
                                           "Number of bins:",
                                           min = 1,
                                           max = 50,
                                           value = 30)
                             ),
                             mainPanel(
                               plotlyOutput(outputId="map")
                             )
                    )
                  )
)
)
=======
                             )),
                    tabPanel("Spatial Visualization",
                             sidbarLayout(
                               sidebarPanel(
                                 
                               )
                             ))
                  )))
>>>>>>> 9480490bb4369fcd9ace3b08c1b749ec4e6ebe0b

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