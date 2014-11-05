plot4 <- function(data.input = "skim.Rda", ...){
    source("power_consumption.R")
    
    # Check if the processed input exists
    # If not, create it 
    check.input(data.input, ...)
    
    # Read in properly formatted data
    data <- readRDS(data.input)
    
    # make histogram of "Global Active Power"
    png(filename = "plot4.png"
        , width = 480
        , height = 480
        , bg = "transparent"
        )
    devnr <- dev.cur()
    
    par(mfrow=c(2,2))
    
    myplot2(data, ylabel="Global Active Power")
    myplot4.1(data)
    myplot3(data, legend.border="n")
    myplot4.2(data)
    
    dev.off()
}