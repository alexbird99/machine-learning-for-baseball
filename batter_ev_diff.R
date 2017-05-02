# calculate batter Exit Velocity difference between 2016 and 2017
#
# Statcast Search
# Pitch Result: In play (4 items)
# Player Type: Batter
# Game Date: 2017-04-01 to 2017-04-30
# Download "Results" CSV File
#

#setwd("C:\\GitHub\\machine-learning-for-baseball")

ev16 <- read.csv('csv\\2016_B_INPLAY.csv', fileEncoding = "UTF-8-BOM")
ev17 <- read.csv('csv\\2017_B_INPLAY.csv', fileEncoding = "UTF-8-BOM")

ev16$launch_speed <- as.numeric(as.character(ev16$launch_speed))
ev17$launch_speed <- as.numeric(as.character(ev17$launch_speed))

# set median number of pitches as filter
summary(ev16) 

# merge two dataframe, calculate EV difference
result <- merge(ev16, ev17, by="player_name")
index <- result$pitches.x > 50 & result$pitches.y > 30
result <- result[index, c("player_name", "pitches.x", "pitches.y",
                          "launch_speed.x", "launch_speed.y")]
result$ev_diff <- result$launch_speed.y - result$launch_speed.x

# sort by EV difference
result <- result[order(result[,"ev_diff"]) , ]
result <- result[, c("player_name","ev_diff","launch_speed.x","launch_speed.y")]
colnames(result) <- c("", "  Diff", "  2016", "  2017")

# print top 10 and bottom 10
print("batter Avg EV (Average Exit Velocity) (mph)")
print(head(result[rev(rownames(result)),], 10), row.names = FALSE)
print(head(result, 10), row.names = FALSE)


