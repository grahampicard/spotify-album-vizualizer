#### Sidebar ####
sidebar  <- dashboardSidebar(
              br(),
              div(align = 'center',
                img(src="Spotify_Logo_RGB_Green.png", width = 125),
                br(),
                textInput("artist", "", placeholder="Enter an artist..."),
                actionButton("run",label="Get Started!")),
              br(),
              sidebarMenu(id="tabs", 
                menuItem("Audio Features", tabName = "album", icon = icon("music"))
              )
            )

#### Tabs ####
album    <- tabItem(
  tabName = "album",
  fluidPage(
    column(width = 6, 
      selectInput("album","Albums", 
        choices = c("")
      )
    ),
    column(width = 6, 
      selectInput("var", "Audio Feature", 
        choices = c("Getting Started"), selected = "Getting Started"
      )
    ),
    column(width = 6, 
      h2(textOutput("graph_title")),
      chartOutput("hist","nvd3")
    ),
    column(width = 6,
      h2(textOutput("selected_feature")),
      textOutput("feature_description")
      ),
    column(width = 12, align = 'center',
      br(),
      p("All descriptions taken from the ", tags$a(href = "https://developer.spotify.com/web-api/get-several-audio-features/" , "Spotify API Documentation.")),
      p("Created by ", tags$a(href = "https://github.com/grahampicard", "Graham Picard"))
    )
  )
)

global   <- tabItem(
              tabName = "global",
              fluidPage(
                p("test text")
              )
            )


#### Body ####
body   <- dashboardBody(
            tabItems(
              global,
              album
              )
            )

#### Dashboard ####
dashboardPage( skin = 'black',
               dashboardHeader(title = "Album Analyzer"),
               sidebar,
               body
)

