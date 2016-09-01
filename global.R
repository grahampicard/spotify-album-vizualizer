library(shinydashboard)
library(rjson)
library(httr)
library(dplyr)
library(tidyr)
library(rCharts)
library(stringi)

## Authorizations
credentials <- fromJSON(file = "www/credentials.json")

## Call in labels for features
labels <- readRDS("feature-labels")

#### Authentication ####
response = POST(
  'https://accounts.spotify.com/api/token',
  accept_json(),
  authenticate(credentials$client_id, credentials$client_secret),
  body = list(grant_type = 'client_credentials'),
  encode = 'form',
  verbose()
)

mytoken     <- content(response)$access_token
HeaderValue <- paste0('Bearer ', mytoken)


#### Artist Info ####
get_artist <- function(artist = "") {

  # Search for an artist. Get content. Parse Name, ID, and Popularity for dashboard
  if (artist != "") {
    url    <- paste0("https://api.spotify.com/v1/search?q=", gsub(" ", "%20", artist), "&type=artist")
    search <- content(GET(url, add_headers(Authorization = HeaderValue)))
    data   <- data.frame(
                artist = search$artists$items[[1]]$name,
                artist_id = search$artists$items[[1]]$id,
                artist_pop = search$artists$items[[1]]$popularity,
                artist_fol = search$artists$items[[1]]$followers$total,
                artist_img = search$artists$items[[1]]$images[[1]]$url
              )

    return(data)    
  } else {
    return(NULL)
  }
}


#### Album Info ####
get_albums <-function(artist_id = "", country="US", albumType="album", cleanDups=TRUE) {

  if (artist_id != "") {
    url <- paste0("https://api.spotify.com/v1/artists/", artist_id, "/albums?album_type=", albumType, "&limit=50&country=", country)
    albums <- content(GET(url, add_headers(Authorization = HeaderValue)))
    album_df <- data.frame(artist_id=NULL,album=NULL, album_id=NULL)
    
    # Cylce through JSON to get list of albums
    for (i in c(1:length(albums$items))){
      temp <- data.frame(
        artist_id = artist_id, 
        album = albums$items[[i]]$name,
        album_id = albums$items[[i]]$id
      )
      album_df <- rbind(album_df, temp)
    }
    album_df <- album_df[!duplicated(album_df$album), ]
    return(album_df)    
  } else {
    return(NULL)
  }
}


#### Track info ####
get_tracks <- function(album_id) {

  url    <- paste0("https://api.spotify.com/v1/albums/", album_id, "/tracks?limit=50")
  albums <- content(GET(url, add_headers(Authorization = HeaderValue)))
  
  tracks <- data.frame(artist = NULL,artist_id = NULL,album = NULL, album_id = NULL, track = NULL, 
                       track_id = NULL, track_number = NULL, track_length = NULL, preview_url = NULL)
    
    for (j in c(1:length(albums$items))){
      temp <- data.frame(
        album_id = album_id,          
        track = albums$items[[j]]$name,
        track_id = albums$items[[j]]$id,
        track_number = albums$items[[j]]$track_number,
        track_length = albums$items[[j]]$duration_ms
      )
      tracks <- rbind(tracks, temp)
    }
  
  return(tracks)
}

add_track_info <- function(tracks_df) {
  track_info <- data.frame(track_id = NULL, Danceability = NULL,
                           Energy = NULL, Key = NULL, Loudness = NULL,
                           Speechiness = NULL, Acousticness = NULL,
                           Instrumentalness = NULL, Liveness = NULL,
                           Valence = NULL, Tempo = NULL)
 
  for (i in c(1:length(tracks_df$track_id))) {
    url  <- paste0("https://api.spotify.com/v1/audio-features/", tracks_df[i,3])
    info <- content(GET(url = url, add_headers(Authorization = HeaderValue)))
    
    temp <- data.frame(
      track_id         = tracks_df[i,3],
      Danceability     = ifelse(is.null(info$danceability),0,info$danceability),
      Energy           = ifelse(is.null(info$energy),0,info$energy),
      Key              = ifelse(is.null(info$key),0,info$key),
      Loudness         = ifelse(is.null(info$loudness),0,info$loudness),
      Speechineses     = ifelse(is.null(info$speechiness),0,info$speechiness),
      Acousticness     = ifelse(is.null(info$acousticness),0,info$acousticness),
      Instrumentalness = ifelse(is.null(info$instrumentalness),0,info$instrumentalness),
      Liveness         = ifelse(is.null(info$liveness),0,info$liveness),
      Valence          = ifelse(is.null(info$valence),0,info$valence),
      Tempo            = ifelse(is.null(info$tempo),0,info$tempo)
    )
    track_info <- rbind(track_info, temp)
  }
  tracks_df <- tracks_df %>% inner_join(track_info, by = c("track_id"))
  
  return(tracks_df)
}


graph_df <- function(track_info_df) {
  graph <-  track_info_df %>% 
            mutate(Danceability = round(Danceability, 2),
                   Energy = round(Energy, 2),
                   Loudness = round(Loudness, 2),
                   Tempo = round(Tempo,0),
                   Valence = round(Valence, 2),
                   Instrumentalness = round(Instrumentalness, 2),
                   Acousticness = round(Acousticness, 2),
                   Speechineses = round(Speechineses, 2),
                   Duration = track_length/60000,
                   test = format(.POSIXct( track_length/1000,tz="GMT"), "%M:%S"),
                   track = as.character(track),
                   end_time = cumsum(Duration),
                   start_time = end_time - Duration) %>%
            arrange(track_number) %>%
            select(track, track_number, Danceability, Energy, Loudness, Speechineses, 
                   Acousticness, Instrumentalness, Liveness, Valence, 
                   Tempo, Duration) %>%
            mutate(track = ifelse(stri_length(track) > 18, 
                                  paste0(track_number, " - ", substr(track, 1, 15),"..."),
                                  paste0(track_number, " - ", track))) %>%  
            gather(measure, Value, -track)
  return(graph)  
}
