#setwd("C:\\GitHub\\machine-learning-for-baseball")

batter_data <- read.csv('csv\\xBABIP.csv', fileEncoding = "UTF-8-BOM")

str(batter_data)


batter_data$FB.   <- as.numeric(sub("%", "", batter_data $FB., fixed=TRUE))/100
batter_data$IFFB. <- as.numeric(sub("%", "", batter_data $IFFB., fixed=TRUE))/100
batter_data$LD.   <- as.numeric(sub("%", "", batter_data $LD., fixed=TRUE))/100
batter_data$Oppo. <- as.numeric(sub("%", "", batter_data $Oppo., fixed=TRUE))/100
batter_data$Hard. <- as.numeric(sub("%", "", batter_data $Hard., fixed=TRUE))/100
#
# xBABIP = .1770 ¡X .3085*(True IFFB%) ¡X .1285*(True FB%) + .3684*LD% + .0798*Oppo%
#          + .0045*Spd + .2287*Hard% + Year Constant
# True IFFB% = FB% * IFFB%
# True FB% = FB% * (1 ¡X IFFB%)
#
batter_data$TrueIFFB. <- batter_data$FB. * batter_data$IFFB.
batter_data$TrueFB.   <- batter_data$FB. * (1 - batter_data$IFFB.)

batter_data$xBABIP. <- 0.1770 - 0.3085 * batter_data$TrueIFFB. - 0.1285 * batter_data$TrueFB. + 
  0.3684 * batter_data$LD. + 0.0798 * batter_data$Oppo. + 0.0045 * batter_data$Spd + 
  0.2287 * batter_data$Hard. 

batter_data$Diff <- (batter_data$xBABIP. - batter_data$BABIP) 
batter_data[order(batter_data$Diff),]

write.csv(batter_data, file = "output.csv")
