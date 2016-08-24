library(httr)
library(dplyr)

#### credentials - make these hidden ####
client_id     <- "6094ae25b1c940beb2fdbebddb495f75"
client_secret <-  "3b07e96365af4feb97f79accff9ff5ae"
redirect_uri  <- "http://www.displaymyhostname.com/"

myscope <- "user-read-private"

response = POST(
  'https://accounts.spotify.com/api/token',
  accept_json(),
  authenticate(client_id, client_secret),
  body = list(grant_type = 'client_credentials'),
  encode = 'form',
  verbose()
)

mytoken <- content(response)$access_token

## Frank Sinatra spotify artist ID
artistID = '1Mxqyy3pSjf8kZZL4QVxS0'

HeaderValue = paste0('Bearer ', mytoken)

URI = paste0('https://api.spotify.com/v1/artists/', artistID)
response2 = GET(url = URI, add_headers(Authorization = HeaderValue))
Artist = content(response2)


test_url  <- "https://accounts.spotify.com/authorize"
test_pars <- list(
  username = "username",
  password = "password"
  )

headers <- list(
  "Referer" = "https://accounts.spotify.com/authorize",
  "Host" = "spotify.com",
  "Connection" = "keep-alive",
  "Accept-Language" = "en-US,en;q=0.5",
  "Scopes" = "user-read-private"
)  

un <- "partywave/coolk1d"