# calculate pitcher 4-seam fastball velocity difference between 201604 and 201704
#
# Statcast Search
# Pitch Type: FastBall(4-seam)
# Player Type: Pitcher
# Game Date: 2017-04-01 to 2017-04-30
# Download "Results" CSV File
#

#setwd("C:\\GitHub\\machine-learning-for-baseball")

ff16 <- read.csv('csv\\2016_P_FF.csv', fileEncoding = "UTF-8-BOM")
ff17 <- read.csv('csv\\2017_P_FF.csv', fileEncoding = "UTF-8-BOM")

# set median number of pitches as filter
summary(ev16) 

# merge two dataframe, calculate Velocity difference
result <- merge(ff16, ff17, by="player_name")
index <- result$pitches.x > 60 & result$pitches.y > 30
result <- result[index, c("player_name", "pitches.x", "pitches.y",
                          "velocity.x", "velocity.y")]
result$vel_diff <- result$velocity.y - result$velocity.x

# sort by velocity difference
result <- result[order(result[,"vel_diff"]) , ]
result <- result[, c("player_name","vel_diff","velocity.x","velocity.y")]
colnames(result) <- c("", "  Diff", "  2016", "  2017")

# print top 10 and bottom 10
print("pitcher 4-seam fastball velocity (mph)")
print(head(result[rev(rownames(result)),], 10), row.names = FALSE)
print(head(result, 10), row.names = FALSE)

