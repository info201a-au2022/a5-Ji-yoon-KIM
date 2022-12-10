#library(shiny)

# Introduction page
intro_page <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  p("In this website, the visualization of CO2 Emissions per capita in each country across the years are going to be introduced. The data was retrieved from ", em("Our World in Data"), " for analysis.",
    strong("All data is measured in units of metric ton per capita.")),
  h3("Variables"),
    p("In 2020, the average CO2 emissions per capita across all countries was ", textOutput(outputId = "avg_2020", inline = T),
    " and the country where average CO2 emissions per capita was the highest across all of the years was ", textOutput(outputId = "highest_co2", inline = T),
    "while we could also see that CO2 emissions per capita had increased over the last 100 years from 1920 to 2020, with an increase of ", textOutput(outputId = "change_co2", inline = T), " on average.",
    "As the CO2 emissions per capita is experiencing an increase, the visualizations would introduce the general trend of changes in CO2 emissions per capita across countries for closer examination and comparison between countries."
    )
)

# Visualization page
viz_page <- tabPanel(
  "Visualization",
  titlePanel("CO2 Emissions Per Capita in Countries"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "slideryear",
        label = "Select Year Range",
        min = min(data$year),
        max = max(data$year),
        value = c(1920, 2020), step = 1
      ),
      selectizeInput(
        inputId = "countries",
        label = "Select country",
        choices = data$country,
        selected = "United States",
        multiple = T
      )
    ),
    mainPanel(
      p(plotlyOutput(outputId = "plot"),
        "Through this visualization, we can compare CO2 emissions of different countries over the years in order to examine general trends and patterns. 
        Recently, we can see that countries are experiencing a decrease in CO2 emissions in general, starting from around 2000.
        Even the Dutch part of Sint Maarten, which had drastically high CO2 emission rates per capita around 1950 to 1960, experienced a drastic decrease starting from 1960.
        United Arab Emirates also had high emission rates starting from 1969, but experienced a sharp decline starting from 1978.")
    )
  )
)

ui <- navbarPage(
  "CO2 Emissions",
  intro_page,
  viz_page
)