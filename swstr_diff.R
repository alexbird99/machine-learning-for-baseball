# Swinging strike percentage (SwStr% ¡X swinging strikes per pitch) 

# 70(stable sample size BF Strikeout Rate) * 3.75(pitches average per PA)
MIN_PITCHES=300

#setwd("C:\\GitHub\\machine-learning-for-baseball")
filenames <- list.files("csv\\2017pitcher", full.names=TRUE)
raw_data <- do.call("rbind", lapply(filenames, read.csv, header = TRUE))

# 2016SwStr% data from fangraph
swstr16 <- read.csv("csv\\2016pitcher_swstr.csv", fileEncoding = "UTF-8-BOM")
# % to num
swstr16$SwStr. <- as.numeric(sub("%", "", swstr16 $SwStr., fixed=TRUE)) / 100


# create 2017 empty dataframe
swstr17 <- data.frame("Name"=character(), "SwStr."=factor(), "Pitches"=integer())

playernames <- unique(raw_data$player_name)
for (name in playernames) {
  row <- raw_data[raw_data$player_name==name,]
  newRow <- data.frame(
              Name=name, 
              SwStr.=round(sum(row$description=="swinging_strike")/nrow(row), digits=3),
              Pitches=nrow(row)
              )
  swstr17 <- rbind(swstr17,newRow)
}

# merge 16 and 17 data 
result <- merge(swstr16, swstr17, by="Name")
result <- result[result$Pitches.x>MIN_PITCHES & result$Pitches.y>MIN_PITCHES, ]
result$SwStr_diff <- round(result$SwStr..y - result$SwStr..x, digits=3)
result <- result[order(result[, "SwStr_diff"], decreasing=TRUE), ]
result <- result[, c(1,8,3,6)]
result <- cbind("name"=result[, c(1)], result[, c(-1)]*c(100,100,100))
colnames(result) <- c("", "Diff", "16SwStr%", "17SwStr%")

print("SwStr% - Percentage of Strikes that were swung at and missed")
print(head(result, 10), row.names = FALSE)
print(head(result[rev(rownames(result)),], 10), row.names = FALSE)
