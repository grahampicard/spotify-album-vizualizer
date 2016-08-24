shinyServer(
  function(input, output, session) {
         
   	observeEvent(input$run,{
       
  	  #extract artist from text input
  		album_df <- rgraph
  		
  		output$gantt_type <- renderText({
  		  paste(input$var)
  		})
  		
  		output$hist <- renderPlot({
  		  
  		  gdf <- album_df %>%
      		    select_("track", input$var)
  		  
  		  ggplot(data = gdf) + 
  		    aes_string("track", input$var) + 
  		    geom_bar(stat = 'identity') + 
  		    coord_flip() +
  		    scale_x_discrete(limits = rev(gdf$track)) +
  		    theme(panel.background = element_blank(),
  		          plot.background = element_blank(),
  		          legend.title = element_blank(),
  		          # legend.text = element_text(color="#555555", size = 12),
  		          legend.background = element_blank(),
  		          legend.key = element_blank(),
  		          axis.title.x = element_blank(),
  		          axis.title.y = element_blank(),
  		          axis.ticks.x = element_blank(),
  		          axis.ticks.y = element_blank(),
  		          axis.text.y = element_text(size = 12),
  		          axis.text.x = element_text(size = 10),  		          
  		          panel.grid.major.x = element_blank(),
  		          panel.grid.minor.x = element_blank(),
  		          panel.grid.major.y = element_blank(),
  		          panel.grid.minor.y = element_blank()
  		    )
  		  
   	  }, bg = "transparent"
		  )
 	  })
  }
)
  		
  		
  # 		#hit apis to gather tracks
  #     tracks<-try(getAlbumsTracks(getArtistsAlbums(getArtists(artist))), silent=TRUE)
  #     
  #     #if the above has errored return error message
  # 		if(inherits(tracks, "try-error")){
  # 		  
  # 		    output$artist<-renderText(paste0("Artist Error: ", artist))
  # 		    session$sendCustomMessage(type="jsondata","")
  # 		  
  # 		    } else {
  # 		  
  # 		    #else process the data  
  # 		    output$artist<-renderText(paste0("Discography: ", tracks$artist[1]))
  #   		  #format data
  #   		  json<-jsonNestedData(structure=tracks[,c(1,3,5)], values=tracks[,9], top_label="Discography")
  #     		var_json<-json$json
  #     		#push data into d3script
  #     		session$sendCustomMessage(type="jsondata",var_json)
  # 		}
  # 
  # 		})
  # 
  #   }
  # )