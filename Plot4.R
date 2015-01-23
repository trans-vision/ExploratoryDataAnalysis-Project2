library(dplyr)
library(ggplot2)

setwd("~/Documents/ExploratoryDataAnalysis/Project2")

# Load data
dt_NEI <- tbl_df(readRDS("summarySCC_PM25.rds")) %>%
    select(Emissions, year, SCC)
dt_SCC <- tbl_df(readRDS("Source_Classification_Code.rds"))

# Compute total emissions from coal sources
# Select coal combustion sources identified by sector type
# Chosen to select only coal combustion sources and not other activities 
# (e.g. coal mining) as combustion is direct emmissions. 
dt_SCC_Coal <- filter(dt_SCC, grepl("Comb.*Coal", EI.Sector)) %>%
    select(SCC, Short.Name)
dt_PlotData <- merge(dt_NEI, dt_SCC_Coal, by="SCC", sort=FALSE) %>%
    group_by(year) %>%
    summarise(TotalPM2.5=sum(Emissions))

# Plot graph of total emissions from coal combustion sources
g <- ggplot(dt_PlotData, aes(year, TotalPM2.5)) + 
    geom_point() + geom_smooth(method="lm") + 
    ggtitle("Total PM2.5 Emission from Coal Combustion Sources") +
    xlab("Year") + ylab("PM2.5 (tons)")
    
png("plot4.png", width=480, height=480, units="px")
print(g)
dev.off()