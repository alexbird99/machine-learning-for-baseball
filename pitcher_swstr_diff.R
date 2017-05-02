# calculate SwStr%(Swinging strike percentage) Difference
#
# Statcast Search
# Player Type: Pitcher
# Download "Data" as CSV File
#
# Fangraph
# Custom Leaderboards: Pitches, SwStr%
#

# 70(stable sample size BF Strikeout Rate) * 3.75(pitches average per PA)
MIN_PITCHES=70*3.75

#setwd("C:\\GitHub\\machine-learning-for-baseball")
filenames <- list.files("csv\\2017pitcher", full.names=TRUE)
raw_data <- do.call("rbind", lapply(filenames, read.csv, header = TRUE))

# 2016SwStr% data from fangraph
swstr16 <- read.csv("csv\\2016_P_FG_SWSTR.csv", fileEncoding = "UTF-8-BOM")
# % to num
swstr16$SwStr. <- as.numeric(sub("%", "", swstr16 $SwStr., fixed=TRUE)) / 100


# create 2017 empty dataframe
swstr17 <- data.frame("Name"=character(), "SwStr."=factor(), "Pitches"=integer())

playernames <- unique(raw_data$player_name)

for (name in playernames) {
  row <- raw_data[raw_data$player_name==name,]
  # SwStr% = swining strikes per pitch
  newRow <- data.frame(
              Name=name, 
              SwStr.=round(sum(row$description=="swinging_strike" |
                               row$description=="swinging_strike_blocked")
                           /nrow(row), digits=3),
              Pitches=nrow(row)
            )
  swstr17 <- rbind(swstr17,newRow)
}

# merge two dataframe, calculate SwStr% difference
result <- merge(swstr16, swstr17, by="Name")
result <- result[result$Pitches.x>MIN_PITCHES & result$Pitches.y>MIN_PITCHES, ]
result$SwStr_diff <- round(result$SwStr..y - result$SwStr..x, digits=3)
result <- result[order(result[, "SwStr_diff"], decreasing=TRUE), ]
result <- result[, c("Name","SwStr_diff","SwStr..x","SwStr..y")]

# except first column, all columns times 100 
result <- cbind("name"=result[, c("Name")], result[, names(result)!="Name"]*c(100,100,100))

colnames(result) <- c("", "  Diff", "  2016", "  2017")

# print top 10 and bottom 10
print("pitcher SwStr% (Swinging Strike percentage) (%)")
print(head(result[rev(rownames(result)),], 10), row.names = FALSE)
print(head(result, 10), row.names = FALSE)

