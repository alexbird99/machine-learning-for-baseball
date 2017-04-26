# calculate pitcher 4-seam fastball velocity difference between 201604 to 201704

#setwd("C:\\GitHub\\machine-learning-for-baseball")
ff16 <- read.csv('csv\\201604FF.csv', fileEncoding = "UTF-8-BOM")
ff17 <- read.csv('csv\\201704FF.csv', fileEncoding = "UTF-8-BOM")

str(ff16) 

# merge two dataframe 
result <- merge(ff16, ff17, by="player_name")
index <- result$pitches.x > 60 & result$pitches.y > 60
result <- result[index, c("player_name", "pitches.x", "pitches.y", "velocity.x", "velocity.y")]
result$vel_diff <- result$velocity.y - result$velocity.x

# sort by velocity diff
result <- result[order(result[,"vel_diff"]) , ]
result <- result[, c(1,6,4,5)]
colnames(result) <- c("", "Diff", "201604", "201704")

# print top 10 and bottom 10
print(head(result, 10), row.names = FALSE)
print(head(result[rev(rownames(result)),], 10), row.names = FALSE)



