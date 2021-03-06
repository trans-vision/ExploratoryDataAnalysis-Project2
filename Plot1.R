library(dplyr)

setwd("~/Documents/ExploratoryDataAnalysis/Project2")

# Load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Compute total emissions 
dt_NEI <- tbl_df(NEI[,c("Emissions", "year")])
dt_PlotData <- group_by(dt_NEI, year) %>%
    summarise(TotalPM2.5=sum(Emissions))

# Plot graph of total emissions 
png("plot1.png", width=480, height=480, units="px")

plot(dt_PlotData$year,dt_PlotData$TotalPM2.5, 
     xlab="Year", ylab="Total PM2.5 (tons)")
title(main="Total PM2.5 Emission From All Sources")
# Add regression line
model <- lm(TotalPM2.5 ~ year, dt_PlotData)
abline(model, lty=2, col="blue")

dev.off()