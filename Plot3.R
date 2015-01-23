library(dplyr)
library(ggplot2)

setwd("~/Documents/ExploratoryDataAnalysis/Project2")

# Load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Compute emissions by source type for Baltimore City, MD
dt_NEI <- tbl_df(NEI[NEI$fips=="24510",c("Emissions", "type", "year")])
dt_PlotData <- group_by(dt_NEI, type, year) %>%
    summarise(TotalPM2.5=sum(Emissions))
dt_PlotData$type <- as.factor(dt_PlotData$type)

# Plot graph of emissions by type
p <- qplot(year, TotalPM2.5, data=dt_PlotData, facets=.~type, 
      method="lm", geom=c("point", "smooth"))
p <- p + ggtitle("Sources of PM2.5 Emission in Baltimore City, MD")
p <- p + xlab("Year") + ylab("PM2.5 (tons)")

png("plot3.png", width=480, height=480, units="px")
print(p)
dev.off()
