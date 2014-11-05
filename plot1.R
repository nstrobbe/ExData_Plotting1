plot1 <- function(data.input = "skim.Rda", ...){
    # Check if the processed input exists
    # If not, create it
    check.input(data.input, ...)

    # Read in properly formatted data
    data <- readRDS(data.input)
    
    # make histogram of "Global Active Power"
    png(filename = "plot1.png"
        , width = 480
        , height = 480
        , bg = "transparent")
    
    hist(data[,"Global_active_power"]
         , col = "red"
         , xlab = "Global Active Power (kilowatts)"
         , main = "Global Active Power")
    
    dev.off()
}