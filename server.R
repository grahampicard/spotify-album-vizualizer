shinyServer(

  function(input, output, session) {
         
   	observeEvent(input$run,{
      
   	  if (input$artist == "") {
   	    return(NULL)
   	  }
   	  
   	  artist <- get_artist(input$artist)
   	  albums <- get_albums(artist$artist_id)
   	  
   	  if (is.null(albums$album) == FALSE) {
   	    updateSelectInput(session, "album", choices = as.vector(albums$album))
   	    updateSelectInput(session, "var", choices = c("Energy","Duration",
   	      "Danceability","Loudness","Acousticness","Instrumentalness",
   	      "Liveness","Valence","Tempo"), selected = "Energy")   	    
   	  }
   	})
   	  
  	current_album <- reactive({
  	  validate(
  	    need(input$album != "", label = "Artist")
  	  )
  	  
	    album <- albums %>% 
	             filter(album == input$album) %>% 
	             select(album_id) %>% 
	             unlist(use.names = FALSE) %>%
	             get_tracks() %>% 
	             add_track_info() %>% 
	             graph_df()
  	})  
  		
		output$graph_title <- renderText({
		  if(input$album == "") {
		    return("Enter an Artist")  	    
		  }		  
		  return(paste0(input$var, " on '", input$album, "'"))
		})
		
		output$selected_feature <- renderText({
		  if(input$var == "Getting Started") {
		    return(input$var)  	    
		  }	
		  return(paste0("What is ", input$var, "?"))
		})
		
		output$feature_description <- renderText({
		  selected_label <- labels %>%
		    filter(Feature == input$var) %>%
		    select(Description)
		  
		  return(toString(selected_label[[1]]))
		})
		
		output$hist <- rCharts::renderChart2({
		 
		  track_df <- current_album() %>% 
		         filter(measure == input$var)
		  
		  opt_margin <- max(stri_length(track_df$track)) * 7

		  p3 <- nPlot(Value ~ track, data = track_df, type = 'multiBarHorizontalChart')
		  p3$chart(showControls = F, 
		           showLegend = F,
               color = c('#1ED760', '#1ED760'),
		           margin = list(left = opt_margin),
               tooltipContent = "#! function(key, x, y){ 
                 return 'Song: ' + x + '  Value: ' + y 
            		   } !#")
		  p3$params$width <- 500
		  p3
 	  })
  }
)
  		
  		