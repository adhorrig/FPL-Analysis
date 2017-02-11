library(devtools)
library(RMySQL)
library(plotly)
install_github("ropensci/plotly")
install.packages('RMySQL')

# Connect to the MySQL database
mydb = dbConnect(MySQL(), user='root', password='', dbname='fpl', host='127.0.0.1')
dbListTables(mydb)
dbListFields(mydb, 'live')

# Query the data
rs = dbSendQuery(mydb, "select sum(total_points) AS total, gameweek_id from live group by gameweek_id")
data = fetch(rs, n=-1)
str(data)
p <- plot_ly(
  x = c(data$gameweek_id),
  y = c(data$total),
  name = "Scores across weeks",
  type = "bar"
)

p

# Query the data - forwards
rs = dbSendQuery(mydb, "select live.gameweek_id, live.total_points, players.second_name from live INNER join players ON live.player_id = players.player_id where players.second_name like '%Vardy%' OR players.second_name like '%Aguero%' OR players.second_name like '%Lukaku%' or players.second_name LIKE '%Ibrahimovic%' or players.second_name = 'Kane' order by live.gameweek_id ASC")
data = fetch(rs, n=-1)
p <- plot_ly(data, x = ~gameweek_id, y = ~total_points) %>%
  add_lines(color = ~second_name)
p

# Query the data - midfielders
rs = dbSendQuery(mydb, "select live.gameweek_id, live.total_points, players.second_name from live INNER join players ON live.player_id = players.player_id where players.second_name like '%Coutinho%' OR players.second_name like '%Sanchez%' OR players.second_name like '%De Bruyne%' or players.second_name LIKE '%Hazard%' or players.second_name = 'Eriksen' order by live.gameweek_id ASC")
data = fetch(rs, n=-1)
p <- plot_ly(data, x = ~gameweek_id, y = ~total_points) %>%
  add_lines(color = ~second_name)
p

# Query the data - defenders
rs = dbSendQuery(mydb, "select live.gameweek_id, live.total_points, players.second_name from live INNER join players ON live.player_id = players.player_id where players.second_name like '%Walker%' OR players.second_name like '%Clyne%' OR players.second_name like '%Koscielny%' or players.second_name LIKE '%Cahill%' or players.second_name = 'Otamendi' order by live.gameweek_id ASC")
data = fetch(rs, n=-1)
p <- plot_ly(data, x = ~gameweek_id, y = ~total_points) %>%
  add_lines(color = ~second_name)
p

#Query the data - Points per game
rs = dbSendQuery(mydb, "select sum(players.points_per_game) as total, teams.name from players inner join teams  on players.team_code = teams.code group by teams.name order by total desc")
data = fetch(rs, n=-1)
str(data)

p <- plot_ly(
  x = c(data$name),
  y = c(data$total),
  name = "Scores across weeks",
  type = "bar"
)

p

# Query the data - countries doing the best 
rs = dbSendQuery(mydb, "select sum(profiles.summary_overall_points) as total, profiles.player_region_short_iso from profiles group by profiles.player_region_short_iso order by total DESC limit 10")
data = fetch(rs, n=-1)

slices <- data$total
lbls <- data$player_region_short_iso
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) 
lbls <- paste(lbls,"%",sep="")
pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Countries with highest % of total points in the game. (Top 10 countries)")

#Query the data - weather affecting performance
rs = dbGetQuery(mydb, "select live.total_points, weather.mintp from live inner join weather on live.gameweek_id = weather.gameweek_id")
p <- plot_ly(data = rs, x = ~mintp, y = ~total_points,
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = 'Styled Scatter',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p

rs = dbGetQuery(mydb, "select live.total_points, weather.wdsp from live inner join weather on live.gameweek_id = weather.gameweek_id")
p <- plot_ly(data = rs, x = ~wdsp, y = ~total_points,
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = 'Styled Scatter',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p

rs = dbGetQuery(mydb, "select live.goals_scored, weather.maxtp from live inner join weather on live.gameweek_id = weather.gameweek_id")
p <- plot_ly(data = rs, x = ~maxtp, y = ~goals_scored,
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = 'Styled Scatter',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p

#Query the data - correlation between rank and transfers made
rs = dbGetQuery(mydb, "select summary_overall_rank, total_transfers from profiles where summary_overall_rank < 50000 and summary_overall_rank >= 1")
p <- plot_ly(data = rs, x = ~total_transfers, y = ~summary_overall_rank,
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = 'Styled Scatter',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p

#Query the data - correlation between rank and transfers made - Good Users
rs = dbGetQuery(mydb, "select summary_overall_rank, total_transfers from profiles where summary_overall_rank < 5000 and summray_overall_rank > 0")
p <- plot_ly(data = rs, x = ~total_transfers, y = ~summary_overall_rank,
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = 'Correlation between total transfers and overall rank. Top 5k users',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p


#Query the data - correlation between rank and transfers made - Bad Users
rs = dbGetQuery(mydb, "select summary_overall_rank, total_transfers from profiles where summary_overall_rank > 500000 LIMIT 20000")
p <- plot_ly(data = rs, x = ~total_transfers, y = ~summary_overall_rank,
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = 'Correlation between total transfers and overall rank. Users worse than 500k overall rank.',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p
