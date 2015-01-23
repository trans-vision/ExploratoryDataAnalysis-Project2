library(dplyr)
library(ggplot2)

setwd("~/Documents/ExploratoryDataAnalysis/Project2")

# Load Baltimore City emissions data
dt_NEI_BaltimoreCity <- tbl_df(readRDS("summarySCC_PM25.rds")) %>%
    filter(fips=="24510") %>%
    select(Emissions, year, SCC)

# Select motor vehicle emissions as onroad vehicles as it is most relevant to 
# emissions in the city
dt_SCC_MotorVeh <- tbl_df(readRDS("Source_Classification_Code.rds")) %>%
    filter(Data.Category=="Onroad") %>%
    select(SCC, Short.Name, EI.Sector)

# Merging the tables to get only Onroad emissions for Baltimore City
dt_PlotData <- merge(dt_NEI_BaltimoreCity, dt_SCC_MotorVeh, by="SCC", sort=FALSE) %>%
    group_by(year) %>%
    summarise(TotalPM2.5=sum(Emissions))

# Plot trend of emissions from motor vehicles in Baltimore City
g <- ggplot(dt_PlotData, aes(year, TotalPM2.5)) + 
    geom_point() + geom_smooth(method="lm") + 
    ggtitle("PM2.5 Emission from Motor Vehicles in Baltimore City, MD") +
    xlab("Year") + ylab("PM2.5 (tons)")
png("plot5.png", width=480, height=480, units="px")
print(g)
dev.off()