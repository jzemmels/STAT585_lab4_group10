library(shiny)
library(plotly)

shinyUI(fluidPage(title="Stat 585 Lab 4 Group 10",
                  tabsetPanel(
                    tabPanel("Temporal Visualization",
                                       sidebarPanel(
                                         selectInput(inputId = "unit_of_time",label = "Unit of Time", multiple = FALSE,
                                                     choices = list("week",
                                                                    "month",
                                                                    "quarter",
                                                                    "year")
                                         ),
                                         selectInput(inputId = "responseVar",label = "Response Variable", multiple = FALSE,
                                                     choices = list("Sale..Dollars.",
                                                                    "Bottles.Sold")
                                         )
                                       ),
                                       mainPanel(
                                         plotlyOutput(outputId="temporalPlot")
                                       )
                    ),
                    tabPanel("Spatial Visualization",
                             sidebarPanel(
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
                                                                "UV")
                               )
                             ),
                             mainPanel(
                               plotlyOutput(outputId="map")
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