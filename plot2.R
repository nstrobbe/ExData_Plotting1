plot2 <- function(data.input = "skim.Rda", ...){
    source("power_consumption.R")
    
    # Check if the processed input exists
    # If not, create it
    check.input(data.input, ...)

    # Read in properly formatted data
    data <- readRDS(data.input)
    
    # make histogram of "Global Active Power"
    png(filename = "plot2.png"
        , width = 480
        , height = 480
        , bg = "transparent")

    myplot2(data)
    
    dev.off()
}