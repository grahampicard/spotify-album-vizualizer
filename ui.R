#### Sidebar ####
sidebar  <- dashboardSidebar(
              br(),
              div(align = 'center',
                img(src="Spotify_Logo_RGB_Green.png", width = 125),
                br(),
                textInput("artist", "Enter Artist", placeholder="artist name..."),
                actionButton("run",label="Get Started!")),
              br(),
              sidebarMenu(id="tabs", 
                menuItem("Album Analyzer", tabName = "album", icon = icon("music")),                        
                menuItem("Global Availability", tabName = "global", icon = icon("globe"))
              )
            )

#### Tabs ####
album    <- tabItem(
  tabName = "album",
  fluidPage(
    selectInput("var", label = "Choose an album attribute",
                choices = c("Duration","Energy","Danceability","Loudness",
                            "Acousticness","Instrumentalness","Liveness",
                            "Valence","Tempo"), selected = "Energy"),
    column(width = 6, 
      plotOutput("hist")
    ),
    column(width = 6,
      textOutput("gantt_type")
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
               dashboardHeader(title = "Artist Popularity"),
               sidebar,
               body
)

