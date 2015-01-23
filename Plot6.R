library(dplyr)
library(ggplot2)

setwd("~/Documents/ExploratoryDataAnalysis/Project2")

# Load Baltimore City and LA County emissions data
dt_NEI_Cities <- tbl_df(readRDS("summarySCC_PM25.rds")) %>%
    filter(fips=="24510"|fips=="06037") %>%
    select(Emissions, year, SCC, fips)

# Select motor vehicle emissions as onroad vehicles as it is most relevant to 
# emissions in the city
dt_SCC_MotorVeh <- tbl_df(readRDS("Source_Classification_Code.rds")) %>%
    filter(Data.Category=="Onroad") %>%
    select(SCC, Short.Name, EI.Sector)

# Merging the tables to get only Onroad emissions for Baltimore City and LA County
dt_PlotData <- merge(dt_NEI_Cities, dt_SCC_MotorVeh, by="SCC", sort=FALSE) %>%
    group_by(fips, year) %>%
    summarise(TotalPM2.5=sum(Emissions))

# Convert county code to factor and rename
dt_PlotData$fips <- as.factor(dt_PlotData$fips)
levels(dt_PlotData$fips)[levels(dt_PlotData$fips)=="06037"] <- "Los Angeles County"
levels(dt_PlotData$fips)[levels(dt_PlotData$fips)=="24510"] <- "Baltimore City"

# A box plot of the total annual emissions for each year will show the variance 
# between total Onroad emissions over the years for each city, providing an answer 
# to the question "Which city has seen greater changes over time in motor vehicle 
# emissions?"
g <- ggplot(dt_PlotData, aes(fips, TotalPM2.5, fill=fips)) + 
    geom_boxplot() + theme(legend.position="none") +
    ggtitle("Annual Motor Vehicles PM2.5 Emission Comparison (1999-2008)") +
    xlab("Location") + ylab("PM2.5 (tons)") + 
    guides(fill=guide_legend(title="Location"))

png("plot6.png", width=480, height=480, units="px")
print(g)
dev.off()