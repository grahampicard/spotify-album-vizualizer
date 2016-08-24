library(httr)

client_id     <- "6094ae25b1c940beb2fdbebddb495f75"
client_secret <-"3b07e96365af4feb97f79accff9ff5ae"
client_uri    <- "http://www.displaymyhostname.com/"

response = POST(
  'https://accounts.spotify.com/api/token',
  accept_json(),
  authenticate(client_id, client_secret),
  body = list(grant_type = 'client_credentials'),
  encode = 'form',
  verbose()
)

mytoken = content(response)$access_token

## Frank Sinatra spotify artist ID
artistID = '1Mxqyy3pSjf8kZZL4QVxS0'

HeaderValue = paste0('Bearer ', mytoken)

URI = "https://api.spotify.com/v1/audio-features/06AKEBrKUckW0KREUWRnvT" 
response2 = GET(url = URI, add_headers(Authorization = HeaderValue))
Artist = content(response2)

