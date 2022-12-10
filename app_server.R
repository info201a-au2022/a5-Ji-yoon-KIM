library(shiny)
library(dplyr)
library(plotly)

# data
data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv") %>%
  filter(population != "NA", iso_code != "")

# Introduction

# What is the average value of CO2 emissions per capita across all the counties in 2020?
avg_2020 <- data %>%
  filter(year == 2020) %>%
  summarise(avg = mean(co2_per_capita, na.rm = T)) %>%
  pull(avg)

# Where is CO2 emissions per capita the highest?
highest_co2 <- data %>%
  group_by(country) %>%
  summarize(co2_avg = mean(co2_per_capita, na.rm = T)) %>%
  filter(co2_avg == max(co2_avg, na.rm = T)) %>%
  pull(country)

# How much has CO2 emissions per capita changed over the last 100 years?
change_co2 <- data %>%
  filter(year == 1920 | year == 2020) %>%
  group_by(year) %>%
  summarize(avg = mean(co2_per_capita, na.rm = T)) %>%
  summarize(diff = max(avg) - min(avg)) %>%
  pull(diff)

# server function
server <- function(input, output) {
  
  output$avg_2020 <- renderText({ avg_2020 })
  output$highest_co2 <- renderText({ highest_co2 })
  output$change_co2 <- renderText({ change_co2 })
  
  output$plot <- renderPlotly({
    
    data_sub <- reactive({
      return(subset(data, (country %in% input$countries & year %in% (input$slideryear[1]:input$slideryear[2]))))
    })
    
    viz_plot <- plot_ly(data = data_sub(), 
                        x = ~year, 
                        y = ~co2_per_capita, 
                        color = ~country,
                        colors = "Set1",
                        type = 'scatter', 
                        mode = 'lines') %>%
      layout(title = "CO2 Emissions per Capita in Countries Over the Years",
             xaxis = list(title = "year"),
             yaxis = list(title = "CO2 Emissions Per Capita (t)")
      )
  })
}